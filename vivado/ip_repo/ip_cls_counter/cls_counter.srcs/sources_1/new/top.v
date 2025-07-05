`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/07 13:43:30
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLS_COUNTER(
    input clock,
    input RESET_N,
    input count,
    input trigger,
    input [31:0] dwell,
    output reg [31:0] out_data
    );
    
   reg count_state, count_state_prev;
   reg start_button_state, start_button_state_prev;

   reg [31:0] count_data;
   reg [31:0] dwell_clock;
   reg [31:0] dwell_counter;
   reg dwellDone;
    
 initial 
 begin
     count_data = 8'h00000000;
     dwell_clock = 8'h00000000;
     dwell_counter = 8'h00000000;
 end
 
always @(posedge clock)
begin
    if(!RESET_N)
    begin
        count_state <= 0;
        count_state_prev <= 0;
    end
    else
    begin
        count_state_prev <= count_state;
        count_state <= count;
    end
end

always @(*)
begin
    dwell_clock = dwell;
end

always @(posedge clock)
begin
    if(!RESET_N || dwellDone) begin
        count_data <= 0;
    end 
    else if(count_state && !count_state_prev && trigger) begin
        count_data <= count_data + 1;
        out_data <= count_data;
    end
end

always @(posedge clock)
begin
    if(!RESET_N) begin
        dwell_counter <= 0;
    end
    else if(dwell_counter != dwell_clock)
    begin
        dwell_counter <= dwell_counter + 1;
        dwellDone <= 1'b0;
    end
    else begin
        dwell_counter <= 0;
        dwellDone <= 1'b1;
    end
end

endmodule
