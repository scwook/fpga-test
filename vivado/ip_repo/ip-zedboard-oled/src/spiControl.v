`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 15:43:20
// Design Name: 
// Module Name: spiControl
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


module spiControl(
input clock,
input reset_n,
input [7:0] data_in,
input load_data,
output reg done_send,
output     spi_clock,
output reg spi_data
    );
    
reg [2:0] counter = 0;
reg [2:0] dataCount;
reg [7:0] shiftReg;
reg [1:0] state;
reg clock_10;
reg CE;

assign spi_clock = (CE == 1) ? clock_10 : 1'b1;

localparam  IDLE = 'd0,
            SEND = 'd1,
            DONE = 'd2;
            
always @(posedge clock)
begin
    if(counter != 4)
        counter <= counter + 1;
    else
        counter <= 0;
end

initial
    clock_10 <= 0;

always @(posedge clock)
begin
    if(counter == 4)
        clock_10 <= ~clock_10;
end

always  @(negedge clock_10)
begin
    if(!reset_n)
    begin
        state <= IDLE;
        dataCount <= 0;
        done_send <= 1'b0;
        CE <= 0;
        spi_data <= 1'b1;
    end
    else
    begin
        case(state)
            IDLE:begin
                if(load_data)
                begin
                    shiftReg <= data_in;
                    state <= SEND;
                    dataCount <=0;
                end 
            end
            SEND:begin
                spi_data <= shiftReg[7];
                shiftReg <= {shiftReg[6:0], 1'b0};
                CE <= 1;
                if(dataCount != 7)
                    dataCount <= dataCount + 1;
                else
                    state <= DONE;
            end
            DONE:begin
                done_send <= 1'b1;
                CE <= 0;
                if(!load_data)
                begin
                    done_send <= 1'b0;
                    state <= IDLE;
                end
            end
        endcase
    end
end
endmodule
