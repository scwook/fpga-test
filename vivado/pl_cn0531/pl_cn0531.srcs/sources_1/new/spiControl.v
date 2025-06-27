`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 10:16:07 AM
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
input        clock,
input        reset,
input [23:0] data_in,
input        spi_load,
output   reg spi_done,
output       spi_clock,
output   reg spi_data,
output   reg spi_sync
);
    
reg [8:0] counter = 0;
reg [8:0] dataCount;
reg [23:0] shiftReg;
reg [1:0] state;
reg clock_10;
reg CE;

assign spi_clock = (CE == 1) ? clock_10 : 1'b1;

localparam  IDLE = 'd0,
            SEND = 'd1,
            DONE = 'd2;
            
always @(posedge clock)
begin
    if(counter != 49)
        counter <= counter + 1;
    else
        counter <= 0;
end

initial
    clock_10 <= 0;

always @(posedge clock)
begin
    if(counter == 49)
        clock_10 <= ~clock_10;
end

always  @(posedge clock_10)
begin
    if(reset)
    begin
        state <= IDLE;
        dataCount <= 0;
        spi_done <= 1'b0;
        CE <= 0;
        spi_data <= 1'b0;
        spi_sync <= 1'b1;
    end
    else
    begin
        case(state)
            IDLE:begin
                if(spi_load)
                begin
                    shiftReg <= data_in;
                    state <= SEND;
                    dataCount <= 0;
                    CE <= 1;
                end 
            end
            SEND:begin
                spi_sync <= 0;
                spi_data <= shiftReg[23];
                shiftReg <= {shiftReg[22:0], 1'b0};

                if(dataCount != 23)
                    dataCount <= dataCount + 1;
                else
                    state <= DONE;
            end
            DONE:begin
                spi_done <= 1'b1;
                CE <= 0;
                spi_sync <= 1'b1;
                
                if(!spi_load)
                begin
                    spi_done <= 1'b0;
                    state <= IDLE;
                end
            end
        endcase
    end
end
endmodule