
module PS2_Controller #(parameter INITIALIZE_MOUSE = 0) (
  // Inputs
  clk,
  reset,

  the_command,
  send_command,

  PS2_CLK_IN,          // PS2 Clock
  PS2_DAT_IN,          // PS2 Data

  // Outputs
  PS2_CLK_OUT,          // PS2 Clock
  PS2_DAT_OUT,          // PS2 Data

  PS2_CLK_OE,          // PS2 Clock
  PS2_DAT_OE,          // PS2 Data

  command_was_sent,
  error_communication_timed_out,

  received_data,
  received_data_en      // If 1 - new data has been received
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input        clk;
input        reset;

input [7:0]  the_command;
input        send_command;

input        PS2_CLK_IN;
input        PS2_DAT_IN;

// Outputs

output       PS2_CLK_OUT;
output       PS2_DAT_OUT;

output       PS2_CLK_OE;
output       PS2_DAT_OE;

output       command_was_sent;
output       error_communication_timed_out;

output [7:0] received_data;
output       received_data_en;

wire [7:0] the_command_w;
wire send_command_w, command_was_sent_w, error_communication_timed_out_w;

assign PS2_CLK_OUT = 1'b0;
assign PS2_DAT_OUT = 1'b0;

generate
  if(INITIALIZE_MOUSE) begin
    assign the_command_w = init_done ? the_command : 8'hf4;
    assign send_command_w = init_done ? send_command : (!command_was_sent_w && !error_communication_timed_out_w);
    assign command_was_sent = init_done ? command_was_sent_w : 0;
    assign error_communication_timed_out = init_done ? error_communication_timed_out_w : 1;
    
    reg init_done;
    
    always @(posedge clk)
      if(reset) init_done <= 0;
      else if(command_was_sent_w) init_done <= 1;
    
  end else begin
    assign the_command_w = the_command;
    assign send_command_w = send_command;
    assign command_was_sent = command_was_sent_w;
    assign error_communication_timed_out = error_communication_timed_out_w;
  end
endgenerate

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/
// states
localparam  PS2_STATE_0_IDLE      = 3'h0,
      PS2_STATE_1_DATA_IN      = 3'h1,
      PS2_STATE_2_COMMAND_OUT    = 3'h2,
      PS2_STATE_3_END_TRANSFER  = 3'h3,
      PS2_STATE_4_END_DELAYED    = 3'h4;

