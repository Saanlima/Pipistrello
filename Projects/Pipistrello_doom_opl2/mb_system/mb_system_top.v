//-----------------------------------------------------------------------------
// mb_system_top.v
//-----------------------------------------------------------------------------

module mb_system_top
  (
    rzq,
    mcbx_dram_we_n,
    mcbx_dram_udqs,
    mcbx_dram_udm,
    mcbx_dram_ras_n,
    mcbx_dram_ldm,
    mcbx_dram_dqs,
    mcbx_dram_dq,
    mcbx_dram_clk_n,
    mcbx_dram_clk,
    mcbx_dram_cke,
    mcbx_dram_cas_n,
    mcbx_dram_ba,
    mcbx_dram_addr,
    USB_UART_TX,
    USB_UART_RX,
    SPI_FLASH_Wn,
    SPI_FLASH_SS,
    SPI_FLASH_SCLK,
    SPI_FLASH_MOSI,
    SPI_FLASH_MISO,
    SPI_FLASH_HOLDn,
    RESET,
    CLK_50MHZ,
    WING_A,
    LED1,
    LED2,
    LED3,
    LED4,
    SD_SPI,
    SD_LED,
    AUDIO_LEFT,
    AUDIO_RIGHT,
    PS2_CLK,
    PS2_DAT,
    MOUSE_CLK,
    MOUSE_DAT,
    TMDS,
    TMDSB
  );
  inout rzq;
  output mcbx_dram_we_n;
  inout mcbx_dram_udqs;
  output mcbx_dram_udm;
  output mcbx_dram_ras_n;
  output mcbx_dram_ldm;
  inout mcbx_dram_dqs;
  inout [15:0] mcbx_dram_dq;
  output mcbx_dram_clk_n;
  output mcbx_dram_clk;
  output mcbx_dram_cke;
  output mcbx_dram_cas_n;
  output [1:0] mcbx_dram_ba;
  output [12:0] mcbx_dram_addr;
  output USB_UART_TX;
  input USB_UART_RX;
  output SPI_FLASH_Wn;
  inout SPI_FLASH_SS;
  inout SPI_FLASH_SCLK;
  inout SPI_FLASH_MOSI;
  inout SPI_FLASH_MISO;
  output SPI_FLASH_HOLDn;
  input RESET;
  input CLK_50MHZ;
  inout [15:0] WING_A;
  output LED1;
  output LED2;
  output LED3;
  output LED4;
  inout [3:0] SD_SPI;
  output SD_LED;
  output AUDIO_LEFT;
  output AUDIO_RIGHT;
  inout PS2_CLK;
  inout PS2_DAT;
  inout MOUSE_CLK;
  inout MOUSE_DAT;
  output [3:0] TMDS;
  output [3:0] TMDSB;
  
  (* BOX_TYPE = "user_black_box" *)
  mb_system
    mb_system_i (
      .rzq ( rzq ),
      .mcbx_dram_we_n ( mcbx_dram_we_n ),
      .mcbx_dram_udqs ( mcbx_dram_udqs ),
      .mcbx_dram_udm ( mcbx_dram_udm ),
      .mcbx_dram_ras_n ( mcbx_dram_ras_n ),
      .mcbx_dram_ldm ( mcbx_dram_ldm ),
      .mcbx_dram_dqs ( mcbx_dram_dqs ),
      .mcbx_dram_dq ( mcbx_dram_dq ),
      .mcbx_dram_clk_n ( mcbx_dram_clk_n ),
      .mcbx_dram_clk ( mcbx_dram_clk ),
      .mcbx_dram_cke ( mcbx_dram_cke ),
      .mcbx_dram_cas_n ( mcbx_dram_cas_n ),
      .mcbx_dram_ba ( mcbx_dram_ba ),
      .mcbx_dram_addr ( mcbx_dram_addr ),
      .SPI_FLASH_Wn ( SPI_FLASH_Wn ),
      .SPI_FLASH_SS ( SPI_FLASH_SS ),
      .SPI_FLASH_SCLK ( SPI_FLASH_SCLK ),
      .SPI_FLASH_MOSI ( SPI_FLASH_MOSI ),
      .SPI_FLASH_MISO ( SPI_FLASH_MISO ),
      .SPI_FLASH_HOLDn ( SPI_FLASH_HOLDn ),
      .RESET ( RESET ),
      .CLK_50MHZ ( CLK_50MHZ ),
      .spi_0_SPI ( SD_SPI ),
      .spi_0_SPI_LED_pin ( SD_LED ),
      .wing_0_WING ( WING_A ),
      .wing_0_WING_LED1_pin ( LED1 ),
      .wing_0_WING_LED2_pin ( LED2 ),
      .wing_0_WING_LED3_pin ( LED3 ),
      .wing_0_WING_LED4_pin ( LED4 ),
      .uart_0_UART_TX_pin ( USB_UART_TX ),
      .uart_0_UART_RX_pin ( USB_UART_RX ),
      .sound_0_Audio_left_pin ( AUDIO_LEFT ),
      .sound_0_Audio_right_pin ( AUDIO_RIGHT ),
      .ps2_0_PS2_CLK(PS2_CLK),
      .ps2_0_PS2_DAT(PS2_DAT),
      .ps2_1_PS2_CLK(MOUSE_CLK),
      .ps2_1_PS2_DAT(MOUSE_DAT),
      .TMDS ( TMDS ),
      .TMDSB ( TMDSB )
    );

endmodule

