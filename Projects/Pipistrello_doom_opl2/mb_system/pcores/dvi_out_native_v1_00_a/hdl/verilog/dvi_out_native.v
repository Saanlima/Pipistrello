//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor:        Xilinx
// \   \   \/    Version:       1.0.0
//  \   \        Filename:      vtc_demo.v
//  /   /        Date Created:  April 8, 2009
// /___/   /\    Author:        Bob Feng   
// \   \  /  \
//  \___\/\___\
//
// Devices:   Spartan-6 Generation FPGA
// Purpose:   SP601 board demo top level
// Contact:   
// Reference: None
//
// Revision History:
// 
//
//////////////////////////////////////////////////////////////////////////////
//
// LIMITED WARRANTY AND DISCLAIMER. These designs are provided to you "as is".
// Xilinx and its licensors make and you receive no warranties or conditions,
// express, implied, statutory or otherwise, and Xilinx specifically disclaims
// any implied warranties of merchantability, non-infringement, or fitness for
// a particular purpose. Xilinx does not warrant that the functions contained
// in these designs will meet your requirements, or that the operation of
// these designs will be uninterrupted or error free, or that defects in the
// designs will be corrected. Furthermore, Xilinx does not warrant or make any
// representations regarding use or the results of the use of the designs in
// terms of correctness, accuracy, reliability, or otherwise.
//
// LIMITATION OF LIABILITY. In no event will Xilinx or its licensors be liable
// for any loss of data, lost profits, cost or procurement of substitute goods
// or services, or for any special, incidental, consequential, or indirect
// damages arising from the use or operation of the designs or accompanying
// documentation, however caused and on any theory of liability. This
// limitation will apply even if Xilinx has been advised of the possibility
// of such damage. This limitation shall apply not-withstanding the failure
// of the essential purpose of any limited remedies herein.
//
//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

//`define USE_TG

module dvi_out_native (
	 input  wire reset,
	 input  wire pll_lckd,
	 input  wire clkin,                // pixel clock, from bufg
	 input  wire clkx2in,              // pixel clock x2, from bufg
	 input  wire clkx10in,             // pixel clock x10, unbuffered
	 input  wire [7:0] blue_din,       // Blue data in
	 input  wire [7:0] green_din,      // Green data in
	 input  wire [7:0] red_din,        // Red data in
	 input  wire       hsync,          // hsync data
	 input  wire       vsync,          // vsync data
	 input  wire       de,             // data enable
  
	 output wire [3:0] TMDS,
	 output wire [3:0] TMDSB
);
  
	wire 					 pclk = clkin;
	wire 					 pclkx2 = clkx2in;
	
	wire 					 pclkx10;
	wire 					 serdesstrobe;
	wire 					 bufpll_lock;

  wire  [7:0]    blue_enc;
  wire  [7:0]    green_enc;
  wire  [7:0]    red_enc;
  wire           hsync_enc;
  wire           vsync_enc;
  wire           de_enc;
  
 `ifdef USE_TG
   //640x480@60HZ
  parameter HPIXELS_VGA = 11'd640; //Horizontal Live Pixels
  parameter VLINES_VGA  = 11'd480; //Vertical Live ines
  parameter HSYNCPW_VGA = 11'd96;  //HSYNC Pulse Width
  parameter VSYNCPW_VGA = 11'd2;   //VSYNC Pulse Width
  parameter HFNPRCH_VGA = 11'd16;  //Horizontal Front Portch
  parameter VFNPRCH_VGA = 11'd11;  //Vertical Front Portch
  parameter HBKPRCH_VGA = 11'd48;  //Horizontal Front Portch
  parameter VBKPRCH_VGA = 11'd31;  //Vertical Front Portch

  reg [10:0] tc_hsblnk;
  reg [10:0] tc_hssync;
  reg [10:0] tc_hesync;
  reg [10:0] tc_heblnk;
  reg [10:0] tc_vsblnk;
  reg [10:0] tc_vssync;
  reg [10:0] tc_vesync;
  reg [10:0] tc_veblnk;
  
  reg hvsync_polarity; //1-Negative, 0-Positive
  
  always @ (*) begin
    hvsync_polarity = 1'b1;
    tc_hsblnk = HPIXELS_VGA - 11'd1;
    tc_hssync = HPIXELS_VGA - 11'd1 + HFNPRCH_VGA;
    tc_hesync = HPIXELS_VGA - 11'd1 + HFNPRCH_VGA + HSYNCPW_VGA;
    tc_heblnk = HPIXELS_VGA - 11'd1 + HFNPRCH_VGA + HSYNCPW_VGA + HBKPRCH_VGA;
    tc_vsblnk =  VLINES_VGA - 11'd1;
    tc_vssync =  VLINES_VGA - 11'd1 + VFNPRCH_VGA;
    tc_vesync =  VLINES_VGA - 11'd1 + VFNPRCH_VGA + VSYNCPW_VGA;
    tc_veblnk =  VLINES_VGA - 11'd1 + VFNPRCH_VGA + VSYNCPW_VGA + VBKPRCH_VGA;
  end

  wire          VGA_HSYNC_INT, VGA_VSYNC_INT;
  wire   [10:0] bgnd_hcount;
  wire          bgnd_hsync;
  wire          bgnd_hblnk;
  wire   [10:0] bgnd_vcount;
  wire          bgnd_vsync;
  wire          bgnd_vblnk;

  timing timing_inst (
    .tc_hsblnk(tc_hsblnk), //input
    .tc_hssync(tc_hssync), //input
    .tc_hesync(tc_hesync), //input
    .tc_heblnk(tc_heblnk), //input
    .hcount(bgnd_hcount), //output
    .hsync(VGA_HSYNC_INT), //output
    .hblnk(bgnd_hblnk), //output
    .tc_vsblnk(tc_vsblnk), //input
    .tc_vssync(tc_vssync), //input
    .tc_vesync(tc_vesync), //input
    .tc_veblnk(tc_veblnk), //input
    .vcount(bgnd_vcount), //output
    .vsync(VGA_VSYNC_INT), //output
    .vblnk(bgnd_vblnk), //output
    .restart(reset),
    .clk(pclk));

  /////////////////////////////////////////
  // V/H SYNC and DE generator
  /////////////////////////////////////////

  reg active_q;
  reg vsync_tg, hsync_tg;
  reg VGA_HSYNC, VGA_VSYNC;
  reg de_tg;

  always @ (posedge pclk)
  begin
    hsync_tg <= VGA_HSYNC_INT ^ hvsync_polarity ;
    vsync_tg <= VGA_VSYNC_INT ^ hvsync_polarity ;
    VGA_HSYNC <= hsync;
    VGA_VSYNC <= vsync;
    active_q <= !bgnd_hblnk && !bgnd_vblnk;
    de_tg <= active_q;
  end

  wire  [7:0]    blue_data;
  wire  [7:0]    green_data;
  wire  [7:0]    red_data;

  hdcolorbar clrbar(
    .i_clk_74M(pclk),
    .i_rst(reset),
    .i_hcnt(bgnd_hcount),
    .i_vcnt(bgnd_vcount),
    .baronly(1'b0),
    .i_format(2'b00),
    .o_r(red_data),
    .o_g(green_data),
    .o_b(blue_data)
  );
  
  reg [9:0] ramp;
  always @ (posedge pclk) begin
    if (!de)
      ramp <= 0;
    else
      ramp <= ramp + 1'b1;
  end

  assign blue_enc = blue_data;
  assign green_enc = green_data;
  assign red_enc = red_data;
  assign hsync_enc = hsync_tg;
  assign vsync_enc = vsync_tg;
  assign de_enc = de_tg;
`else
  assign blue_enc = blue_din;
  assign green_enc = green_din;
  assign red_enc = red_din;
  assign hsync_enc = hsync;
  assign vsync_enc = vsync;
  assign de_enc = de;
