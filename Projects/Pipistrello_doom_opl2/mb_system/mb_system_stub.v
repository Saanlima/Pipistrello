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
    USB_Uart_sout,
    USB_Uart_sin,
    SPI_FLASH_Wn,
    SPI_FLASH_SS,
    SPI_FLASH_SCLK,
    SPI_FLASH_MOSI,
    SPI_FLASH_MISO,
    SPI_FLASH_HOLDn,
    RESET,
    CLK_50MHZ,
    wing_0_WING
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
  output USB_Uart_sout;
  input USB_Uart_sin;
  output SPI_FLASH_Wn;
  inout SPI_FLASH_SS;
  inout SPI_FLASH_SCLK;
  inout SPI_FLASH_MOSI;
  inout SPI_FLASH_MISO;
  output SPI_FLASH_HOLDn;
  input RESET;
  input CLK_50MHZ;
  inout [15:0] wing_0_WING;

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
      .USB_Uart_sout ( USB_Uart_sout ),
      .USB_Uart_sin ( USB_Uart_sin ),
      .SPI_FLASH_Wn ( SPI_FLASH_Wn ),
      .SPI_FLASH_SS ( SPI_FLASH_SS ),
      .SPI_FLASH_SCLK ( SPI_FLASH_SCLK ),
      .SPI_FLASH_MOSI ( SPI_FLASH_MOSI ),
      .SPI_FLASH_MISO ( SPI_FLASH_MISO ),
      .SPI_FLASH_HOLDn ( SPI_FLASH_HOLDn ),
      .RESET ( RESET ),
      .CLK_50MHZ ( CLK_50MHZ ),
      .wing_0_WING ( wing_0_WING )
    );

endmodule

