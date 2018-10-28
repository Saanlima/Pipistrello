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
//      The actual span/column drawing functions.
//      Here find the main potential for optimization,
//       e.g. inline assembly, different algorithms.
//
//-----------------------------------------------------------------------------

#include "doomdef.h"

#include "i_system.h"
#include "z_zone.h"
#include "w_wad.h"

#include "r_local.h"

// Needs access to LFB (guess what).
#include "v_video.h"

// State.
#include "doomstat.h"

// status bar height at bottom of screen
#define SBARHEIGHT		32

//
// All drawing to the view buffer is accomplished in this file.
// The other refresh files only know about ccordinates,
//  not the architecture of the frame buffer.
// Conveniently, the frame buffer is a linear one,
//  and we need only the base address,
//  and the total size == width*height*depth/8.,
//

int viewwidth;
int scaledviewwidth;
int viewheight;
int viewwindowx;
int viewwindowy;
byte *ylookup[SCREENHEIGHT];
int columnofs[SCREENWIDTH];

// Color tables for different players,
//  translate a limited part to another
//  (color ramps used for  suit colors).
//
byte translations[3][256];

//
// R_DrawColumn
// Source is the top of the column to scale.
//
lighttable_t *dc_colormap;
int dc_x;
int dc_yl;
int dc_yh;
fixed_t dc_iscale;
fixed_t dc_texturemid;

// first pixel in a column (possibly virtual) 
byte *dc_source;

// just for profiling 
int dccount;

//
// A column is a vertical slice/span from a wall texture that,
//  given the DOOM style restrictions on the view orientation,
//  will always have constant z depth.
// Thus a special case loop for very fast rendering can
//  be used. It has also been used with Wolfenstein 3D.
// 
void R_DrawColumn(void)
{
	int count, pos;
	byte *dest, color;
	fixed_t frac;
	fixed_t fracstep;

	count = dc_yh - dc_yl + 1;

	// Zero length, column does not exceed a pixel.
	if (count <= 0)
		return;

#ifdef RANGECHECK
	if ((unsigned)dc_x >= SCREENWIDTH || dc_yl < 0 || dc_yh >= SCREENHEIGHT)
		I_Error("R_DrawColumn: %i to %i at %i", dc_yl, dc_yh, dc_x);
#endif

	// Framebuffer destination address.
	// Use ylookup LUT to avoid multiply with ScreenWidth.
	// Use columnofs LUT for subwindows? 
	dest = ylookup[dc_yl] + columnofs[dc_x];

	// Determine scaling,
	//  which is the only mapping to be done.
	fracstep = dc_iscale;
	frac = dc_texturemid + (dc_yl - centery) * fracstep;

	if (dc_colormap == colormaps) {
		// NO COLORMAP!!

		if (fracstep >= FRACUNIT) {
			while (count >= 2) {
				*dest = dc_source[(frac >> FRACBITS) & 127];
				frac += fracstep;
				dest[SCREENWIDTH] = dc_source[(frac >> FRACBITS) & 127];
				frac += fracstep;
				dest += SCREENWIDTH * 2;
				count -= 2;
			}
			if (count) {
				*dest = dc_source[(frac >> FRACBITS) & 127];
			}
		} else {
			/* magnification */
			pos = frac >> FRACBITS;
			while (1) {
				frac &= (FRACUNIT-1);
				color = dc_source[pos & 127];

				while (frac < FRACUNIT) {
					*dest = color;
					frac += fracstep;
					count--;
					dest += SCREENWIDTH;
					if (!count)
						return;
				}
				pos++;
			}
		}
		return;
	}

	if (fracstep >= FRACUNIT) {
		while (count >= 2) {
			*dest = dc_colormap[dc_source[(frac >> FRACBITS) & 127]];
			frac += fracstep;
			dest[SCREENWIDTH] = dc_colormap[dc_source[(frac >> FRACBITS) & 127]];
			frac += fracstep;
			dest += SCREENWIDTH * 2;
			count -= 2;
		}
		if (count) {
			*dest = dc_colormap[dc_source[(frac >> FRACBITS) & 127]];
		}
	} else {
		/* magnification */
		pos = frac >> FRACBITS;
		while (1) {
			frac &= (FRACUNIT-1);
			color = dc_colormap[dc_source[pos & 127]];

			while (frac < FRACUNIT) {
				*dest = color;
				frac += fracstep;
				count--;
				dest += SCREENWIDTH;
				if (!count)
					return;
			}
			pos++;
		}
	}
}

