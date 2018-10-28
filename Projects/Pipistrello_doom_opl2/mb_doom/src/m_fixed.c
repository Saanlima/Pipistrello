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
//      Fixed point implementation.
//
//-----------------------------------------------------------------------------

#include "doomtype.h"
#include "i_system.h"
#include "doomdef.h"

#include "m_fixed.h"

fixed_t FixedMul(fixed_t a, fixed_t b)
{
  return ((int64_t) a * (int64_t) b) >> FRACBITS;
}

static uint32_t quickdiv(uint32_t a, uint32_t div)
{
	if (div >= 0x10000) {
		div >>= 8;
		return ((a / div) << 8)
			+ ((a % div) << 8) / div;
	} else {
		return ((a / div) << 16)
			+ ((a % div) << 16) / div;
	}
}

#define QUICK_MATH

fixed_t FixedDiv(fixed_t a, fixed_t b)
{
	int neg = 0;
	if ((abs(a) >> 14) >= abs(b)) {
		return (a ^ b) < 0 ? INT_MIN : INT_MAX;
	}

#ifdef QUICK_MATH
	if (a < 0) {
		neg = !neg;
		a = -a;
	}
	if (b < 0) {
		neg = !neg;
		b = -b;
	}
	if (!neg)
		return quickdiv(a, b);
	else
		return -(fixed_t)quickdiv(a, b);
#else
	return (fixed_t) (((int64_t) a << 16) / b);
#endif
}
