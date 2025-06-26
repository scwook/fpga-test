`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2025 02:53:05 PM
// Design Name: 
// Module Name: ad5791_controller
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

module ad5791_controller (
    input        clk,
    input        init,
    input        rst_n,     
    output       SCLK,
    output       SDO,
    output       SYNC_N,
    output reg   LDAC_N,
    output reg   RESET_N,
    output reg   CLR_N
);

    reg        spi_start;
    reg [23:0] spi_data;
    wire       spi_busy;

    ad5791_spi_master spi (
        .clk(clk),
        .start(spi_start),
        .tx_data(spi_data),
        .busy(spi_busy),
        .SCLK(SCLK),
        .MOSI(SDO),
        .CS_N(SYNC_N)
    );

    
    localparam  IDLE        = 'd0,
                WRITE_CTRL  = 'd1,
                WAIT1       = 'd2,
                WRITE_DAC   = 'd3,
                WAIT2       = 'd4,
                LDAC_PULSE  = 'd5,
                DONE        = 'd6;
            

    reg [4:0] state;
    reg [7:0] ldac_cnt;


    always @(posedge clk) begin
        if (rst_n) begin
            state      <= IDLE;
            spi_start  <= 0;
            LDAC_N     <= 0;
            ldac_cnt   <= 0;
            RESET_N    <= 0;
            CLR_N      <= 0;
            
        end else begin
            case (state)
                IDLE: begin
                    spi_start <= 0;
                    RESET_N   <= 1;
                    CLR_N     <= 1;
                    if (init) begin
                        spi_data  <= 24'b001000000000000000010010; // Control reg 설정
                        spi_start <= 1;
                        state     <= WRITE_CTRL;
                    end
                end

                WRITE_CTRL: begin
                    spi_start <= 0;
                    if (!spi_busy)
                        state <= WAIT1;
                end

                WAIT1: begin
                    if (!spi_busy) begin
                        spi_data  <= 24'b000111111111111111111111; // DAC midscale
                        spi_start <= 1;
                        state     <= WRITE_DAC;
                    end
                end

                WRITE_DAC: begin
                    spi_start <= 0;
                    if (!spi_busy)
                        state <= WAIT2;
                end

                WAIT2: begin
                    if (!spi_busy) begin
                        LDAC_N   <= 0;
                        ldac_cnt <= 0;
                        state    <= LDAC_PULSE;
                    end
                end

                LDAC_PULSE: begin
                    ldac_cnt <= ldac_cnt + 1;
                    if (ldac_cnt > 10) begin // 최소 몇 클럭 정도 LOW 유지
                        LDAC_N <= 1;
                        state  <= DONE;
                    end
                end

                DONE: begin
                    // 동작 완료 후 IDLE 복귀
                    if (!init)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule

    


//    reg start_cmd;
//    reg [23:0] cmd;
//    wire busy;

//    ad5791_spi_master spi (
//        .clk(clk), .start(start_cmd), .tx_data(cmd),
//        .busy(busy), .SCLK(SCLK), .MOSI(MOSI), .CS_N(CS_N)
//    );

//    localparam INIT_CMD  = 24'b001000000000000000010010;  // 제어 레지스터 초기화
//    localparam MID_CMD   = 24'b000110000000000000000000;  // mid-scale DAC

//    reg [1:0] state;
//    always @(posedge clk) begin
//        case (state)
//            0: if (init) begin
//                    cmd <= INIT_CMD;
//                    start_cmd <= 1;
//                    state <= 1;
//               end
//            1: if (busy == 0) begin
//                    start_cmd <= 0;
//                    cmd <= MID_CMD;
//                    start_cmd <= 1;
//                    state <= 2;
//               end
//            2: if (busy == 0) begin
//                    start_cmd <= 0;
//                    LDAC_N <= 0;
//                    state <= 3;
//               end
//            3: begin
//                   LDAC_N <= 1;
//                   state <= 0;
//               end
//        endcase
//    end