void R_DrawColumnLow(void)
{
	int count;
	byte *dest;
	byte *dest2;
	fixed_t frac;
	fixed_t fracstep;
	int x;

	count = dc_yh - dc_yl;

	// Zero length.
	if (count < 0)
		return;

#ifdef RANGECHECK
	if ((unsigned)dc_x >= SCREENWIDTH || dc_yl < 0 || dc_yh >= SCREENHEIGHT) {

		I_Error("R_DrawColumnLow: %i to %i at %i", dc_yl, dc_yh, dc_x);
	}
	//  dccount++; 
#endif
	// Blocky mode, need to multiply by 2.
	x = dc_x << 1;

	dest = ylookup[dc_yl] + columnofs[x];
	dest2 = ylookup[dc_yl] + columnofs[x + 1];

	fracstep = dc_iscale;
	frac = dc_texturemid + (dc_yl - centery) * fracstep;

	do {
		// Hack. Does not work corretly.
		*dest2 = *dest =
		    dc_colormap[dc_source[(frac >> FRACBITS) & 127]];
		dest += SCREENWIDTH;
		dest2 += SCREENWIDTH;
		frac += fracstep;

	} while (count--);
}

//
// Spectre/Invisibility.
//
#define FUZZTABLE		50
#define FUZZOFF	(SCREENWIDTH)

int fuzzoffset[FUZZTABLE] = {
	FUZZOFF, -FUZZOFF, FUZZOFF, -FUZZOFF, FUZZOFF, FUZZOFF, -FUZZOFF,
	FUZZOFF, FUZZOFF, -FUZZOFF, FUZZOFF, FUZZOFF, FUZZOFF, -FUZZOFF,
	FUZZOFF, FUZZOFF, FUZZOFF, -FUZZOFF, -FUZZOFF, -FUZZOFF, -FUZZOFF,
	FUZZOFF, -FUZZOFF, -FUZZOFF, FUZZOFF, FUZZOFF, FUZZOFF, FUZZOFF,
	    -FUZZOFF,
	FUZZOFF, -FUZZOFF, FUZZOFF, FUZZOFF, -FUZZOFF, -FUZZOFF, FUZZOFF,
	FUZZOFF, -FUZZOFF, -FUZZOFF, -FUZZOFF, -FUZZOFF, FUZZOFF, FUZZOFF,
	FUZZOFF, FUZZOFF, -FUZZOFF, FUZZOFF, FUZZOFF, -FUZZOFF, FUZZOFF
};

int fuzzpos = 0;

//
// Framebuffer postprocessing.
// Creates a fuzzy image by copying pixels
//  from adjacent ones to left and right.
// Used with an all black colormap, this
//  could create the SHADOW effect,
//  i.e. spectres and invisible players.
//
void R_DrawFuzzColumn(void)
{
	int count;
	byte *dest;
	fixed_t frac;
	fixed_t fracstep;

	// Adjust borders. Low... 
	if (!dc_yl)
		dc_yl = 1;

	// .. and high.
	if (dc_yh == viewheight - 1)
		dc_yh = viewheight - 2;

	count = dc_yh - dc_yl;

	// Zero length.
	if (count < 0)
		return;

#ifdef RANGECHECK
	if ((unsigned)dc_x >= SCREENWIDTH || dc_yl < 0 || dc_yh >= SCREENHEIGHT) {
		I_Error("R_DrawFuzzColumn: %i to %i at %i", dc_yl, dc_yh, dc_x);
	}
#endif

	dest = ylookup[dc_yl] + columnofs[dc_x];

	// Looks familiar.
	fracstep = dc_iscale;
	frac = dc_texturemid + (dc_yl - centery) * fracstep;

	// Looks like an attempt at dithering,
	//  using the colormap #6 (of 0-31, a bit
	//  brighter than average).
	do {
		// Lookup framebuffer, and retrieve
		//  a pixel that is either one column
		//  left or right of the current one.
		// Add index from colormap to index.
		*dest = colormaps[6 * 256 + dest[fuzzoffset[fuzzpos]]];

		// Clamp table lookup index.
		if (++fuzzpos == FUZZTABLE)
			fuzzpos = 0;

		dest += SCREENWIDTH;

		frac += fracstep;
	} while (count--);
}

