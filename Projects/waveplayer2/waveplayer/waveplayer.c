#include <stdio.h>
#include <stdint.h>
#include "registers.h"
#include "ff.h"
#include "diskio.h"


#define BLOCK_SIZE 512
#define BAUD 115200

char name[128];

struct riff_header 
{
  char chunk_id[4];
  unsigned int chunk_size;
  char format[4];
};

struct chunk_header
{
  char chunk_id[4];
  unsigned int chunk_size;
};

struct fmt_header 
{
  unsigned short audio_format;
  unsigned short num_channels;
  unsigned int sample_rate;
  unsigned int byte_rate;
  unsigned short block_align;
  unsigned short bits_per_sample;
  unsigned short cb_size;
  unsigned short valid_bits_per_sample;
  unsigned int channel_mask;
  char sub_format[16];
};

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

void wav_play (char *filename)
{
  FIL file;
  int count;
  struct riff_header riff;
  struct chunk_header chunk;
  struct fmt_header format;
  unsigned int length;
  unsigned int blocks;
  unsigned int first_block;
  unsigned int i;
  unsigned int j;
  unsigned int sample;
  unsigned char audio_buf[BLOCK_SIZE];
  unsigned char info[256];
  int incomingByte = 0;
  int bytes_read;

  // open the file for reading:
  if (f_open(&file, filename, FA_OPEN_EXISTING | FA_READ)) {
    outbyte('1');
    return;
  }

  f_read(&file, &riff, sizeof(riff), &count);
  bytes_read = count;
  if ((count != sizeof(riff)) ||
      (strncmp("RIFF", riff.chunk_id, sizeof(riff.chunk_id)) != 0) ||
      (strncmp("WAVE", riff.format, sizeof(riff.format)) != 0))
  {
    f_close(&file);
    outbyte('2'); // Invalid WAVE file
    return;
  }

  format.audio_format = 0;
  length = 0;

  // process all sub-chunks
  while(1) {
    // read the sub-chunk type and size
    f_read(&file, &chunk, sizeof(chunk), &count);
    bytes_read = count;
    if (count != sizeof(chunk))
    {
      f_close(&file);
      outbyte('2'); // Invalid WAVE file
      return;
    }
    // See if it's the fmt chunk
    if (strncmp("fmt ", chunk.chunk_id, sizeof(chunk.chunk_id)) == 0)
    {
      // make sure it's one of the valid sizes
      if ((chunk.chunk_size != 16) && 
          (chunk.chunk_size != 18) &&
          (chunk.chunk_size != 40))
      {
        f_close(&file);
        outbyte('2'); // Invalid WAVE file
        return;
      }
      // read in the rest of the fmt chunk (16, 18 or 40 bytes) and check it
      f_read(&file, &format, chunk.chunk_size, &count);
      bytes_read += count;
      if ((count != chunk.chunk_size) ||
          (format.audio_format != 1) ||
          ((format.num_channels != 2) && (format.num_channels != 1)) ||
          (format.bits_per_sample != 16) ||
          ((format.sample_rate != 32000) && (format.sample_rate != 44100) &&
           (format.sample_rate != 48000) && (format.sample_rate != 96000)) ||
          ((format.sample_rate == 96000) && (format.num_channels == 2)))
      {
        f_close(&file);
        outbyte('3'); // Invalid wave format
        return;
      }
    }
    // see if it's the data chunk
    else if (strncmp("data", chunk.chunk_id, sizeof(chunk.chunk_id)) == 0)
    {
      // grab the data length and play the song
      length = chunk.chunk_size;
      break;
    }
    // must be some other kind of sub-chunk (like LIST)
    // read it and throw it away
    else if (chunk.chunk_size <= sizeof(info))
    {
      f_read(&file, &info, chunk.chunk_size, &count);
      bytes_read += count;
      if (count != chunk.chunk_size)
      {
        f_close(&file);
        outbyte('2'); // Invalid WAVE file
        return;
      }
    }
    else {
      // too big sub-chunk
      f_close(&file);
      outbyte('2'); // Invalid WAVE file
      return;
    }
  }

  // make sure we have a valid format and data chunk
  if ((format.audio_format != 1) || (length == 0))
  {
    f_close(&file);
    outbyte('2'); // Invalid WAVE file
    return;
  }
  
  outbyte('0'); // Success

  // How much is left of first data block?
  first_block = BLOCK_SIZE - (bytes_read % BLOCK_SIZE);
	
  // How many full or partial blocks do we have to play?
  blocks = ((length - bytes_read + BLOCK_SIZE - 1) / BLOCK_SIZE);

  // set up the sigma-delta DAC output unit
  SOUND0_PERIOD = F_CPU/format.sample_rate; // time between each sample in clocks
  SOUND0_CONTROL = 0x01; // start output audio

  for (i=0;i<blocks;i++)
  {

    if (available() > 0) {
      // read the incoming byte:
      incomingByte = peek();
      if ((incomingByte == 'S') || (incomingByte == 'F'))
        break;
      else {
        inbyte(); // throw it away
        outbyte('1');
      }
    }

    if (first_block > 0)
    {
      f_read(&file, &audio_buf, first_block, &count);
      if (count != first_block)
        break;
      first_block = 0;
    }
    else
    {
      f_read(&file, &audio_buf, BLOCK_SIZE, &count);
      if (count != BLOCK_SIZE)
        break;
    }
    if (format.num_channels == 2)
    {
      // stereo
      for (j=0; j<count; j+=4)
      {
        sample = audio_buf[j+3];
        sample = (sample << 8) | audio_buf[j+2];
        sample = (sample << 8) | audio_buf[j+1];
        sample = (sample << 8) | audio_buf[j];
        sample ^= 0x80008000;
        while (SOUND0_STATUS);
        SOUND0_FIFO = sample;
      }
    }
    else
    {
      // mono, duplicate the sample on both channels
      for (j=0; j<count; j+=2)
      {
        sample = audio_buf[j+1];
        sample = (sample << 8) | audio_buf[j];
        sample = (sample << 8) | audio_buf[j+1];
        sample = (sample << 8) | audio_buf[j];
        sample ^= 0x80008000;
        while (SOUND0_STATUS);
        SOUND0_FIFO = sample;
      }
    }
  }

  SOUND0_FIFO = 0x80008000;
  f_close(&file);
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

  // ramp up the DAC slowly to the mid-point to minimize click noise
  SOUND0_PERIOD = F_CPU/44100; // time between each sample in clocks
  SOUND0_CONTROL = 0x01; // start output audio
  
  for (i=0; i<35678; i++)
  {
    while (SOUND0_STATUS);
    SOUND0_FIFO = i<<16 | i;
  }
  
  while (1)
  {
    // Try to mount the sd card
    if (disk_initialize(0)) {
  //		printf("\r\nERROR: Unable to initialize SD card!\r\n");
    } else {
      if (f_mount(&Fatfs, "", 0)) {
  //      printf("\r\nERROR: Unable to mount file system!\r\n");
      } else {
        while (1)
        {
          char incomingByte = 0;
          int cnt;
          if (available() > 0)
          {
            // read the incoming byte:
            incomingByte = inbyte();
            if (incomingByte == 'S')
            {
              // stop
              outbyte('0');
            }
            else if (incomingByte == 'F')
            {
              // play file
              cnt = 0;
              while (available() == 0);
              incomingByte = inbyte();
              while ((incomingByte != 0x0) && (incomingByte != 0x0d))
              {
                if (cnt < (sizeof(name) - 1))
                  name[cnt++] = incomingByte;
                while (available() == 0);
                incomingByte = inbyte();
              }
              name[cnt] = 0;
              wav_play(name);
            }
            else
            {
              // unknown command
              outbyte('1');
            }
          }
        }
      }
    }
    msleep(100); // wait 100 ms before trying again
  }
}
