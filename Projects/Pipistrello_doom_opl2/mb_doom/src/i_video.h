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
//      System specific interface stuff.
//
//-----------------------------------------------------------------------------

#ifndef __I_VIDEO__
#define __I_VIDEO__

#include "doomtype.h"

#include "types.h"

#define FB1 0xa7e00000
#define FB2 0xa7f00000

#define SCR_WIDTH	640
#define SCR_HEIGHT	480

#define WHITE		0xFFFF
#define BLACK		0

#define RGB(r, g, b)		\
	((b) >> 3 | (uint16_t)((g) >> 2) << 5 | (uint16_t)((r) >> 3) << 11)

struct IMAGE {
	uint16_t *pixels;
	unsigned int width, height;
};

struct PAL_IMAGE {
	uint8_t *pixels;
	const uint16_t *palette;
	unsigned int width, height;
};

extern struct IMAGE screen;

void draw_pal_image(struct IMAGE *target, int x, int y,
		    const struct PAL_IMAGE *image);
void flip_page();

// Called by D_DoomMain,
// determines the hardware configuration
// and sets up the video mode
void I_InitGraphics(void);

// Takes full 8 bit values.
void I_SetPalette(byte * palette);

void I_FinishUpdate(void);

// Wait for vertical retrace or pause a bit.
void I_WaitVBL(int count);

void I_ReadScreen(byte * scr);

void I_BeginRead(void);
void I_EndRead(void);

#endif