// low detail mode version

void R_DrawFuzzColumnLow(void)
{
	int count;
	byte *dest;
	byte *dest2;
	fixed_t frac;
	fixed_t fracstep;
	int x;

	// Adjust borders. Low... 
	if (!dc_yl)
		dc_yl = 1;

	// .. and high.
	if (dc_yh == viewheight - 1)
		dc_yh = viewheight - 2;

	count = dc_yh - dc_yl;

	// Zero length.
	if (count < 0)
		return;

	// low detail mode, need to multiply by 2

	x = dc_x << 1;

#ifdef RANGECHECK
	if ((unsigned)x >= SCREENWIDTH || dc_yl < 0 || dc_yh >= SCREENHEIGHT) {
		I_Error("R_DrawFuzzColumn: %i to %i at %i", dc_yl, dc_yh, dc_x);
	}
#endif

	dest = ylookup[dc_yl] + columnofs[x];
	dest2 = ylookup[dc_yl] + columnofs[x + 1];

	// Looks familiar.
	fracstep = dc_iscale;
	frac = dc_texturemid + (dc_yl - centery) * fracstep;

	// Looks like an attempt at dithering,
	//  using the colormap #6 (of 0-31, a bit
	//  brighter than average).
	do {
		// Lookup framebuffer, and retrieve
		//  a pixel that is either one column
		//  left or right of the current one.
		// Add index from colormap to index.
		*dest = colormaps[6 * 256 + dest[fuzzoffset[fuzzpos]]];
		*dest2 = colormaps[6 * 256 + dest2[fuzzoffset[fuzzpos]]];

		// Clamp table lookup index.
		if (++fuzzpos == FUZZTABLE)
			fuzzpos = 0;

		dest += SCREENWIDTH;
		dest2 += SCREENWIDTH;

		frac += fracstep;
	} while (count--);
}

//
// R_DrawTranslatedColumn
// Used to draw player sprites
//  with the green colorramp mapped to others.
// Could be used with different translation
//  tables, e.g. the lighter colored version
//  of the BaronOfHell, the HellKnight, uses
//  identical sprites, kinda brightened up.
//
byte *dc_translation;
byte *translationtables;

void R_DrawTranslatedColumn(void)
{
	int count;
	byte *dest;
	fixed_t frac;
	fixed_t fracstep;

	count = dc_yh - dc_yl;
	if (count < 0)
		return;

#ifdef RANGECHECK
	if ((unsigned)dc_x >= SCREENWIDTH || dc_yl < 0 || dc_yh >= SCREENHEIGHT) {
		I_Error("R_DrawTranslationColumn: %i to %i at %i", dc_yl, dc_yh, dc_x);
	}
#endif

	dest = ylookup[dc_yl] + columnofs[dc_x];

	// Looks familiar.
	fracstep = dc_iscale;
	frac = dc_texturemid + (dc_yl - centery) * fracstep;

	// Here we do an additional index re-mapping.
	do {
		// Translation tables are used
		//  to map certain colorramps to other ones,
		//  used with PLAY sprites.
		// Thus the "green" ramp of the player 0 sprite
		//  is mapped to gray, red, black/indigo. 
		*dest =
		    dc_colormap[dc_translation[dc_source[frac >> FRACBITS]]];
		dest += SCREENWIDTH;

		frac += fracstep;
	} while (count--);
}

