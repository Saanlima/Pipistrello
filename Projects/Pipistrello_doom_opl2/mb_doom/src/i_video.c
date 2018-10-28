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
//      DOOM graphics stuff.
//
//-----------------------------------------------------------------------------

#include "doomdef.h"
#include "doomstat.h"
#include "d_main.h"
#include "i_system.h"
#include "i_video.h"
#include "i_timer.h"
#include "i_registers.h"
#include "sounds.h"
#include "v_video.h"
#include "w_wad.h"
#include "z_zone.h"

static uint16_t palette[256];

/* DOOM render buffer */
static struct PAL_IMAGE doomvideo;

struct IMAGE screen;


void draw_pal_image(struct IMAGE *target, int x, int y,
		    const struct PAL_IMAGE *image)
{
	uint16_t *d;
	const uint8_t *src;
	unsigned int h = image->height, i;

	d = &target->pixels[x + y * target->width];
	src = image->pixels;
	while (h--)
	{
		i = image->width;
		while (i--)
		{
			*d++ = image->palette[*src++];
		}
		d += target->width - image->width;
	}
}

void flip_page()
{
	flush_dcache();
  
	DVI_AR = (uint32_t)screen.pixels;

	if (screen.pixels == (uint16_t*)FB1)
		screen.pixels = (uint16_t*)FB2;
	else
		screen.pixels = (uint16_t*)FB1;
}


void I_BeginRead(void)
{

}

void I_EndRead(void)
{

}

//
// I_FinishUpdate
//
void I_FinishUpdate(void)
{
	draw_pal_image(&screen, 0, 20, &doomvideo);
	flip_page();
}

//
// I_ReadScreen
//
void I_ReadScreen(byte * scr)
{
	memcpy(scr, screens[0], SCREENWIDTH * SCREENHEIGHT);
}

//
// I_SetPalette
//
void I_SetPalette(byte * doompalette)
{
	int i;

	/* Convert Doom palette to fast LUT */
	for (i = 0; i < 256; ++i) {
		palette[i] = RGB(gammatable[usegamma][doompalette[0]],
				 gammatable[usegamma][doompalette[1]],
				 gammatable[usegamma][doompalette[2]]);
		doompalette += 3;
	}
}

void I_InitGraphics(void)
{
	byte *doompal;
	
	screen.width = SCR_WIDTH / 2;
	screen.height = SCR_HEIGHT / 2;
	screen.pixels = (uint16_t*)FB1;

	memset(screens[0], 0, SCREENWIDTH * SCREENHEIGHT);

	doomvideo.width = SCREENWIDTH;
	doomvideo.height = SCREENHEIGHT;
	doomvideo.pixels = screens[0];
	doomvideo.palette = palette;

	doompal = W_CacheLumpName("PLAYPAL", PU_CACHE);

	I_SetPalette(doompal);
}
