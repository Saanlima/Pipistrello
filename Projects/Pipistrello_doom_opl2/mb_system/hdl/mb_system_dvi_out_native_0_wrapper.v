//-----------------------------------------------------------------------------
// mb_system_dvi_out_native_0_wrapper.v
//-----------------------------------------------------------------------------

module mb_system_dvi_out_native_0_wrapper
  (
    reset,
    pll_lckd,
    clkin,
    clkx2in,
    clkx10in,
    blue_din,
    green_din,
    red_din,
    hsync,
    vsync,
    de,
    TMDS,
    TMDSB
  );
  input reset;
  input pll_lckd;
  input clkin;
  input clkx2in;
  input clkx10in;
  input [7:0] blue_din;
  input [7:0] green_din;
  input [7:0] red_din;
  input hsync;
  input vsync;
  input de;
  output [3:0] TMDS;
  output [3:0] TMDSB;

  dvi_out_native
    dvi_out_native_0 (
      .reset ( reset ),
      .pll_lckd ( pll_lckd ),
      .clkin ( clkin ),
      .clkx2in ( clkx2in ),
      .clkx10in ( clkx10in ),
      .blue_din ( blue_din ),
      .green_din ( green_din ),
      .red_din ( red_din ),
      .hsync ( hsync ),
      .vsync ( vsync ),
      .de ( de ),
      .TMDS ( TMDS ),
      .TMDSB ( TMDSB )
    );

endmodule