void R_DrawTranslatedColumnLow(void)
{
	int count;
	byte *dest;
	byte *dest2;
	fixed_t frac;
	fixed_t fracstep;
	int x;

	count = dc_yh - dc_yl;
	if (count < 0)
		return;

	// low detail, need to scale by 2
	x = dc_x << 1;

#ifdef RANGECHECK
	if ((unsigned)x >= SCREENWIDTH || dc_yl < 0 || dc_yh >= SCREENHEIGHT) {
		I_Error("R_DrawTranslationColumnLow: %i to %i at %i", dc_yl, dc_yh, x);
	}
#endif

	dest = ylookup[dc_yl] + columnofs[x];
	dest2 = ylookup[dc_yl] + columnofs[x + 1];

	// Looks familiar.
	fracstep = dc_iscale;
	frac = dc_texturemid + (dc_yl - centery) * fracstep;

	// Here we do an additional index re-mapping.
	do {
		// Translation tables are used
		//  to map certain colorramps to other ones,
		//  used with PLAY sprites.
		// Thus the "green" ramp of the player 0 sprite
		//  is mapped to gray, red, black/indigo. 
		*dest =
		    dc_colormap[dc_translation[dc_source[frac >> FRACBITS]]];
		*dest2 =
		    dc_colormap[dc_translation[dc_source[frac >> FRACBITS]]];
		dest += SCREENWIDTH;
		dest2 += SCREENWIDTH;

		frac += fracstep;
	} while (count--);
}

//
// R_InitTranslationTables
// Creates the translation tables to map
//  the green color ramp to gray, brown, red.
// Assumes a given structure of the PLAYPAL.
// Could be read from a lump instead.
//
void R_InitTranslationTables(void)
{
	int i;

	translationtables = Z_Malloc(256 * 3, PU_STATIC, 0);

	// translate just the 16 green colors
	for (i = 0; i < 256; i++) {
		if (i >= 0x70 && i <= 0x7f) {
			// map green ramp to gray, brown, red
			translationtables[i] = 0x60 + (i & 0xf);
			translationtables[i + 256] = 0x40 + (i & 0xf);
			translationtables[i + 512] = 0x20 + (i & 0xf);
		} else {
			// Keep all other colors as is.
			translationtables[i] = translationtables[i + 256]
			    = translationtables[i + 512] = i;
		}
	}
}

//
// R_DrawSpan 
// With DOOM style restrictions on view orientation,
//  the floors and ceilings consist of horizontal slices
//  or spans with constant z depth.
// However, rotation around the world z axis is possible,
//  thus this mapping, while simpler and faster than
//  perspective correct texture mapping, has to traverse
//  the texture at an angle in all but a few cases.
// In consequence, flats are not stored by column (like walls),
//  and the inner loop has to step in texture space u and v.
//
int ds_y;
int ds_x1;
int ds_x2;

lighttable_t *ds_colormap;

fixed_t ds_xfrac;
fixed_t ds_yfrac;
fixed_t ds_xstep;
fixed_t ds_ystep;

// start of a 64*64 tile image 
byte *ds_source;

// just for profiling
int dscount;

