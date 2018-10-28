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
//      DOOM main program (D_DoomMain) and game loop (D_DoomLoop),
//      plus functions to determine game mode (shareware, registered),
//      parse command line parameters, configure game parameters (turbo),
//      and call the startup functions.
//
//-----------------------------------------------------------------------------

#include <ctype.h>

//#include "config.h"
#include "doomdef.h"
#include "doomstat.h"

#include "dstrings.h"
#include "doomfeatures.h"
#include "sounds.h"

#include "d_iwad.h"

#include "z_zone.h"
#include "w_wad.h"
#include "w_merge.h"
#include "s_sound.h"
#include "v_video.h"

#include "f_finale.h"
#include "f_wipe.h"

#include "m_argv.h"
#include "m_config.h"
#include "m_misc.h"
#include "m_menu.h"
#include "p_saveg.h"

#include "i_system.h"
#include "i_video.h"
#include "i_timer.h"
#include "i_sound.h"
#include "i_oplmusic.h"

#include "g_game.h"

#include "hu_stuff.h"
#include "wi_stuff.h"
#include "st_stuff.h"
#include "am_map.h"

#include "p_setup.h"
#include "r_local.h"

#include "d_main.h"


//
// D-DoomLoop()
// Not a globally visible function,
//  just included for source reference,
//  called by D_DoomMain, never exits.
// Manages timing and IO,
//  calls all ?_Responder, ?_Ticker, and ?_Drawer,
//  calls I_GetTime, I_StartFrame, and I_StartTic
//
void D_DoomLoop(void);

char *iwadfile;

boolean devparm = false;	// started game with -devparm
boolean nomonsters = false;	// checkparm of -nomonsters
boolean respawnparm = false;	// checkparm of -respawn
boolean fastparm = false;	// checkparm of -fast

//extern int soundVolume;
//extern  int   sfxVolume;
//extern  int   musicVolume;

static skill_t startskill;
static int startepisode;
static int startmap;

// Savegame slot to load on startup.  This is the value provided to
// the -loadgame option.  If this has not been provided, this is -1.

static boolean autostart;
static int startloadgame;

boolean advancedemo = false;

// Store demo, do not accept any inputs

boolean storedemo = false;


void D_ProcessEvents(void);
void G_BuildTiccmd(ticcmd_t * cmd);
void D_DoAdvanceDemo(void);

//
// D_ProcessEvents
// Send all the events of the given timestamp down the responder chain
//
void D_ProcessEvents(void)
{
	event_t ev;

	// IF STORE DEMO, DO NOT ACCEPT INPUT
	if (storedemo)
		return;

	while (I_PopEvent(&ev)) {
		if (M_Responder(&ev))
			continue;	// menu ate the event
		G_Responder(&ev);
	}
}

//
// D_Display
//  draw current display, possibly wiping it from the previous
//

// wipegamestate can be set to -1 to force a wipe on the next draw
gamestate_t wipegamestate = GS_DEMOSCREEN;
static gamestate_t oldgamestate = -1;
void R_ExecuteSetViewSize(void);

