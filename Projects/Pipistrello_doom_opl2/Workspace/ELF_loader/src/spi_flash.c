/******************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2009 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/

/***************************** Include Files *********************************/
#include "xparameters.h"        /* EDK generated parameters */
#include "xintc.h"              /* Interrupt controller device driver */
#include "xspi.h"               /* SPI device driver */
#include "mb_interface.h"       /* Microblaze interface */

#include <xstatus.h>
#include <stdio.h>
#include <string.h>

/************************** Constant Definitions *****************************/
/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define SPI_DEVICE_ID			XPAR_SPI_0_DEVICE_ID

/*
 * The following constant defines the slave select signal that is used to
 * to select the Flash device on the SPI bus, this signal is typically
 * connected to the chip select of the device.
 */
#define STM_SPI_SELECT 0x01

/*
 * Definitions of the commands 
 */
#define STM_COMMAND_RANDOM_READ		0x03    /* Random read command */
#define STM_COMMAND_PAGEPROGRAM_WRITE	0x02    /* Page Program command */
#define	STM_COMMAND_WRITE_ENABLE	0x06    /* Write Enable command */
#define STM_COMMAND_SECTOR_ERASE	0xD8    /* Sector Erase command */
#define STM_COMMAND_BULK_ERASE		0xC7    /* Bulk Erase command */
#define STM_COMMAND_STATUSREG_READ	0x05    /* Status read command */

/*
 * This definitions specify the EXTRA bytes in each of the command
 * transactions. This count includes Command byte, address bytes and any
 * don't care bytes needed.
 */
#define STM_READ_WRITE_EXTRA_BYTES	4       /* Read/Write extra bytes */
#define	STM_WRITE_ENABLE_BYTES		1       /* Write Enable bytes */
#define STM_SECTOR_ERASE_BYTES		4       /* Sector erase extra bytes */
#define STM_BULK_ERASE_BYTES		1       /* Bulk erase extra bytes */
#define STM_STATUS_READ_BYTES		2       /* Status read bytes count */
#define STM_STATUS_WRITE_BYTES		2       /* Status write bytes count */

/*
 * Flash not busy mask in the status register of the flash device.
 */
#define STM_FLASH_SR_IS_READY_MASK	0x01    /* Ready mask */

/*
 * Number of bytes per page in the flash device.
 */
#define STM_PAGE_SIZE		256

/*
 * Byte Positions.
 */
#define BYTE1				0       /* Byte 1 position */
#define BYTE2				1       /* Byte 2 position */
#define BYTE3				2       /* Byte 3 position */
#define BYTE4				3       /* Byte 4 position */
#define BYTE5				4       /* Byte 5 position */


/************************** Variable Definitions *****************************/
/*
 * The instances to support the device drivers are global such that they
 * are initialized to zero each time the program runs. They could be local
 * but should at least be static so they are zeroed.
 */
static XSpi Spi;

/*
 * Buffers used during read and write transactions.
 */
u8 ReadBuffer[STM_PAGE_SIZE + STM_READ_WRITE_EXTRA_BYTES];
u8 WriteBuffer[STM_PAGE_SIZE + STM_READ_WRITE_EXTRA_BYTES];

/************************** Function Definitions ******************************/

int
spi_flash_init()
{
    int Status;

    /*
     * Initialize the SPI driver so that it's ready to use,
     * specify the device ID that is generated in xparameters.h.
     */
    Status = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /*
     * Set the SPI device as a master and in manual slave select mode such
     * that the slave select signal does not toggle for every byte of a
     * transfer, this must be done before the slave select is set.
     */
    Status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION |
                             XSP_MANUAL_SSELECT_OPTION);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /*
     * Select the STM flash device on the SPI bus, so that it can be
     * read and written using the SPI bus.
     */
    Status = XSpi_SetSlaveSelect(&Spi, STM_SPI_SELECT);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /*
     * Start the SPI driver so that interrupts and the device are enabled.
     */
    XSpi_Start(&Spi);

    /*
     * Disable Global interrupt to use polled mode operation
     */
    XSpi_IntrGlobalDisable(&Spi);

    return 0;
}

/*****************************************************************************
*
* spi_flash_read:
*
* Read 'bytes' from the SPI flash from offset 'addr'.  Results stored in user
* provided buffer 'dest'.
*
******************************************************************************/
int
spi_flash_read(unsigned addr, int bytes, char *dest)
{
    int Status;
    unsigned int block;

    while (bytes > 0) {
        /*
         * Prepare the WriteBuffer.
         */
        WriteBuffer[BYTE1] = STM_COMMAND_RANDOM_READ;
        WriteBuffer[BYTE2] = (u8) (addr >> 16);
        WriteBuffer[BYTE3] = (u8) (addr >> 8);
        WriteBuffer[BYTE4] = (u8) addr;

        /*
         * Initiate the Transfer.
         */
        Status = XSpi_Transfer(&Spi, WriteBuffer, ReadBuffer,
                               (STM_PAGE_SIZE + STM_READ_WRITE_EXTRA_BYTES));
        if (Status != XST_SUCCESS) {
            return XST_FAILURE;
        }

        /* 
         * Copy to the end-user specified buffer.
         * XSpi_Transfer() can not be handed the end-user buffer directly as
         * it includes extra crud at offset 0 rather than the requested data.
         */
        if (bytes >= STM_PAGE_SIZE)
        {
        	block = STM_PAGE_SIZE;
        }
        else
        {
        	block = bytes;
        }

		memcpy(dest, &ReadBuffer[STM_READ_WRITE_EXTRA_BYTES], block);
		addr += block;
		dest += block;
		bytes -= block;

    }

    return XST_SUCCESS;
}

