`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 14:40:05
// Design Name: 
// Module Name: oledControl
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


module oledControl(
input clock,
input reset_n,
input reset_btn,
output wire oled_spi_clk,
output wire oled_spi_data,
output reg oled_vdd,
output reg oled_vbat,
output reg oled_reset_n,
output reg oled_dc_n,

input [6:0] sendData,
input       sendDataValid,
output reg  sendDone
    );

reg [4:0] state;
reg startDelay;
reg [4:0] nextState;
reg [7:0] spiData;
reg spiLoadData;
wire delayDone;
wire spiDone;
reg [1:0] currPage;
wire [63:0] charBitMap;
reg [7:0] columnAddr;
reg [3:0] byteCounter;

localparam  IDEL = 'd0,
            DELAY = 'd1,
            INIT = 'd2,
            RESET = 'd3,
            CHARG_PUMP = 'd4,
            CHARG_PUMP1 = 'd5,
            WAIT_SPI = 'd6,
            PRE_CHARG = 'd7,
            PRE_CHARG1 = 'd8,
            VBAT_ON = 'd9,
            CONTRAST = 'd10,
            CONTRAST1 = 'd11,
            SEG_REMAP = 'd12,
            SCAN_DIR = 'd13,
            COM_PIN = 'd14,
            COM_PIN1 = 'd15,
            DISPLAY_ON = 'd16,
            FULL_DISPLAY = 'd17,
            DONE = 'd18,
            PAGE_ADDR = 'd19,
            PAGE_ADDR1 = 'd20,
            PAGE_ADDR2 = 'd21,
            COLUMN_ADDR = 'd22,
            SEND_DATA = 'd23;
           
            
            
always @(posedge clock)
begin
    if(!reset_n || reset_btn)
    begin
        state <= IDEL;
        nextState <= IDEL;
        oled_vdd <= 1'b1;
        oled_vbat <= 1'b1;
        oled_reset_n <= 1'b1;
        oled_dc_n <= 1'b1;
        startDelay <= 1'b0;
        spiData <= 8'd0;
        spiLoadData <= 1'b0;
        currPage <= 0;
        sendDone <= 0;
        columnAddr <= 0;
    end
    else
    begin
        case(state)
            IDEL:begin
                oled_vbat <= 1'b1;
                oled_reset_n <= 1'b1;
                oled_dc_n <= 1'b0;
                oled_vdd <= 1'b0;
                state <= DELAY;
                nextState <= INIT;
            end
            DELAY:begin
                startDelay <= 1'b1;
                if(delayDone)
                begin
                    state <= nextState;
                    startDelay <= 1'b0;
                end
            end
            INIT:begin
                spiData <= 'hAE;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    oled_reset_n <= 1'b0;
                    state <= DELAY;
                    nextState <= RESET;
                end
            end
            RESET:begin
                oled_reset_n <= 1'b1;
                state <= DELAY;
                nextState <= CHARG_PUMP;
            end
            CHARG_PUMP:begin
                spiData <= 'h8D;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= CHARG_PUMP1;
                end
            end
            WAIT_SPI:begin
                if(!spiDone)
                begin
                    state <= nextState;
                end
            end
            CHARG_PUMP1:begin
                spiData <= 'h14;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PRE_CHARG1;
                end
            end
            PRE_CHARG:begin
                spiData <= 'hD9;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PRE_CHARG1;
                end
            end
            PRE_CHARG1:begin
                spiData <= 'hF1;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= VBAT_ON;
                end
            end
            VBAT_ON:begin
                oled_vbat <= 1'b0;
                state <= DELAY;
                nextState <= CONTRAST;
            end
            CONTRAST:begin
                spiData <= 'h81;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= CONTRAST1;
                end
            end
            CONTRAST1:begin
                spiData <= 'hFF;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= SEG_REMAP;
                end
            end
            SEG_REMAP:begin
                spiData <= 'hA0;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= SCAN_DIR;
                end
            end
            SCAN_DIR:begin
                spiData <= 'hC0;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= COM_PIN;
                end
            end
            COM_PIN:begin
                spiData <= 'hDA;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= COM_PIN1;
                end
            end
            COM_PIN1:begin
                spiData <= 'h00;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= DISPLAY_ON;
                end
            end
            DISPLAY_ON:begin
                spiData <= 'hAF;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PAGE_ADDR;
                end
            end
            PAGE_ADDR:begin
                spiData <= 'h22;
                spiLoadData <= 1'b1;
                oled_dc_n <= 1'b0;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PAGE_ADDR1;
                end
            end
            PAGE_ADDR1:begin
                spiData <= currPage;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    currPage <= currPage + 1;
                    nextState <= PAGE_ADDR2;
                end
            end
            PAGE_ADDR2:begin
                spiData <= currPage;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= COLUMN_ADDR;
                end
            end
            COLUMN_ADDR:begin
                spiData <= 'h10;
                spiLoadData <= 1'b1;
                if(spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= DONE;
                end
            end
//            FULL_DISPLAY:begin
//                spiData <= 'hA5;
//                spiLoadData <= 1'b1;
//                if(spiDone)
//                begin
//                    spiLoadData <= 1'b0;
//                    state <= WAIT_SPI;
//                    nextState <= DONE;
//                end
//            end
            DONE:begin
                sendDone <= 1'b0;
                if(sendDataValid & columnAddr != 128 & !sendDone)
                begin
                    state <= SEND_DATA;
                    byteCounter <= 8;
                end
                else if(sendDataValid & columnAddr == 128 & !sendDone)
                begin
                    state <= PAGE_ADDR;
                    columnAddr <= 0;
                    byteCounter <= 8;
                end
            end
            SEND_DATA:begin
                spiData <= charBitMap[(byteCounter*8-1)-:8];
                spiLoadData <= 1'b1;
                oled_dc_n <= 1'b1;
                if(spiDone)
                begin
                    columnAddr <= columnAddr + 1;
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    if(byteCounter != 1)
                    begin
                        byteCounter <= byteCounter -1;
                        nextState <= SEND_DATA;
                    end
                end
                else
                begin
                    nextState <= DONE;
                    sendDone <= 1'b1;
                end
            end
        endcase
    end
end

delayGen DG(
    .clock(clock),
    .delayEn(startDelay),
    .delayDone(delayDone)
    );

spiControl SC(
.clock(clock),
.reset_n(reset_n),
.data_in(spiData),
.load_data(spiLoadData),
.done_send(spiDone),
.spi_clock(oled_spi_clk),
.spi_data(oled_spi_data)
    );
    
charROM CR (
    .addr(sendData),
    .data(charBitMap)
    );
endmodule