void D_Display(fixed_t frac)
{
	static boolean automapstate = false;
	static boolean menuactivestate = false;
	static boolean inhelpscreensstate = false;
	static boolean oldviewheight = 0;
	int y;

	switch (gamestate) {
	case GS_LEVEL:
		if (!gametic)
			break;
		if (HU_Erase() ||
		    (inhelpscreensstate && !inhelpscreens) ||
		    (automapstate && !automapactive) ||
		    (menuactivestate && !menuactive) ||
		    (viewheight != oldviewheight) ||
		    gamestate != GS_LEVEL) {
			if (!automapactive)
				R_FillScreenBorder();
			ST_Drawer(viewheight == 200, true);
		} else {
			ST_Drawer(viewheight == 200, false);
		}

		if (automapactive)
			AM_Drawer();
		else
			R_RenderPlayerView(&players[displayplayer], frac);

		HU_Drawer();
		break;

	case GS_INTERMISSION:
		WI_Drawer();
		break;

	case GS_FINALE:
		F_Drawer();
		break;

	case GS_DEMOSCREEN:
		D_PageDrawer();
		break;
	}

	// clean up border stuff
	if (gamestate != oldgamestate && gamestate != GS_LEVEL)
		I_SetPalette(W_CacheLumpName("PLAYPAL", PU_CACHE));

	oldviewheight = viewheight;
	menuactivestate = menuactive;
	automapstate = automapactive;
	inhelpscreensstate = inhelpscreens;

	// draw pause pic
	if (paused) {
		if (automapactive)
			y = 4;
		else
			y = viewwindowy + 4;
		V_DrawPatchDirect(viewwindowx + (scaledviewwidth - 68) / 2,
				  y, 0, W_CacheLumpName("M_PAUSE", PU_CACHE));
	}
}

extern boolean demorecording;

void D_DoomTicker(int tics, fixed_t frac)
{
	static boolean wipe = false;
	int i;
  
	if (tics > 4) tics = 4;

	if (!wipe) {
		D_ProcessEvents();

		for (i = 0; i < tics; ++i) {
			D_DoAdvanceDemo();
			M_Ticker();
			G_Ticker();
		}

		// move positional sounds
		S_UpdateSounds(players[consoleplayer].mo);

		// change the view size if needed
		if (setsizeneeded) {
			R_ExecuteSetViewSize();
			oldgamestate = -1;	// force background redraw
		}
		// save the current screen if about to wipe
		if (gamestate != wipegamestate) {
			wipe = true;
			wipe_StartScreen(0, 0, SCREENWIDTH, SCREENHEIGHT);
		}

		D_Display(frac);
		oldgamestate = wipegamestate = gamestate;

		if (wipe) {
			wipe_EndScreen(0, 0, SCREENWIDTH, SCREENHEIGHT);
		}
	}

	if (wipe && tics > 0) {
		if (wipe_ScreenWipe(wipe_Melt, 0, 0, SCREENWIDTH, SCREENHEIGHT,
				    tics)) {
			// done
			wipe = false;
		}
	}

	// menu is drawn even on top of everything
	M_Drawer();
	I_FinishUpdate();
}

//
//  D_DoomLoop
//
void D_DoomLoop(void)
{
	int nowtime, prevtime;
	fixed_t tics = 0;

	if (demorecording)
		G_BeginRecording();

	R_ExecuteSetViewSize();

	prevtime = I_GetTimeMS();

	while (1) {
		nowtime = I_GetTimeMS();
		tics += (nowtime - prevtime) * (FRACUNIT * TICRATE / 1000);
		prevtime = nowtime;

		I_UpdateSound();
    if (I_MusicIsPlaying())
      I_PlayTrack();

		D_DoomTicker(tics >> FRACBITS, tics & (FRACUNIT-1));
		tics &= FRACUNIT-1;
	}
}

//
//  DEMO LOOP
//
static int demosequence;
static int pagetic;
static char *pagename;

//
// D_PageTicker
// Handles timing for warped projection
//
void D_PageTicker(void)
{
	if (--pagetic < 0)
		D_AdvanceDemo();
}

//
// D_PageDrawer
//
void D_PageDrawer(void)
{
	V_DrawPatch(0, 0, 0, W_CacheLumpName(pagename, PU_CACHE));
}

//
// D_AdvanceDemo
// Called after each demo or intro demosequence finishes
//
void D_AdvanceDemo(void)
{
	advancedemo = true;
}

