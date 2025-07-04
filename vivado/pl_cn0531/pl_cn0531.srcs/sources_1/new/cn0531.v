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
    output wire spi_clock,
    output wire spi_data,
    output wire spi_sync,
    output reg  led
);

reg [4:0] state;
//reg [4:0] nextState;
reg [23:0] spiData;
reg spiLoadData;
wire spiDone;
reg startDelay;
wire delayDone;

localparam IDLE     = 3'd0;
localparam CONFIG   = 3'd1;
localparam SEND     = 3'd2;
localparam INIT     = 3'd3;
localparam DONE     = 3'd4;
localparam DELAY    = 3'd5;

always @(posedge clock)
begin
    if(reset)
    begin
        state <= IDLE;
//        nextState <= IDLE;
        spiData <= 24'h000000;
        spiLoadData <= 1'b0;
        led <= 1'b0;
        startDelay <= 1'b0;

    end
    else
    begin
        case(state)
            IDLE:begin
                state <= CONFIG;
                
            end
            
//            INIT:begin
//                spiData <= 24'h400004;
//                spiLoadData <= 1'b1;
//                if(spiDone)
//                begin
//                    spiLoadData <= 1'b0;
//                    led <= led + 1;
//                end
//            end
            
            CONFIG:begin
                spiData <= 24'h200010; // Set configureaion register: RBUF:1, OPGND:0, DACTRI:0, BIN/2sC:0, SDODIS:0, LIN COMP:0000
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= DELAY;
                end
            end
            
            DELAY:begin
                startDelay <= 1'b1;
                if(delayDone)
                begin
                    state <= SEND;
                    startDelay <= 1'b0;
                end
            end
            
            SEND:begin
                spiData <= 24'h199999; //Set Init output voltage: 1V (FFFFF: 5V, 7FFFF:0V ,00000:-5V)
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= DONE;
                end
            end
            
            DONE: begin
                led <= 1'b1;
            end
        endcase
    end
end

spiControl ad5791 (
.clock(clock),
.reset(reset),
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