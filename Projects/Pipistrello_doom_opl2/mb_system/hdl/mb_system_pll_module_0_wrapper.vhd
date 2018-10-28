-------------------------------------------------------------------------------
-- mb_system_pll_module_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library pll_module_v2_00_a;
use pll_module_v2_00_a.all;

entity mb_system_pll_module_0_wrapper is
  port (
    CLKFBDCM : out std_logic;
    CLKFBOUT : out std_logic;
    CLKOUT0 : out std_logic;
    CLKOUT1 : out std_logic;
    CLKOUT2 : out std_logic;
    CLKOUT3 : out std_logic;
    CLKOUT4 : out std_logic;
    CLKOUT5 : out std_logic;
    CLKOUTDCM0 : out std_logic;
    CLKOUTDCM1 : out std_logic;
    CLKOUTDCM2 : out std_logic;
    CLKOUTDCM3 : out std_logic;
    CLKOUTDCM4 : out std_logic;
    CLKOUTDCM5 : out std_logic;
    LOCKED : out std_logic;
    CLKFBIN : in std_logic;
    CLKIN1 : in std_logic;
    RST : in std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of mb_system_pll_module_0_wrapper : entity is "pll_module_v2_00_a";

end mb_system_pll_module_0_wrapper;

architecture STRUCTURE of mb_system_pll_module_0_wrapper is

  component pll_module is
    generic (
      C_BANDWIDTH : STRING;
      C_CLKFBOUT_MULT : INTEGER;
      C_CLKFBOUT_PHASE : REAL;
      C_CLKIN1_PERIOD : REAL;
      C_CLKOUT0_DIVIDE : INTEGER;
      C_CLKOUT0_DUTY_CYCLE : REAL;
      C_CLKOUT0_PHASE : REAL;
      C_CLKOUT1_DIVIDE : INTEGER;
      C_CLKOUT1_DUTY_CYCLE : REAL;
      C_CLKOUT1_PHASE : REAL;
      C_CLKOUT2_DIVIDE : INTEGER;
      C_CLKOUT2_DUTY_CYCLE : REAL;
      C_CLKOUT2_PHASE : REAL;
      C_CLKOUT3_DIVIDE : INTEGER;
      C_CLKOUT3_DUTY_CYCLE : REAL;
      C_CLKOUT3_PHASE : REAL;
      C_CLKOUT4_DIVIDE : INTEGER;
      C_CLKOUT4_DUTY_CYCLE : REAL;
      C_CLKOUT4_PHASE : REAL;
      C_CLKOUT5_DIVIDE : INTEGER;
      C_CLKOUT5_DUTY_CYCLE : REAL;
      C_CLKOUT5_PHASE : REAL;
      C_COMPENSATION : STRING;
      C_DIVCLK_DIVIDE : INTEGER;
      C_REF_JITTER : REAL;
      C_RESET_ON_LOSS_OF_LOCK : BOOLEAN;
      C_RST_DEASSERT_CLK : STRING;
      C_CLKOUT0_DESKEW_ADJUST : STRING;
      C_CLKOUT1_DESKEW_ADJUST : STRING;
      C_CLKOUT2_DESKEW_ADJUST : STRING;
      C_CLKOUT3_DESKEW_ADJUST : STRING;
      C_CLKOUT4_DESKEW_ADJUST : STRING;
      C_CLKOUT5_DESKEW_ADJUST : STRING;
      C_CLKFBOUT_DESKEW_ADJUST : STRING;
      C_CLKIN1_BUF : BOOLEAN;
      C_CLKFBOUT_BUF : BOOLEAN;
      C_CLKOUT0_BUF : BOOLEAN;
      C_CLKOUT1_BUF : BOOLEAN;
      C_CLKOUT2_BUF : BOOLEAN;
      C_CLKOUT3_BUF : BOOLEAN;
      C_CLKOUT4_BUF : BOOLEAN;
      C_CLKOUT5_BUF : BOOLEAN;
      C_EXT_RESET_HIGH : INTEGER;
      C_FAMILY : STRING
    );
    port (
      CLKFBDCM : out std_logic;
      CLKFBOUT : out std_logic;
      CLKOUT0 : out std_logic;
      CLKOUT1 : out std_logic;
      CLKOUT2 : out std_logic;
      CLKOUT3 : out std_logic;
      CLKOUT4 : out std_logic;
      CLKOUT5 : out std_logic;
      CLKOUTDCM0 : out std_logic;
      CLKOUTDCM1 : out std_logic;
      CLKOUTDCM2 : out std_logic;
      CLKOUTDCM3 : out std_logic;
      CLKOUTDCM4 : out std_logic;
      CLKOUTDCM5 : out std_logic;
      LOCKED : out std_logic;
      CLKFBIN : in std_logic;
      CLKIN1 : in std_logic;
      RST : in std_logic
    );
  end component;

begin

  pll_module_0 : pll_module
    generic map (
      C_BANDWIDTH => "OPTIMIZED",
      C_CLKFBOUT_MULT => 10,
      C_CLKFBOUT_PHASE => 0.000000,
      C_CLKIN1_PERIOD => 20.0,
      C_CLKOUT0_DIVIDE => 2,
      C_CLKOUT0_DUTY_CYCLE => 0.500000,
      C_CLKOUT0_PHASE => 0.000000,
      C_CLKOUT1_DIVIDE => 20,
      C_CLKOUT1_DUTY_CYCLE => 0.500000,
      C_CLKOUT1_PHASE => 0.000000,
      C_CLKOUT2_DIVIDE => 10,
      C_CLKOUT2_DUTY_CYCLE => 0.500000,
      C_CLKOUT2_PHASE => 0.000000,
      C_CLKOUT3_DIVIDE => 1,
      C_CLKOUT3_DUTY_CYCLE => 0.500000,
      C_CLKOUT3_PHASE => 0.000000,
      C_CLKOUT4_DIVIDE => 1,
      C_CLKOUT4_DUTY_CYCLE => 0.500000,
      C_CLKOUT4_PHASE => 0.000000,
      C_CLKOUT5_DIVIDE => 1,
      C_CLKOUT5_DUTY_CYCLE => 0.500000,
      C_CLKOUT5_PHASE => 0.000000,
      C_COMPENSATION => "SYSTEM_SYNCHRONOUS",
      C_DIVCLK_DIVIDE => 1,
      C_REF_JITTER => 0.100000,
      C_RESET_ON_LOSS_OF_LOCK => false,
      C_RST_DEASSERT_CLK => "CLKIN1",
      C_CLKOUT0_DESKEW_ADJUST => "NONE",
      C_CLKOUT1_DESKEW_ADJUST => "NONE",
      C_CLKOUT2_DESKEW_ADJUST => "NONE",
      C_CLKOUT3_DESKEW_ADJUST => "NONE",
      C_CLKOUT4_DESKEW_ADJUST => "NONE",
      C_CLKOUT5_DESKEW_ADJUST => "NONE",
      C_CLKFBOUT_DESKEW_ADJUST => "NONE",
      C_CLKIN1_BUF => false,
      C_CLKFBOUT_BUF => false,
      C_CLKOUT0_BUF => false,
      C_CLKOUT1_BUF => true,
      C_CLKOUT2_BUF => true,
      C_CLKOUT3_BUF => false,
      C_CLKOUT4_BUF => false,
      C_CLKOUT5_BUF => false,
      C_EXT_RESET_HIGH => 1,
      C_FAMILY => "spartan6"
    )
    port map (
      CLKFBDCM => CLKFBDCM,
      CLKFBOUT => CLKFBOUT,
      CLKOUT0 => CLKOUT0,
      CLKOUT1 => CLKOUT1,
      CLKOUT2 => CLKOUT2,
      CLKOUT3 => CLKOUT3,
      CLKOUT4 => CLKOUT4,
      CLKOUT5 => CLKOUT5,
      CLKOUTDCM0 => CLKOUTDCM0,
      CLKOUTDCM1 => CLKOUTDCM1,
      CLKOUTDCM2 => CLKOUTDCM2,
      CLKOUTDCM3 => CLKOUTDCM3,
      CLKOUTDCM4 => CLKOUTDCM4,
      CLKOUTDCM5 => CLKOUTDCM5,
      LOCKED => LOCKED,
      CLKFBIN => CLKFBIN,
      CLKIN1 => CLKIN1,
      RST => RST
    );

end architecture STRUCTURE;

