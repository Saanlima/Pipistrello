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
//      Miscellaneous.
//
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <ctype.h>

#include "ff.h"
#include "doomdef.h"
#include "doomstat.h"

#include "i_swap.h"
#include "i_system.h"
#include "i_video.h"
#include "m_misc.h"
#include "v_video.h"
#include "w_wad.h"
#include "z_zone.h"

// Check if a file exists

boolean M_FileExists(char *filename)
{
  FIL fil;
	if (f_open(&fil, filename, FA_OPEN_EXISTING | FA_READ))
		return false;
  f_close(&fil);
	return true;
}

//
// Determine the length of an open file.
//

long M_FileLength(FIL *handle)
{ 
    long length;

    f_lsize(&handle, &length);
    if (length == 0)
      fprintf(stderr, "File length == 0!\n");
    
    return length;
}

//
// M_WriteFile
//

boolean M_WriteFile(char *name, void *source, int length)
{
	FIL f;
	int count = 0;

  if (f_open(&f, name, FA_CREATE_ALWAYS | FA_WRITE))
  {
    fprintf(stderr, "Can't open %s for writing\n", name);
	  return false;
  }

	f_write(&f, source, length, &count);
	f_close(&f);

	if (count < length)
		return false;

	return true;

}

int M_ReadFile(char *name, byte ** buffer)
{
	FIL f;
	int count, length;
	byte *buf;

  if (f_open(&f, name, FA_OPEN_EXISTING | FA_READ))
		I_Error("Couldn't read file %s", name);

	length = M_FileLength(&f);

	buf = Z_Malloc(length, PU_STATIC, NULL);
  f_read(&f, buf, length, &count);
	f_close(&f);

	if (count < length)
		I_Error("Couldn't read file %s", name);

	*buffer = buf;
	return length;
}

// Returns the path to a temporary file of the given name, stored
// inside the system temporary directory.
//
// The returned value must be freed with Z_Free after use.

char *M_TempFile(char *s)
{
    char *result;
    char *tempdir;

    tempdir = ".";

    result = Z_Malloc(strlen(tempdir) + strlen(s) + 2, PU_STATIC, 0);
    sprintf(result, "%s%c%s", tempdir, DIR_SEPARATOR, s);

    return result;
}

/*
//
// M_WriteFile
//

boolean M_WriteFile(char *name, void *source, int length)
{
	FILE *handle;
	int count;

	handle = fopen(name, "wb");

	if (handle == NULL)
		return false;

	count = fwrite(source, 1, length, handle);
	fclose(handle);

	if (count < length)
		return false;

	return true;

}

//
// M_ReadFile
//

int M_ReadFile(char *name, byte ** buffer)
{
	FILE *handle;
	int count, length;
	byte *buf;

	handle = fopen(name, "rb");
	if (handle == NULL)
		I_Error("Couldn't read file %s", name);

	// find the size of the file by seeking to the end and
	// reading the current position

	length = M_FileLength(handle);

	buf = Z_Malloc(length, PU_STATIC, NULL);
	count = fread(buf, 1, length, handle);
	fclose(handle);

	if (count < length)
		I_Error("Couldn't read file %s", name);

	*buffer = buf;
	return length;
}

// Returns the path to a temporary file of the given name, stored
// inside the system temporary directory.
//
// The returned value must be freed with Z_Free after use.

char *M_TempFile(char *s)
{
    char *result;
    char *tempdir;

    tempdir = ".";

    result = Z_Malloc(strlen(tempdir) + strlen(s) + 2, PU_STATIC, 0);
    sprintf(result, "%s%c%s", tempdir, DIR_SEPARATOR, s);

    return result;
}
*/