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
//
// DESCRIPTION:
//    Configuration file interface.
//
//-----------------------------------------------------------------------------

#include <ctype.h>

//#include "config.h"
#include "doomdef.h"
#include "doomfeatures.h"

#include "z_zone.h"

#include "m_menu.h"
#include "m_argv.h"

#include "w_wad.h"

#include "i_swap.h"
#include "i_system.h"
#include "i_video.h"
#include "v_video.h"

#include "hu_stuff.h"

// State.
#include "doomstat.h"

// Data.
#include "dstrings.h"

#include "m_misc.h"

//
// DEFAULTS
//

extern int key_right;
extern int key_left;
extern int key_up;
extern int key_down;

extern int key_strafeleft;
extern int key_straferight;

extern int key_fire;
extern int key_use;
extern int key_strafe;
extern int key_speed;

extern int dclick_use;

extern int viewwidth;
extern int viewheight;

extern int mouseSensitivity;
extern int showMessages;

// machine-independent sound params
extern int numChannels;

extern char *chat_macros[];

extern int vanilla_savegame_limit;
extern int vanilla_demo_limit;

typedef enum {
	DEFAULT_INT,
	DEFAULT_STRING,
	DEFAULT_FLOAT,
	DEFAULT_KEY,
} default_type_t;

typedef struct {
	// Name of the variable
	char *name;

	// Pointer to the location in memory of the variable
	void *location;

	// Type of the variable
	default_type_t type;

	// If this is a key value, the original integer scancode we read from
	// the config file before translating it to the internal key value.
	// If zero, we didn't read this value from a config file.
	int untranslated;

	// The value we translated the scancode into when we read the 
	// config file on startup.  If the variable value is different from
	// this, it has been changed and needs to be converted; otherwise,
	// use the 'untranslated' value.
	int original_translated;
} default_t;

typedef struct {
	default_t *defaults;
	int numdefaults;
	char *filename;
} default_collection_t;

