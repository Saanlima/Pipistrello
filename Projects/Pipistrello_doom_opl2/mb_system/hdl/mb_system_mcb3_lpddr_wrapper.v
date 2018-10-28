//-----------------------------------------------------------------------------
// mb_system_mcb3_lpddr_wrapper.v
//-----------------------------------------------------------------------------

(* x_core_info = "axi_s6_ddrx_v1_06_a" *)
module mb_system_mcb3_lpddr_wrapper
  (
    sysclk_2x,
    sysclk_2x_180,
    pll_ce_0,
    pll_ce_90,
    pll_lock,
    pll_lock_bufpll_o,
    sysclk_2x_bufpll_o,
    sysclk_2x_180_bufpll_o,
    pll_ce_0_bufpll_o,
    pll_ce_90_bufpll_o,
    sys_rst,
    mcbx_dram_addr,
    mcbx_dram_ba,
    mcbx_dram_ras_n,
    mcbx_dram_cas_n,
    mcbx_dram_we_n,
    mcbx_dram_cke,
    mcbx_dram_clk,
    mcbx_dram_clk_n,
    mcbx_dram_dq,
    mcbx_dram_dqs,
    mcbx_dram_dqs_n,
    mcbx_dram_udqs,
    mcbx_dram_udqs_n,
    mcbx_dram_udm,
    mcbx_dram_ldm,
    mcbx_dram_odt,
    mcbx_dram_ddr3_rst,
    rzq,
    zio,
    ui_clk,
    uo_done_cal,
    s0_axi_aclk,
    s0_axi_aresetn,
    s0_axi_awid,
    s0_axi_awaddr,
    s0_axi_awlen,
    s0_axi_awsize,
    s0_axi_awburst,
    s0_axi_awlock,
    s0_axi_awcache,
    s0_axi_awprot,
    s0_axi_awqos,
    s0_axi_awvalid,
    s0_axi_awready,
    s0_axi_wdata,
    s0_axi_wstrb,
    s0_axi_wlast,
    s0_axi_wvalid,
    s0_axi_wready,
    s0_axi_bid,
    s0_axi_bresp,
    s0_axi_bvalid,
    s0_axi_bready,
    s0_axi_arid,
    s0_axi_araddr,
    s0_axi_arlen,
    s0_axi_arsize,
    s0_axi_arburst,
    s0_axi_arlock,
    s0_axi_arcache,
    s0_axi_arprot,
    s0_axi_arqos,
    s0_axi_arvalid,
    s0_axi_arready,
    s0_axi_rid,
    s0_axi_rdata,
    s0_axi_rresp,
    s0_axi_rlast,
    s0_axi_rvalid,
    s0_axi_rready,
    s1_axi_aclk,
    s1_axi_aresetn,
    s1_axi_awid,
    s1_axi_awaddr,
    s1_axi_awlen,
    s1_axi_awsize,
    s1_axi_awburst,
    s1_axi_awlock,
    s1_axi_awcache,
    s1_axi_awprot,
    s1_axi_awqos,
    s1_axi_awvalid,
    s1_axi_awready,
    s1_axi_wdata,
    s1_axi_wstrb,
    s1_axi_wlast,
    s1_axi_wvalid,
    s1_axi_wready,
    s1_axi_bid,
    s1_axi_bresp,
    s1_axi_bvalid,
    s1_axi_bready,
    s1_axi_arid,
    s1_axi_araddr,
    s1_axi_arlen,
    s1_axi_arsize,
    s1_axi_arburst,
    s1_axi_arlock,
    s1_axi_arcache,
    s1_axi_arprot,
    s1_axi_arqos,
    s1_axi_arvalid,
    s1_axi_arready,
    s1_axi_rid,
    s1_axi_rdata,
    s1_axi_rresp,
    s1_axi_rlast,
    s1_axi_rvalid,
    s1_axi_rready,
    s2_axi_aclk,
    s2_axi_aresetn,
    s2_axi_awid,
    s2_axi_awaddr,
    s2_axi_awlen,
    s2_axi_awsize,
    s2_axi_awburst,
    s2_axi_awlock,
    s2_axi_awcache,
    s2_axi_awprot,
    s2_axi_awqos,
    s2_axi_awvalid,
    s2_axi_awready,
    s2_axi_wdata,
    s2_axi_wstrb,
    s2_axi_wlast,
    s2_axi_wvalid,
    s2_axi_wready,
    s2_axi_bid,
    s2_axi_bresp,
    s2_axi_bvalid,
    s2_axi_bready,
    s2_axi_arid,
    s2_axi_araddr,
    s2_axi_arlen,
    s2_axi_arsize,
    s2_axi_arburst,
    s2_axi_arlock,
    s2_axi_arcache,
    s2_axi_arprot,
    s2_axi_arqos,
    s2_axi_arvalid,
    s2_axi_arready,
    s2_axi_rid,
    s2_axi_rdata,
    s2_axi_rresp,
    s2_axi_rlast,
    s2_axi_rvalid,
    s2_axi_rready,
    s3_axi_aclk,
    s3_axi_aresetn,
    s3_axi_awid,
    s3_axi_awaddr,
    s3_axi_awlen,
    s3_axi_awsize,
    s3_axi_awburst,
    s3_axi_awlock,
    s3_axi_awcache,
    s3_axi_awprot,
    s3_axi_awqos,
    s3_axi_awvalid,
    s3_axi_awready,
    s3_axi_wdata,
    s3_axi_wstrb,
    s3_axi_wlast,
    s3_axi_wvalid,
    s3_axi_wready,
    s3_axi_bid,
    s3_axi_bresp,
    s3_axi_bvalid,
    s3_axi_bready,
    s3_axi_arid,
    s3_axi_araddr,
    s3_axi_arlen,
    s3_axi_arsize,
    s3_axi_arburst,
    s3_axi_arlock,
    s3_axi_arcache,
    s3_axi_arprot,
    s3_axi_arqos,
    s3_axi_arvalid,
    s3_axi_arready,
    s3_axi_rid,
    s3_axi_rdata,
    s3_axi_rresp,
    s3_axi_rlast,
    s3_axi_rvalid,
    s3_axi_rready,
    s4_axi_aclk,
    s4_axi_aresetn,
    s4_axi_awid,
    s4_axi_awaddr,
    s4_axi_awlen,
    s4_axi_awsize,
    s4_axi_awburst,
    s4_axi_awlock,
    s4_axi_awcache,
    s4_axi_awprot,
    s4_axi_awqos,
    s4_axi_awvalid,
    s4_axi_awready,
    s4_axi_wdata,
    s4_axi_wstrb,
    s4_axi_wlast,
    s4_axi_wvalid,
    s4_axi_wready,
    s4_axi_bid,
    s4_axi_bresp,
    s4_axi_bvalid,
    s4_axi_bready,
    s4_axi_arid,
    s4_axi_araddr,
    s4_axi_arlen,
    s4_axi_arsize,
    s4_axi_arburst,
    s4_axi_arlock,
    s4_axi_arcache,
    s4_axi_arprot,
    s4_axi_arqos,
    s4_axi_arvalid,
    s4_axi_arready,
    s4_axi_rid,
    s4_axi_rdata,
    s4_axi_rresp,
    s4_axi_rlast,
    s4_axi_rvalid,
    s4_axi_rready,
    s5_axi_aclk,
    s5_axi_aresetn,
    s5_axi_awid,
    s5_axi_awaddr,
    s5_axi_awlen,
    s5_axi_awsize,
    s5_axi_awburst,
    s5_axi_awlock,
    s5_axi_awcache,
    s5_axi_awprot,
    s5_axi_awqos,
    s5_axi_awvalid,
    s5_axi_awready,
    s5_axi_wdata,
    s5_axi_wstrb,
    s5_axi_wlast,
    s5_axi_wvalid,
    s5_axi_wready,
    s5_axi_bid,
    s5_axi_bresp,
    s5_axi_bvalid,
    s5_axi_bready,
    s5_axi_arid,
    s5_axi_araddr,
    s5_axi_arlen,
    s5_axi_arsize,
    s5_axi_arburst,
    s5_axi_arlock,
    s5_axi_arcache,
    s5_axi_arprot,
    s5_axi_arqos,
    s5_axi_arvalid,
    s5_axi_arready,
    s5_axi_rid,
    s5_axi_rdata,
    s5_axi_rresp,
    s5_axi_rlast,
    s5_axi_rvalid,
    s5_axi_rready
  );
  input sysclk_2x;
  input sysclk_2x_180;
  input pll_ce_0;
  input pll_ce_90;
  input pll_lock;
  output pll_lock_bufpll_o;
  output sysclk_2x_bufpll_o;
  output sysclk_2x_180_bufpll_o;
  output pll_ce_0_bufpll_o;
  output pll_ce_90_bufpll_o;
  input sys_rst;
  output [12:0] mcbx_dram_addr;
  output [1:0] mcbx_dram_ba;
  output mcbx_dram_ras_n;
  output mcbx_dram_cas_n;
  output mcbx_dram_we_n;
  output mcbx_dram_cke;
  output mcbx_dram_clk;
  output mcbx_dram_clk_n;
  inout [15:0] mcbx_dram_dq;
  inout mcbx_dram_dqs;
  inout mcbx_dram_dqs_n;
  inout mcbx_dram_udqs;
  inout mcbx_dram_udqs_n;
  output mcbx_dram_udm;
  output mcbx_dram_ldm;
  output mcbx_dram_odt;
  output mcbx_dram_ddr3_rst;
  inout rzq;
  inout zio;
  input ui_clk;
  output uo_done_cal;
  input s0_axi_aclk;
  input s0_axi_aresetn;
  input [1:0] s0_axi_awid;
  input [31:0] s0_axi_awaddr;
  input [7:0] s0_axi_awlen;
  input [2:0] s0_axi_awsize;
  input [1:0] s0_axi_awburst;
  input [0:0] s0_axi_awlock;
  input [3:0] s0_axi_awcache;
  input [2:0] s0_axi_awprot;
  input [3:0] s0_axi_awqos;
  input s0_axi_awvalid;
  output s0_axi_awready;
  input [127:0] s0_axi_wdata;
  input [15:0] s0_axi_wstrb;
  input s0_axi_wlast;
  input s0_axi_wvalid;
  output s0_axi_wready;
  output [1:0] s0_axi_bid;
  output [1:0] s0_axi_bresp;
  output s0_axi_bvalid;
  input s0_axi_bready;
  input [1:0] s0_axi_arid;
  input [31:0] s0_axi_araddr;
  input [7:0] s0_axi_arlen;
  input [2:0] s0_axi_arsize;
  input [1:0] s0_axi_arburst;
  input [0:0] s0_axi_arlock;
  input [3:0] s0_axi_arcache;
  input [2:0] s0_axi_arprot;
  input [3:0] s0_axi_arqos;
  input s0_axi_arvalid;
  output s0_axi_arready;
  output [1:0] s0_axi_rid;
  output [127:0] s0_axi_rdata;
  output [1:0] s0_axi_rresp;
  output s0_axi_rlast;
  output s0_axi_rvalid;
  input s0_axi_rready;
  input s1_axi_aclk;
  input s1_axi_aresetn;
  input [3:0] s1_axi_awid;
  input [31:0] s1_axi_awaddr;
  input [7:0] s1_axi_awlen;
  input [2:0] s1_axi_awsize;
  input [1:0] s1_axi_awburst;
  input [0:0] s1_axi_awlock;
  input [3:0] s1_axi_awcache;
  input [2:0] s1_axi_awprot;
  input [3:0] s1_axi_awqos;
  input s1_axi_awvalid;
  output s1_axi_awready;
  input [31:0] s1_axi_wdata;
  input [3:0] s1_axi_wstrb;
  input s1_axi_wlast;
  input s1_axi_wvalid;
  output s1_axi_wready;
  output [3:0] s1_axi_bid;
  output [1:0] s1_axi_bresp;
  output s1_axi_bvalid;
  input s1_axi_bready;
  input [3:0] s1_axi_arid;
  input [31:0] s1_axi_araddr;
  input [7:0] s1_axi_arlen;
  input [2:0] s1_axi_arsize;
  input [1:0] s1_axi_arburst;
  input [0:0] s1_axi_arlock;
  input [3:0] s1_axi_arcache;
  input [2:0] s1_axi_arprot;
  input [3:0] s1_axi_arqos;
  input s1_axi_arvalid;
  output s1_axi_arready;
  output [3:0] s1_axi_rid;
  output [31:0] s1_axi_rdata;
  output [1:0] s1_axi_rresp;
  output s1_axi_rlast;
  output s1_axi_rvalid;
  input s1_axi_rready;
  input s2_axi_aclk;
  input s2_axi_aresetn;
  input [3:0] s2_axi_awid;
  input [31:0] s2_axi_awaddr;
  input [7:0] s2_axi_awlen;
  input [2:0] s2_axi_awsize;
  input [1:0] s2_axi_awburst;
  input [0:0] s2_axi_awlock;
  input [3:0] s2_axi_awcache;
  input [2:0] s2_axi_awprot;
  input [3:0] s2_axi_awqos;
  input s2_axi_awvalid;
  output s2_axi_awready;
  input [31:0] s2_axi_wdata;
  input [3:0] s2_axi_wstrb;
  input s2_axi_wlast;
  input s2_axi_wvalid;
  output s2_axi_wready;
  output [3:0] s2_axi_bid;
  output [1:0] s2_axi_bresp;
  output s2_axi_bvalid;
  input s2_axi_bready;
  input [3:0] s2_axi_arid;
  input [31:0] s2_axi_araddr;
  input [7:0] s2_axi_arlen;
  input [2:0] s2_axi_arsize;
  input [1:0] s2_axi_arburst;
  input [0:0] s2_axi_arlock;
  input [3:0] s2_axi_arcache;
  input [2:0] s2_axi_arprot;
  input [3:0] s2_axi_arqos;
  input s2_axi_arvalid;
  output s2_axi_arready;
  output [3:0] s2_axi_rid;
  output [31:0] s2_axi_rdata;
  output [1:0] s2_axi_rresp;
  output s2_axi_rlast;
  output s2_axi_rvalid;
  input s2_axi_rready;
  input s3_axi_aclk;
  input s3_axi_aresetn;
  input [3:0] s3_axi_awid;
  input [31:0] s3_axi_awaddr;
  input [7:0] s3_axi_awlen;
  input [2:0] s3_axi_awsize;
  input [1:0] s3_axi_awburst;
  input [0:0] s3_axi_awlock;
  input [3:0] s3_axi_awcache;
  input [2:0] s3_axi_awprot;
  input [3:0] s3_axi_awqos;
  input s3_axi_awvalid;
  output s3_axi_awready;
  input [31:0] s3_axi_wdata;
  input [3:0] s3_axi_wstrb;
  input s3_axi_wlast;
  input s3_axi_wvalid;
  output s3_axi_wready;
  output [3:0] s3_axi_bid;
  output [1:0] s3_axi_bresp;
  output s3_axi_bvalid;
  input s3_axi_bready;
  input [3:0] s3_axi_arid;
  input [31:0] s3_axi_araddr;
  input [7:0] s3_axi_arlen;
  input [2:0] s3_axi_arsize;
  input [1:0] s3_axi_arburst;
  input [0:0] s3_axi_arlock;
  input [3:0] s3_axi_arcache;
  input [2:0] s3_axi_arprot;
  input [3:0] s3_axi_arqos;
  input s3_axi_arvalid;
  output s3_axi_arready;
  output [3:0] s3_axi_rid;
  output [31:0] s3_axi_rdata;
  output [1:0] s3_axi_rresp;
  output s3_axi_rlast;
  output s3_axi_rvalid;
  input s3_axi_rready;
  input s4_axi_aclk;
  input s4_axi_aresetn;
  input [3:0] s4_axi_awid;
  input [31:0] s4_axi_awaddr;
  input [7:0] s4_axi_awlen;
  input [2:0] s4_axi_awsize;
  input [1:0] s4_axi_awburst;
  input [0:0] s4_axi_awlock;
  input [3:0] s4_axi_awcache;
  input [2:0] s4_axi_awprot;
  input [3:0] s4_axi_awqos;
  input s4_axi_awvalid;
  output s4_axi_awready;
  input [31:0] s4_axi_wdata;
  input [3:0] s4_axi_wstrb;
  input s4_axi_wlast;
  input s4_axi_wvalid;
  output s4_axi_wready;
  output [3:0] s4_axi_bid;
  output [1:0] s4_axi_bresp;
  output s4_axi_bvalid;
  input s4_axi_bready;
  input [3:0] s4_axi_arid;
  input [31:0] s4_axi_araddr;
  input [7:0] s4_axi_arlen;
  input [2:0] s4_axi_arsize;
  input [1:0] s4_axi_arburst;
  input [0:0] s4_axi_arlock;
  input [3:0] s4_axi_arcache;
  input [2:0] s4_axi_arprot;
  input [3:0] s4_axi_arqos;
  input s4_axi_arvalid;
  output s4_axi_arready;
  output [3:0] s4_axi_rid;
  output [31:0] s4_axi_rdata;
  output [1:0] s4_axi_rresp;
  output s4_axi_rlast;
  output s4_axi_rvalid;
  input s4_axi_rready;
  input s5_axi_aclk;
  input s5_axi_aresetn;
  input [3:0] s5_axi_awid;
  input [31:0] s5_axi_awaddr;
  input [7:0] s5_axi_awlen;
  input [2:0] s5_axi_awsize;
  input [1:0] s5_axi_awburst;
  input [0:0] s5_axi_awlock;
  input [3:0] s5_axi_awcache;
  input [2:0] s5_axi_awprot;
  input [3:0] s5_axi_awqos;
  input s5_axi_awvalid;
  output s5_axi_awready;
  input [31:0] s5_axi_wdata;
  input [3:0] s5_axi_wstrb;
  input s5_axi_wlast;
  input s5_axi_wvalid;
  output s5_axi_wready;
  output [3:0] s5_axi_bid;
  output [1:0] s5_axi_bresp;
  output s5_axi_bvalid;
  input s5_axi_bready;
  input [3:0] s5_axi_arid;
  input [31:0] s5_axi_araddr;
  input [7:0] s5_axi_arlen;
  input [2:0] s5_axi_arsize;
  input [1:0] s5_axi_arburst;
  input [0:0] s5_axi_arlock;
  input [3:0] s5_axi_arcache;
  input [2:0] s5_axi_arprot;
  input [3:0] s5_axi_arqos;
  input s5_axi_arvalid;
  output s5_axi_arready;
  output [3:0] s5_axi_rid;
  output [31:0] s5_axi_rdata;
  output [1:0] s5_axi_rresp;
  output s5_axi_rlast;
  output s5_axi_rvalid;
  input s5_axi_rready;

  axi_s6_ddrx
    #(
      .C_S0_AXI_BASEADDR ( 32'ha4000000 ),
      .C_S0_AXI_HIGHADDR ( 32'ha7ffffff ),
      .C_S1_AXI_BASEADDR ( 32'hFFFFFFFF ),
      .C_S1_AXI_HIGHADDR ( 32'h00000000 ),
      .C_S2_AXI_BASEADDR ( 32'hFFFFFFFF ),
      .C_S2_AXI_HIGHADDR ( 32'h00000000 ),
      .C_S3_AXI_BASEADDR ( 32'hFFFFFFFF ),
      .C_S3_AXI_HIGHADDR ( 32'h00000000 ),
      .C_S4_AXI_BASEADDR ( 32'hFFFFFFFF ),
      .C_S4_AXI_HIGHADDR ( 32'h00000000 ),
      .C_S5_AXI_BASEADDR ( 32'hFFFFFFFF ),
      .C_S5_AXI_HIGHADDR ( 32'h00000000 ),
      .C_MEM_TYPE ( "MDDR" ),
      .C_NUM_DQ_PINS ( 16 ),
      .C_MEM_ADDR_WIDTH ( 13 ),
      .C_MEM_BANKADDR_WIDTH ( 2 ),
      .C_MEM_NUM_COL_BITS ( 10 ),
      .C_MEM_TRAS ( 40000 ),
      .C_MEM_TRCD ( 15000 ),
      .C_MEM_TREFI ( 7800000 ),
      .C_MEM_TRFC ( 110000 ),
      .C_MEM_TRP ( 15000 ),
      .C_MEM_TWR ( 15000 ),
      .C_MEM_TRTP ( 7500 ),
      .C_MEM_TWTR ( 2 ),
      .C_PORT_CONFIG ( "B128" ),
      .C_SKIP_IN_TERM_CAL ( 1 ),
      .C_MEMCLK_PERIOD ( 5000 ),
      .C_MEM_ADDR_ORDER ( "ROW_BANK_COLUMN" ),
      .C_MEM_TZQINIT_MAXCNT ( 512 ),
      .C_MEM_CAS_LATENCY ( 3 ),
      .C_SIMULATION ( "FALSE" ),
      .C_MEM_DDR1_2_ODS ( "FULL" ),
      .C_MEM_DDR2_RTT ( "150OHMS" ),
      .C_MEM_DDR2_DIFF_DQS_EN ( "YES" ),
      .C_MEM_DDR2_3_PA_SR ( "FULL" ),
      .C_MEM_DDR2_3_HIGH_TEMP_SR ( "NORMAL" ),
      .C_MEM_DDR3_CAS_WR_LATENCY ( 5 ),
      .C_MEM_DDR3_CAS_LATENCY ( 6 ),
      .C_MEM_DDR3_ODS ( "DIV6" ),
      .C_MEM_DDR3_RTT ( "DIV4" ),
      .C_MEM_DDR3_AUTO_SR ( "ENABLED" ),
      .C_MEM_MOBILE_PA_SR ( "FULL" ),
      .C_MEM_MDDR_ODS ( "FULL" ),
      .C_ARB_ALGORITHM ( 0 ),
      .C_ARB_NUM_TIME_SLOTS ( 12 ),
      .C_ARB_TIME_SLOT_0 ( 18'b000000000001010011 ),
      .C_ARB_TIME_SLOT_1 ( 18'b000000001010011000 ),
      .C_ARB_TIME_SLOT_2 ( 18'b000000010011000001 ),
      .C_ARB_TIME_SLOT_3 ( 18'b000000011000001010 ),
      .C_ARB_TIME_SLOT_4 ( 18'b000000000001010011 ),
      .C_ARB_TIME_SLOT_5 ( 18'b000000001010011000 ),
      .C_ARB_TIME_SLOT_6 ( 18'b000000010011000001 ),
      .C_ARB_TIME_SLOT_7 ( 18'b000000011000001010 ),
      .C_ARB_TIME_SLOT_8 ( 18'b000000000001010011 ),
      .C_ARB_TIME_SLOT_9 ( 18'b000000001010011000 ),
      .C_ARB_TIME_SLOT_10 ( 18'b000000010011000001 ),
      .C_ARB_TIME_SLOT_11 ( 18'b000000011000001010 ),
      .C_S0_AXI_ENABLE ( 1 ),
      .C_S0_AXI_ID_WIDTH ( 2 ),
      .C_S0_AXI_ADDR_WIDTH ( 32 ),
      .C_S0_AXI_DATA_WIDTH ( 128 ),
      .C_S0_AXI_SUPPORTS_READ ( 1 ),
      .C_S0_AXI_SUPPORTS_WRITE ( 1 ),
      .C_S0_AXI_SUPPORTS_NARROW_BURST ( 1 ),
      .C_S0_AXI_REG_EN0 ( 20'h00000 ),
      .C_S0_AXI_REG_EN1 ( 20'h01000 ),
      .C_S0_AXI_STRICT_COHERENCY ( 0 ),
      .C_S0_AXI_ENABLE_AP ( 0 ),
      .C_S1_AXI_ENABLE ( 0 ),
      .C_S1_AXI_ID_WIDTH ( 4 ),
      .C_S1_AXI_ADDR_WIDTH ( 32 ),
      .C_S1_AXI_DATA_WIDTH ( 32 ),
      .C_S1_AXI_SUPPORTS_READ ( 0 ),
      .C_S1_AXI_SUPPORTS_WRITE ( 0 ),
      .C_S1_AXI_SUPPORTS_NARROW_BURST ( 1 ),
      .C_S1_AXI_REG_EN0 ( 20'h0000F ),
      .C_S1_AXI_REG_EN1 ( 20'h01000 ),
      .C_S1_AXI_STRICT_COHERENCY ( 1 ),
      .C_S1_AXI_ENABLE_AP ( 0 ),
      .C_S2_AXI_ENABLE ( 0 ),
      .C_S2_AXI_ID_WIDTH ( 4 ),
      .C_S2_AXI_ADDR_WIDTH ( 32 ),
      .C_S2_AXI_DATA_WIDTH ( 32 ),
      .C_S2_AXI_SUPPORTS_READ ( 0 ),
      .C_S2_AXI_SUPPORTS_WRITE ( 0 ),
      .C_S2_AXI_SUPPORTS_NARROW_BURST ( 1 ),
      .C_S2_AXI_REG_EN0 ( 20'h0000F ),
      .C_S2_AXI_REG_EN1 ( 20'h01000 ),
      .C_S2_AXI_STRICT_COHERENCY ( 1 ),
      .C_S2_AXI_ENABLE_AP ( 0 ),
      .C_S3_AXI_ENABLE ( 0 ),
      .C_S3_AXI_ID_WIDTH ( 4 ),
      .C_S3_AXI_ADDR_WIDTH ( 32 ),
      .C_S3_AXI_DATA_WIDTH ( 32 ),
      .C_S3_AXI_SUPPORTS_READ ( 0 ),
      .C_S3_AXI_SUPPORTS_WRITE ( 0 ),
      .C_S3_AXI_SUPPORTS_NARROW_BURST ( 1 ),
      .C_S3_AXI_REG_EN0 ( 20'h0000F ),
      .C_S3_AXI_REG_EN1 ( 20'h01000 ),
      .C_S3_AXI_STRICT_COHERENCY ( 1 ),
      .C_S3_AXI_ENABLE_AP ( 0 ),
      .C_S4_AXI_ENABLE ( 0 ),
      .C_S4_AXI_ID_WIDTH ( 4 ),
      .C_S4_AXI_ADDR_WIDTH ( 32 ),
      .C_S4_AXI_DATA_WIDTH ( 32 ),
      .C_S4_AXI_SUPPORTS_READ ( 0 ),
      .C_S4_AXI_SUPPORTS_WRITE ( 0 ),
      .C_S4_AXI_SUPPORTS_NARROW_BURST ( 1 ),
      .C_S4_AXI_REG_EN0 ( 20'h0000F ),
      .C_S4_AXI_REG_EN1 ( 20'h01000 ),
      .C_S4_AXI_STRICT_COHERENCY ( 1 ),
      .C_S4_AXI_ENABLE_AP ( 0 ),
      .C_S5_AXI_ENABLE ( 0 ),
      .C_S5_AXI_ID_WIDTH ( 4 ),
      .C_S5_AXI_ADDR_WIDTH ( 32 ),
      .C_S5_AXI_DATA_WIDTH ( 32 ),
      .C_S5_AXI_SUPPORTS_READ ( 0 ),
      .C_S5_AXI_SUPPORTS_WRITE ( 0 ),
      .C_S5_AXI_SUPPORTS_NARROW_BURST ( 1 ),
      .C_S5_AXI_REG_EN0 ( 20'h0000F ),
      .C_S5_AXI_REG_EN1 ( 20'h01000 ),
      .C_S5_AXI_STRICT_COHERENCY ( 1 ),
      .C_S5_AXI_ENABLE_AP ( 0 ),
      .C_MCB_USE_EXTERNAL_BUFPLL ( 0 ),
      .C_SYS_RST_PRESENT ( 1 )
    )
    MCB3_LPDDR (
      .sysclk_2x ( sysclk_2x ),
      .sysclk_2x_180 ( sysclk_2x_180 ),
      .pll_ce_0 ( pll_ce_0 ),
      .pll_ce_90 ( pll_ce_90 ),
      .pll_lock ( pll_lock ),
      .pll_lock_bufpll_o ( pll_lock_bufpll_o ),
      .sysclk_2x_bufpll_o ( sysclk_2x_bufpll_o ),
      .sysclk_2x_180_bufpll_o ( sysclk_2x_180_bufpll_o ),
      .pll_ce_0_bufpll_o ( pll_ce_0_bufpll_o ),
      .pll_ce_90_bufpll_o ( pll_ce_90_bufpll_o ),
      .sys_rst ( sys_rst ),
      .mcbx_dram_addr ( mcbx_dram_addr ),
      .mcbx_dram_ba ( mcbx_dram_ba ),
      .mcbx_dram_ras_n ( mcbx_dram_ras_n ),
      .mcbx_dram_cas_n ( mcbx_dram_cas_n ),
      .mcbx_dram_we_n ( mcbx_dram_we_n ),
      .mcbx_dram_cke ( mcbx_dram_cke ),
      .mcbx_dram_clk ( mcbx_dram_clk ),
      .mcbx_dram_clk_n ( mcbx_dram_clk_n ),
      .mcbx_dram_dq ( mcbx_dram_dq ),
      .mcbx_dram_dqs ( mcbx_dram_dqs ),
      .mcbx_dram_dqs_n ( mcbx_dram_dqs_n ),
      .mcbx_dram_udqs ( mcbx_dram_udqs ),
      .mcbx_dram_udqs_n ( mcbx_dram_udqs_n ),
      .mcbx_dram_udm ( mcbx_dram_udm ),
      .mcbx_dram_ldm ( mcbx_dram_ldm ),
      .mcbx_dram_odt ( mcbx_dram_odt ),
      .mcbx_dram_ddr3_rst ( mcbx_dram_ddr3_rst ),
      .rzq ( rzq ),
      .zio ( zio ),
      .ui_clk ( ui_clk ),
      .uo_done_cal ( uo_done_cal ),
      .s0_axi_aclk ( s0_axi_aclk ),
      .s0_axi_aresetn ( s0_axi_aresetn ),
      .s0_axi_awid ( s0_axi_awid ),
      .s0_axi_awaddr ( s0_axi_awaddr ),
      .s0_axi_awlen ( s0_axi_awlen ),
      .s0_axi_awsize ( s0_axi_awsize ),
      .s0_axi_awburst ( s0_axi_awburst ),
      .s0_axi_awlock ( s0_axi_awlock ),
      .s0_axi_awcache ( s0_axi_awcache ),
      .s0_axi_awprot ( s0_axi_awprot ),
      .s0_axi_awqos ( s0_axi_awqos ),
      .s0_axi_awvalid ( s0_axi_awvalid ),
      .s0_axi_awready ( s0_axi_awready ),
      .s0_axi_wdata ( s0_axi_wdata ),
      .s0_axi_wstrb ( s0_axi_wstrb ),
      .s0_axi_wlast ( s0_axi_wlast ),
      .s0_axi_wvalid ( s0_axi_wvalid ),
      .s0_axi_wready ( s0_axi_wready ),
      .s0_axi_bid ( s0_axi_bid ),
      .s0_axi_bresp ( s0_axi_bresp ),
      .s0_axi_bvalid ( s0_axi_bvalid ),
      .s0_axi_bready ( s0_axi_bready ),
      .s0_axi_arid ( s0_axi_arid ),
      .s0_axi_araddr ( s0_axi_araddr ),
      .s0_axi_arlen ( s0_axi_arlen ),
      .s0_axi_arsize ( s0_axi_arsize ),
      .s0_axi_arburst ( s0_axi_arburst ),
      .s0_axi_arlock ( s0_axi_arlock ),
      .s0_axi_arcache ( s0_axi_arcache ),
      .s0_axi_arprot ( s0_axi_arprot ),
      .s0_axi_arqos ( s0_axi_arqos ),
      .s0_axi_arvalid ( s0_axi_arvalid ),
      .s0_axi_arready ( s0_axi_arready ),
      .s0_axi_rid ( s0_axi_rid ),
      .s0_axi_rdata ( s0_axi_rdata ),
      .s0_axi_rresp ( s0_axi_rresp ),
      .s0_axi_rlast ( s0_axi_rlast ),
      .s0_axi_rvalid ( s0_axi_rvalid ),
      .s0_axi_rready ( s0_axi_rready ),
      .s1_axi_aclk ( s1_axi_aclk ),
      .s1_axi_aresetn ( s1_axi_aresetn ),
      .s1_axi_awid ( s1_axi_awid ),
      .s1_axi_awaddr ( s1_axi_awaddr ),
      .s1_axi_awlen ( s1_axi_awlen ),
      .s1_axi_awsize ( s1_axi_awsize ),
      .s1_axi_awburst ( s1_axi_awburst ),
      .s1_axi_awlock ( s1_axi_awlock ),
      .s1_axi_awcache ( s1_axi_awcache ),
      .s1_axi_awprot ( s1_axi_awprot ),
      .s1_axi_awqos ( s1_axi_awqos ),
      .s1_axi_awvalid ( s1_axi_awvalid ),
      .s1_axi_awready ( s1_axi_awready ),
      .s1_axi_wdata ( s1_axi_wdata ),
      .s1_axi_wstrb ( s1_axi_wstrb ),
      .s1_axi_wlast ( s1_axi_wlast ),
      .s1_axi_wvalid ( s1_axi_wvalid ),
      .s1_axi_wready ( s1_axi_wready ),
      .s1_axi_bid ( s1_axi_bid ),
      .s1_axi_bresp ( s1_axi_bresp ),
      .s1_axi_bvalid ( s1_axi_bvalid ),
      .s1_axi_bready ( s1_axi_bready ),
      .s1_axi_arid ( s1_axi_arid ),
      .s1_axi_araddr ( s1_axi_araddr ),
      .s1_axi_arlen ( s1_axi_arlen ),
      .s1_axi_arsize ( s1_axi_arsize ),
      .s1_axi_arburst ( s1_axi_arburst ),
      .s1_axi_arlock ( s1_axi_arlock ),
      .s1_axi_arcache ( s1_axi_arcache ),
      .s1_axi_arprot ( s1_axi_arprot ),
      .s1_axi_arqos ( s1_axi_arqos ),
      .s1_axi_arvalid ( s1_axi_arvalid ),
      .s1_axi_arready ( s1_axi_arready ),
      .s1_axi_rid ( s1_axi_rid ),
      .s1_axi_rdata ( s1_axi_rdata ),
      .s1_axi_rresp ( s1_axi_rresp ),
      .s1_axi_rlast ( s1_axi_rlast ),
      .s1_axi_rvalid ( s1_axi_rvalid ),
      .s1_axi_rready ( s1_axi_rready ),
      .s2_axi_aclk ( s2_axi_aclk ),
      .s2_axi_aresetn ( s2_axi_aresetn ),
      .s2_axi_awid ( s2_axi_awid ),
      .s2_axi_awaddr ( s2_axi_awaddr ),
      .s2_axi_awlen ( s2_axi_awlen ),
      .s2_axi_awsize ( s2_axi_awsize ),
      .s2_axi_awburst ( s2_axi_awburst ),
      .s2_axi_awlock ( s2_axi_awlock ),
      .s2_axi_awcache ( s2_axi_awcache ),
      .s2_axi_awprot ( s2_axi_awprot ),
      .s2_axi_awqos ( s2_axi_awqos ),
      .s2_axi_awvalid ( s2_axi_awvalid ),
      .s2_axi_awready ( s2_axi_awready ),
      .s2_axi_wdata ( s2_axi_wdata ),
      .s2_axi_wstrb ( s2_axi_wstrb ),
      .s2_axi_wlast ( s2_axi_wlast ),
      .s2_axi_wvalid ( s2_axi_wvalid ),
      .s2_axi_wready ( s2_axi_wready ),
      .s2_axi_bid ( s2_axi_bid ),
      .s2_axi_bresp ( s2_axi_bresp ),
      .s2_axi_bvalid ( s2_axi_bvalid ),
      .s2_axi_bready ( s2_axi_bready ),
      .s2_axi_arid ( s2_axi_arid ),
      .s2_axi_araddr ( s2_axi_araddr ),
      .s2_axi_arlen ( s2_axi_arlen ),
      .s2_axi_arsize ( s2_axi_arsize ),
      .s2_axi_arburst ( s2_axi_arburst ),
      .s2_axi_arlock ( s2_axi_arlock ),
      .s2_axi_arcache ( s2_axi_arcache ),
      .s2_axi_arprot ( s2_axi_arprot ),
      .s2_axi_arqos ( s2_axi_arqos ),
      .s2_axi_arvalid ( s2_axi_arvalid ),
      .s2_axi_arready ( s2_axi_arready ),
      .s2_axi_rid ( s2_axi_rid ),
      .s2_axi_rdata ( s2_axi_rdata ),
      .s2_axi_rresp ( s2_axi_rresp ),
      .s2_axi_rlast ( s2_axi_rlast ),
      .s2_axi_rvalid ( s2_axi_rvalid ),
      .s2_axi_rready ( s2_axi_rready ),
      .s3_axi_aclk ( s3_axi_aclk ),
      .s3_axi_aresetn ( s3_axi_aresetn ),
      .s3_axi_awid ( s3_axi_awid ),
      .s3_axi_awaddr ( s3_axi_awaddr ),
      .s3_axi_awlen ( s3_axi_awlen ),
      .s3_axi_awsize ( s3_axi_awsize ),
      .s3_axi_awburst ( s3_axi_awburst ),
      .s3_axi_awlock ( s3_axi_awlock ),
      .s3_axi_awcache ( s3_axi_awcache ),
      .s3_axi_awprot ( s3_axi_awprot ),
      .s3_axi_awqos ( s3_axi_awqos ),
      .s3_axi_awvalid ( s3_axi_awvalid ),
      .s3_axi_awready ( s3_axi_awready ),
      .s3_axi_wdata ( s3_axi_wdata ),
      .s3_axi_wstrb ( s3_axi_wstrb ),
      .s3_axi_wlast ( s3_axi_wlast ),
      .s3_axi_wvalid ( s3_axi_wvalid ),
      .s3_axi_wready ( s3_axi_wready ),
      .s3_axi_bid ( s3_axi_bid ),
      .s3_axi_bresp ( s3_axi_bresp ),
      .s3_axi_bvalid ( s3_axi_bvalid ),
      .s3_axi_bready ( s3_axi_bready ),
      .s3_axi_arid ( s3_axi_arid ),
      .s3_axi_araddr ( s3_axi_araddr ),
      .s3_axi_arlen ( s3_axi_arlen ),
      .s3_axi_arsize ( s3_axi_arsize ),
      .s3_axi_arburst ( s3_axi_arburst ),
      .s3_axi_arlock ( s3_axi_arlock ),
      .s3_axi_arcache ( s3_axi_arcache ),
      .s3_axi_arprot ( s3_axi_arprot ),
      .s3_axi_arqos ( s3_axi_arqos ),
      .s3_axi_arvalid ( s3_axi_arvalid ),
      .s3_axi_arready ( s3_axi_arready ),
      .s3_axi_rid ( s3_axi_rid ),
      .s3_axi_rdata ( s3_axi_rdata ),
      .s3_axi_rresp ( s3_axi_rresp ),
      .s3_axi_rlast ( s3_axi_rlast ),
      .s3_axi_rvalid ( s3_axi_rvalid ),
      .s3_axi_rready ( s3_axi_rready ),
      .s4_axi_aclk ( s4_axi_aclk ),
      .s4_axi_aresetn ( s4_axi_aresetn ),
      .s4_axi_awid ( s4_axi_awid ),
      .s4_axi_awaddr ( s4_axi_awaddr ),
      .s4_axi_awlen ( s4_axi_awlen ),
      .s4_axi_awsize ( s4_axi_awsize ),
      .s4_axi_awburst ( s4_axi_awburst ),
      .s4_axi_awlock ( s4_axi_awlock ),
      .s4_axi_awcache ( s4_axi_awcache ),
      .s4_axi_awprot ( s4_axi_awprot ),
      .s4_axi_awqos ( s4_axi_awqos ),
      .s4_axi_awvalid ( s4_axi_awvalid ),
      .s4_axi_awready ( s4_axi_awready ),
      .s4_axi_wdata ( s4_axi_wdata ),
      .s4_axi_wstrb ( s4_axi_wstrb ),
      .s4_axi_wlast ( s4_axi_wlast ),
      .s4_axi_wvalid ( s4_axi_wvalid ),
      .s4_axi_wready ( s4_axi_wready ),
      .s4_axi_bid ( s4_axi_bid ),
      .s4_axi_bresp ( s4_axi_bresp ),
      .s4_axi_bvalid ( s4_axi_bvalid ),
      .s4_axi_bready ( s4_axi_bready ),
      .s4_axi_arid ( s4_axi_arid ),
      .s4_axi_araddr ( s4_axi_araddr ),
      .s4_axi_arlen ( s4_axi_arlen ),
      .s4_axi_arsize ( s4_axi_arsize ),
      .s4_axi_arburst ( s4_axi_arburst ),
      .s4_axi_arlock ( s4_axi_arlock ),
      .s4_axi_arcache ( s4_axi_arcache ),
      .s4_axi_arprot ( s4_axi_arprot ),
      .s4_axi_arqos ( s4_axi_arqos ),
      .s4_axi_arvalid ( s4_axi_arvalid ),
      .s4_axi_arready ( s4_axi_arready ),
      .s4_axi_rid ( s4_axi_rid ),
      .s4_axi_rdata ( s4_axi_rdata ),
      .s4_axi_rresp ( s4_axi_rresp ),
      .s4_axi_rlast ( s4_axi_rlast ),
      .s4_axi_rvalid ( s4_axi_rvalid ),
      .s4_axi_rready ( s4_axi_rready ),
      .s5_axi_aclk ( s5_axi_aclk ),
      .s5_axi_aresetn ( s5_axi_aresetn ),
      .s5_axi_awid ( s5_axi_awid ),
      .s5_axi_awaddr ( s5_axi_awaddr ),
      .s5_axi_awlen ( s5_axi_awlen ),
      .s5_axi_awsize ( s5_axi_awsize ),
      .s5_axi_awburst ( s5_axi_awburst ),
      .s5_axi_awlock ( s5_axi_awlock ),
      .s5_axi_awcache ( s5_axi_awcache ),
      .s5_axi_awprot ( s5_axi_awprot ),
      .s5_axi_awqos ( s5_axi_awqos ),
      .s5_axi_awvalid ( s5_axi_awvalid ),
      .s5_axi_awready ( s5_axi_awready ),
      .s5_axi_wdata ( s5_axi_wdata ),
      .s5_axi_wstrb ( s5_axi_wstrb ),
      .s5_axi_wlast ( s5_axi_wlast ),
      .s5_axi_wvalid ( s5_axi_wvalid ),
      .s5_axi_wready ( s5_axi_wready ),
      .s5_axi_bid ( s5_axi_bid ),
      .s5_axi_bresp ( s5_axi_bresp ),
      .s5_axi_bvalid ( s5_axi_bvalid ),
      .s5_axi_bready ( s5_axi_bready ),
      .s5_axi_arid ( s5_axi_arid ),
      .s5_axi_araddr ( s5_axi_araddr ),
      .s5_axi_arlen ( s5_axi_arlen ),
      .s5_axi_arsize ( s5_axi_arsize ),
      .s5_axi_arburst ( s5_axi_arburst ),
      .s5_axi_arlock ( s5_axi_arlock ),
      .s5_axi_arcache ( s5_axi_arcache ),
      .s5_axi_arprot ( s5_axi_arprot ),
      .s5_axi_arqos ( s5_axi_arqos ),
      .s5_axi_arvalid ( s5_axi_arvalid ),
      .s5_axi_arready ( s5_axi_arready ),
      .s5_axi_rid ( s5_axi_rid ),
      .s5_axi_rdata ( s5_axi_rdata ),
      .s5_axi_rresp ( s5_axi_rresp ),
      .s5_axi_rlast ( s5_axi_rlast ),
      .s5_axi_rvalid ( s5_axi_rvalid ),
      .s5_axi_rready ( s5_axi_rready )
    );

endmodule

