// Emacs style mode select   -*- C++ -*- 
//-----------------------------------------------------------------------------
//
// Copyright(C) 1993-1996 Id Software, Inc.
// Copyright(C) 2005 Simon Howard
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
// 02111-1307, USA.
//
// DESCRIPTION:
//
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <stdarg.h>

#include "ff.h"
#include "diskio.h"

#include "doomdef.h"
#include "doomstat.h"
#include "m_argv.h"
#include "m_config.h"
#include "m_misc.h"
#include "i_video.h"
#include "s_sound.h"
#include "g_game.h"
#include "i_system.h"
#include "i_registers.h"
#include "i_utils.h"

static boolean key_release = false, key_extended = false;

uint8_t inbyte(void)
{
  uint8_t c;
  // wait for RX data
  while ((UART0_UCR & UART_UCR_RX_DATA) == 0);
  c = UART0_UDR;
  return c;
}

void outbyte(uint8_t c)
{
  if (c == '\n')
  {
	  // wait if TX fifo full
    while ((UART0_UCR & UART_UCR_TX_FULL));
    UART0_UDR = '\r';
  }
  // wait if TX fifo full
  while ((UART0_UCR & UART_UCR_TX_FULL));
  UART0_UDR = c;
}

//
// EVENT HANDLING
//
// Events are asynchronous inputs generally generated by the game user.
// Events can be discarded if no responder claims them
//

#define MAXEVENTS		64

static event_t events[MAXEVENTS];
static int eventhead = 0;
static int eventtail = 0;

FATFS Fatfs;

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


static unsigned char translate_key[512] = {
	[0x0D] = KEY_TAB,
	[0x11] = KEY_RALT,
	[0x12] = KEY_RSHIFT,
	[0x14] = KEY_RCTRL,
	[0x15] = 'Q',
	[0x16] = '1',
	[0x1a] = 'Z',
	[0x1b] = 'S',
	[0x1c] = 'A',
	[0x1d] = 'W',
	[0x1e] = '2',
	[0x21] = 'C',
	[0x22] = 'X',
	[0x23] = 'D',
	[0x24] = 'E',
	[0x25] = '4',
	[0x26] = '3',
	[0x29] = ' ',
	[0x2a] = 'V',
	[0x2b] = 'F',
	[0x2c] = 'T',
	[0x2d] = 'R',
	[0x2e] = '5',
	[0x31] = 'N',
	[0x32] = 'B',
	[0x33] = 'H',
	[0x34] = 'G',
	[0x35] = 'Y',
	[0x36] = '6',
	[0x3a] = 'M',
	[0x3b] = 'J',
	[0x3c] = 'U',
	[0x3d] = '7',
	[0x3e] = '8',
	[0x42] = 'K',
	[0x43] = 'I',
	[0x44] = 'O',
	[0x45] = '0',
	[0x46] = '9',
	[0x4b] = 'L',
	[0x4d] = 'P',
	[0x59] = KEY_RSHIFT,
	[0x5A] = KEY_ENTER,
	[0x76] = KEY_ESCAPE,

	[0x111] = KEY_RALT,
	[0x114] = KEY_RCTRL,
	[0x16B] = KEY_LEFTARROW,
	[0x172] = KEY_DOWNARROW,
	[0x174] = KEY_RIGHTARROW,
	[0x175] = KEY_UPARROW,
	[0x15A] = KEY_ENTER,
};

static uint32_t last_mstime, new_mstime;
static uint32_t msdata[5];
static int mscount;


void exception_handler(void) __attribute__ ((interrupt_handler));

void exception_handler()
{
	unsigned int val;
	event_t event;
	if (INTC_IPR & KBD_INT)
	{
		val = KBD_DATA;
		if (val == 0xF0) {
			key_release = true;
		} else if (val == 0xE0) {
			key_extended = true;
		} else {
			if (key_extended)
				val |= 0x100;
			if (translate_key[val]) {
				event.type = key_release ? ev_keyup : ev_keydown;
				event.data1 = translate_key[val];
				event.data2 = tolower(translate_key[val]);
				I_PostEvent(&event);
			}
			key_release = false;
			key_extended = false;
		}
		INTC_IAR = KBD_INT;
	} else if (INTC_IPR & MOUSE_INT)
	{
		val = MOUSE_DATA;
		new_mstime = TMR_MILLIS;
		if ((mscount == 0) || ((new_mstime > last_mstime) && (new_mstime - last_mstime > 5)))
		{
			msdata[0] = val;
			mscount = 1;
		}
		else
		{
			msdata[mscount] = val;
			mscount++;
		}
		if (mscount == 3)
		{
			// process mouse event
			//printf("mouse data: 0x%x, 0x%x, 0x%x  ", msdata[0], msdata[1], msdata[2]);
			// first swap the buttons
			int buttons = 0;
			if (msdata[0] & 1)
				buttons |= 1;
			if (msdata[0] & 4)
				buttons |= 2;
			if (msdata[0] & 2)
				buttons |= 4;
			// next form and sign-extend the 9-bit x and y values
			if ((msdata[0] & 0x10) == 0x10)
				msdata[1] |= 0xffffff00;
			if ((msdata[0] & 0x20) == 0x20)
				msdata[2] |= 0xffffff00;
			// mouse accelerate code
			int x = (int)msdata[1] * 4;
			if ((x > 10) || (x < -10))
				x *= 2;
			int y = (int)msdata[2] * 4;
			if ((y > 10) || (y < -10))
				y *= 2;
			// post the event
			event.type = ev_mouse;
			event.data1 = buttons;
			event.data2 = x;
			event.data3 = y;
			I_PostEvent(&event);
			mscount = 0;
		}
		last_mstime = new_mstime;
		INTC_IAR = MOUSE_INT;
	} else
	{
		INTC_IAR = INTC_IPR;
	}
}

