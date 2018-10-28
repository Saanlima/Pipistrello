/******************************************************************************
*
*       ELF Loader
*
*       written by Magnus Karlsson
*       (c) Copyright 2013 Saanlima Electronics
*       All rights reserved.
*
******************************************************************************/

#include <stdio.h>
#include <stdint.h>
#include "platform.h"
#include "spi_flash.h"

// location of the elf file in flash memory space
#define ELF_IMAGE_BASEADDR 0x180000

#define EI_NIDENT       16
#define Elf32_Addr      uint32_t
#define Elf32_Half      uint16_t
#define Elf32_Word      uint32_t
#define Elf32_Off       uint32_t



typedef struct {
        unsigned char   e_ident[EI_NIDENT];
        Elf32_Half      e_type;
        Elf32_Half      e_machine;
        Elf32_Word      e_version;
        Elf32_Addr      e_entry;
        Elf32_Off       e_phoff;
        Elf32_Off       e_shoff;
        Elf32_Word      e_flags;
        Elf32_Half      e_ehsize;
        Elf32_Half      e_phentsize;
        Elf32_Half      e_phnum;
        Elf32_Half      e_shentsize;
        Elf32_Half      e_shnum;
        Elf32_Half      e_shstrndx;
} Elf32_Ehdr;

typedef struct {
        Elf32_Word      p_type;
        Elf32_Off       p_offset;
        Elf32_Addr      p_vaddr;
        Elf32_Addr      p_paddr;
        Elf32_Word      p_filesz;
        Elf32_Word      p_memsz;
        Elf32_Word      p_flags;
        Elf32_Word      p_align;
} Elf32_Phdr;


void sendByte(uint8_t c)
{
  while ((UART_CONTROL & 0x02))    ;
  UART_DATA = c;
}

void printString(char *line) {
  while (*line)
    sendByte(*line++);
}

int main()
{
	int i;
	uint32_t p_header_addr;
    void (*fp)();
    Elf32_Ehdr * elf_header;
    Elf32_Phdr * program_header;

    init_platform();

    printString("\r\n\nPipistrello ELF bootloader\r\n\n");

    spi_flash_init();

    // read the ELF header
    spi_flash_read(ELF_IMAGE_BASEADDR, sizeof(Elf32_Ehdr), (char*)elf_header);

    // make sure we have an ELF image
    if ((elf_header->e_ident[0] == 0x7f) &&
    	(elf_header->e_ident[1] == 'E') &&
    	(elf_header->e_ident[2] == 'L') &&
    	(elf_header->e_ident[3] == 'F'))
      printString("Found ELF image\n\r");
    else
    {
    	printString("Error: no ELF image found!\n\r");
    	cleanup_platform();
    	return 0;
    }

    fp = (void *)elf_header->e_entry;

  	printString("Loading sections ...\r\n");
    p_header_addr = ELF_IMAGE_BASEADDR + elf_header->e_phoff;
    for (i = 0; i < elf_header->e_phnum; i++)
    {
    	// read the program header
    	spi_flash_read(p_header_addr, sizeof(Elf32_Phdr), (char*)program_header);
//    	xil_printf("   Program header %d: type = %d, size = 0x%x, address = 0x%x\n\r", i + 1
//    			, program_header->p_type, program_header->p_memsz, program_header->p_paddr);
    	if (program_header->p_type == 1)
    	{
    		spi_flash_read(ELF_IMAGE_BASEADDR + program_header->p_offset, program_header->p_memsz, (char*)program_header->p_paddr);
    	}
    	p_header_addr += elf_header->e_phentsize;
    }

  	printString("Finished loading sections\r\n");
  	printString("Starting program\r\n\n");

    cleanup_platform();
    (*fp)();

    // will never get here
    return 0;
}
