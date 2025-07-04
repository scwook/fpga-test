`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/07 13:25:48
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


module OLED(
    input  clock, //100MHz onboard clock
    input  RESET_N,
    input  RESET_BTN,
    input  [31:0] data,
    
    //oled interface
    output oled_spi_clk,
    output oled_spi_data,
    output oled_vdd,
    output oled_vbat,
    output oled_reset_n,
    output oled_dc_n
    );

 localparam StringLen = 64;
 
 reg [1:0] state;
 reg [7:0] sendData;
 reg sendDataValid;
 integer byteCounter;
 wire sendDone;
 
reg [31:0] count;
reg [(8*StringLen)-1:0] count_string;

always @(*) begin
    count = data;
end

always @(posedge clock) begin
    if (!RESET_N || RESET_BTN) begin
        count_string <= 64'h3030303030303030; // Initialize with "00000000"
    end else begin
        count_string[511:448] <= " ";
        count_string[447:440] <= 8'h30 + (count / 10000000) % 10;
        count_string[439:432] <= 8'h30 + (count / 1000000) % 10;
        count_string[431:424] <= 8'h30 + (count / 100000) % 10;
        count_string[423:416] <= 8'h30 + (count / 10000) % 10;
        count_string[415:408] <= 8'h30 + (count / 1000) % 10;
        count_string[407:400] <= 8'h30 + (count / 100) % 10;
        count_string[399:392]  <= 8'h30 + (count / 10) % 10;
        count_string[391:384]   <= 8'h30 + count % 10;
        count_string[383:256]  <= " ";
        count_string[255:128]  <= " ";
        count_string[127:0] <= " ";
        
    end
end

 localparam IDLE = 'd0,
            SEND = 'd1,
            DONE = 'd2;
            
 always @(posedge clock)
 begin
    if(!RESET_N || RESET_BTN)
    begin
        state <= IDLE;
        byteCounter <= StringLen;
        sendDataValid <= 1'b0;
    end
    else
    begin
        case(state)
            IDLE:begin
                if(!sendDone)
                begin
                    sendData <= count_string[(byteCounter*8-1)-:8];
                    sendDataValid <= 1'b1;
                    state <= SEND;
                end
            end
            SEND:begin
                if(sendDone)
                begin
                    sendDataValid <= 1'b0;
                    byteCounter <= byteCounter-1;
                    if(byteCounter != 1)
                        state <= IDLE;
                    else
                        state <= DONE;
                end
            end
            DONE:begin
                state <= IDLE;
                byteCounter <= StringLen;
                sendDataValid <= 1'b0;
                
            end
        endcase
    end
 end

oledControl OC(
    .clock(clock), //100MHz onboard clock
    .reset_n(RESET_N),
    .reset_btn(RESET_BTN),
    //oled interface
    .oled_spi_clk(oled_spi_clk),
    .oled_spi_data(oled_spi_data),
    .oled_vdd(oled_vdd),
    .oled_vbat(oled_vbat),
    .oled_reset_n(oled_reset_n),
    .oled_dc_n(oled_dc_n),
    //
    .sendData(sendData),
    .sendDataValid(sendDataValid),
    .sendDone(sendDone)
        );
endmodule