/*****************************************************************************
 *                 Internal wires and registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire      ps2_clk_posedge;
wire      ps2_clk_negedge;

wire      start_receiving_data;
wire      wait_for_incoming_data;

// Internal Registers
reg    [7:0]  idle_counter;

reg        ps2_clk_reg;
reg        ps2_data_reg;
reg        last_ps2_clk;

// State Machine Registers
reg    [2:0]  ns_ps2_transceiver;
reg    [2:0]  s_ps2_transceiver;

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

always @(posedge clk)
begin
  if (reset == 1'b1)
    s_ps2_transceiver <= PS2_STATE_0_IDLE;
  else
    s_ps2_transceiver <= ns_ps2_transceiver;
end

always @(*)
begin
  // Defaults
  ns_ps2_transceiver = PS2_STATE_0_IDLE;

    case (s_ps2_transceiver)
  PS2_STATE_0_IDLE:
    begin
      if ((idle_counter == 8'hFF) && 
          (send_command == 1'b1))
        ns_ps2_transceiver = PS2_STATE_2_COMMAND_OUT;
      else if ((ps2_data_reg == 1'b0) && (ps2_clk_posedge == 1'b1))
        ns_ps2_transceiver = PS2_STATE_1_DATA_IN;
      else
        ns_ps2_transceiver = PS2_STATE_0_IDLE;
    end
  PS2_STATE_1_DATA_IN:
    begin
      if ((received_data_en == 1'b1)/* && (ps2_clk_posedge == 1'b1)*/)
        ns_ps2_transceiver = PS2_STATE_0_IDLE;
      else
        ns_ps2_transceiver = PS2_STATE_1_DATA_IN;
    end
  PS2_STATE_2_COMMAND_OUT:
    begin
      if ((command_was_sent == 1'b1) ||
        (error_communication_timed_out == 1'b1))
        ns_ps2_transceiver = PS2_STATE_3_END_TRANSFER;
      else
        ns_ps2_transceiver = PS2_STATE_2_COMMAND_OUT;
    end
  PS2_STATE_3_END_TRANSFER:
    begin
      if (send_command == 1'b0)
        ns_ps2_transceiver = PS2_STATE_0_IDLE;
      else if ((ps2_data_reg == 1'b0) && (ps2_clk_posedge == 1'b1))
        ns_ps2_transceiver = PS2_STATE_4_END_DELAYED;
      else
        ns_ps2_transceiver = PS2_STATE_3_END_TRANSFER;
    end
  PS2_STATE_4_END_DELAYED:  
    begin
      if (received_data_en == 1'b1)
      begin
        if (send_command == 1'b0)
          ns_ps2_transceiver = PS2_STATE_0_IDLE;
        else
          ns_ps2_transceiver = PS2_STATE_3_END_TRANSFER;
      end
      else
        ns_ps2_transceiver = PS2_STATE_4_END_DELAYED;
    end  
  default:
      ns_ps2_transceiver = PS2_STATE_0_IDLE;
  endcase
end

/*****************************************************************************
 *                             Sequential logic                              *
 *****************************************************************************/

always @(posedge clk)
begin
  if (reset == 1'b1)
  begin
    last_ps2_clk  <= 1'b1;
    ps2_clk_reg    <= 1'b1;

    ps2_data_reg  <= 1'b1;
  end
  else
  begin
    last_ps2_clk  <= ps2_clk_reg;
    ps2_clk_reg    <= PS2_CLK_IN;

    ps2_data_reg  <= PS2_DAT_IN;
  end
end

always @(posedge clk)
begin
  if (reset == 1'b1)
    idle_counter <= 6'h00;
  else if ((s_ps2_transceiver == PS2_STATE_0_IDLE) &&
      (idle_counter != 8'hFF))
    idle_counter <= idle_counter + 6'h01;
  else if (s_ps2_transceiver != PS2_STATE_0_IDLE)
    idle_counter <= 6'h00;
end

/*****************************************************************************
 *                            Combinational logic                            *
 *****************************************************************************/

assign ps2_clk_posedge = 
      ((ps2_clk_reg == 1'b1) && (last_ps2_clk == 1'b0)) ? 1'b1 : 1'b0;
assign ps2_clk_negedge = 
      ((ps2_clk_reg == 1'b0) && (last_ps2_clk == 1'b1)) ? 1'b1 : 1'b0;

assign start_receiving_data    = (s_ps2_transceiver == PS2_STATE_1_DATA_IN);
assign wait_for_incoming_data  = 
      (s_ps2_transceiver == PS2_STATE_3_END_TRANSFER);


/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Data_In PS2_Data_In (
  // Inputs
  .clk                    (clk),
  .reset                  (reset),

  .wait_for_incoming_data (wait_for_incoming_data),
  .start_receiving_data   (start_receiving_data),

  .ps2_clk_posedge        (ps2_clk_posedge),
  .ps2_clk_negedge        (ps2_clk_negedge),
  .ps2_data               (ps2_data_reg),

  // Outputs
  .received_data          (received_data),
  .received_data_en       (received_data_en)
);

PS2_Command_Out PS2_Command_Out (
  // Inputs
  .clk                    (clk),
  .reset                  (reset),

  .the_command            (the_command_w),
  .send_command           (send_command_w),

  .ps2_clk_posedge        (ps2_clk_posedge),
  .ps2_clk_negedge        (ps2_clk_negedge),

   // Outputs
  .PS2_CLK_OE             (PS2_CLK_OE),
  .PS2_DAT_OE             (PS2_DAT_OE),

  .command_was_sent       (command_was_sent_w),
  .error_communication_timed_out  (error_communication_timed_out_w)
);

endmodule

