
`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic
(
  wing_in,                        // Wing interface
  wing_out,
  wing_dir,
  wing_int,
  wing_led1,
  wing_led2,
  wing_led3,
  wing_led4,
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error                    // IP to Bus error response
);

parameter WING_DWIDTH                    = 16;
parameter PWM_DWIDTH                     = 16;
parameter C_NUM_REG                      = 32;
parameter C_SLV_DWIDTH                   = 32;

input      [WING_DWIDTH-1 : 0]            wing_in;
output     [WING_DWIDTH-1 : 0]            wing_out;
output     [WING_DWIDTH-1 : 0]            wing_dir;
output                                    wing_int;
output                                    wing_led1;
output                                    wing_led2;
output                                    wing_led3;
output                                    wing_led4;
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE;
output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  wire       [WING_DWIDTH-1 : 0]            wing_in;   // pins
  wire       [WING_DWIDTH-1 : 0]            wing_out;  // port
  wire       [WING_DWIDTH-1 : 0]            wing_dir;  // dir
  wire                                      wing_int;  // interrupt
  reg        [WING_DWIDTH-1 : 0]            wing_in_d; // registered pins
  reg        [WING_DWIDTH-1 : 0]            wing_in_d2; 

  reg        [WING_DWIDTH-1 : 0]            port;
  reg        [WING_DWIDTH-1 : 0]            dir;
  reg        [PWM_DWIDTH-1 : 0]             pwm0;
  reg        [PWM_DWIDTH-1 : 0]             pwm1;
  reg        [PWM_DWIDTH-1 : 0]             pwm2;
  reg        [PWM_DWIDTH-1 : 0]             pwm3;
  reg        [PWM_DWIDTH-1 : 0]             pwm4;
  reg        [PWM_DWIDTH-1 : 0]             pwm5;
  reg        [PWM_DWIDTH-1 : 0]             pwm6;
  reg        [PWM_DWIDTH-1 : 0]             pwm7;
  reg        [PWM_DWIDTH-1 : 0]             pwm8;
  reg        [PWM_DWIDTH-1 : 0]             pwm9;
  reg        [PWM_DWIDTH-1 : 0]             pwm10;
  reg        [PWM_DWIDTH-1 : 0]             pwm11;
  reg        [PWM_DWIDTH-1 : 0]             pwm12;
  reg        [PWM_DWIDTH-1 : 0]             pwm13;
  reg        [PWM_DWIDTH-1 : 0]             pwm14;
  reg        [PWM_DWIDTH-1 : 0]             pwm15;
  reg        [15 : 0]                       pwm_en;
  reg        [WING_DWIDTH*2-1 : 0]          int_sel;
  reg        [WING_DWIDTH-1 : 0]            int_flag, next_int_flag;
  reg        [15 : 0]                       led_map;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg30;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg31;
  wire       [31 : 0]                       slv_reg_write_sel;
  wire       [31 : 0]                       slv_reg_read_sel;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;


  reg        [PWM_DWIDTH-1 : 0]             pwm_counter;
  wire       [15 : 0]                       pwm_out;
  wire                                      pwm0_out;
  wire                                      pwm1_out;
  wire                                      pwm2_out;
  wire                                      pwm3_out;
  wire                                      pwm4_out;
  wire                                      pwm5_out;
  wire                                      pwm6_out;
  wire                                      pwm7_out;
  wire                                      pwm8_out;
  wire                                      pwm9_out;
  wire                                      pwm10_out;
  wire                                      pwm11_out;
  wire                                      pwm12_out;
  wire                                      pwm13_out;
  wire                                      pwm14_out;
  wire                                      pwm15_out;
  wire       [3 : 0]                        led1_select;
  wire       [3 : 0]                        led2_select;
  wire       [3 : 0]                        led3_select;
  wire       [3 : 0]                        led4_select;


  always @( posedge Bus2IP_Clk )
    begin
      wing_in_d <= wing_in;
      wing_in_d2 <= wing_in_d;
    end
 
  // interrupt detect logic
  always @ (*)
    begin
      next_int_flag = int_flag;
      for ( bit_index = 0; bit_index <= WING_DWIDTH-1; bit_index = bit_index+1 )
        if ( ((wing_in_d2[bit_index] == 0) && (wing_in_d[bit_index] == 1) && (int_sel[bit_index*2] == 1)) || // rising edge
             ((wing_in_d2[bit_index] == 1) && (wing_in_d[bit_index] == 0) && (int_sel[bit_index*2 + 1] == 1)) ) // falling edge
          next_int_flag[bit_index] = 1;
    end

  // interrupt generation
  assign wing_int = |int_flag;
 

  // pwm counter and comparators
  always @( posedge Bus2IP_Clk )
    if ( Bus2IP_Resetn == 1'b0 )
      pwm_counter <= 0;
    else
      pwm_counter <= pwm_counter + 1;

  assign pwm0_out = (pwm0 > pwm_counter) && pwm_en[0];
  assign pwm1_out = (pwm1 > pwm_counter) && pwm_en[1];
  assign pwm2_out = (pwm2 > pwm_counter) && pwm_en[2];
  assign pwm3_out = (pwm3 > pwm_counter) && pwm_en[3];
  assign pwm4_out = (pwm4 > pwm_counter) && pwm_en[4];
  assign pwm5_out = (pwm5 > pwm_counter) && pwm_en[5];
  assign pwm6_out = (pwm6 > pwm_counter) && pwm_en[6];
  assign pwm7_out = (pwm7 > pwm_counter) && pwm_en[7];
  assign pwm8_out = (pwm8 > pwm_counter) && pwm_en[8];
  assign pwm9_out = (pwm9 > pwm_counter) && pwm_en[9];
  assign pwm10_out = (pwm10 > pwm_counter) && pwm_en[10];
  assign pwm11_out = (pwm11 > pwm_counter) && pwm_en[11];
  assign pwm12_out = (pwm12 > pwm_counter) && pwm_en[12];
  assign pwm13_out = (pwm13 > pwm_counter) && pwm_en[13];
  assign pwm14_out = (pwm14 > pwm_counter) && pwm_en[14];
  assign pwm15_out = (pwm15 > pwm_counter) && pwm_en[15];
  
  assign pwm_out = {pwm15_out,pwm14_out,pwm13_out,pwm12_out,pwm11_out,pwm10_out,pwm9_out,pwm8_out,pwm7_out,pwm6_out,pwm5_out,pwm4_out,pwm3_out,pwm2_out,pwm1_out,pwm0_out};

  assign wing_out = (port & ~pwm_en) | (pwm_out & pwm_en);
  assign wing_dir = ~(dir | pwm_en);
  
  assign led1_select = led_map[3:0];
  assign led2_select = led_map[7:4];
  assign led3_select = led_map[11:8];
  assign led4_select = led_map[15:12];

  assign wing_led1 = wing_in_d[led1_select];
  assign wing_led2 = wing_in_d[led2_select];
  assign wing_led3 = wing_in_d[led3_select];
  assign wing_led4 = wing_in_d[led4_select];
      
  assign
    slv_reg_write_sel = Bus2IP_WrCE[31:0],
    slv_reg_read_sel  = Bus2IP_RdCE[31:0],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3] || Bus2IP_WrCE[4] || Bus2IP_WrCE[5] || Bus2IP_WrCE[6] || Bus2IP_WrCE[7] || Bus2IP_WrCE[8] || Bus2IP_WrCE[9] || Bus2IP_WrCE[10] || Bus2IP_WrCE[11] || Bus2IP_WrCE[12] || Bus2IP_WrCE[13] || Bus2IP_WrCE[14] || Bus2IP_WrCE[15] || Bus2IP_WrCE[16] || Bus2IP_WrCE[17] || Bus2IP_WrCE[18] || Bus2IP_WrCE[19] || Bus2IP_WrCE[20] || Bus2IP_WrCE[21] || Bus2IP_WrCE[22] || Bus2IP_WrCE[23] || Bus2IP_WrCE[24] || Bus2IP_WrCE[25] || Bus2IP_WrCE[26] || Bus2IP_WrCE[27] || Bus2IP_WrCE[28] || Bus2IP_WrCE[29] || Bus2IP_WrCE[30] || Bus2IP_WrCE[31],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3] || Bus2IP_RdCE[4] || Bus2IP_RdCE[5] || Bus2IP_RdCE[6] || Bus2IP_RdCE[7] || Bus2IP_RdCE[8] || Bus2IP_RdCE[9] || Bus2IP_RdCE[10] || Bus2IP_RdCE[11] || Bus2IP_RdCE[12] || Bus2IP_RdCE[13] || Bus2IP_RdCE[14] || Bus2IP_RdCE[15] || Bus2IP_RdCE[16] || Bus2IP_RdCE[17] || Bus2IP_RdCE[18] || Bus2IP_RdCE[19] || Bus2IP_RdCE[20] || Bus2IP_RdCE[21] || Bus2IP_RdCE[22] || Bus2IP_RdCE[23] || Bus2IP_RdCE[24] || Bus2IP_RdCE[25] || Bus2IP_RdCE[26] || Bus2IP_RdCE[27] || Bus2IP_RdCE[28] || Bus2IP_RdCE[29] || Bus2IP_RdCE[30] || Bus2IP_RdCE[31];

  // implement slave model register(s)
  always @( posedge Bus2IP_Clk )
    begin

      if ( Bus2IP_Resetn == 1'b0 )
        begin
          port <= 0;
          dir <= 0;
          pwm0 <= 0;
          pwm1 <= 0;
          pwm2 <= 0;
          pwm3 <= 0;
          pwm4 <= 0;
          pwm5 <= 0;
          pwm6 <= 0;
          pwm7 <= 0;
          pwm8 <= 0;
          pwm9 <= 0;
          pwm10 <= 0;
          pwm11 <= 0;
          pwm12 <= 0;
          pwm13 <= 0;
          pwm14 <= 0;
          pwm15 <= 0;
          pwm_en <= 0;
          int_sel <= 0;
          int_flag <= 0;
          led_map <= 16'hfedc;
          slv_reg30 <= 0;
          slv_reg31 <= 0;
        end
      else
        begin
          int_flag <= next_int_flag;
          case ( slv_reg_write_sel )
            32'b10000000000000000000000000000000 : // port
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  port[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b01000000000000000000000000000000 : // port_set
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      port[(byte_index*8) + bit_index] <= 1'b1;
            32'b00100000000000000000000000000000 : // port_clr
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      port[(byte_index*8) + bit_index] <= 1'b0;
            32'b00010000000000000000000000000000 : // port_tgl
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      port[(byte_index*8) + bit_index] <= ~port[(byte_index*8) + bit_index];
            32'b00001000000000000000000000000000 : // dir
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  dir[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000100000000000000000000000000 : // dir_set
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      dir[(byte_index*8) + bit_index] <= 1'b1;
            32'b00000010000000000000000000000000 : // dir_clr
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      dir[(byte_index*8) + bit_index] <= 1'b0;
            32'b00000001000000000000000000000000 : // pin -> port_tgl
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      port[(byte_index*8) + bit_index] <= ~port[(byte_index*8) + bit_index];
            32'b00000000100000000000000000000000 : // pwmcmp_0
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm0[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000010000000000000000000000 : //pwmcmp_1
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm1[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000001000000000000000000000 : //pwmcmp_2
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm2[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000100000000000000000000 : //pwmcmp_3
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm3[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000010000000000000000000 : //pwmcmp_4
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm4[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000001000000000000000000 : //pwmcmp_5
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm5[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000100000000000000000 : //pwmcmp_6
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm6[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000010000000000000000 : //pwmcmp_7
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm7[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000001000000000000000 : //pwmcmp_8
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm8[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000100000000000000 : //pwmcmp_9
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm9[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000010000000000000 : //pwmcmp_10
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm10[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000001000000000000 : //pwmcmp_11
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm11[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000100000000000 : //pwmcmp_12
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm12[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000010000000000 : //pwmcmp_13
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm13[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000001000000000 : //pwmcmp_14
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm14[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000000100000000 : //pwmcmp_15
              for ( byte_index = 0; byte_index <= (PWM_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm15[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000000010000000 : // pwm_en
              for ( byte_index = 0; byte_index <= 1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  pwm_en[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000000001000000 : // pwm_enset
              for ( byte_index = 0; byte_index <= 1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      pwm_en[(byte_index*8) + bit_index] <= 1'b1;
            32'b00000000000000000000000000100000 : // pwm_enclr
              for ( byte_index = 0; byte_index <= 1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      pwm_en[(byte_index*8) + bit_index] <= 1'b0;
            32'b00000000000000000000000000010000 : // int_sel
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/4)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  int_sel[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000000000001000 : // int_flag
              for ( byte_index = 0; byte_index <= (WING_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  for ( bit_index = 0; bit_index <= 7; bit_index = bit_index+1 )
                    if ( Bus2IP_Data[(byte_index*8) + bit_index] == 1 )
                      int_flag[(byte_index*8) + bit_index] <= 1'b0;
            32'b00000000000000000000000000000100 :
              for ( byte_index = 0; byte_index <= 1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  led_map[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000000000000010 :
              for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  slv_reg30[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            32'b00000000000000000000000000000001 :
              for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  slv_reg31[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            default : begin
              port <= port;
              dir <= dir;
              pwm0 <= pwm0;
              pwm1 <= pwm1;
              pwm2 <= pwm2;
              pwm3 <= pwm3;
              pwm4 <= pwm4;
              pwm5 <= pwm5;
              pwm6 <= pwm6;
              pwm7 <= pwm7;
              pwm8 <= pwm8;
              pwm9 <= pwm9;
              pwm10 <= pwm10;
              pwm11 <= pwm11;
              pwm12 <= pwm12;
              pwm13 <= pwm13;
              pwm14 <= pwm14;
              pwm15 <= pwm15;
              pwm_en <= pwm_en;
              int_sel <= int_sel;
              led_map <= led_map;
              slv_reg30 <= slv_reg30;
              slv_reg31 <= slv_reg31;
            end
          endcase
        end

    end

  always @( slv_reg_read_sel or port or dir or wing_in_d or pwm0 or pwm1 or pwm2 or pwm3 or pwm4 or pwm5 or pwm6 or pwm7 or pwm8 or pwm9 or pwm10 or pwm11 or pwm12 or pwm13 or pwm14 or pwm15 or pwm_en or int_sel or int_flag or led_map or slv_reg30 or slv_reg31 )
    begin 

      case ( slv_reg_read_sel )
        32'b10000000000000000000000000000000 : slv_ip2bus_data <= port;
        32'b01000000000000000000000000000000 : slv_ip2bus_data <= 0;
        32'b00100000000000000000000000000000 : slv_ip2bus_data <= 0;
        32'b00010000000000000000000000000000 : slv_ip2bus_data <= 0;
        32'b00001000000000000000000000000000 : slv_ip2bus_data <= dir;
        32'b00000100000000000000000000000000 : slv_ip2bus_data <= 0;
        32'b00000010000000000000000000000000 : slv_ip2bus_data <= 0;
        32'b00000001000000000000000000000000 : slv_ip2bus_data <= wing_in_d;
        32'b00000000100000000000000000000000 : slv_ip2bus_data <= pwm0;
        32'b00000000010000000000000000000000 : slv_ip2bus_data <= pwm1;
        32'b00000000001000000000000000000000 : slv_ip2bus_data <= pwm2;
        32'b00000000000100000000000000000000 : slv_ip2bus_data <= pwm3;
        32'b00000000000010000000000000000000 : slv_ip2bus_data <= pwm4;
        32'b00000000000001000000000000000000 : slv_ip2bus_data <= pwm5;
        32'b00000000000000100000000000000000 : slv_ip2bus_data <= pwm6;
        32'b00000000000000010000000000000000 : slv_ip2bus_data <= pwm7;
        32'b00000000000000001000000000000000 : slv_ip2bus_data <= pwm8;
        32'b00000000000000000100000000000000 : slv_ip2bus_data <= pwm9;
        32'b00000000000000000010000000000000 : slv_ip2bus_data <= pwm10;
        32'b00000000000000000001000000000000 : slv_ip2bus_data <= pwm11;
        32'b00000000000000000000100000000000 : slv_ip2bus_data <= pwm12;
        32'b00000000000000000000010000000000 : slv_ip2bus_data <= pwm13;
        32'b00000000000000000000001000000000 : slv_ip2bus_data <= pwm14;
        32'b00000000000000000000000100000000 : slv_ip2bus_data <= pwm15;
        32'b00000000000000000000000010000000 : slv_ip2bus_data <= pwm_en;
        32'b00000000000000000000000001000000 : slv_ip2bus_data <= 0;
        32'b00000000000000000000000000100000 : slv_ip2bus_data <= 0;
        32'b00000000000000000000000000010000 : slv_ip2bus_data <= int_sel;
        32'b00000000000000000000000000001000 : slv_ip2bus_data <= int_flag;
        32'b00000000000000000000000000000100 : slv_ip2bus_data <= led_map;
        32'b00000000000000000000000000000010 : slv_ip2bus_data <= slv_reg30;
        32'b00000000000000000000000000000001 : slv_ip2bus_data <= slv_reg31;
        default : slv_ip2bus_data <= 0;
      endcase

    end


assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data :  0 ;
  assign IP2Bus_WrAck = slv_write_ack;
  assign IP2Bus_RdAck = slv_read_ack;
  assign IP2Bus_Error = 0;

endmodule
