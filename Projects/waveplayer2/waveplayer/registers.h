#define UART0_UDR      (*(volatile  uint8_t *)(0xc0000000))
#define UART0_UCR      (*(volatile uint16_t *)(0xc0000004))
#define UART0_UBRR     (*(volatile uint16_t *)(0xc0000008))
#define UART0_INT      0x000008

#define WINGA_PORT     (*(volatile uint16_t *)(0xc0000100))
#define WINGA_PORTSET  (*(volatile uint16_t *)(0xc0000104))
#define WINGA_PORTCLR  (*(volatile uint16_t *)(0xc0000108))
#define WINGA_PORTTGL  (*(volatile uint16_t *)(0xc000010c))
#define WINGA_DIR      (*(volatile uint16_t *)(0xc0000110))
#define WINGA_DIRSET   (*(volatile uint16_t *)(0xc0000114))
#define WINGA_DIRCLR   (*(volatile uint16_t *)(0xc0000118))
#define WINGA_PIN      (*(volatile uint16_t *)(0xc000011c))
#define WINGA_PWMCMP0  (*(volatile uint16_t *)(0xc0000120))
#define WINGA_PWMCMP1  (*(volatile uint16_t *)(0xc0000124))
#define WINGA_PWMCMP2  (*(volatile uint16_t *)(0xc0000128))
#define WINGA_PWMCMP3  (*(volatile uint16_t *)(0xc000012c))
#define WINGA_PWMCMP4  (*(volatile uint16_t *)(0xc0000130))
#define WINGA_PWMCMP5  (*(volatile uint16_t *)(0xc0000134))
#define WINGA_PWMCMP6  (*(volatile uint16_t *)(0xc0000138))
#define WINGA_PWMCMP7  (*(volatile uint16_t *)(0xc000013c))
#define WINGA_PWMCMP8  (*(volatile uint16_t *)(0xc0000140))
#define WINGA_PWMCMP9  (*(volatile uint16_t *)(0xc0000144))
#define WINGA_PWMCMP10 (*(volatile uint16_t *)(0xc0000148))
#define WINGA_PWMCMP11 (*(volatile uint16_t *)(0xc000014c))
#define WINGA_PWMCMP12 (*(volatile uint16_t *)(0xc0000150))
#define WINGA_PWMCMP13 (*(volatile uint16_t *)(0xc0000154))
#define WINGA_PWMCMP14 (*(volatile uint16_t *)(0xc0000158))
#define WINGA_PWMCMP15 (*(volatile uint16_t *)(0xc000015c))
#define WINGA_PWMEN    (*(volatile uint16_t *)(0xc0000160))
#define WINGA_PWMENSET (*(volatile uint16_t *)(0xc0000164))
#define WINGA_PWMENCLR (*(volatile uint16_t *)(0xc0000168))
#define WINGA_INTSEL   (*(volatile uint16_t *)(0xc000016c))
#define WINGA_INTFLG   (*(volatile uint16_t *)(0xc0000170))
#define WINGA_LEDMAP   (*(volatile uint16_t *)(0xc0000174))
#define WINGA_SET      (*(volatile uint32_t *)(0xc0000178))
#define WINGA_CLR      (*(volatile uint32_t *)(0xc000017c))
#define WINGA_INT      0x000010

#define TMR_DCR        (*(volatile uint16_t *)(0xc0000200))
#define TMR_DELAY      (*(volatile uint32_t *)(0xc0000204))
#define TMR_MICROS     (*(volatile uint32_t *)(0xc0000208))
#define TMR_MILLIS     (*(volatile uint32_t *)(0xc000020c))

#define SPI0_PORT      (*(volatile uint16_t *)(0xc0000300))
#define SPI0_PORTSET   (*(volatile uint16_t *)(0xc0000304))
#define SPI0_PORTCLR   (*(volatile uint16_t *)(0xc0000308))
#define SPI0_PORTTGL   (*(volatile uint16_t *)(0xc000030c))
#define SPI0_DIR       (*(volatile uint16_t *)(0xc0000310))
#define SPI0_DIRSET    (*(volatile uint16_t *)(0xc0000314))
#define SPI0_DIRCLR    (*(volatile uint16_t *)(0xc0000318))
#define SPI0_PIN       (*(volatile uint16_t *)(0xc000031c))
#define SPI0_SPCR      (*(volatile  uint8_t *)(0xc0000320))
#define SPI0_SPSR      (*(volatile  uint8_t *)(0xc0000324))
#define SPI0_SPDR      (*(volatile  uint8_t *)(0xc0000328))

#define SOUND0_PERIOD  (*(volatile uint16_t *)(0xc0000400))
#define SOUND0_CONTROL (*(volatile  uint8_t *)(0xc0000404))
#define SOUND0_STATUS  (*(volatile  uint8_t *)(0xc0000408))
#define SOUND0_FIFO    (*(volatile uint32_t *)(0xc000040c))


// UART UCR register bit definitions
#define UART_UCR_ENABLE    0x80
#define UART_UCR_RX_IE     0x40
#define UART_UCR_TX_IE     0x20
#define UART_UCR_RX_DATA   0x10
#define UART_UCR_RX_FULL   0x08
#define UART_UCR_TX_DATA   0x04
#define UART_UCR_TX_FULL   0x02
#define UART_UCR_TX_HALF   0x01

// Timer DCR register bit definitions
#define TMR_DCR_ENABLE     0x0100
#define TMR_DCR_DLY_TO     0x0200

// SPI I/O bit definitions
#define SPI_MISO        0
#define SPI_MOSI        1
#define SPI_SCK         2
#define SPI_SS          3

// SPCR bit definitions
#define SPIE            7
#define SPE             6
#define DORD            5
#define MSTR            4
#define CPOL            3
#define CPHA            2
#define SPR1            1
#define SPR0            0

// SPSR bit definitions
#define SPIF            7
#define SPI2X           0

// Processor clock rate (in Hz)
#define F_CPU           120000000



