
`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic
(
  UART_tx,
  UART_rx,
  UART_int,
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

parameter C_NUM_REG                      = 3;
parameter C_SLV_DWIDTH                   = 32;

output                                    UART_tx;
input                                     UART_rx;
output                                    UART_int;
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

  reg [15:0]  baud_count;
  reg  		en_16_x_baud;
  wire    tx_data_present;
  wire  	tx_full;
  wire  	tx_half_full;
  wire [7:0] 	rx_data;
  wire  	rx_data_present;
  wire  	rx_full;
  wire  	rx_half_full;
  wire    write_to_uart;
  wire    read_from_uart;
  wire    uart_enable;
  wire    rx_interrupt_enable;
  wire    tx_interrupt_enable;

  wire [1:0] uart_rx_status = {rx_data_present,rx_full};
  wire [2:0] uart_tx_status = {tx_data_present,tx_full,tx_half_full};

  reg        [2 : 0]                        uart_control;
  reg        [15 : 0]                       baud_control;
  wire       [2 : 0]                        slv_reg_write_sel;
  wire       [2 : 0]                        slv_reg_read_sel;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;

  assign
    slv_reg_write_sel = Bus2IP_WrCE[2:0],
    slv_reg_read_sel  = Bus2IP_RdCE[2:0],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2];

  assign uart_enable = uart_control[2];
  assign rx_interrupt_enable = uart_control[1];
  assign tx_interrupt_enable = uart_control[0];
  assign write_to_uart = slv_reg_write_sel[2] & Bus2IP_BE[0];
  assign read_from_uart = slv_reg_read_sel[2] & Bus2IP_BE[0];
  assign UART_int = uart_enable & ((rx_interrupt_enable & rx_data_present) | (tx_interrupt_enable & ~tx_half_full));

  always @( posedge Bus2IP_Clk )
    begin

      if ( Bus2IP_Resetn == 1'b0 )
        begin
          uart_control <= 0;
          baud_control <= 0;
        end
      else
        case ( slv_reg_write_sel )
          3'b010 :
            if ( Bus2IP_BE[0] == 1 )
              uart_control <= Bus2IP_Data[7:5];
          3'b001 :
            for ( byte_index = 0; byte_index <= 1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                baud_control[(byte_index*8) +: 8] <= Bus2IP_Data[(byte_index*8) +: 8];
          default :
            begin
              uart_control <= uart_control;
              baud_control <= baud_control;
            end
        endcase

    end

  always @( * )
    begin 

      case ( slv_reg_read_sel )
        3'b100 : slv_ip2bus_data <= rx_data;
        3'b010 : slv_ip2bus_data <= {rx_data, uart_enable, rx_interrupt_enable, tx_interrupt_enable, uart_rx_status, uart_tx_status};
        3'b001 : slv_ip2bus_data <= baud_control;
        default : slv_ip2bus_data <= 0;
      endcase

    end


  assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data :  0 ;
  assign IP2Bus_WrAck = slv_write_ack;
  assign IP2Bus_RdAck = slv_read_ack;
  assign IP2Bus_Error = 0;

  always @(posedge Bus2IP_Clk) begin
    if (!Bus2IP_Resetn | slv_reg_write_sel[0]) begin
      baud_count <= 16'b0;
      en_16_x_baud <= 1'b0;
    end else begin
      if (baud_count == baud_control) begin
        baud_count <= 16'b0;
        en_16_x_baud <= 1'b1;
      end else begin
        baud_count <= baud_count + 1;
        en_16_x_baud <= 1'b0;
      end
    end
  end

/////////////////////////////////////////////////////////////////////////////////////////
// UART Transmitter with integral 16 byte FIFO buffer
/////////////////////////////////////////////////////////////////////////////////////////
uart_tx6 transmit
(	.data_in(Bus2IP_Data[7:0]),
  .buffer_write(write_to_uart),
  .buffer_reset(~uart_enable),
  .en_16_x_baud(en_16_x_baud),
  .serial_out(UART_tx),
  .buffer_data_present(tx_data_present),
  .buffer_full(tx_full),
  .buffer_half_full(tx_half_full),
  .clk(Bus2IP_Clk)
);

/////////////////////////////////////////////////////////////////////////////////////////
// UART Receiver with integral 16 byte FIFO buffer
/////////////////////////////////////////////////////////////////////////////////////////
uart_rx6 receive
(	.serial_in(UART_rx),
  .data_out(rx_data),
  .buffer_read(read_from_uart),
  .buffer_reset(~uart_enable),
  .en_16_x_baud(en_16_x_baud),
  .buffer_data_present(rx_data_present),
  .buffer_full(rx_full),
  .buffer_half_full(rx_half_full),
  .clk(Bus2IP_Clk)
);

endmodule
