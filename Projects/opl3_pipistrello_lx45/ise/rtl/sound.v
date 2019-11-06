/***************************************************************************************************
*  sound.v
*
*  Copyright (c) 2013, Magnus Karlsson
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted
*  provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice, this list of conditions
*     and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright notice, this list of
*     conditions and the following disclaimer in the documentation and/or other materials provided
*     with the distribution.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
*  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
*  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
*  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
*  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
*  WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
***************************************************************************************************/
module sound(
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Reset,                   // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_Adr,                     // Bus to IP address bus
  Bus2IP_RD,                      // Bus to IP read enable
  Bus2IP_WR,                      // Bus to IP write enable
  Bus2IP_CS,                      // Bus to IP chip select
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Int,                     // IP to Bus interrupt
  clk_opl3,                       //
  audio_left,                     // left channel output
  audio_right                     // right channel output
  );

  input         Bus2IP_Clk;
  input         Bus2IP_Reset;
  input [31:0]  Bus2IP_Data;
  input [3:0]   Bus2IP_BE;
  input [1:0]   Bus2IP_Adr;
  input         Bus2IP_RD;
  input         Bus2IP_WR;
  input         Bus2IP_CS;
  output [31:0] IP2Bus_Data;
  output        IP2Bus_RdAck;
  output        IP2Bus_WrAck;
  output        IP2Bus_Int;
  input         clk_opl3;
  output        audio_left;
  output        audio_right;

  reg [15:0] period;
  reg go, int_en;
  reg [31:0] slv_ip2bus_data;
  wire opl3_we;
  reg opl3_we_d;
  wire [7:0] opl3_data;
  wire [8:0] opl3_adr;
  wire signed [15:0] opl3_channel_a;
  wire signed [15:0] opl3_channel_b;
  wire signed [15:0] opl3_channel_c;
  wire signed [15:0] opl3_channel_d;
  wire fifo_we;
  reg fifo_we_d;
  wire [31:0] fifo_din, fifo_dout;
  wire stop;
  reg [15:0] counter;
  reg fifo_rd;
  reg signed [15:0] fifo_left, fifo_right;
  wire signed [18:0] left_pre, right_pre;
  wire [15:0] left, right;

  always @(posedge Bus2IP_Clk) begin
    if (Bus2IP_Reset) begin
      period <= 16'd0;
      go <= 1'b0;
      int_en <= 1'b0;
    end else if (Bus2IP_CS & Bus2IP_WR) begin
      if ((Bus2IP_Adr == 2'b00) && (Bus2IP_BE[1:0] == 2'b11))
        period <= Bus2IP_Data[15:0];
      if ((Bus2IP_Adr == 2'b01) && (Bus2IP_BE[0] == 1'b1)) begin
        go <= Bus2IP_Data[0];
        int_en <= Bus2IP_Data[1];
      end
    end
  end

  always @(*)
    case(Bus2IP_Adr) // synopsys full_case parallel_case
      2'b00: slv_ip2bus_data = {16'd0, period};
      2'b01: slv_ip2bus_data = {30'd0, int_en, go};
      2'b10: slv_ip2bus_data = {31'd0, fifo_full};
      2'b11: slv_ip2bus_data = 32'd0;
      default: slv_ip2bus_data = 32'd0;      
    endcase
  
  assign opl3_we = Bus2IP_CS & Bus2IP_WR & ((Bus2IP_Adr == 2'b10) && (Bus2IP_BE[3:0] == 4'b1111));
  assign opl3_data = Bus2IP_Data[7:0];
  assign opl3_adr = Bus2IP_Data[16:8];
  
  assign fifo_we = Bus2IP_CS & Bus2IP_WR & ((Bus2IP_Adr == 2'b11) && (Bus2IP_BE[3:0] == 4'b1111));
  assign fifo_din = Bus2IP_Data[31:0];
  assign stop = ~go;

  assign IP2Bus_Int = ~fifo_full & int_en;
  assign IP2Bus_RdAck = Bus2IP_CS & Bus2IP_RD;
  assign IP2Bus_WrAck = Bus2IP_CS & Bus2IP_WR;
  assign IP2Bus_Data = (IP2Bus_RdAck == 1'b1) ? slv_ip2bus_data :  0 ;

  opl3 opl3(
    .clk(Bus2IP_Clk),
    .clk_opl3(clk_opl3),
    .opl3_we(opl3_we & !opl3_we_d),
    .opl3_data(opl3_data),
    .opl3_adr(opl3_adr),
    .channel_a(opl3_channel_a),
    .channel_b(opl3_channel_b),
    .channel_c(opl3_channel_c),
    .channel_d(opl3_channel_d)
  );

  sound_fifo sound_fifo(
    .clk(Bus2IP_Clk),
    .srst(stop),
    .din(fifo_din),
    .wr_en(fifo_we & !fifo_we_d),
    .rd_en(fifo_rd),
    .dout(fifo_dout),
    .full(),
    .empty(fifo_empty),
    .prog_full(fifo_full)
  );

  always @(posedge Bus2IP_Clk) begin
    if (stop) begin
      fifo_we_d <= 0;
      opl3_we_d <= 0;
      counter <= 0;
      fifo_rd <= 0;
      fifo_left <= 0;
      fifo_right <= 0;
    end else begin
      fifo_we_d <= fifo_we;
      opl3_we_d <= opl3_we;
      if (counter == period) begin
        counter <= 0;
        fifo_rd <= 1;
      end else begin
        counter <= counter + 1;
        fifo_rd <= 0;
      end
      if (fifo_rd & !fifo_empty) begin
        fifo_left <= fifo_dout[15:0];
        fifo_right <= fifo_dout[31:16];
      end
    end
  end

  assign left_pre = fifo_left + (opl3_channel_a + opl3_channel_c)<<<3;
  assign left = left_pre > 32767 ? 16'hffff : left_pre < -32768 ? 16'h0000 : left_pre[15:0] ^ 16'h8000;
  
  assign right_pre = fifo_right + (opl3_channel_b + opl3_channel_d)<<<3;
  assign right = right_pre > 32767 ? 16'hffff : right_pre < -32768 ? 16'h0000: right_pre[15:0] ^ 16'h8000;

  dac left_dac(
    .DACout(audio_left), 
    .DACin(left[15:4]), 
    .clock(Bus2IP_Clk)
  );
  
  dac right_dac(
    .DACout(audio_right), 
    .DACin(right[15:4]), 
    .clock(Bus2IP_Clk)
  );
  
endmodule
