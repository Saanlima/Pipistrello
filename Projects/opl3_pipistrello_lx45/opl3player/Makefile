CC=mb-gcc
LD=mb-gcc

CSRC       = opl3player.c mmc.c ff.c ccsbcs.c
ASRC       = utils.S
COBJ       =  $(CSRC:.c=.o)
AOBJ       =  $(ASRC:.S=.o)

ELF_OUT    = opl3player.elf
BIT_OUT    = opl3player.bit
LD_SCRIPT  = bram.ld
TOP_BIT    = ../ise/top.bit
BD_BMM     = ../ise/ipcore_dir/microblaze_mcs_v1_3_bd.bmm
BSCAN_SPI  = bscan_spi_lx45_csg324.bit

CFLAGS=-c -g -Os -w -mlittle-endian -mcpu=v8.40.b
LDFLAGS=-Wl,--no-relax -Wl,-Map,build.map -Wl,-T -Wl,$(LD_SCRIPT) -mlittle-endian


$(BIT_OUT): $(TOP_BIT) $(ELF_OUT)
	data2mem -bm $(BD_BMM) -bt $(TOP_BIT) -bd $(ELF_OUT) -o b $(BIT_OUT)

$(ELF_OUT): $(COBJ) $(AOBJ) $(LD_SCRIPT)
	$(LD) $(LDFLAGS) -o $(ELF_OUT) $(COBJ) $(AOBJ)

$(COBJ) : %.o : %.c
	$(CC) $(CFLAGS) $< -o $@ 

$(AOBJ) : %.o : %.S
	$(CC) $(CFLAGS) $< -o $@
  
load: $(BIT_OUT)
	fpgaprog -v -f $(BIT_OUT)

flash: $(BIT_OUT)
	fpgaprog -v -f $(BIT_OUT) -b $(BSCAN_SPI) -sa -r

clean:
	rm -f $(ELF_OUT) $(BINARY) $(COBJ) $(AOBJ) *.map

.PHONY: clean