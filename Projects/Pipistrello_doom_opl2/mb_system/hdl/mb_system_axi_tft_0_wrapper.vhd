-------------------------------------------------------------------------------
-- mb_system_axi_tft_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library axi_tft_v1_00_a;
use axi_tft_v1_00_a.all;

entity mb_system_axi_tft_0_wrapper is
  port (
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_AWREADY : out std_logic;
    M_AXI_ACLK : in std_logic;
    M_AXI_ARESETN : in std_logic;
    M_AXI_AWADDR : out std_logic_vector(31 downto 0);
    M_AXI_AWLEN : out std_logic_vector(7 downto 0);
    M_AXI_AWSIZE : out std_logic_vector(2 downto 0);
    M_AXI_AWBURST : out std_logic_vector(1 downto 0);
    M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
    M_AXI_AWPROT : out std_logic_vector(2 downto 0);
    M_AXI_AWVALID : out std_logic;
    M_AXI_AWREADY : in std_logic;
    M_AXI_WDATA : out std_logic_vector(31 downto 0);
    M_AXI_WSTRB : out std_logic_vector(3 downto 0);
    M_AXI_WLAST : out std_logic;
    M_AXI_WVALID : out std_logic;
    M_AXI_WREADY : in std_logic;
    M_AXI_BRESP : in std_logic_vector(1 downto 0);
    M_AXI_BVALID : in std_logic;
    M_AXI_BREADY : out std_logic;
    M_AXI_ARADDR : out std_logic_vector(31 downto 0);
    M_AXI_ARLEN : out std_logic_vector(7 downto 0);
    M_AXI_ARSIZE : out std_logic_vector(2 downto 0);
    M_AXI_ARBURST : out std_logic_vector(1 downto 0);
    M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
    M_AXI_ARPROT : out std_logic_vector(2 downto 0);
    M_AXI_ARVALID : out std_logic;
    M_AXI_ARREADY : in std_logic;
    M_AXI_RDATA : in std_logic_vector(31 downto 0);
    M_AXI_RRESP : in std_logic_vector(1 downto 0);
    M_AXI_RLAST : in std_logic;
    M_AXI_RVALID : in std_logic;
    M_AXI_RREADY : out std_logic;
    SYS_TFT_Clk : in std_logic;
    IP2INTC_Irpt : out std_logic;
    TFT_HSYNC : out std_logic;
    TFT_VSYNC : out std_logic;
    TFT_DE : out std_logic;
    TFT_DPS : out std_logic;
    TFT_VGA_CLK : out std_logic;
    TFT_VGA_R : out std_logic_vector(7 downto 0);
    TFT_VGA_G : out std_logic_vector(7 downto 0);
    TFT_VGA_B : out std_logic_vector(7 downto 0);
    TFT_DVI_CLK_P : out std_logic;
    TFT_DVI_CLK_N : out std_logic;
    TFT_DVI_DATA : out std_logic_vector(11 downto 0);
    TFT_IIC_SCL_I : in std_logic;
    TFT_IIC_SCL_O : out std_logic;
    TFT_IIC_SCL_T : out std_logic;
    TFT_IIC_SDA_I : in std_logic;
    TFT_IIC_SDA_O : out std_logic;
    TFT_IIC_SDA_T : out std_logic
  );
end mb_system_axi_tft_0_wrapper;

