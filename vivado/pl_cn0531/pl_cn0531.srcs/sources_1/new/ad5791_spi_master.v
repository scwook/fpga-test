`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2025 02:50:10 PM
// Design Name: 
// Module Name: ad5791_spi_master
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


module ad5791_spi_master (
    input        clk,
    input        start,
    input  [23:0] tx_data,
    output reg   busy,
    output       SCLK,
    output reg   MOSI,
    output reg   CS_N
);
    wire spi_clk;
    reg enable;
    reg [4:0] bitcnt;
    reg [23:0] shift;

    spi_clk_div clk_div (.clk(clk), .enable(enable), .spi_clk(spi_clk));
    assign SCLK = spi_clk;

    always @(posedge clk) begin
        if (start && !busy) begin
            busy    <= 1;
            CS_N    <= 0;
            enable  <= 1;
            shift   <= tx_data;
            bitcnt  <= 0;
        end else if (busy && spi_clk) begin
            MOSI <= shift[23];
        end else if (busy && !spi_clk) begin
            shift  <= shift << 1;
            bitcnt <= bitcnt + 1;
            if (bitcnt == 23) begin
                busy   <= 0;
                CS_N   <= 1;
                enable <= 0;
            end
        end
    end
endmodule