`endif

  ////////////////////////////////////////////////////////////////
  // DVI Encoder
  ////////////////////////////////////////////////////////////////
  wire [4:0] tmds_data0, tmds_data1, tmds_data2;
    
  dvi_encoder enc0 (
    .clkin      (pclk),
    .clkx2in    (pclkx2),
    .rstin      (reset),
    .blue_din   (blue_enc),
    .green_din  (green_enc),
    .red_din    (red_enc),
    .hsync      (hsync_enc),
    .vsync      (vsync_enc),
    .de         (de_enc),
    .tmds_data0 (tmds_data0),
    .tmds_data1 (tmds_data1),
    .tmds_data2 (tmds_data2));

	
	wire [2:0] tmdsint;
	wire 		   serdes_rst = reset | ~bufpll_lock;

	BUFPLL #(.DIVIDE(5)) ioclk_buf (.PLLIN(clkx10in), .GCLK(pclkx2), .LOCKED(pll_lckd),
											  .IOCLK(pclkx10), .SERDESSTROBE(serdesstrobe), .LOCK(bufpll_lock));


  serdes_n_to_1 #(.SF(5)) oserdes0 (
             .ioclk(pclkx10),
             .serdesstrobe(serdesstrobe),
             .reset(serdes_rst),
             .gclk(pclkx2),
             .datain(tmds_data0),
             .iob_data_out(tmdsint[0])) ;

  serdes_n_to_1 #(.SF(5)) oserdes1 (
             .ioclk(pclkx10),
             .serdesstrobe(serdesstrobe),
             .reset(serdes_rst),
             .gclk(pclkx2),
             .datain(tmds_data1),
             .iob_data_out(tmdsint[1])) ;

  serdes_n_to_1 #(.SF(5)) oserdes2 (
             .ioclk(pclkx10),
             .serdesstrobe(serdesstrobe),
             .reset(serdes_rst),
             .gclk(pclkx2),
             .datain(tmds_data2),
             .iob_data_out(tmdsint[2])) ;

  OBUFDS TMDS0 (.I(tmdsint[0]), .O(TMDS[0]), .OB(TMDSB[0])) ;
  OBUFDS TMDS1 (.I(tmdsint[1]), .O(TMDS[1]), .OB(TMDSB[1])) ;
  OBUFDS TMDS2 (.I(tmdsint[2]), .O(TMDS[2]), .OB(TMDSB[2])) ;


  reg [4:0] tmdsclkint = 5'b00000;
  reg toggle = 1'b0;

  always @ (posedge pclkx2 or posedge serdes_rst) begin
    if (serdes_rst)
      toggle <= 1'b0;
    else
      toggle <= ~toggle;
  end

  always @ (posedge pclkx2) begin
    if (toggle)
      tmdsclkint <= 5'b11111;
    else
      tmdsclkint <= 5'b00000;
  end

  wire tmdsclk;

  serdes_n_to_1 #(
    .SF           (5))
  clkout (
    .iob_data_out (tmdsclk),
    .ioclk        (pclkx10),
    .serdesstrobe (serdesstrobe),
    .gclk         (pclkx2),
    .reset        (serdes_rst),
    .datain       (tmdsclkint));

  OBUFDS TMDS3 (.I(tmdsclk), .O(TMDS[3]), .OB(TMDSB[3])) ;// clock

endmodule
