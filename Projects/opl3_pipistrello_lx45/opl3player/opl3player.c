#include <stdio.h>
#include <stdint.h>
#include "registers.h"
#include "ff.h"
#include "diskio.h"


#define BAUD 115200

#define CMD_EOF	 				-1
#define CMD_NULL				0		//no command
#define CMD_FULL				1		//cmd + delay
#define CMD_DELAY_ONLY	2		//delay

unsigned char shadow_opl[256];
unsigned char shadow_opl_written[256];
unsigned char mutemask[9];
unsigned short dro1_high;
unsigned char dro2_codetable[256];
unsigned char dro2_delaycodes[2];

typedef enum
{
	FT_IMF0,
	FT_IMF1,
	FT_DRO1,
	FT_DRO2
} filetype;

typedef struct
{
	unsigned short reg;
	unsigned char data;
	unsigned short delay;
} cmd;

typedef struct
{
	FIL stream;
	filetype type;
} fileinfo;

char name[128];

int available(void)
{
  uint16_t status = UART0_UCR;
  if (status & UART_UCR_RX_FULL)
    return 16;
  if (status & UART_UCR_RX_DATA)
    return  1;
  return 0;
}

int peek(void)
{
  uint16_t status = UART0_UCR;
  if (status & UART_UCR_RX_DATA) {
    return (status>>8);
  } else {
    return -1;
  }
}

// Polling version
uint8_t inbyte(void)
{
  uint8_t c;
  // wait for RX data
  while ((UART0_UCR & UART_UCR_RX_DATA) == 0);
  c = UART0_UDR;
  return c;
}

// Polling version
void outbyte(uint8_t c)
{
  // wait if TX fifo full
  while ((UART0_UCR & UART_UCR_TX_FULL));
  UART0_UDR = c;
}

void msleep(unsigned int ms)
{
	TMR_DELAY = ms * 1000;
	while ((TMR_DCR & TMR_DCR_DLY_TO) == 0);
}

void usleep(unsigned int us)
{
	TMR_DELAY = us;
	while ((TMR_DCR & TMR_DCR_DLY_TO) == 0);
}

unsigned long get_ms()
{
  unsigned int millis = TMR_MILLIS;
  return millis;
}


volatile BYTE rtcYear = 2013-1980, rtcMon = 7, rtcMday = 6, rtcHour, rtcMin, rtcSec;

DWORD get_fattime (void)
{
	DWORD tmr;

	/* Pack date and time into a DWORD variable */
	tmr =	  (((DWORD)rtcYear - 80) << 25)
			| ((DWORD)rtcMon << 21)
			| ((DWORD)rtcMday << 16)
			| (WORD)(rtcHour << 11)
			| (WORD)(rtcMin << 5)
			| (WORD)(rtcSec >> 1);

	return tmr;
}

void opl2_out(unsigned int reg, unsigned char data)
{
  SOUND0_OPL3 = reg<<8 | data;
	shadow_opl[reg] = data;
}

void opl2_clear(void)
{
	int i;
	for (i = 0; i < 256; i++) {
		opl2_out(i, 0);
	}
}

void mute_toggle(int channel)
{
	mutemask[channel] = !mutemask[channel];

	if (mutemask[channel])
		opl2_out(0xB0 + channel, shadow_opl[0xB0 + channel] & 0xDF);

}

int is_muted(int reg)
{
	if ((reg >= 0xA0 && reg <= 0xA8)
		|| (reg >= 0xB0 && reg <= 0xB8)
		|| (reg >= 0xC0 && reg <= 0xC8))
		return mutemask[reg & 0x0F];

	if ((reg >= 0x20 && reg <= 0x35)
		|| (reg >= 0x40 && reg <= 0x55)
		|| (reg >= 0x60 && reg <= 0x75)
		|| (reg >= 0x80 && reg <= 0x95)
		|| (reg >= 0xE0 && reg <= 0xF5))
		switch(reg % 32)
		{
			case 0: case 3: return mutemask[0];
			case 1: case 4: return mutemask[1];
			case 2: case 5: return mutemask[2];
			case 8: case 11: return mutemask[3];
			case 9: case 12: return mutemask[4];
			case 10: case 13: return mutemask[5];
			case 16: case 19: return mutemask[6];
			case 17: case 20: return mutemask[7];
			case 18: case 21: return mutemask[8];
		}
	return 0;
}
  
