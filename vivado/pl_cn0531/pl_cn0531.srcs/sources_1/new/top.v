`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2025 02:39:36 PM
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

module top (
    input  clk_100mhz,
    input  btn0,
    input  btn1,
    output SCLK,
    output SDO,
    output SYNC_N,
    output LDAC_N,
    output RESET_N,
    output CLR_N
);
    ad5791_controller ctrl (
        .clk(clk_100mhz),
        .init(btn0),
        .rst_n(btn1),
        .SCLK(SCLK),
        .SDO(SDO),
        .SYNC_N(SYNC_N),
        .LDAC_N(LDAC_N),
        .RESET_N(RESET_N),
        .CLR_N(CLR_N)
    );
endmodule