//
// Draws the actual span.
void R_DrawSpan(void)
{
	fixed_t xfrac;
	fixed_t yfrac;
	fixed_t xfrac2;
	fixed_t yfrac2;
	fixed_t xss;
	fixed_t yss;
	byte *dest, a, b;
	int count, j;
	int spot;

#ifdef RANGECHECK
	if (ds_x2 < ds_x1
	    || ds_x1 < 0
	    || ds_x2 >= SCREENWIDTH || (unsigned)ds_y > SCREENHEIGHT) {
		I_Error("R_DrawSpan: %i to %i at %i", ds_x1, ds_x2, ds_y);
	}
//      dscount++; 
#endif

	count = ds_x2 - ds_x1 + 1;
	if (count <= 0)
		return;

	xfrac = ds_xfrac;
	yfrac = ds_yfrac;
	xss = ds_xstep * 2;
	yss = ds_ystep * 2;

	dest = ylookup[ds_y] + columnofs[ds_x1];

	if (ds_colormap == colormaps) {
		// NO COLORMAP!!

		if ((unsigned long)dest & 1) {
			// Current texture index in u,v.
			spot =
			    ((yfrac >> (16 - 6)) & (63 * 64)) +
			    ((xfrac >> 16) & 63);

			// Lookup pixel from flat texture tile,
			//  re-index using light/colormap.
			*dest++ = ds_source[spot];

			// Next step in u,v.
			xfrac += ds_xstep;
			yfrac += ds_ystep;
			count--;
		}

		xfrac2 = xfrac + ds_xstep;
		yfrac2 = yfrac + ds_ystep;
		while (count >= 2) {
			spot =
			    ((yfrac >> (16 - 6)) & (63 * 64)) +
			    ((xfrac >> 16) & 63);
			a = ds_source[spot];

			spot =
			    ((yfrac2 >> (16 - 6)) & (63 * 64)) +
			    ((xfrac2 >> 16) & 63);
			b = ds_source[spot];

			*(unsigned short *)dest = a | (b << 8);
			dest += 2;

			// Next step in u,v.
			xfrac += xss;
			yfrac += yss;
			xfrac2 += xss;
			yfrac2 += yss;

			count -= 2;
		}
		if (count) {
			// Current texture index in u,v.
			spot =
			    ((yfrac >> (16 - 6)) & (63 * 64)) +
			    ((xfrac >> 16) & 63);

			// Lookup pixel from flat texture tile,
			//  re-index using light/colormap.
			*dest = ds_source[spot];
		}
		return;
	}

	if ((unsigned long)dest & 1) {
		// Current texture index in u,v.
		spot = ((yfrac >> (16 - 6)) & (63 * 64)) + ((xfrac >> 16) & 63);

		// Lookup pixel from flat texture tile,
		//  re-index using light/colormap.
		*dest++ = ds_colormap[ds_source[spot]];

		// Next step in u,v.
		xfrac += ds_xstep;
		yfrac += ds_ystep;
		count--;
	}

	xfrac2 = xfrac + ds_xstep;
	yfrac2 = yfrac + ds_ystep;
	while (count >= 2) {
		spot = ((yfrac >> (16 - 6)) & (63 * 64)) + ((xfrac >> 16) & 63);
		a = ds_colormap[ds_source[spot]];

		spot =
		    ((yfrac2 >> (16 - 6)) & (63 * 64)) + ((xfrac2 >> 16) & 63);
		b = ds_colormap[ds_source[spot]];

		*(unsigned short *)dest = a | (b << 8);
		dest += 2;

		// Next step in u,v.
		xfrac += xss;
		yfrac += yss;
		xfrac2 += xss;
		yfrac2 += yss;

		count -= 2;
	}
	if (count) {
		// Current texture index in u,v.
		spot = ((yfrac >> (16 - 6)) & (63 * 64)) + ((xfrac >> 16) & 63);

		// Lookup pixel from flat texture tile,
		//  re-index using light/colormap.
		*dest = ds_colormap[ds_source[spot]];
	}
}

//
// Again..
//
void R_DrawSpanLow(void)
{
	fixed_t xfrac;
	fixed_t yfrac;
	byte *dest;
	int count;
	int spot;

#ifdef RANGECHECK
	if (ds_x2 < ds_x1
	    || ds_x1 < 0
	    || ds_x2 >= SCREENWIDTH || (unsigned)ds_y > SCREENHEIGHT) {
		I_Error("R_DrawSpanLow: %i to %i at %i", ds_x1, ds_x2, ds_y);
	}
//      dscount++; 
#endif

	xfrac = ds_xfrac;
	yfrac = ds_yfrac;

	count = (ds_x2 - ds_x1);

	// Blocky mode, need to multiply by 2.
	ds_x1 <<= 1;
	ds_x2 <<= 1;

	dest = ylookup[ds_y] + columnofs[ds_x1];

	do {
		spot = ((yfrac >> (16 - 6)) & (63 * 64)) + ((xfrac >> 16) & 63);
		// Lowres/blocky mode does it twice,
		//  while scale is adjusted appropriately.
		*dest++ = ds_colormap[ds_source[spot]];
		*dest++ = ds_colormap[ds_source[spot]];

		xfrac += ds_xstep;
		yfrac += ds_ystep;

	} while (count--);
}