int read_next_cmd(fileinfo *fi, cmd *c)
{
  int count;
	unsigned char rb[4];
	unsigned int ri;

	switch(fi->type)
	{
		case FT_IMF0:
		case FT_IMF1:
      f_read(&fi->stream, rb, 4, &count);
			if (count != 4)
				return CMD_EOF;

			c->reg = rb[0];
			c->data = rb[1];
			c->delay = rb[2] | (rb[3] << 8);
			return CMD_FULL;

		case FT_DRO1:
			c->reg = c->data = c->delay = 0;
      f_read(&fi->stream, rb, 1, &count);
			if (count != 1)
				return CMD_EOF;
			ri = rb[0];
			switch(ri)
			{
				case 0:	//1B delay
          f_read(&fi->stream, rb, 1, &count);
					if (count != 1)
						return CMD_EOF;
					ri = rb[0];
					c->delay = ri + 1;
					return CMD_DELAY_ONLY;

				case 1:	//2B delay
          f_read(&fi->stream, rb, 1, &count);
					if (count != 1)
						return CMD_EOF;
					ri = rb[0];
					c->delay = ri;
          f_read(&fi->stream, rb, 1, &count);
					if (count != 1)
						return CMD_EOF;
					ri = rb[0];
					c->delay |= ri << 8;
					c->delay++;
					return CMD_DELAY_ONLY;

				case 2:	//switch to low chip
					dro1_high = 0;
					break;

				case 3:	//switch to high chip
					dro1_high = 0x0100;
					break;

				case 4:	//escape
					return CMD_NULL;

				default:
					c->reg = ri | dro1_high;
          f_read(&fi->stream, rb, 1, &count);
					if (count != 1)
						return CMD_EOF;
					ri = rb[0];
					c->data = ri;
					return CMD_FULL;
			}

		case FT_DRO2:
			c->reg = c->data = c->delay = 0;
      f_read(&fi->stream, rb, 1, &count);
			if (count != 1)
				return CMD_EOF;
			ri = rb[0];
			if (ri == dro2_delaycodes[0])
			{
        f_read(&fi->stream, rb, 1, &count);
				if (count != 1)
					return CMD_EOF;
				ri = rb[0];
				c->delay = ri + 1;
				return CMD_DELAY_ONLY;
			}
			else if (ri == dro2_delaycodes[1])
			{
        f_read(&fi->stream, rb, 1, &count);
				if (count != 1)
					return CMD_EOF;
				ri = rb[0];
				c->delay = 256 * (ri + 1);
				return CMD_DELAY_ONLY;
			}
			else
			{
				c->reg = dro2_codetable[ri & 0x7F];
				c->reg |= (ri & 0x80) << 1;
        f_read(&fi->stream, rb, 1, &count);
				if (count != 1)
					return CMD_EOF;
				ri = rb[0];
				c->data = ri;
				return CMD_FULL;
			}
	}

	return 0;
}