#define CONFIG_VARIABLE_KEY(name, variable) \
    { #name, &variable, DEFAULT_KEY, 0, 0 }
#define CONFIG_VARIABLE_INT(name, variable) \
    { #name, &variable, DEFAULT_INT, 0, 0 }
#define CONFIG_VARIABLE_FLOAT(name, variable) \
    { #name, &variable, DEFAULT_FLOAT, 0, 0 }
#define CONFIG_VARIABLE_STRING(name, variable) \
    { #name, &variable, DEFAULT_STRING, 0, 0 }

//! @begin_config_file default.cfg

static default_t doom_defaults_list[] = {
	//! 
	// Mouse sensitivity.  This value is used to multiply input mouse
	// movement to control the effect of moving the mouse.
	//
	// The "normal" maximum value available for this through the 
	// in-game options menu is 9. A value of 31 or greater will cause
	// the game to crash when entering the options menu.
	//

	CONFIG_VARIABLE_INT(mouse_sensitivity, mouseSensitivity),

	//!
	// Volume of sound effects, range 0-15.
	//

	CONFIG_VARIABLE_INT(sfx_volume, sfxVolume),

	//!
	// Volume of in-game music, range 0-15.
	//

	CONFIG_VARIABLE_INT(music_volume, musicVolume),

	//!
	// If non-zero, messages are displayed on the heads-up display
	// in the game ("picked up a clip", etc).  If zero, these messages
	// are not displayed.
	//

	CONFIG_VARIABLE_INT(show_messages, showMessages),

	//! 
	// Keyboard key to turn right.
	//

	CONFIG_VARIABLE_KEY(key_right, key_right),

	//!
	// Keyboard key to turn left.
	//

	CONFIG_VARIABLE_KEY(key_left, key_left),

	//!
	// Keyboard key to move forward.
	//

	CONFIG_VARIABLE_KEY(key_up, key_up),

	//!
	// Keyboard key to move backward.
	//

	CONFIG_VARIABLE_KEY(key_down, key_down),

	//!
	// Keyboard key to strafe left.
	//

	CONFIG_VARIABLE_KEY(key_strafeleft, key_strafeleft),

	//!
	// Keyboard key to strafe right.
	//

	CONFIG_VARIABLE_KEY(key_straferight, key_straferight),

	//!
	// Keyboard key to fire the currently selected weapon.
	//

	CONFIG_VARIABLE_KEY(key_fire, key_fire),

	//!
	// Keyboard key to "use" an object, eg. a door or switch.
	//

	CONFIG_VARIABLE_KEY(key_use, key_use),

	//!
	// Keyboard key to turn on strafing.  When held down, pressing the
	// key to turn left or right causes the player to strafe left or
	// right instead.
	//

	CONFIG_VARIABLE_KEY(key_strafe, key_strafe),

	//!
	// Keyboard key to make the player run.
	//

	CONFIG_VARIABLE_KEY(key_speed, key_speed),

	//!
	// Screen size, range 3-11.
	//
	// A value of 11 gives a full-screen view with the status bar not 
	// displayed.  A value of 10 gives a full-screen view with the
	// status bar displayed.
	//

	CONFIG_VARIABLE_INT(screenblocks, screenblocks),

	//!
	// Screen detail.  Zero gives normal "high detail" mode, while
	// a non-zero value gives "low detail" mode.
	//

	CONFIG_VARIABLE_INT(detaillevel, detailLevel),

	//!
	// Gamma correction level.  A value of zero disables gamma 
	// correction, while a value in the range 1-4 gives increasing
	// levels of gamma correction.
	//

	CONFIG_VARIABLE_INT(usegamma, usegamma),

	//!
	// Multiplayer chat macro: message to send when alt+0 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro0, chat_macros[0]),

	//!
	// Multiplayer chat macro: message to send when alt+1 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro1, chat_macros[1]),

	//!
	// Multiplayer chat macro: message to send when alt+2 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro2, chat_macros[2]),

	//!
	// Multiplayer chat macro: message to send when alt+3 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro3, chat_macros[3]),

	//!
	// Multiplayer chat macro: message to send when alt+4 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro4, chat_macros[4]),

	//!
	// Multiplayer chat macro: message to send when alt+5 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro5, chat_macros[5]),

	//!
	// Multiplayer chat macro: message to send when alt+6 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro6, chat_macros[6]),

	//!
	// Multiplayer chat macro: message to send when alt+7 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro7, chat_macros[7]),

	//!
	// Multiplayer chat macro: message to send when alt+8 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro8, chat_macros[8]),

	//!
	// Multiplayer chat macro: message to send when alt+9 is pressed.
	//

	CONFIG_VARIABLE_STRING(chatmacro9, chat_macros[9]),
};

static default_collection_t doom_defaults = {
	doom_defaults_list,
	arrlen(doom_defaults_list),
	"default.cfg",
};

//! @begin_config_file chocolate-doom.cfg

static default_t extra_defaults_list[] = {
	//!
	// If non-zero, the Vanilla savegame limit is enforced; if the 
	// savegame exceeds 180224 bytes in size, the game will exit with
	// an error.  If this has a value of zero, there is no limit to
	// the size of savegames.
	//

	CONFIG_VARIABLE_INT(vanilla_savegame_limit, vanilla_savegame_limit),

	//!
	// If non-zero, the Vanilla demo size limit is enforced; the game 
	// exits with an error when a demo exceeds the demo size limit
	// (128KiB by default).  If this has a value of zero, there is no
	// limit to the size of demos.
	//

	CONFIG_VARIABLE_INT(vanilla_demo_limit, vanilla_demo_limit),

	//!
	// If non-zero, double-clicking a mouse button acts like pressing
	// the "use" key to use an object in-game, eg. a door or switch.
	//

	CONFIG_VARIABLE_INT(dclick_use, dclick_use),
};

static default_collection_t extra_defaults = {
	extra_defaults_list,
	arrlen(extra_defaults_list),
	"chocolate-doom.cfg",
};

#if 0
static const int scantokey[128] = {
	0, 27, '1', '2', '3', '4', '5', '6',
	'7', '8', '9', '0', '-', '=', KEY_BACKSPACE, 9,
	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i',
	'o', 'p', '[', ']', 13, KEY_RCTRL, 'a', 's',
	'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
	'\'', '`', KEY_RSHIFT, '\\', 'z', 'x', 'c', 'v',
	'b', 'n', 'm', ',', '.', '/', KEY_RSHIFT, KEYP_MULTIPLY,
	KEY_RALT, ' ', KEY_CAPSLOCK, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5,
	KEY_F6, KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_PAUSE, KEY_SCRLCK,
	    KEY_HOME,
	KEY_UPARROW, KEY_PGUP, KEY_MINUS, KEY_LEFTARROW, KEYP_5, KEY_RIGHTARROW,
	    KEYP_PLUS, KEY_END,
	KEY_DOWNARROW, KEY_PGDN, KEY_INS, KEY_DEL, 0, 0, 0, KEY_F11,
	KEY_F12, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0
};

static void SaveDefaultCollection(default_collection_t * collection)
{
	default_t *defaults;
	int i, v;
	FILE *f;

	f = fopen(collection->filename, "w");
	if (!f)
		return;		// can't write the file, but don't complain

	defaults = collection->defaults;

	for (i = 0; i < collection->numdefaults; i++) {
		int chars_written;

		// Print the name and line up all values at 30 characters

		chars_written = fprintf(f, "%s ", defaults[i].name);

		for (; chars_written < 30; ++chars_written)
			fprintf(f, " ");

		// Print the value

		switch (defaults[i].type) {
		case DEFAULT_KEY:

			// use the untranslated version if we can, to reduce
			// the possibility of screwing up the user's config
			// file

			v = *(int *)defaults[i].location;

			if (defaults[i].untranslated
			    && v == defaults[i].original_translated) {
				// Has not been changed since the last time we
				// read the config file.

				v = defaults[i].untranslated;
			} else {
				// search for a reverse mapping back to a scancode
				// in the scantokey table

				int s;

				for (s = 0; s < 128; ++s) {
					if (scantokey[s] == v) {
						v = s;
						break;
					}
				}
			}

			fprintf(f, "%i", v);
			break;

		case DEFAULT_INT:
			fprintf(f, "%i", *(int *)defaults[i].location);
			break;

		case DEFAULT_FLOAT:
			fprintf(f, "%f", *(float *)defaults[i].location);
			break;

		case DEFAULT_STRING:
			fprintf(f, "\"%s\"", *(char **)(defaults[i].location));
			break;
		}

		fprintf(f, "\n");
	}

	fclose(f);
}

// Parses integer values in the configuration file

static int ParseIntParameter(char *strparm)
{
	int parm;

	if (strparm[0] == '0' && strparm[1] == 'x')
		sscanf(strparm + 2, "%x", &parm);
	else
		sscanf(strparm, "%i", &parm);

	return parm;
}

static void LoadDefaultCollection(default_collection_t * collection)
{
	default_t *defaults = collection->defaults;
	int i;
	FILE *f;
	char defname[80];
	char strparm[100];

	// read the file in, overriding any set defaults
	f = fopen(collection->filename, "r");

	if (!f) {
		// File not opened, but don't complain

		return;
	}

	while (!feof(f)) {
		if (fscanf(f, "%79s %[^\n]\n", defname, strparm) != 2) {
			// This line doesn't match

			continue;
		}
		// Strip off trailing non-printable characters (\r characters
		// from DOS text files)

		while (strlen(strparm) > 0
		       && !isprint(strparm[strlen(strparm) - 1])) {
			strparm[strlen(strparm) - 1] = '\0';
		}

		// Find the setting in the list

		for (i = 0; i < collection->numdefaults; ++i) {
			default_t *def = &collection->defaults[i];
			char *s;
			int intparm;

			if (strcmp(defname, def->name) != 0) {
				// not this one
				continue;
			}
			// parameter found

			switch (def->type) {
			case DEFAULT_STRING:
				s = strdup(strparm + 1);
				s[strlen(s) - 1] = '\0';
				*(char **)def->location = s;
				break;

			case DEFAULT_INT:
				*(int *)def->location =
				    ParseIntParameter(strparm);
				break;

			case DEFAULT_KEY:

				// translate scancodes read from config
				// file (save the old value in untranslated)

				intparm = ParseIntParameter(strparm);
				defaults[i].untranslated = intparm;
				intparm = scantokey[intparm];

				defaults[i].original_translated = intparm;
				*(int *)def->location = intparm;
				break;

			case DEFAULT_FLOAT:
				*(float *)def->location = (float)atof(strparm);
				break;
			}

			// finish

			break;
		}
	}

	fclose(f);
}
#endif

//
// M_SaveDefaults
//

void M_SaveDefaults(void)
{
	/*SaveDefaultCollection(&doom_defaults);
	   SaveDefaultCollection(&extra_defaults); */
}

//
// M_LoadDefaults
//

void M_LoadDefaults(void)
{
	int i;

	// check for a custom default file

	//!
	// @arg <file>
	// @vanilla
	//
	// Load configuration from the specified file, instead of
	// default.cfg.
	//

	i = M_CheckParm("-config");

	if (i && i < myargc - 1) {
		doom_defaults.filename = myargv[i + 1];
		printf (" default file: %s\n",doom_defaults.filename);
	}

	printf("saving config in %s\n", doom_defaults.filename);

	//!
	// @arg <file>
	//
	// Load extra configuration from the specified file, instead 
	// of chocolate-doom.cfg.
	//

	i = M_CheckParm("-extraconfig");

	if (i && i < myargc - 1) {
		extra_defaults.filename = myargv[i + 1];
		printf("        extra configuration file: %s\n", 
		   extra_defaults.filename);
	}

	/*LoadDefaultCollection(&doom_defaults);
	   LoadDefaultCollection(&extra_defaults); */
}
