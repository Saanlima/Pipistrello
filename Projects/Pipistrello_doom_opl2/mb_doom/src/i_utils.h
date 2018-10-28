

#ifndef __I_UTILS__
#define __I_UTILS__

#include "types.h"

extern void enable_interrupts(void);                 /* Enable Interrupts */
extern void disable_interrupts(void);                /* Disable Interrupts */
extern void enable_icache(void);                     /* Enable Instruction Cache */
extern void disable_icache(void);                    /* Disable Instruction Cache */
extern void enable_dcache(void);                     /* Enable Instruction Cache */
extern void disable_dcache(void);                    /* Disable Instruction Cache */
extern void enable_exceptions(void);                 /* Enable hardware exceptions */
extern void disable_exceptions(void);                /* Disable hardware exceptions */
extern void invalidate_icache(void);                 /* Invalidate the entire icache */
extern void invalidate_dcache(void);                 /* Invalidate the entire dcache */
extern void flush_dcache(void);                      /* Flush the whole dcache */
extern void invalidate_icache_range(unsigned int cacheaddr, unsigned int len);   /* Invalidate a part of the icache */
extern void invalidate_dcache_range(unsigned int cacheaddr, unsigned int len);   /* Invalidate a part of the dcache */
extern void flush_dcache_range(unsigned int cacheaddr, unsigned int len);        /* Flush a part of the dcache */
extern void scrub(void);                             /* Scrub LMB and internal BRAM */

#endif