int file_open(fileinfo *fi, char *fname)
{
  int count;
	char rb[16];
	char drosig[] = "DBRAWOPL";

  if (f_open(&fi->stream, fname, FA_OPEN_EXISTING | FA_READ)) {
    outbyte('?');
    outbyte(0x0d);
    outbyte(0x0a);
    return 0;
  }

  f_read(&fi->stream, rb, 2, &count);
	if (count != 2)
		return 0;

	if (rb[0] == 'D' && rb[1] == 'B')
	{
		//might be a DRO
		f_read(&fi->stream, &rb[2], 6, &count);
		if ((count == 6)
			&& (memcmp(rb, drosig, 8) == 0))
		{
			//it is!
      f_read(&fi->stream, rb, 4, &count);
			if (count != 4)
				return 0;
			if (rb[0] == 0 && rb[1] == 0 && rb[2] == 1 && rb[3] == 0)
			{
				//DRO 1.0
				//skip remaining header data
        f_read(&fi->stream, rb, 12, &count);
				if (count != 12)
					return 0;
				//older DRO1 revision
				if (rb[9] != 0 || rb[10] != 0 || rb[11] != 0)
//					f_seek(&fi->stream, 21L, SEEK_SET);

				fi->type = FT_DRO1;
				return 1;
			}
			else if (rb[0] == 2 && rb[1] == 0 && rb[2] == 0 && rb[3] == 0)
			{
				//DRO 2.0
        f_read(&fi->stream, rb, 14, &count);
				if (count != 14)
					return 0;

				if (rb[9] != 0 || rb[10] != 0)
				{
					return 0;
				}

				dro2_delaycodes[0] = rb[11];	//short delay code
				dro2_delaycodes[1] = rb[12];	//long delay code

				//read codetable
        f_read(&fi->stream, (char *) dro2_codetable, rb[13], &count);
				if (count != rb[13])
					return 0;

				fi->type = FT_DRO2;
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}

	//not a DRO
	if (rb[0] == 0 && rb[1] == 0)
	{
		fi->type = FT_IMF0;
//		f_lseek(&fi->stream, 0L, SEEK_SET);
		return 1;
	}
	else
	{
		fi->type = FT_IMF1;
//		f_lseek(&fi->stream, 2L, SEEK_SET);
		return 1;
	}
}

void file_rewind(fileinfo * fi)
{
  f_lseek (&fi->stream, 0);
}

void file_close(fileinfo *fi)
{
	f_close(&fi->stream);
}

int imfplay(char *filename)
{
	fileinfo f;

	if (file_open(&f, filename)) {;

    //clear OPL2
    opl2_clear();

    //play
    {
      int run = 1;
      cmd c;
      int res;
      int next_event = 0;
      int clock_ticks;
      int incomingByte = 0;;
      
      while (run)
      {
        res = read_next_cmd(&f, &c);
        if (res == CMD_EOF) {
          // loop to somg
          file_close(&f);
          file_open(&f, filename);
        } else {
          if (res == CMD_FULL && !is_muted(c.reg))
          {
            if (c.reg < 0x100)
            {
              opl2_out(c.reg, c.data);
              shadow_opl_written[c.reg] = 1;
            }
          }
          next_event = c.delay;
          /*
           * Prevent drop-out due to back to back command, fast clock speed of
           * CPU, slow clock speed of FPGA. FPGA can miss key-off, key-on
           * event.
           */
          if (next_event == 0)
            usleep(50);

          if (available() > 0) {
            // read the incoming byte:
            incomingByte = inbyte();
            if (incomingByte == 'S')
              run = 0;
          }
          for (clock_ticks = 0; clock_ticks < next_event; clock_ticks++)
            msleep(1);
        }
      }
    }
  }
	//close the file
	file_close(&f);
	//clear OPL2
	opl2_clear();
	//exit
	return 1;
}

int main (void)
{
  FATFS Fatfs;
  int i;
  
  // Init timer: clocks per microsecond, timer enable
  TMR_DCR = (F_CPU/1000000) | TMR_DCR_ENABLE;
  
  // Init UART0
  UART0_UBRR = (F_CPU/8/BAUD + 1)/2 - 1; //67 @ 115200  baud
  UART0_UCR = UART_UCR_ENABLE; // uart enable, uart

  // Init SD-card SPI controller
  SPI0_PORTSET = 1 << SPI_SS; // make CS output
  SPI0_DIRSET = 1 << SPI_SS;  // set CS high

  // Clear all OPL2 registers
  opl2_clear();
  
  while (1)
  {
    // Try to mount the sd card
    if (disk_initialize(0)) {
      outbyte('?');
    } else {
      if (f_mount(&Fatfs, "", 0)) {
        outbyte('?');
      } else {
        outbyte(0x0d);
        outbyte(0x0a);
        outbyte('>');
        while (1)
        {
          char incomingByte = 0;
          int cnt;
          // play file
          cnt = 0;
          while (available() == 0);
          incomingByte = inbyte();
          outbyte(incomingByte);
          while ((incomingByte != 0x0) && (incomingByte != 0x0d))
          {
            if (cnt < (sizeof(name) - 1))
              name[cnt++] = incomingByte;
            while (available() == 0);
            incomingByte = inbyte();
            outbyte(incomingByte);
          }
          outbyte(0x0a);
          name[cnt] = 0;
          imfplay(name);
          outbyte('>');
        }
      }
    }
    // wait a second before trying again
    msleep(1000);
  }
}
