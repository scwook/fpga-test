`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 09:10:49 AM
// Design Name: 
// Module Name: clk_led
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2026 09:11:58 AM
// Design Name: 
// Module Name: clock_led
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


module clk_led (
    // Clock Wizard에서 생성된 100MHz 클럭 입력
    input  wire clk_in,
    // 보드 리셋 신호 (없다면 1'b0으로 처리 가능)
    input  wire reset_n,
    // 보드 LED 출력 (4비트 기준)
    output wire [3:0] led
);

    // 100MHz 기준 약 0.5초마다 반전시키기 위한 카운터
    // 100,000,000 / 2 = 50,000,000 (약 2^26승 정도의 카운터 필요)
    reg [27:0] counter = 28'd0;

    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 28'd0;
        end else begin
            counter <= counter + 1;
        end
    end

    // 카운터의 상위 비트를 LED에 연결하여 눈으로 확인
    assign led[0] = counter[25]; // 약 0.16초 주기
    assign led[1] = counter[26]; // 약 0.33초 주기
    assign led[2] = counter[27]; // 약 0.67초 주기
    assign led[3] = reset_n;      // 리셋 상태 확인용 (리셋 안 눌렸을 때 켜짐)

endmodule

