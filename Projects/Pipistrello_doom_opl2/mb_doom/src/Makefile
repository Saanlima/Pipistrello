CC=mb-gcc
LD=mb-gcc

CSRC       = am_map.c d_items.c d_iwad.c d_main.c doomdef.c doomstat.c dstrings.c \
             f_finale.c f_wipe.c g_game.c hu_lib.c hu_stuff.c \
             info.c i_main.c i_sound.c i_system.c i_timer.c i_video.c \
             m_argv.c m_bbox.c m_cheat.c m_config.c m_fixed.c m_menu.c m_misc.c m_random.c \
             p_ceilng.c p_doors.c p_enemy.c p_floor.c p_inter.c p_lights.c \
             p_map.c p_maputl.c p_mobj.c p_plats.c p_pspr.c p_saveg.c p_setup.c \
             p_sight.c p_spec.c p_switch.c p_telept.c p_tick.c p_user.c r_bsp.c \
             r_data.c r_draw.c r_main.c r_plane.c r_segs.c r_sky.c r_things.c \
             sounds.c s_sound.c st_lib.c st_stuff.c tables.c v_video.c wi_stuff.c \
             w_file.c w_merge.c w_wad.c z_zone.c \
             ff.c ccsbcs.c mmc.c i_oplmusic.c memio.c midifile.c mus2mid.c
ASRC       = i_utils.S
COBJ       =  $(CSRC:.c=.o)
AOBJ       =  $(ASRC:.S=.o)

ELF_OUT    = doom.elf
LD_SCRIPT  = lpddr.ld
BIT_OUT    = ../bit_files/doom.bit
ELF_BIT    = ../bit_files/elf.bit
MAP        = doom.map

CFLAGS=-c -g -Os -w -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mno-xl-soft-div -mcpu=v8.40.b -mno-xl-soft-mul -mxl-multiply-high -fmessage-length=0 -ffunction-sections -fdata-sections -MMD -DRANGECHECK
LDFLAGS=-Wl,--no-relax -Wl,-Map,$(MAP) -Wl,-T -Wl,$(LD_SCRIPT) -mlittle-endian

.PHONY: clean

elf: $(ELF_OUT)

bit: $(BIT_OUT)

flashdoom: $(BIT_OUT)
	../tools/fpgaprog.exe -v -f $(BIT_OUT) -b ../tools/bscan_spi_lx45_csg324.bit -n 180000 -sa -r

flashdoombit: $(BIT_OUT)
	../tools/fpgaprog.exe -v -f $(BIT_OUT) -b ../tools/bscan_spi_lx45_csg324.bit -sa -r

 $(BIT_OUT): $(ELF_BIT) $(ELF_OUT)
	../tools/bitmerge $(ELF_BIT) 180000:$(ELF_OUT) $(BIT_OUT)
  
$(ELF_OUT): $(COBJ) $(AOBJ) $(LD_SCRIPT)
	$(LD) $(LDFLAGS) -o $(ELF_OUT) $(COBJ) $(AOBJ)


$(COBJ) : %.o : %.c
	$(CC) $(CFLAGS) $< -o $@ 

$(AOBJ) : %.o : %.S
	$(CC) $(CFLAGS) $< -o $@
  
  
clean:
	rm -f $(ELF_OUT) $(COBJ) $(AOBJ) $(MAP) *.d

