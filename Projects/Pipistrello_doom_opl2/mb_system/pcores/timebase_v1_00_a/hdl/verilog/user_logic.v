
`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic
(
  TB_Int,
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

parameter C_NUM_REG                      = 4;
parameter C_SLV_DWIDTH                   = 32;

output                                    TB_Int;
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


  reg        [7 : 0]                        clkCounter1;
  reg        [9 : 0]                        clkCounter2;
  reg        [31 : 0]                       clkCounter3;
  reg        [31 : 0]                       micros, millis;
  reg                                       inc_delay;
  reg                                       clr_delay;
  reg                                       delay_to;
  wire                                      interruptEnable;
  wire                                      counterEnable;
  wire       [7 : 0]                        clkFreq;

  reg        [15 : 0]                       delayControl;
  reg        [C_SLV_DWIDTH-1 : 0]           delay;
  wire       [3 : 0]                        slv_reg_write_sel;
  wire       [3 : 0]                        slv_reg_read_sel;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;


  assign clkFreq = delayControl[7:0];
  assign counterEnable = delayControl[8];
  assign interruptEnable = delayControl[9];
  assign TB_Int = delay_to & interruptEnable;
  
  always @( posedge Bus2IP_Clk )
    begin
      if ( counterEnable == 1'b0 )
        begin
          clkCounter1 <= 0;
          clkCounter2 <= 0;
          inc_delay <= 0;
          micros <= 0;
          millis <= 0;
        end
      else
        begin
          if (clkCounter1 >= clkFreq)
            begin
              micros <= micros + 1;
              clkCounter1 <= 1;
              if (clkCounter2 == 999)
                begin
                  inc_delay <= 1;
                  millis <= millis + 1;
                  clkCounter2 <= 0;
                end
              else
                clkCounter2 <= clkCounter2 + 1;
            end
          else
            begin
              clkCounter1 <= clkCounter1 + 1;
              inc_delay <= 0;
            end
        end
    end        

  always @( posedge Bus2IP_Clk )
    begin
      if ((counterEnable == 1'b0) || (clr_delay == 1'b1))
        begin
          delay_to <= 0;
          clkCounter3 <= 1;
        end
      else if (inc_delay == 1'b1)
        begin
          if (clkCounter3 >= delay)
            delay_to <= 1;
          else 
            clkCounter3 <= clkCounter3 + 1;
        end
    end
          

  assign
    slv_reg_write_sel = Bus2IP_WrCE[3:0],
    slv_reg_read_sel  = Bus2IP_RdCE[3:0],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3];


  always @( posedge Bus2IP_Clk )
    begin

      if ( Bus2IP_Resetn == 1'b0 )
        begin
          delayControl <= 0;
          delay <= 0;
          clr_delay <= 0;
        end
      else
        begin
          clr_delay <= 0;
          case ( slv_reg_write_sel )
            4'b1000 :
              for ( byte_index = 0; byte_index <= 1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  delayControl[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
            4'b0100 : begin
              clr_delay <= 1;
              for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
                if ( Bus2IP_BE[byte_index] == 1 )
                  delay[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
              end
            default : begin
              delayControl <= delayControl;
              delay <= delay;
            end
          endcase
        end

    end


  always @( slv_reg_read_sel or delay_to or counterEnable or clkFreq or delay or micros or millis )
    begin 

      case ( slv_reg_read_sel )
        4'b1000 : slv_ip2bus_data <= {delay_to, interruptEnable, counterEnable, clkFreq};
        4'b0100 : slv_ip2bus_data <= delay;
        4'b0010 : slv_ip2bus_data <= micros;
        4'b0001 : slv_ip2bus_data <= millis;
        default : slv_ip2bus_data <= 0;
      endcase

    end

  assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data :  0 ;
  assign IP2Bus_WrAck = slv_write_ack;
  assign IP2Bus_RdAck = slv_read_ack;
  assign IP2Bus_Error = 0;

endmodule
