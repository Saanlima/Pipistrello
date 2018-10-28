
#ifndef __SPI_FLASH_H__
#define __SPI_FLASH_H__

extern int spi_flash_init();
extern int spi_flash_read(unsigned addr, int bytes, char *dest);

#endif