architecture STRUCTURE of mb_system_axi_tft_0_wrapper is

  component axi_tft is
    generic (
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_FAMILY : STRING;
      C_INSTANCE : STRING;
      C_TFT_INTERFACE : INTEGER;
      C_I2C_SLAVE_ADDR : std_logic_vector;
      C_DEFAULT_TFT_BASE_ADDR : std_logic_vector;
      C_M_AXI_ADDR_WIDTH : INTEGER;
      C_M_AXI_DATA_WIDTH : INTEGER;
      C_MAX_BURST_LEN : INTEGER;
      C_USE_WSTRB : INTEGER;
      C_DPHASE_TIMEOUT : INTEGER
    );
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_AWREADY : out std_logic;
      M_AXI_ACLK : in std_logic;
      M_AXI_ARESETN : in std_logic;
      M_AXI_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_AWLEN : out std_logic_vector(7 downto 0);
      M_AXI_AWSIZE : out std_logic_vector(2 downto 0);
      M_AXI_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_AWPROT : out std_logic_vector(2 downto 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in std_logic;
      M_AXI_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_WLAST : out std_logic;
      M_AXI_WVALID : out std_logic;
      M_AXI_WREADY : in std_logic;
      M_AXI_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_BVALID : in std_logic;
      M_AXI_BREADY : out std_logic;
      M_AXI_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_ARLEN : out std_logic_vector(7 downto 0);
      M_AXI_ARSIZE : out std_logic_vector(2 downto 0);
      M_AXI_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_ARPROT : out std_logic_vector(2 downto 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in std_logic;
      M_AXI_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_RLAST : in std_logic;
      M_AXI_RVALID : in std_logic;
      M_AXI_RREADY : out std_logic;
      SYS_TFT_Clk : in std_logic;
      IP2INTC_Irpt : out std_logic;
      TFT_HSYNC : out std_logic;
      TFT_VSYNC : out std_logic;
      TFT_DE : out std_logic;
      TFT_DPS : out std_logic;
      TFT_VGA_CLK : out std_logic;
      TFT_VGA_R : out std_logic_vector(7 downto 0);
      TFT_VGA_G : out std_logic_vector(7 downto 0);
      TFT_VGA_B : out std_logic_vector(7 downto 0);
      TFT_DVI_CLK_P : out std_logic;
      TFT_DVI_CLK_N : out std_logic;
      TFT_DVI_DATA : out std_logic_vector(11 downto 0);
      TFT_IIC_SCL_I : in std_logic;
      TFT_IIC_SCL_O : out std_logic;
      TFT_IIC_SCL_T : out std_logic;
      TFT_IIC_SDA_I : in std_logic;
      TFT_IIC_SDA_O : out std_logic;
      TFT_IIC_SDA_T : out std_logic
    );
  end component;

begin

  axi_tft_0 : axi_tft
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_BASEADDR => X"48000000",
      C_HIGHADDR => X"4800ffff",
      C_FAMILY => "spartan6",
      C_INSTANCE => "axi_tft_0",
      C_TFT_INTERFACE => 0,
      C_I2C_SLAVE_ADDR => B"1110110",
      C_DEFAULT_TFT_BASE_ADDR => X"a7e00000",
      C_M_AXI_ADDR_WIDTH => 32,
      C_M_AXI_DATA_WIDTH => 32,
      C_MAX_BURST_LEN => 16,
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8
    )
    port map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      M_AXI_ACLK => M_AXI_ACLK,
      M_AXI_ARESETN => M_AXI_ARESETN,
      M_AXI_AWADDR => M_AXI_AWADDR,
      M_AXI_AWLEN => M_AXI_AWLEN,
      M_AXI_AWSIZE => M_AXI_AWSIZE,
      M_AXI_AWBURST => M_AXI_AWBURST,
      M_AXI_AWCACHE => M_AXI_AWCACHE,
      M_AXI_AWPROT => M_AXI_AWPROT,
      M_AXI_AWVALID => M_AXI_AWVALID,
      M_AXI_AWREADY => M_AXI_AWREADY,
      M_AXI_WDATA => M_AXI_WDATA,
      M_AXI_WSTRB => M_AXI_WSTRB,
      M_AXI_WLAST => M_AXI_WLAST,
      M_AXI_WVALID => M_AXI_WVALID,
      M_AXI_WREADY => M_AXI_WREADY,
      M_AXI_BRESP => M_AXI_BRESP,
      M_AXI_BVALID => M_AXI_BVALID,
      M_AXI_BREADY => M_AXI_BREADY,
      M_AXI_ARADDR => M_AXI_ARADDR,
      M_AXI_ARLEN => M_AXI_ARLEN,
      M_AXI_ARSIZE => M_AXI_ARSIZE,
      M_AXI_ARBURST => M_AXI_ARBURST,
      M_AXI_ARCACHE => M_AXI_ARCACHE,
      M_AXI_ARPROT => M_AXI_ARPROT,
      M_AXI_ARVALID => M_AXI_ARVALID,
      M_AXI_ARREADY => M_AXI_ARREADY,
      M_AXI_RDATA => M_AXI_RDATA,
      M_AXI_RRESP => M_AXI_RRESP,
      M_AXI_RLAST => M_AXI_RLAST,
      M_AXI_RVALID => M_AXI_RVALID,
      M_AXI_RREADY => M_AXI_RREADY,
      SYS_TFT_Clk => SYS_TFT_Clk,
      IP2INTC_Irpt => IP2INTC_Irpt,
      TFT_HSYNC => TFT_HSYNC,
      TFT_VSYNC => TFT_VSYNC,
      TFT_DE => TFT_DE,
      TFT_DPS => TFT_DPS,
      TFT_VGA_CLK => TFT_VGA_CLK,
      TFT_VGA_R => TFT_VGA_R,
      TFT_VGA_G => TFT_VGA_G,
      TFT_VGA_B => TFT_VGA_B,
      TFT_DVI_CLK_P => TFT_DVI_CLK_P,
      TFT_DVI_CLK_N => TFT_DVI_CLK_N,
      TFT_DVI_DATA => TFT_DVI_DATA,
      TFT_IIC_SCL_I => TFT_IIC_SCL_I,
      TFT_IIC_SCL_O => TFT_IIC_SCL_O,
      TFT_IIC_SCL_T => TFT_IIC_SCL_T,
      TFT_IIC_SDA_I => TFT_IIC_SDA_I,
      TFT_IIC_SDA_O => TFT_IIC_SDA_O,
      TFT_IIC_SDA_T => TFT_IIC_SDA_T
    );

end architecture STRUCTURE;

