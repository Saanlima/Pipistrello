

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic
(
  PS2_CLK_IN,       // PS2 Clock
  PS2_DAT_IN,       // PS2 Data
  PS2_CLK_OUT,      // PS2 Clock
  PS2_DAT_OUT,      // PS2 Data
  PS2_CLK_OE,       // PS2 Clock
  PS2_DAT_OE,       // PS2 Data
  PS2_INT,          // PS2 Interrupt
  Bus2IP_Clk,       // Bus to IP clock
  Bus2IP_Resetn,    // Bus to IP reset
  Bus2IP_Data,      // Bus to IP data bus
  Bus2IP_BE,        // Bus to IP byte enables
  Bus2IP_RdCE,      // Bus to IP read chip enable
  Bus2IP_WrCE,      // Bus to IP write chip enable
  IP2Bus_Data,      // IP to Bus data bus
  IP2Bus_RdAck,     // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,     // IP to Bus write transfer acknowledgement
  IP2Bus_Error      // IP to Bus error response
);

parameter C_NUM_REG                      = 2;
parameter C_SLV_DWIDTH                   = 32;

input                                     PS2_CLK_IN;
input                                     PS2_DAT_IN;
output                                    PS2_CLK_OUT;
output                                    PS2_DAT_OUT;
output                                    PS2_CLK_OE;
output                                    PS2_DAT_OE;
output                                    PS2_INT;
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

  reg        [2 : 0]                        ps2_control;
  wire       [1 : 0]                        slv_reg_write_sel;
  wire       [1 : 0]                        slv_reg_read_sel;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  reg                                       tx_data_sent;
  reg                                       rx_data_present;
  reg                                       tx_error;
  wire                                      write_to_ps2;
  wire                                      read_from_ps2;
  wire                                      ps2_enable;
  wire                                      rx_interrupt_enable;
  wire                                      tx_interrupt_enable;
  wire                                      rx_interrupt_flag;
  wire                                      tx_interrupt_flag;
  wire                                      time_out;
  wire                                      command_sent;
  wire       [7 : 0]                        received_data;
  wire                                      received_data_en;

  assign
    slv_reg_write_sel = Bus2IP_WrCE[1:0],
    slv_reg_read_sel  = Bus2IP_RdCE[1:0],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1];

  assign ps2_enable = ps2_control[2];
  assign tx_interrupt_enable = ps2_control[1];
  assign rx_interrupt_enable = ps2_control[0];
  assign tx_interrupt_flag = ps2_enable & tx_interrupt_enable & (tx_data_sent | tx_error);
  assign rx_interrupt_flag = ps2_enable & rx_interrupt_enable & rx_data_present;
  assign write_to_ps2 = slv_reg_write_sel[1] & Bus2IP_BE[0];
  assign read_from_ps2 = slv_reg_read_sel[1] & Bus2IP_BE[0];
  assign PS2_INT = ps2_enable & ((rx_interrupt_enable & rx_data_present) | (tx_interrupt_enable & (tx_data_sent | tx_error)));

  always @( posedge Bus2IP_Clk )
    begin
      if ( Bus2IP_Resetn == 1'b0 )
        begin
          ps2_control <= 0;
        end
      else
        case ( slv_reg_write_sel )
          2'b01 :
            if ( Bus2IP_BE[0] == 1 )
              ps2_control <= Bus2IP_Data[7:5];
          default :
            begin
              ps2_control <= ps2_control;
            end
        endcase
    end

  always @ ( * )
    begin 
      case ( slv_reg_read_sel )
        2'b10 : slv_ip2bus_data <= received_data;
        2'b01 : slv_ip2bus_data <= {ps2_enable, tx_interrupt_enable, rx_interrupt_enable, tx_interrupt_flag, rx_interrupt_flag, tx_error, tx_data_sent, rx_data_present};
        default : slv_ip2bus_data <= 0;
      endcase

    end

  assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data :  0 ;
  assign IP2Bus_WrAck = slv_write_ack;
  assign IP2Bus_RdAck = slv_read_ack;
  assign IP2Bus_Error = 0;


  always @ (posedge Bus2IP_Clk) begin
    if (~ps2_enable)
      rx_data_present <= 1'b0;
    else if (received_data_en)
      rx_data_present <= 1'b1;
    else if (read_from_ps2 | (slv_reg_write_sel[0] & Bus2IP_BE[0] & Bus2IP_Data[0]))
      rx_data_present <= 1'b0;
  end
  
  always @ (posedge Bus2IP_Clk) begin
    if (~ps2_enable)
      tx_data_sent <= 1'b0;
    else if (command_sent)
      tx_data_sent <= 1'b1;
    else if (write_to_ps2 | (slv_reg_write_sel[0] & Bus2IP_BE[0] & Bus2IP_Data[1]))
      tx_data_sent <= 1'b0;
  end

  always @ (posedge Bus2IP_Clk) begin
    if (~ps2_enable)
      tx_error <= 1'b0;
    else if (time_out)
      tx_error <= 1'b1;
    else if (write_to_ps2 | (slv_reg_write_sel[0] & Bus2IP_BE[0] & Bus2IP_Data[2]))
      tx_error <= 1'b0;
  end

PS2_Controller (
  .clk                           (Bus2IP_Clk),
  .reset                         (~ps2_enable),
  .the_command                   (Bus2IP_Data[7:0]),
  .send_command                  (write_to_ps2),
  .PS2_CLK_IN                    (PS2_CLK_IN),
  .PS2_DAT_IN                    (PS2_DAT_IN),
  .PS2_CLK_OUT                   (PS2_CLK_OUT),
  .PS2_DAT_OUT                   (PS2_DAT_OUT),
  .PS2_CLK_OE                    (PS2_CLK_OE),
  .PS2_DAT_OE                    (PS2_DAT_OE),
  .command_was_sent              (command_sent),
  .error_communication_timed_out (time_out),
  .received_data                 (received_data),
  .received_data_en              (received_data_en)
);

endmodule
