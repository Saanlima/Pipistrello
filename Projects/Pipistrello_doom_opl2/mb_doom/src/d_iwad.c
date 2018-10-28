// Emacs style mode select   -*- C++ -*- 
//-----------------------------------------------------------------------------
//
// Copyright(C) 2006 Simon Howard
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
//     Search for and locate an IWAD file, and initialise according
//     to the IWAD type.
//
//-----------------------------------------------------------------------------

#include <ctype.h>
#include <string.h>

#include "doomdef.h"
#include "doomstat.h"
#include "i_system.h"
#include "m_argv.h"
#include "m_config.h"
#include "m_misc.h"
#include "w_wad.h"
#include "z_zone.h"

static struct {
	char *name;
	GameMission_t mission;
} iwads[] = {
	{
	"doom2.wad", doom2}, {
	"plutonia.wad", pack_plut}, {
	"tnt.wad", pack_tnt}, {
	"doom.wad", doom}, {
	"doom1.wad", doom}, {
"chex.wad", doom},};

// Hack for chex quest mode

static void CheckChex(char *iwad_name)
{
	if (!strcmp(iwad_name, "chex.wad")) {
		gameversion = exe_chex;
	}
}

// Search a directory to try to find an IWAD
// Returns the location of the IWAD if found, otherwise NULL.

static char *SearchDirectoryForIWAD(void)
{
	size_t i;

	for (i = 0; i < arrlen(iwads); ++i) {
		char *filename;

		filename = iwads[i].name;

		if (M_FileExists(filename)) {
			CheckChex(iwads[i].name);
			gamemission = iwads[i].mission;

			return filename;
		}
	}

	return NULL;
}

// When given an IWAD with the '-iwad' parameter,
// attempt to identify it by its name.

static void IdentifyIWADByName(char *name)
{
	size_t i;

	gamemission = none;

	for (i = 0; i < arrlen(iwads); ++i) {
		char *iwadname;

		iwadname = iwads[i].name;

		if (strlen(name) < strlen(iwadname))
			continue;

		// Check if it ends in this IWAD name.

		if (!strcasecmp(name + strlen(name) - strlen(iwadname),
				iwadname)) {
			CheckChex(iwads[i].name);
			gamemission = iwads[i].mission;
			break;
		}
	}
}

//
// Searches WAD search paths for an WAD with a specific filename.
// 

char *D_FindWADByName(char *name)
{
	if (M_FileExists(name)) {
		return name;
	}
	// File not found

	return NULL;
}

//
// D_TryWADByName
//
// Searches for a WAD by its filename, or passes through the filename
// if not found.
//

char *D_TryFindWADByName(char *filename)
{
	char *result;

	result = D_FindWADByName(filename);

	if (result != NULL) {
		return result;
	} else {
		return filename;
	}
}

//
// FindIWAD
// Checks availability of IWAD files by name,
// to determine whether registered/commercial features
// should be executed (notably loading PWADs).
//

char *D_FindIWAD(void)
{
	char *result;
	char *iwadfile;
	int iwadparm;
	int i;

	// Check for the -iwad parameter

	//!
	// Specify an IWAD file to use.
	//
	// @arg <file>
	//

	iwadparm = M_CheckParm("-iwad");

	if (iwadparm) {
		// Search through IWAD dirs for an IWAD with the given name.

		iwadfile = myargv[iwadparm + 1];

		result = D_FindWADByName(iwadfile);

		if (result == NULL) {
			I_Error("IWAD file '%s' not found!", iwadfile);
		}

		IdentifyIWADByName(result);
	} else {
		result = SearchDirectoryForIWAD();
	}

	return result;
}

// 
// Get the IWAD name used for savegames.
//

static char *SaveGameIWADName(void)
{
	size_t i;

	// Chex quest hack

	if (gameversion == exe_chex) {
		return "chex.wad";
	}
	// Find what subdirectory to use for savegames
	//
	// They should be stored in something like
	//    ~/.chocolate-doom/savegames/doom.wad/
	//
	// The directory depends on the IWAD, so that savegames for
	// different IWADs are kept separate.
	//
	// Note that we match on gamemission rather than on IWAD name.
	// This ensures that doom1.wad and doom.wad saves are stored
	// in the same place.

	for (i = 0; i < arrlen(iwads); ++i) {
		if (gamemission == iwads[i].mission) {
			return iwads[i].name;
		}
	}

	return NULL;
}

static char *GetGameName(char *gamename)
{
	return gamename;
}

//
// Find out what version of Doom is playing.
//

void D_IdentifyVersion(void)
{
	// gamemission is set up by the D_FindIWAD function.  But if 
	// we specify '-iwad', we have to identify using 
	// IdentifyIWADByName.  However, if the iwad does not match
	// any known IWAD name, we may have a dilemma.  Try to 
	// identify by its contents.

	if (gamemission == none) {
		unsigned int i;

		for (i = 0; i < numlumps; ++i) {
			if (!strncasecmp(lumpinfo[i].name, "MAP01", 8)) {
				gamemission = doom2;
				break;
			} else if (!strncasecmp(lumpinfo[i].name, "E1M1", 8)) {
				gamemission = doom;
				break;
			}
		}

		if (gamemission == none) {
			// Still no idea.  I don't think this is going to work.

			I_Error("Unknown or invalid IWAD file.");
		}
	}
	// Make sure gamemode is set up correctly

	if (gamemission == doom) {
		// Doom 1.  But which version?

		if (W_CheckNumForName("E4M1") > 0) {
			// Ultimate Doom

			gamemode = retail;
		} else if (W_CheckNumForName("E3M1") > 0) {
			gamemode = registered;
		} else {
			gamemode = shareware;
		}
	} else {
		// Doom 2 of some kind.

		gamemode = commercial;
	}
}

// Set the gamedescription string

void D_SetGameDescription(void)
{
	gamedescription = "Unknown";

	if (gamemission == doom) {
		// Doom 1.  But which version?

		if (gamemode == retail) {
			// Ultimate Doom

			gamedescription = GetGameName("The Ultimate DOOM");
		} else if (gamemode == registered) {
			gamedescription = GetGameName("DOOM Registered");
		} else if (gamemode == shareware) {
			gamedescription = GetGameName("DOOM Shareware");
		}
	} else {
		// Doom 2 of some kind.  But which mission?

		if (gamemission == doom2)
			gamedescription = GetGameName("DOOM 2: Hell on Earth");
		else if (gamemission == pack_plut)
			gamedescription =
			    GetGameName("DOOM 2: Plutonia Experiment");
		else if (gamemission == pack_tnt)
			gamedescription =
			    GetGameName("DOOM 2: TNT - Evilution");
	}
}