//
// R_InitBuffer 
// Creats lookup tables that avoid
//  multiplies and other hazzles
//  for getting the framebuffer address
//  of a pixel to draw.
//
void R_InitBuffer(int width, int height) {
	int i;

	// Handle resize,
	//  e.g. smaller view windows
	//  with border and/or status bar.
	viewwindowx = (SCREENWIDTH - width) >> 1;

	// Column offset. For windows.
	for (i = 0; i < width; i++)
		columnofs[i] = viewwindowx + i;

	// Samw with base row offset.
	if (width == SCREENWIDTH)
		viewwindowy = 0;
	else
		viewwindowy = (SCREENHEIGHT - SBARHEIGHT - height) >> 1;

	// Preclaculate all row offsets.
	for (i = 0; i < height; i++)
		ylookup[i] = screens[0] + (i + viewwindowy) * SCREENWIDTH;
}

//
// R_FillScreenBorder
// Fills the back screen with a pattern
//  for variable screen sizes
// Also draws a beveled edge.
//
void R_FillScreenBorder(void)
{
	byte *src;
	byte *dest;
	int x;
	int y;
	patch_t *patch;

	// DOOM border patch.
	char *name1 = "FLOOR7_2";

	// DOOM II border patch.
	char *name2 = "GRNROCK";

	char *name;

	if (scaledviewwidth == 320)
		return;

	if (gamemode == commercial)
		name = name2;
	else
		name = name1;

	src = W_CacheLumpName(name, PU_CACHE);
	dest = screens[0];

	for (y = 0; y < SCREENHEIGHT - SBARHEIGHT; y++) {
		for (x = 0; x < SCREENWIDTH / 64; x++) {
			memcpy(dest, src + ((y & 63) << 6), 64);
			dest += 64;
		}

		if (SCREENWIDTH & 63) {
			memcpy(dest, src + ((y & 63) << 6), SCREENWIDTH & 63);
			dest += (SCREENWIDTH & 63);
		}
	}

	patch = W_CacheLumpName("brdr_t", PU_CACHE);

	for (x = 0; x < scaledviewwidth; x += 8)
		V_DrawPatch(viewwindowx + x, viewwindowy - 8, 0, patch);
	patch = W_CacheLumpName("brdr_b", PU_CACHE);

	for (x = 0; x < scaledviewwidth; x += 8)
		V_DrawPatch(viewwindowx + x, viewwindowy + viewheight, 0,
			    patch);
	patch = W_CacheLumpName("brdr_l", PU_CACHE);

	for (y = 0; y < viewheight; y += 8)
		V_DrawPatch(viewwindowx - 8, viewwindowy + y, 0, patch);
	patch = W_CacheLumpName("brdr_r", PU_CACHE);

	for (y = 0; y < viewheight; y += 8)
		V_DrawPatch(viewwindowx + scaledviewwidth, viewwindowy + y, 0,
			    patch);

	// Draw beveled edge. 
	V_DrawPatch(viewwindowx - 8,
		    viewwindowy - 8, 0, W_CacheLumpName("brdr_tl", PU_CACHE));

	V_DrawPatch(viewwindowx + scaledviewwidth,
		    viewwindowy - 8, 0, W_CacheLumpName("brdr_tr", PU_CACHE));

	V_DrawPatch(viewwindowx - 8,
		    viewwindowy + viewheight,
		    0, W_CacheLumpName("brdr_bl", PU_CACHE));

	V_DrawPatch(viewwindowx + scaledviewwidth,
		    viewwindowy + viewheight,
		    0, W_CacheLumpName("brdr_br", PU_CACHE));
}