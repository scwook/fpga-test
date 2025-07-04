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
    input RESET_N,
    input RESET_BTN,
    input load_data,
    input [19:0] data,
    output wire spi_clock,
    output wire spi_data,
    output wire spi_sync,
    output reg  [6:0] led
);

reg [4:0] state;
reg [23:0] spiData;
reg spiLoadData;
wire spiDone;
reg startDelay;
wire delayDone;

localparam CONFIG   = 3'd0;
localparam DELAY    = 3'd1;
localparam INIT     = 3'd2;
localparam IDLE     = 3'd3;
localparam SEND     = 3'd4;

always @(posedge clock)
begin
    if(!RESET_N || RESET_BTN)
    begin
        spiData <= 24'h000000;
        spiLoadData <= 1'b0;
        state <= CONFIG;
        led <= 6'b0000000;
        led[0] <= 1;
    end
    else
    begin
        case(state)
           CONFIG:begin
                spiData <= 24'h200010;
                spiLoadData <= 1'b1;
                led[0] <= 0;
                led[1] <= 1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    led[1] <= 0;
                    state <= DELAY;
                end
            end
            
            DELAY:begin
                startDelay <= 1'b1;
                if(delayDone)
                begin
                    state <= INIT;
                    startDelay <= 1'b0;
                end
            end

            INIT:begin
                spiData <= 24'h17FFFF;
                spiLoadData <= 1'b1;
                led[2] <= 1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    led[2] <= 0;
                    state <= IDLE;

                end
            end

            IDLE:begin
                led[6] <= 1;
                if(load_data)
                begin
                    state <= SEND;
                end

            end

            SEND:begin
                spiData <= {4'b0001, data};
                spiLoadData <= 1'b1;
                led[6] <= 0;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= IDLE;
                end
            end

        endcase
    end
end

spiControl ad5791 (
.clock(clock),
.reset_n(RESET_N),
.data_in(spiData),
.spi_load(spiLoadData),
.spi_done(spiDone),
.spi_clock(spi_clock),
.spi_data(spi_data),
.spi_sync(spi_sync)
);

delayGen delay (
 .clock(clock),
 .delayEn(startDelay),
 .delayDone(delayDone)
);

endmodule