`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2025 02:47:54 PM
// Design Name: 
// Module Name: spi_clk_div
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

module spi_clk_div (
    input  wire clk,     // 100 MHz
    input  wire enable,  // 전송 활성 시 동작
    output reg  spi_clk  // 10 MHz SCLK
);
    reg [2:0] cnt;
    always @(posedge clk) begin
        if (!enable) begin
            cnt <= 0; spi_clk <= 0;
        end else if (cnt == 4) begin
            cnt <= 0; spi_clk <= ~spi_clk;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule
