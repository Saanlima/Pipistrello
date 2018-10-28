#ifndef __I_REGISTERS__
#define __I_REGISTERS__

#include "types.h"

// Microblaze system register map

// Interrupt controller
#define INTC_ISR       (*(volatile uint32_t *)(0x41200000)) /* Interrupt Status Register */
#define INTC_IPR       (*(volatile uint32_t *)(0x41200004)) /* Interrupt Pending Register */
#define INTC_IER       (*(volatile uint32_t *)(0x41200008)) /* Interrupt Enable Register */
#define INTC_IAR       (*(volatile uint32_t *)(0x4120000c)) /* Interrupt Acknowledge Register */
#define INTC_SIE       (*(volatile uint32_t *)(0x41200010)) /* Set Interrupt Enable Register */
#define INTC_CIE       (*(volatile uint32_t *)(0x41200014)) /* Clear Interrupt Enable Register */
#define INTC_IVR       (*(volatile uint32_t *)(0x41200018)) /* Interrupt Vector Register */
#define INTC_MER       (*(volatile uint32_t *)(0x4120001c)) /* Master Enable Register */

// Timer
#define TMR_DCR        (*(volatile uint16_t *)(0x43000000))
#define TMR_DELAY      (*(volatile uint32_t *)(0x43000004))
#define TMR_MICROS     (*(volatile uint32_t *)(0x43000008))
#define TMR_MILLIS     (*(volatile uint32_t *)(0x4300000c))
#define TMR_INT        0x000004

// UART
#define UART0_UDR      (*(volatile  uint8_t *)(0x44000000))
#define UART0_UCR      (*(volatile uint16_t *)(0x44000004))
#define UART0_UBRR     (*(volatile uint16_t *)(0x44000008))
#define UART0_INT      0x000008

// SPI
#define SPI0_PORT      (*(volatile uint16_t *)(0x45000000))
#define SPI0_PORTSET   (*(volatile uint16_t *)(0x45000004))
#define SPI0_PORTCLR   (*(volatile uint16_t *)(0x45000008))
#define SPI0_PORTTGL   (*(volatile uint16_t *)(0x4500000c))
#define SPI0_DIR       (*(volatile uint16_t *)(0x45000010))
#define SPI0_DIRSET    (*(volatile uint16_t *)(0x45000014))
#define SPI0_DIRCLR    (*(volatile uint16_t *)(0x45000018))
#define SPI0_PIN       (*(volatile uint16_t *)(0x4500001c))
#define SPI0_SPCR      (*(volatile uint8_t *)(0x45000020))
#define SPI0_SPSR      (*(volatile uint8_t *)(0x45000024))
#define SPI0_SPDR      (*(volatile uint8_t *)(0x45000028))
#define SPI0_INT       0x000020


// Audio
#define SOUND0_PERIOD  (*(volatile uint16_t *)(0x46000000))
#define SOUND0_CONTROL (*(volatile uint8_t *)(0x46000004))
#define SOUND0_STATUS  (*(volatile uint8_t *)(0x46000008))
#define SOUND0_FIFO    (*(volatile uint32_t *)(0x4600000c))
#define SOUND0_OPL3    (*(volatile uint32_t *)(0x46000008))
#define SOUND0_INT     0x0000010

// PS2
#define KBD_DATA       (*(volatile uint8_t *)(0x47000000))
#define KBD_CTRL       (*(volatile uint8_t *)(0x47000004))
#define KBD_INT        0x000001

// PS2
#define MOUSE_DATA     (*(volatile uint8_t *)(0x47800000))
#define MOUSE_CTRL     (*(volatile uint8_t *)(0x47800004))
#define MOUSE_INT      0x000002

// DVI
#define DVI_AR         (*(volatile uint32_t *)(0x48000000))
#define DVI_CR         (*(volatile uint32_t *)(0x48000004))
#define DVI_IESR       (*(volatile uint32_t *)(0x48000008))
#define DVI_INT        0x000040


// Register bit definitions

// UART UCR register bit definitions
#define UART_UCR_ENABLE    0x80
#define UART_UCR_RX_IE     0x40
#define UART_UCR_TX_IE     0x20
#define UART_UCR_RX_DATA   0x10
#define UART_UCR_RX_FULL   0x08
#define UART_UCR_TX_DATA   0x04
#define UART_UCR_TX_FULL   0x02
#define UART_UCR_TX_HALF   0x01

// SPI I/O bit definitions
#define SPI0_MISO       0
#define SPI0_MOSI       1
#define SPI0_SCK        2
#define SPI0_SS         3

// SPI register alias
#define SPCR   SPI0_SPCR
#define SPSR   SPI0_SPSR
#define SPDR   SPI0_SPDR

// SPCR bit definitions
#define SPIE            7
#define SPE             6
#define DORD            5
#define MSTR            4
#define SPR1            1
#define SPR0            0

// SPSR bit definitions
#define SPIF            7
#define SPI2X           0


#define F_CPU 100000000

#endif