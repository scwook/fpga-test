`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 08:27:20 AM
// Design Name: 
// Module Name: pulse_counter
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


module pulse_counter 
(
    input wire CLOCK,
    input wire RESET_N,
    input wire RESET_BTN,
    input wire COUNT_SIG,
    input wire TRIGGER_SIG,
//    input en_trigger,
//    input wire [31:0] DWELL_CNT,
    input wire [31:0] TRIGGER_DLY,
    input wire [31:0] TRIGGER_WIDTH,
    input wire [31:0] CONFIG_REG,
    output reg [31:0] COUNT_DATA,
    output reg [2:0]  CONFIG_DATA,
    
    output wire PASS_COUNT,
    output wire PASS_TRIGGER,
    output reg PASS_GATE
);

// Input signal check
// Count and trigger logic only works when signal transition low to high
reg count_state, count_state_prev;
reg trigger_state, trigger_state_prev;
   
// Pulse count
reg [31:0]  pulse_count;
//reg         pulse_clear;

// Dwell
//reg [31:0]  dwell_clock;
//reg [31:0]  dwell_counter;
//reg         dwellDone;
   
// Trigger
reg [31:0]  trigger_count;
reg         isTrigger;
reg [2:0]   tstate;
//reg [23:0]  trigger_delay;
//reg [31:0]  trigger_width;
//reg         isEnableTrigger;

localparam  IDEL    = 'd0, 
            DELAY   = 'd1, 
            WIDTH   = 'd2;

//always @(*)
//begin
////    dwell_clock     = DWELL_CNT;
//    trigger_width   = TRIGGER_WIDTH;
//    trigger_delay   = CONFIG_REG[31:8];
//    pulse_clear     = CONFIG_REG[0];
//    isEnableTrigger = CONFIG_REG[1];

//end

// CONFIG_REG[0] = Pulse count clear
// CONFIG_REG[1] = Trigger mode enable
// CONFIG_REG[2] = Trigger Input State
// CONFIG_REG[31:3] = Reserve
assign PASS_COUNT = COUNT_SIG;
assign PASS_TRIGGER = TRIGGER_SIG;

always @(posedge CLOCK)
begin
    COUNT_DATA <= pulse_count;
    CONFIG_DATA[0] <= CONFIG_REG[0];
    CONFIG_DATA[1] <= CONFIG_REG[1];
    CONFIG_DATA[2] <= isTrigger;
end
 
always @(posedge CLOCK)
begin
    if(!RESET_N || RESET_BTN)
    begin
        count_state <= 0;
        count_state_prev <= 0;
        trigger_state <= 0;
        trigger_state_prev <= 0;
    end
    else
    begin
        count_state <= COUNT_SIG;
        count_state_prev <= count_state;
        
        trigger_state <= TRIGGER_SIG;
        trigger_state_prev <= trigger_state;
    end
end

always @(posedge CLOCK)
begin
    if(!RESET_N || RESET_BTN || CONFIG_REG[0]) begin
        pulse_count <= 32'b0;
    end 
    else if(CONFIG_REG[1]) begin
        if(count_state && !count_state_prev && isTrigger) begin
            pulse_count <= pulse_count + 1;
        end
        else begin
            pulse_count <= pulse_count;
        end
    end
    else begin
        if(count_state && !count_state_prev) begin
            pulse_count <= pulse_count + 1;
        end
        else begin
            pulse_count <= pulse_count;
        end
    end
end

// Dwell count logic
//always @(posedge CLOCK)
//begin
//    if(!RESET_N || RESET_BTN) begin
//        dwell_counter <= 0;
//        dwellDone <= 1'b1;
//    end
//    else if(dwell_counter != dwell_clock)
//    begin
//        dwell_counter <= dwell_counter + 1;
//        dwellDone <= 1'b0;
//    end
//    else begin
//        dwell_counter <= 0;
//        dwellDone <= 1'b1;
//    end
//end

// Trigger delay and width count logic
always @(posedge CLOCK)
begin
    if(!RESET_N || RESET_BTN)
    begin
        trigger_count <= 32'b0;
        isTrigger <= 1'b0;
        tstate <= IDEL;
    end
    else
    begin
        case(tstate)
            IDEL:begin
                if(trigger_state && !trigger_state_prev) begin
                    tstate <= DELAY;
                end
            end
            DELAY:begin
                if(trigger_count != TRIGGER_DLY) begin
                    trigger_count <= trigger_count + 1;
                end
                else begin
                    isTrigger <= 1'b1;
                    PASS_GATE <= 1'b1;
                    tstate <= WIDTH;
                end
            end
            WIDTH:begin
                if(trigger_count != TRIGGER_WIDTH) begin
                    trigger_count <= trigger_count + 1;
                end
                else begin 
                    trigger_count <= 0;
                    isTrigger <= 1'b0;
                    PASS_GATE <= 1'b0;
                    tstate <= IDEL;
                end
            end
        endcase
    end
end

endmodule