//
// This cycles through the demo sequences.
// FIXME - version dependend demo numbers?
//
void D_DoAdvanceDemo(void)
{
	if (!advancedemo)
		return;

	players[consoleplayer].playerstate = PST_LIVE;	// not reborn
	advancedemo = false;
	usergame = false;	// no save / end game here
	paused = false;
	gameaction = ga_nothing;

	if (gamemode == retail && gameversion != exe_chex)
		demosequence = (demosequence + 1) % 7;
	else
		demosequence = (demosequence + 1) % 6;

	switch (demosequence) {
	case 0:
		if (gamemode == commercial)
			pagetic = TICRATE * 11;
		else
			pagetic = 170;
		gamestate = GS_DEMOSCREEN;
		pagename = "TITLEPIC";
		if (gamemode == commercial)
			S_StartMusic(mus_dm2ttl);
		else
			S_StartMusic(mus_introa);
		break;
	case 1:
		G_DeferedPlayDemo("demo1");
		break;
	case 2:
		pagetic = 200;
		gamestate = GS_DEMOSCREEN;
		pagename = "CREDIT";
		break;
	case 3:
		G_DeferedPlayDemo("demo2");
		break;
	case 4:
		gamestate = GS_DEMOSCREEN;
		if (gamemode == commercial) {
			pagetic = TICRATE * 11;
			pagename = "TITLEPIC";
			S_ChangeMusic(mus_dm2ttl, false);
		} else {
			pagetic = 200;

			if (gamemode == retail)
				pagename = "CREDIT";
			else
				pagename = "HELP2";
		}
		break;
	case 5:
		G_DeferedPlayDemo("demo3");
		break;
		// THE DEFINITIVE DOOM Special Edition demo
	case 6:
		G_DeferedPlayDemo("demo4");
		break;
	}
}

//
// D_StartTitle
//
void D_StartTitle(void)
{
	gameaction = ga_nothing;
	demosequence = -1;
	D_AdvanceDemo();
}

//      print title for every printed line
char title[128];

static boolean D_AddFile(char *filename)
{
	wad_file_t *handle;

	printf(" adding %s\n", filename);
	handle = W_AddFile(filename);

	return handle != NULL;
}

// Startup banner

void PrintBanner(char *msg)
{
	int i;
	int spaces = 35 - (strlen(msg) / 2);

	for (i = 0; i < spaces; ++i)
		putchar(' ');

	puts(msg);
}

static struct {
	char *description;
	char *cmdline;
	GameVersion_t version;
} gameversions[] = {
	{
	"Doom 1.9", "1.9", exe_doom_1_9}, {
	"Ultimate Doom", "ultimate", exe_ultimate}, {
	"Final Doom", "final", exe_final}, {
	"Chex Quest", "chex", exe_chex}, {
NULL, NULL, 0},};

// Initialise the game version

static void InitGameVersion(void)
{
	int p;
	int i;

	//! 
	// @arg <version>
	// @category compat
	//
	// Emulate a specific version of Doom.  Valid values are "1.9",
	// "ultimate" and "final".
	//

	p = M_CheckParm("-gameversion");

	if (p > 0) {
		for (i = 0; gameversions[i].description != NULL; ++i) {
			if (!strcmp(myargv[p + 1], gameversions[i].cmdline)) {
				gameversion = gameversions[i].version;
				break;
			}
		}

		if (gameversions[i].description == NULL) {
			printf("Supported game versions:\n");

			for (i=0; gameversions[i].description != NULL; ++i)
			{
				printf("\t%s (%s)\n", gameversions[i].cmdline,
				gameversions[i].description);
			}

			I_Error("Unknown game version '%s'", myargv[p + 1]);
		}
	} else {
		// Determine automatically

		if (gameversion == exe_chex) {
			// Already determined
		} else if (gamemode == shareware || gamemode == registered) {
			// original

			gameversion = exe_doom_1_9;
		} else if (gamemode == retail) {
			gameversion = exe_ultimate;
		} else if (gamemode == commercial) {
			if (gamemission == doom2) {
				gameversion = exe_doom_1_9;
			} else {
				// Final Doom: tnt or plutonia

				gameversion = exe_final;
			}
		}
	}

	// The original exe does not support retail - 4th episode not supported

	if (gameversion < exe_ultimate && gamemode == retail) {
		gamemode = registered;
	}
	// EXEs prior to the Final Doom exes do not support Final Doom.

	if (gameversion < exe_final && gamemode == commercial) {
		gamemission = doom2;
	}
}