//
// D_PostEvent
// Called by the I/O functions when input is detected
//
void I_PostEvent(event_t * ev)
{
	events[eventhead] = *ev;
	eventhead = (eventhead + 1) % MAXEVENTS;
}

// Read an event from the queue.

boolean I_PopEvent(event_t * ev)
{
	// No more events waiting.

	disable_interrupts();
	if (eventtail == eventhead) {
		enable_interrupts();
		return false;
	}

	*ev = events[eventtail];

	// Advance to the next event in the queue.

	eventtail = (eventtail + 1) % MAXEVENTS;

	enable_interrupts();
	return true;
}

// Tactile feedback function, probably used for the Logitech Cyberman

void I_Tactile(int on, int off, int total)
{
}

//
// I_Init
//
void I_Init(void)
{
	// hardware init:
	
	// enable icache and dcache
	enable_icache();
	enable_dcache();
	
	// init UART at 115200 baud
	UART0_UBRR = (F_CPU/8/115200)/2 - 1;
	UART0_UCR = UART_UCR_ENABLE;
	
	// init PS2 controller (keyboard)
	KBD_CTRL = 0xa0; // enable ps2 controller, enable rx interrupt
	
	// init PS2 controller (mouse)
	MOUSE_CTRL = 0xa0; // enable ps2 controller, enable rx interrupt
	MOUSE_DATA = 0xf4; // enable data reporting
	mscount = 0;
	last_mstime = TMR_MILLIS;
	
	// setup interrupt controller
	INTC_IER = TMR_INT | KBD_INT | MOUSE_INT; // enable ps2 interrupts in interrupt controller
	INTC_MER = 0x03; // enable interrupt controller
	
	// init SPI controller (sd-card)
	SPI0_PORTSET = 1 << SPI0_SS; 
	SPI0_DIRSET = 1 << SPI0_SS;
	
	// init microsec timer
	TMR_DCR = (F_CPU/1000000) | 0x100; // clocks per microsecond, timer enable
	
	// init audio system for 11025 Hz sample rate
	SOUND0_PERIOD = F_CPU/11025; // time between each sample in clocks
	SOUND0_CONTROL = 0x01;       // start output audio
	
	// init video controller
	DVI_AR = FB1;  // frame buffer address
	DVI_CR = 0x5;  // low-rez mode (scan-doubled)
	
	// clear frame buffer memory
	memset(FB1, 0, SCR_WIDTH * SCR_HEIGHT * 2);
	memset(FB2, 0, SCR_WIDTH * SCR_HEIGHT * 2);
	flush_dcache();
	
	// mount the sd card
	if (disk_initialize(0))
	{
		printf("ERROR: Unable to initialize SD card!\n");
	}
	if (f_mount(&Fatfs, "", 0))
	{
		printf("ERROR: Unable to mount file system!\n");
	}
	enable_interrupts();
}

//
// I_Quit
//

void I_Quit(void)
{
	I_Error("QUIT");
}

void I_WaitVBL(int count)
{
	TMR_DCR = (F_CPU/1000000) | 0x100; // clocks per microsecond, timer enable
	TMR_DELAY = (count * 1000) / 70;
	while ((TMR_DCR & 0x400) == 0);
}


//
// I_Error
//
extern boolean demorecording;

static boolean already_quitting = false;

void I_Error (char *error, ...)
{
    va_list	argptr;

    if (already_quitting)
    {
        fprintf(stderr, "Warning: recursive call to I_Error detected.\n");
        disable_interrupts();
        while (1) ;
    }
    else
    {
        already_quitting = true;
    }
    
    // Message first.
    va_start(argptr, error);
    fprintf(stderr, "\nError: ");
    vfprintf(stderr, error, argptr);
    fprintf(stderr, "\n");
    va_end(argptr);
    fflush(stderr);

    // Shutdown. Here might be other errors.

    if (demorecording)
    {
        G_CheckDemoStatus();
    }

    S_Shutdown();

    // abort();

    disable_interrupts();
    while (1) ;
}
