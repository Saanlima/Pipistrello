//-----------------------------------------------------------------------------
// mb_system_stub.v
//-----------------------------------------------------------------------------

module mb_system_stub
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
    SPI_FLASH_Wn,
    SPI_FLASH_SS,
    SPI_FLASH_SCLK,
    SPI_FLASH_MOSI,
    SPI_FLASH_MISO,
    SPI_FLASH_HOLDn,
    RESET,
    CLK_50MHZ,
    wing_0_WING,
    uart_0_UART_TX_pin,
    uart_0_UART_RX_pin,
    wing_0_WING_LED1_pin,
    wing_0_WING_LED2_pin,
    wing_0_WING_LED3_pin,
    wing_0_WING_LED4_pin,
    spi_0_SPI,
    spi_0_SPI_LED_pin,
    TMDS,
    TMDSB,
    sound_0_Audio_left_pin,
    sound_0_Audio_right_pin,
    ps2_0_PS2_CLK,
    ps2_0_PS2_DAT,
    ps2_1_PS2_CLK,
    ps2_1_PS2_DAT,
    dvi_out_native_0_clkin_pin
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
  output SPI_FLASH_Wn;
  inout SPI_FLASH_SS;
  inout SPI_FLASH_SCLK;
  inout SPI_FLASH_MOSI;
  inout SPI_FLASH_MISO;
  output SPI_FLASH_HOLDn;
  input RESET;
  input CLK_50MHZ;
  inout [15:0] wing_0_WING;
  output uart_0_UART_TX_pin;
  input uart_0_UART_RX_pin;
  output wing_0_WING_LED1_pin;
  output wing_0_WING_LED2_pin;
  output wing_0_WING_LED3_pin;
  output wing_0_WING_LED4_pin;
  inout [3:0] spi_0_SPI;
  output spi_0_SPI_LED_pin;
  output [3:0] TMDS;
  output [3:0] TMDSB;
  output sound_0_Audio_left_pin;
  output sound_0_Audio_right_pin;
  inout ps2_0_PS2_CLK;
  inout ps2_0_PS2_DAT;
  inout ps2_1_PS2_CLK;
  inout ps2_1_PS2_DAT;
  input dvi_out_native_0_clkin_pin;

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
      .wing_0_WING ( wing_0_WING ),
      .uart_0_UART_TX_pin ( uart_0_UART_TX_pin ),
      .uart_0_UART_RX_pin ( uart_0_UART_RX_pin ),
      .wing_0_WING_LED1_pin ( wing_0_WING_LED1_pin ),
      .wing_0_WING_LED2_pin ( wing_0_WING_LED2_pin ),
      .wing_0_WING_LED3_pin ( wing_0_WING_LED3_pin ),
      .wing_0_WING_LED4_pin ( wing_0_WING_LED4_pin ),
      .spi_0_SPI ( spi_0_SPI ),
      .spi_0_SPI_LED_pin ( spi_0_SPI_LED_pin ),
      .TMDS ( TMDS ),
      .TMDSB ( TMDSB ),
      .sound_0_Audio_left_pin ( sound_0_Audio_left_pin ),
      .sound_0_Audio_right_pin ( sound_0_Audio_right_pin ),
      .ps2_0_PS2_CLK ( ps2_0_PS2_CLK ),
      .ps2_0_PS2_DAT ( ps2_0_PS2_DAT ),
      .ps2_1_PS2_CLK ( ps2_1_PS2_CLK ),
      .ps2_1_PS2_DAT ( ps2_1_PS2_DAT ),
      .dvi_out_native_0_clkin_pin ( dvi_out_native_0_clkin_pin )
    );

endmodule

module mb_system
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
    SPI_FLASH_Wn,
    SPI_FLASH_SS,
    SPI_FLASH_SCLK,
    SPI_FLASH_MOSI,
    SPI_FLASH_MISO,
    SPI_FLASH_HOLDn,
    RESET,
    CLK_50MHZ,
    wing_0_WING,
    uart_0_UART_TX_pin,
    uart_0_UART_RX_pin,
    wing_0_WING_LED1_pin,
    wing_0_WING_LED2_pin,
    wing_0_WING_LED3_pin,
    wing_0_WING_LED4_pin,
    spi_0_SPI,
    spi_0_SPI_LED_pin,
    TMDS,
    TMDSB,
    sound_0_Audio_left_pin,
    sound_0_Audio_right_pin,
    ps2_0_PS2_CLK,
    ps2_0_PS2_DAT,
    ps2_1_PS2_CLK,
    ps2_1_PS2_DAT,
    dvi_out_native_0_clkin_pin
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
  output SPI_FLASH_Wn;
  inout SPI_FLASH_SS;
  inout SPI_FLASH_SCLK;
  inout SPI_FLASH_MOSI;
  inout SPI_FLASH_MISO;
  output SPI_FLASH_HOLDn;
  input RESET;
  input CLK_50MHZ;
  inout [15:0] wing_0_WING;
  output uart_0_UART_TX_pin;
  input uart_0_UART_RX_pin;
  output wing_0_WING_LED1_pin;
  output wing_0_WING_LED2_pin;
  output wing_0_WING_LED3_pin;
  output wing_0_WING_LED4_pin;
  inout [3:0] spi_0_SPI;
  output spi_0_SPI_LED_pin;
  output [3:0] TMDS;
  output [3:0] TMDSB;
  output sound_0_Audio_left_pin;
  output sound_0_Audio_right_pin;
  inout ps2_0_PS2_CLK;
  inout ps2_0_PS2_DAT;
  inout ps2_1_PS2_CLK;
  inout ps2_1_PS2_DAT;
  input dvi_out_native_0_clkin_pin;
endmodule