void PrintGameVersion(void)
{
	int i;

	for (i = 0; gameversions[i].description != NULL; ++i) {
		if (gameversions[i].version == gameversion) {
			printf("Emulating the behavior of the "
			   "'%s' executable.\n", gameversions[i].description);
			break;
		}
	}
}

//
// D_DoomMain
//
void D_DoomMain(void)
{
	int p;
	char file[256];
	char demolumpname[9];

	M_FindResponseFile();

	// print banner

	//PrintBanner(PACKAGE_STRING);

	printf("Z_Init: Init zone memory allocation daemon. \n");
	Z_Init();

	printf("Looking for iwad file \n");
	iwadfile = D_FindIWAD();

	// None found?
	printf("Checking if it was found \n");

	if (iwadfile == NULL) {
		I_Error
		    ("Game mode indeterminate.  No IWAD file was found.  Try\n"
		     "specifying one with the '-iwad' command line parameter.\n");
	}

	modifiedgame = false;

	//!
	// @vanilla
	//
	// Disable monsters.
	//

	nomonsters = M_CheckParm("-nomonsters");

	//!
	// @vanilla
	//
	// Monsters respawn after being killed.
	//

	respawnparm = M_CheckParm("-respawn");

	//!
	// @vanilla
	//
	// Monsters move faster.
	//

	fastparm = M_CheckParm("-fast");

	//! 
	// @vanilla
	//
	// Developer mode.  F1 saves a screenshot in the current working
	// directory.
	//

	devparm = M_CheckParm("-devparm");

	//!
	// @category net
	// @vanilla
	//
	// Start a deathmatch game.
	//

	if (M_CheckParm("-deathmatch"))
		deathmatch = 1;

	//!
	// @category net
	// @vanilla
	//
	// Start a deathmatch 2.0 game.  Weapons do not stay in place and
	// all items respawn after 30 seconds.
	//

	if (M_CheckParm("-altdeath"))
		deathmatch = 2;

	if (devparm)
		printf(D_DEVSTR);

	//!
	// @arg <x>
	// @vanilla
	//
	// Turbo mode.  The player's speed is multiplied by x%.  If unspecified,
	// x defaults to 200.  Values are rounded up to 10 and down to 400.
	//

	if ((p = M_CheckParm("-turbo"))) {
		int scale = 200;
		extern int forwardmove[2];
		extern int sidemove[2];

		if (p < myargc - 1)
			scale = atoi(myargv[p + 1]);
		if (scale < 10)
			scale = 10;
		if (scale > 400)
			scale = 400;
		printf ("turbo scale: %i%%\n",scale);
		forwardmove[0] = forwardmove[0] * scale / 100;
		forwardmove[1] = forwardmove[1] * scale / 100;
		sidemove[0] = sidemove[0] * scale / 100;
		sidemove[1] = sidemove[1] * scale / 100;
	}
	// init subsystems
	printf("V_Init: allocate screens.\n");
	V_Init();

	printf("M_LoadDefaults: Load system defaults.\n");
	M_LoadDefaults();	// load before initing other systems

	printf("W_Init: Init WADfiles.\n");
	D_AddFile(iwadfile);

#ifdef FEATURE_WAD_MERGE

	// Merged PWADs are loaded first, because they are supposed to be 
	// modified IWADs.

	//!
	// @arg <files>
	// @category mod
	//
	// Simulates the behavior of deutex's -merge option, merging a PWAD
	// into the main IWAD.  Multiple files may be specified.
	//

	p = M_CheckParm("-merge");

	if (p > 0) {
		for (p = p + 1; p < myargc && myargv[p][0] != '-'; ++p) {
			char *filename;

			filename = D_TryFindWADByName(myargv[p]);

			printf(" merging %s\n", filename);
			W_MergeFile(filename);
		}
	}
	// NWT-style merging:

	// NWT's -merge option:

	//!
	// @arg <files>
	// @category mod
	//
	// Simulates the behavior of NWT's -merge option.  Multiple files
	// may be specified.

	p = M_CheckParm("-nwtmerge");

	if (p > 0) {
		for (p = p + 1; p < myargc && myargv[p][0] != '-'; ++p) {
			char *filename;

			filename = D_TryFindWADByName(myargv[p]);

			printf(" performing NWT-style merge of %s\n", filename);
			W_NWTDashMerge(filename);
		}
	}
	// Add flats

	//!
	// @arg <files>
	// @category mod
	//
	// Simulates the behavior of NWT's -af option, merging flats into
	// the main IWAD directory.  Multiple files may be specified.
	//

	p = M_CheckParm("-af");

	if (p > 0) {
		for (p = p + 1; p < myargc && myargv[p][0] != '-'; ++p) {
			char *filename;

			filename = D_TryFindWADByName(myargv[p]);

			printf(" merging flats from %s\n", filename);
			W_NWTMergeFile(filename, W_NWT_MERGE_FLATS);
		}
	}
	//!
	// @arg <files>
	// @category mod
	//
	// Simulates the behavior of NWT's -as option, merging sprites
	// into the main IWAD directory.  Multiple files may be specified.
	//

	p = M_CheckParm("-as");

	if (p > 0) {
		for (p = p + 1; p < myargc && myargv[p][0] != '-'; ++p) {
			char *filename;

			filename = D_TryFindWADByName(myargv[p]);

			printf(" merging sprites from %s\n", filename);
			W_NWTMergeFile(filename, W_NWT_MERGE_SPRITES);
		}
	}
	//!
	// @arg <files>
	// @category mod
	//
	// Equivalent to "-af <files> -as <files>".
	//

	p = M_CheckParm("-aa");

	if (p > 0) {
		for (p = p + 1; p < myargc && myargv[p][0] != '-'; ++p) {
			char *filename;

			filename = D_TryFindWADByName(myargv[p]);

			printf(" merging sprites and flats from %s\n", filename);
			W_NWTMergeFile(filename,
				       W_NWT_MERGE_SPRITES | W_NWT_MERGE_FLATS);
		}
	}
#endif

	//!
	// @arg <files>
	// @vanilla
	//
	// Load the specified PWAD files.
	//

	p = M_CheckParm("-file");
	if (p) {
		// the parms after p are wadfile/lump names,
		// until end of parms or another - preceded parm
		modifiedgame = true;	// homebrew levels
		while (++p != myargc && myargv[p][0] != '-') {
			char *filename;

			filename = D_TryFindWADByName(myargv[p]);

			D_AddFile(filename);
		}
	}
	// add any files specified on the command line with -file wadfile
	// to the wad list
	//
	// convenience hack to allow -wart e m to add a wad file
	// prepend a tilde to the filename so wadfile will be reloadable
	/*p = M_CheckParm ("-wart");
	   if (p)
	   {
	   myargv[p][4] = 'p';     // big hack, change to -warp

	   // Map name handling.
	   switch (gamemode )
	   {
	   case shareware:
	   case retail:
	   case registered:
	   sprintf (file,"~"DEVMAPS"E%cM%c.wad",
	   myargv[p+1][0], myargv[p+2][0]);
	   printf("Warping to Episode %s, Map %s.\n",
	   myargv[p+1],myargv[p+2]);
	   break;

	   case commercial:
	   default:
	   p = atoi (myargv[p+1]);
	   if (p<10)
	   sprintf(file,"~"DEVMAPS"cdata/map0%i.wad", p);
	   else
	   sprintf(file,"~"DEVMAPS"cdata/map%i.wad", p);
	   break;
	   }
	   D_AddFile (file);
	   } */

	//!
	// @arg <demo>
	// @category demo
	// @vanilla
	//
	// Play back the demo named demo.lmp.
	//

	p = M_CheckParm("-playdemo");

	if (!p) {
		//!
		// @arg <demo>
		// @category demo
		// @vanilla
		//
		// Play back the demo named demo.lmp, determining the framerate
		// of the screen.
		//
		p = M_CheckParm("-timedemo");

	}

	if (p && p < myargc - 1) {
		strcpy(file, myargv[p + 1]);

		if (D_AddFile(file)) {
			strncpy(demolumpname, lumpinfo[numlumps - 1].name, 8);
			demolumpname[8] = '\0';
			printf("Playing demo %s.\n", file);
		} else {
			// If file failed to load, still continue trying to play
			// the demo in the same way as Vanilla Doom.  This makes
			// tricks like "-playdemo demo1" possible.

			strncpy(demolumpname, myargv[p + 1], 8);
			demolumpname[8] = '\0';
		}

	}
	// Generate the WAD hash table.  Speed things up a bit.

	printf("W_Init: Generate Hash Table.\n");
	W_GenerateHashTable();

	D_IdentifyVersion();
	InitGameVersion();
	D_SetGameDescription();

	// Check for -file in shareware
	if (modifiedgame) {
		// These are the lumps that will be checked in IWAD,
		// if any one is not present, execution will be aborted.
		char name[23][8] = {
			"e2m1", "e2m2", "e2m3", "e2m4", "e2m5", "e2m6", "e2m7",
			"e2m8", "e2m9",
			"e3m1", "e3m3", "e3m3", "e3m4", "e3m5", "e3m6", "e3m7",
			"e3m8", "e3m9",
			"dphoof", "bfgga0", "heada1", "cybra1", "spida1d1"
		};
		int i;

		if (gamemode == shareware)
			I_Error("\nYou cannot -file with the shareware "
				"version. Register!");

		// Check for fake IWAD with right name,
		// but w/o all the lumps of the registered version. 
		if (gamemode == registered)
			for (i = 0; i < 23; i++)
				if (W_CheckNumForName(name[i]) < 0)
					I_Error
					    ("\nThis is not the registered version.");
	}
	// get skill / episode / map from parms
	startskill = sk_medium;
	startepisode = 1;
	startmap = 1;
	autostart = false;

	//!
	// @arg <skill>
	// @vanilla
	//
	// Set the game skill, 1-5 (1: easiest, 5: hardest).  A skill of
	// 0 disables all monsters.
	//

	p = M_CheckParm("-skill");

	if (p && p < myargc - 1) {
		startskill = myargv[p + 1][0] - '1';
		autostart = true;
	}
	//!
	// @arg <n>
	// @vanilla
	//
	// Start playing on episode n (1-4)
	//

	p = M_CheckParm("-episode");

	if (p && p < myargc - 1) {
		startepisode = myargv[p + 1][0] - '0';
		startmap = 1;
		autostart = true;
	}

	timelimit = 0;

	//! 
	// @arg <n>
	// @category net
	// @vanilla
	//
	// For multiplayer games: exit each level after n minutes.
	//

	p = M_CheckParm("-timer");

	if (p && p < myargc - 1 && deathmatch) {
		timelimit = atoi(myargv[p + 1]);
		printf("timer: %i\n", timelimit);
	}
	//!
	// @category net
	// @vanilla
	//
	// Austin Virtual Gaming: end levels after 20 minutes.
	//

	p = M_CheckParm("-avg");

	if (p && p < myargc - 1 && deathmatch) {
		printf("Austin Virtual Gaming: Levels will end "
			"after 20 minutes\n");
		timelimit = 20;
	}
	//!
	// @arg [<x> <y> | <xy>]
	// @vanilla
	//
	// Start a game immediately, warping to ExMy (Doom 1) or MAPxy
	// (Doom 2)
	//

	p = M_CheckParm("-warp");

	if (p && p < myargc - 1) {
		if (gamemode == commercial)
			startmap = atoi(myargv[p + 1]);
		else {
			startepisode = myargv[p + 1][0] - '0';

			if (p + 2 < myargc) {
				startmap = myargv[p + 2][0] - '0';
			} else {
				startmap = 1;
			}
		}
		autostart = true;
	}
	// Check for load game parameter
	// We do this here and save the slot number, so that the network code
	// can override it or send the load slot to other players.

	//!
	// @arg <s>
	// @vanilla
	//
	// Load the game in slot s.
	//

	p = M_CheckParm("-loadgame");

	if (p && p < myargc - 1) {
		startloadgame = atoi(myargv[p + 1]);
	} else {
		// Not loading a game
		startloadgame = -1;
	}

	//!
	// @category video
	//
	// Disable vertical mouse movement.
	//

	if (M_CheckParm("-novert"))
		novert = true;

	//!
	// @category video
	//
	// Enable vertical mouse movement.
	//

	if (M_CheckParm("-nonovert"))
		novert = false;

	if (W_CheckNumForName("SS_START") >= 0
	    || W_CheckNumForName("FF_END") >= 0) {
		printf
		    ("===========================================================================\n");
		printf
		    (" WARNING: The loaded WAD file contains modified sprites or\n"
		     " floor textures.  You may want to use the '-merge' command\n"
		     " line option instead of '-file'.\n");
	}

	printf
	    ("===========================================================================\n");

	PrintBanner(gamedescription);

	printf
	    ("===========================================================================\n"
//	     " " PACKAGE_NAME
	     " is free software, covered by the GNU General Public\n"
	     " License.  There is NO warranty; not even for MERCHANTABILITY or FITNESS\n"
	     " FOR A PARTICULAR PURPOSE. You are welcome to change and distribute\n"
	     " copies under certain conditions. See the source for more information.\n"
	     "===========================================================================\n");

	printf("M_Init: Init miscellaneous info.\n");
	M_Init();

	printf("R_Init: Init DOOM refresh daemon - ");
	R_Init();

	printf("\nP_Init: Init Playloop state.\n");
	P_Init();

	printf("\nG_Init: Init game state.\n");
	G_Init();

	printf("S_Init: Setting up sound.\n");
	S_Init(sfxVolume * 8, musicVolume * 8);

	PrintGameVersion();

	printf("HU_Init: Setting up heads up display.\n");
	HU_Init();

	printf("ST_Init: Init status bar.\n");
	ST_Init();

	// If Doom II without a MAP01 lump, this is a store demo.  
	// Moved this here so that MAP01 isn't constantly looked up
	// in the main loop.

	if (gamemode == commercial && W_CheckNumForName("map01") < 0)
		storedemo = true;

	printf("\nI_InitGraphics: Init graphics.\n");
	I_InitGraphics();

	//!
	// @arg <x>
	// @category demo
	// @vanilla
	//
	// Record a demo named x.lmp.
	//

	p = M_CheckParm("-record");

	if (p && p < myargc - 1) {
		G_RecordDemo(myargv[p + 1]);
		autostart = true;
	}

	p = M_CheckParm("-playdemo");
	if (p && p < myargc - 1) {
		singledemo = true;	// quit after one demo
		G_DeferedPlayDemo(demolumpname);
		D_DoomLoop();	// never returns
	}

	if (startloadgame >= 0) {
		strcpy(file, P_SaveGameFile(startloadgame));
		G_LoadGame(file);
	}

	if (gameaction != ga_loadgame) {
		if (autostart || netgame)
			G_InitNew(startskill, startepisode, startmap);
		else
			D_StartTitle();	// start up intro loop
	}

	printf("D_DoomLoop: GO!\n");
	D_DoomLoop();		// never returns
}
