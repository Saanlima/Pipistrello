//-----------------------------------------------------------------------------
// microblaze_0_bram_block_elaborate.v
//-----------------------------------------------------------------------------

(* keep_hierarchy = "yes" *)
module microblaze_0_bram_block_elaborate
  (
    BRAM_Rst_A,
    BRAM_Clk_A,
    BRAM_EN_A,
    BRAM_WEN_A,
    BRAM_Addr_A,
    BRAM_Din_A,
    BRAM_Dout_A,
    BRAM_Rst_B,
    BRAM_Clk_B,
    BRAM_EN_B,
    BRAM_WEN_B,
    BRAM_Addr_B,
    BRAM_Din_B,
    BRAM_Dout_B
  );
  parameter
    C_MEMSIZE = 'h10000,
    C_PORT_DWIDTH = 32,
    C_PORT_AWIDTH = 32,
    C_NUM_WE = 4,
    C_FAMILY = "spartan6";
  input BRAM_Rst_A;
  input BRAM_Clk_A;
  input BRAM_EN_A;
  input [0:C_NUM_WE-1] BRAM_WEN_A;
  input [0:C_PORT_AWIDTH-1] BRAM_Addr_A;
  output [0:C_PORT_DWIDTH-1] BRAM_Din_A;
  input [0:C_PORT_DWIDTH-1] BRAM_Dout_A;
  input BRAM_Rst_B;
  input BRAM_Clk_B;
  input BRAM_EN_B;
  input [0:C_NUM_WE-1] BRAM_WEN_B;
  input [0:C_PORT_AWIDTH-1] BRAM_Addr_B;
  output [0:C_PORT_DWIDTH-1] BRAM_Din_B;
  input [0:C_PORT_DWIDTH-1] BRAM_Dout_B;

  // Internal signals

  wire net_gnd0;
  wire [3:0] net_gnd4;
  wire [0:30] pgassign1;
  wire [31:0] pgassign2;
  wire [31:0] pgassign3;
  wire [3:0] pgassign4;
  wire [31:0] pgassign5;
  wire [31:0] pgassign6;
  wire [3:0] pgassign7;
  wire [31:0] pgassign8;
  wire [31:0] pgassign9;
  wire [3:0] pgassign10;
  wire [31:0] pgassign11;
  wire [31:0] pgassign12;
  wire [3:0] pgassign13;
  wire [31:0] pgassign14;
  wire [31:0] pgassign15;
  wire [3:0] pgassign16;
  wire [31:0] pgassign17;
  wire [31:0] pgassign18;
  wire [3:0] pgassign19;
  wire [31:0] pgassign20;
  wire [31:0] pgassign21;
  wire [3:0] pgassign22;
  wire [31:0] pgassign23;
  wire [31:0] pgassign24;
  wire [3:0] pgassign25;
  wire [31:0] pgassign26;
  wire [31:0] pgassign27;
  wire [3:0] pgassign28;
  wire [31:0] pgassign29;
  wire [31:0] pgassign30;
  wire [3:0] pgassign31;
  wire [31:0] pgassign32;
  wire [31:0] pgassign33;
  wire [3:0] pgassign34;
  wire [31:0] pgassign35;
  wire [31:0] pgassign36;
  wire [3:0] pgassign37;
  wire [31:0] pgassign38;
  wire [31:0] pgassign39;
  wire [3:0] pgassign40;
  wire [31:0] pgassign41;
  wire [31:0] pgassign42;
  wire [3:0] pgassign43;
  wire [31:0] pgassign44;
  wire [31:0] pgassign45;
  wire [3:0] pgassign46;
  wire [31:0] pgassign47;
  wire [31:0] pgassign48;
  wire [3:0] pgassign49;
  wire [31:0] pgassign50;
  wire [31:0] pgassign51;
  wire [3:0] pgassign52;
  wire [31:0] pgassign53;
  wire [31:0] pgassign54;
  wire [3:0] pgassign55;
  wire [31:0] pgassign56;
  wire [31:0] pgassign57;
  wire [3:0] pgassign58;
  wire [31:0] pgassign59;
  wire [31:0] pgassign60;
  wire [3:0] pgassign61;
  wire [31:0] pgassign62;
  wire [31:0] pgassign63;
  wire [3:0] pgassign64;
  wire [31:0] pgassign65;
  wire [31:0] pgassign66;
  wire [3:0] pgassign67;
  wire [31:0] pgassign68;
  wire [31:0] pgassign69;
  wire [3:0] pgassign70;
  wire [31:0] pgassign71;
  wire [31:0] pgassign72;
  wire [3:0] pgassign73;
  wire [31:0] pgassign74;
  wire [31:0] pgassign75;
  wire [3:0] pgassign76;
  wire [31:0] pgassign77;
  wire [31:0] pgassign78;
  wire [3:0] pgassign79;
  wire [31:0] pgassign80;
  wire [31:0] pgassign81;
  wire [3:0] pgassign82;
  wire [31:0] pgassign83;
  wire [31:0] pgassign84;
  wire [3:0] pgassign85;
  wire [31:0] pgassign86;
  wire [31:0] pgassign87;
  wire [3:0] pgassign88;
  wire [31:0] pgassign89;
  wire [31:0] pgassign90;
  wire [3:0] pgassign91;
  wire [31:0] pgassign92;
  wire [31:0] pgassign93;
  wire [3:0] pgassign94;
  wire [31:0] pgassign95;
  wire [31:0] pgassign96;
  wire [3:0] pgassign97;
  wire [31:0] pgassign98;
  wire [31:0] pgassign99;
  wire [3:0] pgassign100;
  wire [31:0] pgassign101;
  wire [31:0] pgassign102;
  wire [3:0] pgassign103;
  wire [31:0] pgassign104;
  wire [31:0] pgassign105;
  wire [3:0] pgassign106;
  wire [31:0] pgassign107;
  wire [31:0] pgassign108;
  wire [3:0] pgassign109;
  wire [31:0] pgassign110;
  wire [31:0] pgassign111;
  wire [3:0] pgassign112;
  wire [31:0] pgassign113;
  wire [31:0] pgassign114;
  wire [3:0] pgassign115;
  wire [31:0] pgassign116;
  wire [31:0] pgassign117;
  wire [3:0] pgassign118;
  wire [31:0] pgassign119;
  wire [31:0] pgassign120;
  wire [3:0] pgassign121;
  wire [31:0] pgassign122;
  wire [31:0] pgassign123;
  wire [3:0] pgassign124;
  wire [31:0] pgassign125;
  wire [31:0] pgassign126;
  wire [3:0] pgassign127;
  wire [31:0] pgassign128;
  wire [31:0] pgassign129;
  wire [3:0] pgassign130;
  wire [31:0] pgassign131;
  wire [31:0] pgassign132;
  wire [3:0] pgassign133;
  wire [31:0] pgassign134;
  wire [31:0] pgassign135;
  wire [3:0] pgassign136;
  wire [31:0] pgassign137;
  wire [31:0] pgassign138;
  wire [3:0] pgassign139;
  wire [31:0] pgassign140;
  wire [31:0] pgassign141;
  wire [3:0] pgassign142;
  wire [31:0] pgassign143;
  wire [31:0] pgassign144;
  wire [3:0] pgassign145;
  wire [31:0] pgassign146;
  wire [31:0] pgassign147;
  wire [3:0] pgassign148;
  wire [31:0] pgassign149;
  wire [31:0] pgassign150;
  wire [3:0] pgassign151;
  wire [31:0] pgassign152;
  wire [31:0] pgassign153;
  wire [3:0] pgassign154;
  wire [31:0] pgassign155;
  wire [31:0] pgassign156;
  wire [3:0] pgassign157;
  wire [31:0] pgassign158;
  wire [31:0] pgassign159;
  wire [3:0] pgassign160;
  wire [31:0] pgassign161;
  wire [31:0] pgassign162;
  wire [3:0] pgassign163;
  wire [31:0] pgassign164;
  wire [31:0] pgassign165;
  wire [3:0] pgassign166;
  wire [31:0] pgassign167;
  wire [31:0] pgassign168;
  wire [3:0] pgassign169;
  wire [31:0] pgassign170;
  wire [31:0] pgassign171;
  wire [3:0] pgassign172;
  wire [31:0] pgassign173;
  wire [31:0] pgassign174;
  wire [3:0] pgassign175;
  wire [31:0] pgassign176;
  wire [31:0] pgassign177;
  wire [3:0] pgassign178;
  wire [31:0] pgassign179;
  wire [31:0] pgassign180;
  wire [3:0] pgassign181;
  wire [31:0] pgassign182;
  wire [31:0] pgassign183;
  wire [3:0] pgassign184;
  wire [31:0] pgassign185;
  wire [31:0] pgassign186;
  wire [3:0] pgassign187;
  wire [31:0] pgassign188;
  wire [31:0] pgassign189;
  wire [3:0] pgassign190;
  wire [31:0] pgassign191;
  wire [31:0] pgassign192;
  wire [3:0] pgassign193;

  // Internal assignments

  assign pgassign1[0:30] = 31'b0000000000000000000000000000000;
  assign pgassign2[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign2[0:0] = BRAM_Dout_A[0:0];
  assign BRAM_Din_A[0:0] = pgassign3[0:0];
  assign pgassign4[3:3] = BRAM_WEN_A[0:0];
  assign pgassign4[2:2] = BRAM_WEN_A[0:0];
  assign pgassign4[1:1] = BRAM_WEN_A[0:0];
  assign pgassign4[0:0] = BRAM_WEN_A[0:0];
  assign pgassign5[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign5[0:0] = BRAM_Dout_B[0:0];
  assign BRAM_Din_B[0:0] = pgassign6[0:0];
  assign pgassign7[3:3] = BRAM_WEN_B[0:0];
  assign pgassign7[2:2] = BRAM_WEN_B[0:0];
  assign pgassign7[1:1] = BRAM_WEN_B[0:0];
  assign pgassign7[0:0] = BRAM_WEN_B[0:0];
  assign pgassign8[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign8[0:0] = BRAM_Dout_A[1:1];
  assign BRAM_Din_A[1:1] = pgassign9[0:0];
  assign pgassign10[3:3] = BRAM_WEN_A[0:0];
  assign pgassign10[2:2] = BRAM_WEN_A[0:0];
  assign pgassign10[1:1] = BRAM_WEN_A[0:0];
  assign pgassign10[0:0] = BRAM_WEN_A[0:0];
  assign pgassign11[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign11[0:0] = BRAM_Dout_B[1:1];
  assign BRAM_Din_B[1:1] = pgassign12[0:0];
  assign pgassign13[3:3] = BRAM_WEN_B[0:0];
  assign pgassign13[2:2] = BRAM_WEN_B[0:0];
  assign pgassign13[1:1] = BRAM_WEN_B[0:0];
  assign pgassign13[0:0] = BRAM_WEN_B[0:0];
  assign pgassign14[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign14[0:0] = BRAM_Dout_A[2:2];
  assign BRAM_Din_A[2:2] = pgassign15[0:0];
  assign pgassign16[3:3] = BRAM_WEN_A[0:0];
  assign pgassign16[2:2] = BRAM_WEN_A[0:0];
  assign pgassign16[1:1] = BRAM_WEN_A[0:0];
  assign pgassign16[0:0] = BRAM_WEN_A[0:0];
  assign pgassign17[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign17[0:0] = BRAM_Dout_B[2:2];
  assign BRAM_Din_B[2:2] = pgassign18[0:0];
  assign pgassign19[3:3] = BRAM_WEN_B[0:0];
  assign pgassign19[2:2] = BRAM_WEN_B[0:0];
  assign pgassign19[1:1] = BRAM_WEN_B[0:0];
  assign pgassign19[0:0] = BRAM_WEN_B[0:0];
  assign pgassign20[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign20[0:0] = BRAM_Dout_A[3:3];
  assign BRAM_Din_A[3:3] = pgassign21[0:0];
  assign pgassign22[3:3] = BRAM_WEN_A[0:0];
  assign pgassign22[2:2] = BRAM_WEN_A[0:0];
  assign pgassign22[1:1] = BRAM_WEN_A[0:0];
  assign pgassign22[0:0] = BRAM_WEN_A[0:0];
  assign pgassign23[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign23[0:0] = BRAM_Dout_B[3:3];
  assign BRAM_Din_B[3:3] = pgassign24[0:0];
  assign pgassign25[3:3] = BRAM_WEN_B[0:0];
  assign pgassign25[2:2] = BRAM_WEN_B[0:0];
  assign pgassign25[1:1] = BRAM_WEN_B[0:0];
  assign pgassign25[0:0] = BRAM_WEN_B[0:0];
  assign pgassign26[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign26[0:0] = BRAM_Dout_A[4:4];
  assign BRAM_Din_A[4:4] = pgassign27[0:0];
  assign pgassign28[3:3] = BRAM_WEN_A[0:0];
  assign pgassign28[2:2] = BRAM_WEN_A[0:0];
  assign pgassign28[1:1] = BRAM_WEN_A[0:0];
  assign pgassign28[0:0] = BRAM_WEN_A[0:0];
  assign pgassign29[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign29[0:0] = BRAM_Dout_B[4:4];
  assign BRAM_Din_B[4:4] = pgassign30[0:0];
  assign pgassign31[3:3] = BRAM_WEN_B[0:0];
  assign pgassign31[2:2] = BRAM_WEN_B[0:0];
  assign pgassign31[1:1] = BRAM_WEN_B[0:0];
  assign pgassign31[0:0] = BRAM_WEN_B[0:0];
  assign pgassign32[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign32[0:0] = BRAM_Dout_A[5:5];
  assign BRAM_Din_A[5:5] = pgassign33[0:0];
  assign pgassign34[3:3] = BRAM_WEN_A[0:0];
  assign pgassign34[2:2] = BRAM_WEN_A[0:0];
  assign pgassign34[1:1] = BRAM_WEN_A[0:0];
  assign pgassign34[0:0] = BRAM_WEN_A[0:0];
  assign pgassign35[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign35[0:0] = BRAM_Dout_B[5:5];
  assign BRAM_Din_B[5:5] = pgassign36[0:0];
  assign pgassign37[3:3] = BRAM_WEN_B[0:0];
  assign pgassign37[2:2] = BRAM_WEN_B[0:0];
  assign pgassign37[1:1] = BRAM_WEN_B[0:0];
  assign pgassign37[0:0] = BRAM_WEN_B[0:0];
  assign pgassign38[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign38[0:0] = BRAM_Dout_A[6:6];
  assign BRAM_Din_A[6:6] = pgassign39[0:0];
  assign pgassign40[3:3] = BRAM_WEN_A[0:0];
  assign pgassign40[2:2] = BRAM_WEN_A[0:0];
  assign pgassign40[1:1] = BRAM_WEN_A[0:0];
  assign pgassign40[0:0] = BRAM_WEN_A[0:0];
  assign pgassign41[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign41[0:0] = BRAM_Dout_B[6:6];
  assign BRAM_Din_B[6:6] = pgassign42[0:0];
  assign pgassign43[3:3] = BRAM_WEN_B[0:0];
  assign pgassign43[2:2] = BRAM_WEN_B[0:0];
  assign pgassign43[1:1] = BRAM_WEN_B[0:0];
  assign pgassign43[0:0] = BRAM_WEN_B[0:0];
  assign pgassign44[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign44[0:0] = BRAM_Dout_A[7:7];
  assign BRAM_Din_A[7:7] = pgassign45[0:0];
  assign pgassign46[3:3] = BRAM_WEN_A[0:0];
  assign pgassign46[2:2] = BRAM_WEN_A[0:0];
  assign pgassign46[1:1] = BRAM_WEN_A[0:0];
  assign pgassign46[0:0] = BRAM_WEN_A[0:0];
  assign pgassign47[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign47[0:0] = BRAM_Dout_B[7:7];
  assign BRAM_Din_B[7:7] = pgassign48[0:0];
  assign pgassign49[3:3] = BRAM_WEN_B[0:0];
  assign pgassign49[2:2] = BRAM_WEN_B[0:0];
  assign pgassign49[1:1] = BRAM_WEN_B[0:0];
  assign pgassign49[0:0] = BRAM_WEN_B[0:0];
  assign pgassign50[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign50[0:0] = BRAM_Dout_A[8:8];
  assign BRAM_Din_A[8:8] = pgassign51[0:0];
  assign pgassign52[3:3] = BRAM_WEN_A[1:1];
  assign pgassign52[2:2] = BRAM_WEN_A[1:1];
  assign pgassign52[1:1] = BRAM_WEN_A[1:1];
  assign pgassign52[0:0] = BRAM_WEN_A[1:1];
  assign pgassign53[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign53[0:0] = BRAM_Dout_B[8:8];
  assign BRAM_Din_B[8:8] = pgassign54[0:0];
  assign pgassign55[3:3] = BRAM_WEN_B[1:1];
  assign pgassign55[2:2] = BRAM_WEN_B[1:1];
  assign pgassign55[1:1] = BRAM_WEN_B[1:1];
  assign pgassign55[0:0] = BRAM_WEN_B[1:1];
  assign pgassign56[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign56[0:0] = BRAM_Dout_A[9:9];
  assign BRAM_Din_A[9:9] = pgassign57[0:0];
  assign pgassign58[3:3] = BRAM_WEN_A[1:1];
  assign pgassign58[2:2] = BRAM_WEN_A[1:1];
  assign pgassign58[1:1] = BRAM_WEN_A[1:1];
  assign pgassign58[0:0] = BRAM_WEN_A[1:1];
  assign pgassign59[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign59[0:0] = BRAM_Dout_B[9:9];
  assign BRAM_Din_B[9:9] = pgassign60[0:0];
  assign pgassign61[3:3] = BRAM_WEN_B[1:1];
  assign pgassign61[2:2] = BRAM_WEN_B[1:1];
  assign pgassign61[1:1] = BRAM_WEN_B[1:1];
  assign pgassign61[0:0] = BRAM_WEN_B[1:1];
  assign pgassign62[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign62[0:0] = BRAM_Dout_A[10:10];
  assign BRAM_Din_A[10:10] = pgassign63[0:0];
  assign pgassign64[3:3] = BRAM_WEN_A[1:1];
  assign pgassign64[2:2] = BRAM_WEN_A[1:1];
  assign pgassign64[1:1] = BRAM_WEN_A[1:1];
  assign pgassign64[0:0] = BRAM_WEN_A[1:1];
  assign pgassign65[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign65[0:0] = BRAM_Dout_B[10:10];
  assign BRAM_Din_B[10:10] = pgassign66[0:0];
  assign pgassign67[3:3] = BRAM_WEN_B[1:1];
  assign pgassign67[2:2] = BRAM_WEN_B[1:1];
  assign pgassign67[1:1] = BRAM_WEN_B[1:1];
  assign pgassign67[0:0] = BRAM_WEN_B[1:1];
  assign pgassign68[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign68[0:0] = BRAM_Dout_A[11:11];
  assign BRAM_Din_A[11:11] = pgassign69[0:0];
  assign pgassign70[3:3] = BRAM_WEN_A[1:1];
  assign pgassign70[2:2] = BRAM_WEN_A[1:1];
  assign pgassign70[1:1] = BRAM_WEN_A[1:1];
  assign pgassign70[0:0] = BRAM_WEN_A[1:1];
  assign pgassign71[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign71[0:0] = BRAM_Dout_B[11:11];
  assign BRAM_Din_B[11:11] = pgassign72[0:0];
  assign pgassign73[3:3] = BRAM_WEN_B[1:1];
  assign pgassign73[2:2] = BRAM_WEN_B[1:1];
  assign pgassign73[1:1] = BRAM_WEN_B[1:1];
  assign pgassign73[0:0] = BRAM_WEN_B[1:1];
  assign pgassign74[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign74[0:0] = BRAM_Dout_A[12:12];
  assign BRAM_Din_A[12:12] = pgassign75[0:0];
  assign pgassign76[3:3] = BRAM_WEN_A[1:1];
  assign pgassign76[2:2] = BRAM_WEN_A[1:1];
  assign pgassign76[1:1] = BRAM_WEN_A[1:1];
  assign pgassign76[0:0] = BRAM_WEN_A[1:1];
  assign pgassign77[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign77[0:0] = BRAM_Dout_B[12:12];
  assign BRAM_Din_B[12:12] = pgassign78[0:0];
  assign pgassign79[3:3] = BRAM_WEN_B[1:1];
  assign pgassign79[2:2] = BRAM_WEN_B[1:1];
  assign pgassign79[1:1] = BRAM_WEN_B[1:1];
  assign pgassign79[0:0] = BRAM_WEN_B[1:1];
  assign pgassign80[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign80[0:0] = BRAM_Dout_A[13:13];
  assign BRAM_Din_A[13:13] = pgassign81[0:0];
  assign pgassign82[3:3] = BRAM_WEN_A[1:1];
  assign pgassign82[2:2] = BRAM_WEN_A[1:1];
  assign pgassign82[1:1] = BRAM_WEN_A[1:1];
  assign pgassign82[0:0] = BRAM_WEN_A[1:1];
  assign pgassign83[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign83[0:0] = BRAM_Dout_B[13:13];
  assign BRAM_Din_B[13:13] = pgassign84[0:0];
  assign pgassign85[3:3] = BRAM_WEN_B[1:1];
  assign pgassign85[2:2] = BRAM_WEN_B[1:1];
  assign pgassign85[1:1] = BRAM_WEN_B[1:1];
  assign pgassign85[0:0] = BRAM_WEN_B[1:1];
  assign pgassign86[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign86[0:0] = BRAM_Dout_A[14:14];
  assign BRAM_Din_A[14:14] = pgassign87[0:0];
  assign pgassign88[3:3] = BRAM_WEN_A[1:1];
  assign pgassign88[2:2] = BRAM_WEN_A[1:1];
  assign pgassign88[1:1] = BRAM_WEN_A[1:1];
  assign pgassign88[0:0] = BRAM_WEN_A[1:1];
  assign pgassign89[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign89[0:0] = BRAM_Dout_B[14:14];
  assign BRAM_Din_B[14:14] = pgassign90[0:0];
  assign pgassign91[3:3] = BRAM_WEN_B[1:1];
  assign pgassign91[2:2] = BRAM_WEN_B[1:1];
  assign pgassign91[1:1] = BRAM_WEN_B[1:1];
  assign pgassign91[0:0] = BRAM_WEN_B[1:1];
  assign pgassign92[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign92[0:0] = BRAM_Dout_A[15:15];
  assign BRAM_Din_A[15:15] = pgassign93[0:0];
  assign pgassign94[3:3] = BRAM_WEN_A[1:1];
  assign pgassign94[2:2] = BRAM_WEN_A[1:1];
  assign pgassign94[1:1] = BRAM_WEN_A[1:1];
  assign pgassign94[0:0] = BRAM_WEN_A[1:1];
  assign pgassign95[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign95[0:0] = BRAM_Dout_B[15:15];
  assign BRAM_Din_B[15:15] = pgassign96[0:0];
  assign pgassign97[3:3] = BRAM_WEN_B[1:1];
  assign pgassign97[2:2] = BRAM_WEN_B[1:1];
  assign pgassign97[1:1] = BRAM_WEN_B[1:1];
  assign pgassign97[0:0] = BRAM_WEN_B[1:1];
  assign pgassign98[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign98[0:0] = BRAM_Dout_A[16:16];
  assign BRAM_Din_A[16:16] = pgassign99[0:0];
  assign pgassign100[3:3] = BRAM_WEN_A[2:2];
  assign pgassign100[2:2] = BRAM_WEN_A[2:2];
  assign pgassign100[1:1] = BRAM_WEN_A[2:2];
  assign pgassign100[0:0] = BRAM_WEN_A[2:2];
  assign pgassign101[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign101[0:0] = BRAM_Dout_B[16:16];
  assign BRAM_Din_B[16:16] = pgassign102[0:0];
  assign pgassign103[3:3] = BRAM_WEN_B[2:2];
  assign pgassign103[2:2] = BRAM_WEN_B[2:2];
  assign pgassign103[1:1] = BRAM_WEN_B[2:2];
  assign pgassign103[0:0] = BRAM_WEN_B[2:2];
  assign pgassign104[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign104[0:0] = BRAM_Dout_A[17:17];
  assign BRAM_Din_A[17:17] = pgassign105[0:0];
  assign pgassign106[3:3] = BRAM_WEN_A[2:2];
  assign pgassign106[2:2] = BRAM_WEN_A[2:2];
  assign pgassign106[1:1] = BRAM_WEN_A[2:2];
  assign pgassign106[0:0] = BRAM_WEN_A[2:2];
  assign pgassign107[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign107[0:0] = BRAM_Dout_B[17:17];
  assign BRAM_Din_B[17:17] = pgassign108[0:0];
  assign pgassign109[3:3] = BRAM_WEN_B[2:2];
  assign pgassign109[2:2] = BRAM_WEN_B[2:2];
  assign pgassign109[1:1] = BRAM_WEN_B[2:2];
  assign pgassign109[0:0] = BRAM_WEN_B[2:2];
  assign pgassign110[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign110[0:0] = BRAM_Dout_A[18:18];
  assign BRAM_Din_A[18:18] = pgassign111[0:0];
  assign pgassign112[3:3] = BRAM_WEN_A[2:2];
  assign pgassign112[2:2] = BRAM_WEN_A[2:2];
  assign pgassign112[1:1] = BRAM_WEN_A[2:2];
  assign pgassign112[0:0] = BRAM_WEN_A[2:2];
  assign pgassign113[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign113[0:0] = BRAM_Dout_B[18:18];
  assign BRAM_Din_B[18:18] = pgassign114[0:0];
  assign pgassign115[3:3] = BRAM_WEN_B[2:2];
  assign pgassign115[2:2] = BRAM_WEN_B[2:2];
  assign pgassign115[1:1] = BRAM_WEN_B[2:2];
  assign pgassign115[0:0] = BRAM_WEN_B[2:2];
  assign pgassign116[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign116[0:0] = BRAM_Dout_A[19:19];
  assign BRAM_Din_A[19:19] = pgassign117[0:0];
  assign pgassign118[3:3] = BRAM_WEN_A[2:2];
  assign pgassign118[2:2] = BRAM_WEN_A[2:2];
  assign pgassign118[1:1] = BRAM_WEN_A[2:2];
  assign pgassign118[0:0] = BRAM_WEN_A[2:2];
  assign pgassign119[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign119[0:0] = BRAM_Dout_B[19:19];
  assign BRAM_Din_B[19:19] = pgassign120[0:0];
  assign pgassign121[3:3] = BRAM_WEN_B[2:2];
  assign pgassign121[2:2] = BRAM_WEN_B[2:2];
  assign pgassign121[1:1] = BRAM_WEN_B[2:2];
  assign pgassign121[0:0] = BRAM_WEN_B[2:2];
  assign pgassign122[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign122[0:0] = BRAM_Dout_A[20:20];
  assign BRAM_Din_A[20:20] = pgassign123[0:0];
  assign pgassign124[3:3] = BRAM_WEN_A[2:2];
  assign pgassign124[2:2] = BRAM_WEN_A[2:2];
  assign pgassign124[1:1] = BRAM_WEN_A[2:2];
  assign pgassign124[0:0] = BRAM_WEN_A[2:2];
  assign pgassign125[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign125[0:0] = BRAM_Dout_B[20:20];
  assign BRAM_Din_B[20:20] = pgassign126[0:0];
  assign pgassign127[3:3] = BRAM_WEN_B[2:2];
  assign pgassign127[2:2] = BRAM_WEN_B[2:2];
  assign pgassign127[1:1] = BRAM_WEN_B[2:2];
  assign pgassign127[0:0] = BRAM_WEN_B[2:2];
  assign pgassign128[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign128[0:0] = BRAM_Dout_A[21:21];
  assign BRAM_Din_A[21:21] = pgassign129[0:0];
  assign pgassign130[3:3] = BRAM_WEN_A[2:2];
  assign pgassign130[2:2] = BRAM_WEN_A[2:2];
  assign pgassign130[1:1] = BRAM_WEN_A[2:2];
  assign pgassign130[0:0] = BRAM_WEN_A[2:2];
  assign pgassign131[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign131[0:0] = BRAM_Dout_B[21:21];
  assign BRAM_Din_B[21:21] = pgassign132[0:0];
  assign pgassign133[3:3] = BRAM_WEN_B[2:2];
  assign pgassign133[2:2] = BRAM_WEN_B[2:2];
  assign pgassign133[1:1] = BRAM_WEN_B[2:2];
  assign pgassign133[0:0] = BRAM_WEN_B[2:2];
  assign pgassign134[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign134[0:0] = BRAM_Dout_A[22:22];
  assign BRAM_Din_A[22:22] = pgassign135[0:0];
  assign pgassign136[3:3] = BRAM_WEN_A[2:2];
  assign pgassign136[2:2] = BRAM_WEN_A[2:2];
  assign pgassign136[1:1] = BRAM_WEN_A[2:2];
  assign pgassign136[0:0] = BRAM_WEN_A[2:2];
  assign pgassign137[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign137[0:0] = BRAM_Dout_B[22:22];
  assign BRAM_Din_B[22:22] = pgassign138[0:0];
  assign pgassign139[3:3] = BRAM_WEN_B[2:2];
  assign pgassign139[2:2] = BRAM_WEN_B[2:2];
  assign pgassign139[1:1] = BRAM_WEN_B[2:2];
  assign pgassign139[0:0] = BRAM_WEN_B[2:2];
  assign pgassign140[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign140[0:0] = BRAM_Dout_A[23:23];
  assign BRAM_Din_A[23:23] = pgassign141[0:0];
  assign pgassign142[3:3] = BRAM_WEN_A[2:2];
  assign pgassign142[2:2] = BRAM_WEN_A[2:2];
  assign pgassign142[1:1] = BRAM_WEN_A[2:2];
  assign pgassign142[0:0] = BRAM_WEN_A[2:2];
  assign pgassign143[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign143[0:0] = BRAM_Dout_B[23:23];
  assign BRAM_Din_B[23:23] = pgassign144[0:0];
  assign pgassign145[3:3] = BRAM_WEN_B[2:2];
  assign pgassign145[2:2] = BRAM_WEN_B[2:2];
  assign pgassign145[1:1] = BRAM_WEN_B[2:2];
  assign pgassign145[0:0] = BRAM_WEN_B[2:2];
  assign pgassign146[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign146[0:0] = BRAM_Dout_A[24:24];
  assign BRAM_Din_A[24:24] = pgassign147[0:0];
  assign pgassign148[3:3] = BRAM_WEN_A[3:3];
  assign pgassign148[2:2] = BRAM_WEN_A[3:3];
  assign pgassign148[1:1] = BRAM_WEN_A[3:3];
  assign pgassign148[0:0] = BRAM_WEN_A[3:3];
  assign pgassign149[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign149[0:0] = BRAM_Dout_B[24:24];
  assign BRAM_Din_B[24:24] = pgassign150[0:0];
  assign pgassign151[3:3] = BRAM_WEN_B[3:3];
  assign pgassign151[2:2] = BRAM_WEN_B[3:3];
  assign pgassign151[1:1] = BRAM_WEN_B[3:3];
  assign pgassign151[0:0] = BRAM_WEN_B[3:3];
  assign pgassign152[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign152[0:0] = BRAM_Dout_A[25:25];
  assign BRAM_Din_A[25:25] = pgassign153[0:0];
  assign pgassign154[3:3] = BRAM_WEN_A[3:3];
  assign pgassign154[2:2] = BRAM_WEN_A[3:3];
  assign pgassign154[1:1] = BRAM_WEN_A[3:3];
  assign pgassign154[0:0] = BRAM_WEN_A[3:3];
  assign pgassign155[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign155[0:0] = BRAM_Dout_B[25:25];
  assign BRAM_Din_B[25:25] = pgassign156[0:0];
  assign pgassign157[3:3] = BRAM_WEN_B[3:3];
  assign pgassign157[2:2] = BRAM_WEN_B[3:3];
  assign pgassign157[1:1] = BRAM_WEN_B[3:3];
  assign pgassign157[0:0] = BRAM_WEN_B[3:3];
  assign pgassign158[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign158[0:0] = BRAM_Dout_A[26:26];
  assign BRAM_Din_A[26:26] = pgassign159[0:0];
  assign pgassign160[3:3] = BRAM_WEN_A[3:3];
  assign pgassign160[2:2] = BRAM_WEN_A[3:3];
  assign pgassign160[1:1] = BRAM_WEN_A[3:3];
  assign pgassign160[0:0] = BRAM_WEN_A[3:3];
  assign pgassign161[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign161[0:0] = BRAM_Dout_B[26:26];
  assign BRAM_Din_B[26:26] = pgassign162[0:0];
  assign pgassign163[3:3] = BRAM_WEN_B[3:3];
  assign pgassign163[2:2] = BRAM_WEN_B[3:3];
  assign pgassign163[1:1] = BRAM_WEN_B[3:3];
  assign pgassign163[0:0] = BRAM_WEN_B[3:3];
  assign pgassign164[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign164[0:0] = BRAM_Dout_A[27:27];
  assign BRAM_Din_A[27:27] = pgassign165[0:0];
  assign pgassign166[3:3] = BRAM_WEN_A[3:3];
  assign pgassign166[2:2] = BRAM_WEN_A[3:3];
  assign pgassign166[1:1] = BRAM_WEN_A[3:3];
  assign pgassign166[0:0] = BRAM_WEN_A[3:3];
  assign pgassign167[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign167[0:0] = BRAM_Dout_B[27:27];
  assign BRAM_Din_B[27:27] = pgassign168[0:0];
  assign pgassign169[3:3] = BRAM_WEN_B[3:3];
  assign pgassign169[2:2] = BRAM_WEN_B[3:3];
  assign pgassign169[1:1] = BRAM_WEN_B[3:3];
  assign pgassign169[0:0] = BRAM_WEN_B[3:3];
  assign pgassign170[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign170[0:0] = BRAM_Dout_A[28:28];
  assign BRAM_Din_A[28:28] = pgassign171[0:0];
  assign pgassign172[3:3] = BRAM_WEN_A[3:3];
  assign pgassign172[2:2] = BRAM_WEN_A[3:3];
  assign pgassign172[1:1] = BRAM_WEN_A[3:3];
  assign pgassign172[0:0] = BRAM_WEN_A[3:3];
  assign pgassign173[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign173[0:0] = BRAM_Dout_B[28:28];
  assign BRAM_Din_B[28:28] = pgassign174[0:0];
  assign pgassign175[3:3] = BRAM_WEN_B[3:3];
  assign pgassign175[2:2] = BRAM_WEN_B[3:3];
  assign pgassign175[1:1] = BRAM_WEN_B[3:3];
  assign pgassign175[0:0] = BRAM_WEN_B[3:3];
  assign pgassign176[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign176[0:0] = BRAM_Dout_A[29:29];
  assign BRAM_Din_A[29:29] = pgassign177[0:0];
  assign pgassign178[3:3] = BRAM_WEN_A[3:3];
  assign pgassign178[2:2] = BRAM_WEN_A[3:3];
  assign pgassign178[1:1] = BRAM_WEN_A[3:3];
  assign pgassign178[0:0] = BRAM_WEN_A[3:3];
  assign pgassign179[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign179[0:0] = BRAM_Dout_B[29:29];
  assign BRAM_Din_B[29:29] = pgassign180[0:0];
  assign pgassign181[3:3] = BRAM_WEN_B[3:3];
  assign pgassign181[2:2] = BRAM_WEN_B[3:3];
  assign pgassign181[1:1] = BRAM_WEN_B[3:3];
  assign pgassign181[0:0] = BRAM_WEN_B[3:3];
  assign pgassign182[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign182[0:0] = BRAM_Dout_A[30:30];
  assign BRAM_Din_A[30:30] = pgassign183[0:0];
  assign pgassign184[3:3] = BRAM_WEN_A[3:3];
  assign pgassign184[2:2] = BRAM_WEN_A[3:3];
  assign pgassign184[1:1] = BRAM_WEN_A[3:3];
  assign pgassign184[0:0] = BRAM_WEN_A[3:3];
  assign pgassign185[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign185[0:0] = BRAM_Dout_B[30:30];
  assign BRAM_Din_B[30:30] = pgassign186[0:0];
  assign pgassign187[3:3] = BRAM_WEN_B[3:3];
  assign pgassign187[2:2] = BRAM_WEN_B[3:3];
  assign pgassign187[1:1] = BRAM_WEN_B[3:3];
  assign pgassign187[0:0] = BRAM_WEN_B[3:3];
  assign pgassign188[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign188[0:0] = BRAM_Dout_A[31:31];
  assign BRAM_Din_A[31:31] = pgassign189[0:0];
  assign pgassign190[3:3] = BRAM_WEN_A[3:3];
  assign pgassign190[2:2] = BRAM_WEN_A[3:3];
  assign pgassign190[1:1] = BRAM_WEN_A[3:3];
  assign pgassign190[0:0] = BRAM_WEN_A[3:3];
  assign pgassign191[31:1] = 31'b0000000000000000000000000000000;
  assign pgassign191[0:0] = BRAM_Dout_B[31:31];
  assign BRAM_Din_B[31:31] = pgassign192[0:0];
  assign pgassign193[3:3] = BRAM_WEN_B[3:3];
  assign pgassign193[2:2] = BRAM_WEN_B[3:3];
  assign pgassign193[1:1] = BRAM_WEN_B[3:3];
  assign pgassign193[0:0] = BRAM_WEN_B[3:3];
  assign net_gnd0 = 1'b0;
  assign net_gnd4[3:0] = 4'b0000;

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_0.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_0 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign2 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign3 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign4 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign5 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign6 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign7 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_1.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_1 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign8 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign9 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign10 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign11 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign12 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign13 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_2.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_2 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign14 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign15 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign16 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign17 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign18 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign19 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_3.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_3 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign20 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign21 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign22 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign23 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign24 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign25 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_4.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_4 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign26 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign27 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign28 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign29 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign30 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign31 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_5.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_5 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign32 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign33 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign34 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign35 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign36 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign37 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_6.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_6 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign38 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign39 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign40 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign41 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign42 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign43 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_7.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_7 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign44 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign45 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign46 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign47 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign48 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign49 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_8.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_8 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign50 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign51 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign52 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign53 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign54 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign55 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_9.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_9 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign56 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign57 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign58 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign59 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign60 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign61 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_10.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_10 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign62 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign63 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign64 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign65 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign66 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign67 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_11.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_11 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign68 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign69 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign70 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign71 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign72 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign73 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_12.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_12 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign74 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign75 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign76 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign77 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign78 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign79 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_13.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_13 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign80 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign81 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign82 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign83 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign84 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign85 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_14.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_14 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign86 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign87 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign88 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign89 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign90 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign91 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_15.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_15 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign92 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign93 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign94 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign95 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign96 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign97 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_16.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_16 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign98 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign99 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign100 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign101 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign102 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign103 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_17.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_17 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign104 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign105 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign106 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign107 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign108 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign109 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_18.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_18 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign110 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign111 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign112 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign113 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign114 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign115 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_19.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_19 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign116 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign117 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign118 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign119 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign120 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign121 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_20.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_20 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign122 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign123 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign124 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign125 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign126 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign127 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_21.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_21 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign128 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign129 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign130 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign131 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign132 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign133 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_22.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_22 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign134 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign135 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign136 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign137 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign138 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign139 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_23.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_23 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign140 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign141 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign142 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign143 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign144 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign145 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_24.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_24 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign146 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign147 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign148 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign149 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign150 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign151 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_25.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_25 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign152 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign153 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign154 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign155 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign156 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign157 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_26.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_26 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign158 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign159 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign160 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign161 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign162 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign163 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_27.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_27 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign164 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign165 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign166 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign167 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign168 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign169 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_28.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_28 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign170 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign171 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign172 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign173 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign174 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign175 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_29.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_29 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign176 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign177 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign178 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign179 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign180 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign181 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_30.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_30 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign182 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign183 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign184 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign185 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign186 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign187 )
    );

  (* BMM_INFO = " " *)

  RAMB16BWER
    #(
      .INIT_FILE ( "microblaze_0_bram_block_combined_31.mem" ),
      .DATA_WIDTH_A ( 1 ),
      .DATA_WIDTH_B ( 1 )
    )
    ramb16bwer_31 (
      .ADDRA ( BRAM_Addr_A[16:29] ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign188 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign189 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .RSTA ( BRAM_Rst_A ),
      .WEA ( pgassign190 ),
      .ADDRB ( BRAM_Addr_B[16:29] ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign191 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign192 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .RSTB ( BRAM_Rst_B ),
      .WEB ( pgassign193 )
    );

endmodule

