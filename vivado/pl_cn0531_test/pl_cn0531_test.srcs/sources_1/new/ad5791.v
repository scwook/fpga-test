`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2025 09:50:14 AM
// Design Name: 
// Module Name: ad5791
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

module cn0531 (
    input clock,
    input reset,
    output wire spi_clk,
    output wire spi_data,
    output wire spi_sync,
    output reg [7:0] led
);

reg [4:0] state;
reg [4:0] nextState;
reg [23:0] spiData;
reg spiLoadData;
wire spiDone;
reg startDelay;
wire delayDone;

localparam IDLE     = 3'd0;
localparam CONFIG   = 3'd1;
localparam LOAD     = 3'd2;
localparam INIT     = 3'd3;
localparam DONE     = 3'd4;
localparam DELAY    = 3'd5;

always @(posedge clock)
begin
    if(reset)
    begin
        state <= IDLE;
        nextState <= IDLE;
//        spi_sync <= 1;
        spiData <= 24'h000000;
        spiLoadData <= 1'b0;
        led <= 8'b00000000;
    end
    else
    begin
        case(state)
            IDLE:begin
                state <= CONFIG;
                led <= led + 1;
            end
            
            INIT:begin
                spiData <= 24'h400004;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= DELAY;
                    nextState <= CONFIG;
                    led <= led + 1;
                end
            end
            
            DELAY: begin
                startDelay <= 1'b1;
                led[6] <= 1'b1;
                if(delayDone)
                begin
                    state <= nextState;
                    startDelay <= 1'b0;
                    led[6] <= 1'b0;
                end
            end
            
            CONFIG:begin
                spiData <= 24'h200010;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= DELAY;
                    nextState <= LOAD;
                    led <= led + 1;
                end
            end
            
            LOAD:begin
                spiData <= 24'h000000;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= DONE;
                    led <= led + 1;
                end
            end
            
            DONE: begin
                led[7] <= 1'b1;
            end
        endcase
    end
end

spiControl ad5791 (
.clock(clock),
.reset(reset),
.data_in(spiData),
.load_data(spiLoadData),
.done_send(spiDone),
.spi_clock(spi_clk),
.spi_data(spi_data),
.spi_sync(spi_sync)
);

delayGen delay (
 .clock(clock),
 .delayEn(startDelay),
 .delayDone(delayDone)
);

endmodule