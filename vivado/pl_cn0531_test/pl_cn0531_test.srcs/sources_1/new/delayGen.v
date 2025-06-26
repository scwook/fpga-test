`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 03:08:23 PM
// Design Name: 
// Module Name: delayGen
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


module delayGen(
    input clock,
    input delayEn,
    output reg delayDone
    );
    
reg [24:0] counter;

always @(posedge clock)
begin
    if(delayEn & counter != 10000000)
        counter <= counter + 1;
    else
        counter <= 0;
end

always @(posedge clock)
begin
    if(delayEn & counter == 10000000)
        delayDone <= 1'b1;
    else
        delayDone <= 1'b0;
end
endmodule

