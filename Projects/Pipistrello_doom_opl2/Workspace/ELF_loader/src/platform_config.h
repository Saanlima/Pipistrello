#ifndef __PLATFORM_CONFIG_H_
#define __PLATFORM_CONFIG_H_

#define UART_DATA (*(volatile uint8_t *)(0x44000000))
#define UART_CONTROL (*(volatile uint8_t *)(0x44000004))
#define BAUD_CONTROL (*(volatile uint16_t *)(0x44000008))

#endif
