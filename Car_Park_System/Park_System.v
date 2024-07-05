`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2024 18:12:16
// Design Name: 
// Module Name: Park_System
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


module Park_System(
    input clk,
    input rst,
    input sensor_front,
    input sensor_back,
    input in_enable,
    input [4:0] pass_digit,
    output open_gate,
    output green,
    output red,
    output [3:0] state,
    input [15:0] password
    );
    
    parameter IDLE = 0, WAIT = 1, RIGHT = 2, WRONG = 3, STOP = 4, HOLD = 5, HOLD2 = 6;
    wire [3:0] count;
    reg enable;
    reg reset;
    
    Counter cnt1 (clk, reset || rst, enable, count);
    
    
    reg [3:0] current, next;
    reg pass_rec;
    reg pass;
    reg [15:0] password_temp;
    
    reg green1, red1, open_gate1;
    
    always @ (posedge clk) begin
        if(rst)
            current <= IDLE;
        else
            current <= next;
    end
    
    always @ (*) begin
        casez ({current, sensor_front, sensor_back, pass_rec, pass})
            {IDLE, 1'b1, 1'b0, 1'bz, 1'bz}: next = WAIT;
            {WAIT, 1'bz, 1'bz, 1'b1, 1'b1}: next = RIGHT;
            {WAIT, 1'bz, 1'bz, 1'b1, 1'b0}: next = HOLD;
            {HOLD, 1'bz, 1'bz, 1'bz, 1'bz}: next = WRONG;
            {WRONG, 1'bz, 1'bz, 1'b1, 1'b1}: next = RIGHT;
            {WRONG, 1'bz, 1'bz, 1'b1, 1'b0}: next = HOLD;
            {RIGHT, 1'bz, 1'b0, 1'bz, 1'bz}: next = RIGHT;
            {RIGHT, 1'b1, 1'b1, 1'bz, 1'bz}: next = STOP;
            {RIGHT, 1'b0, 1'b1, 1'bz, 1'bz}: next = IDLE;
            {STOP, 1'bz, 1'bz, 1'b1, 1'b1}: next = RIGHT;
            {HOLD2, 1'bz, 1'bz, 1'bz, 1'bz}: next = STOP;
            {STOP, 1'bz, 1'bz, 1'b1, 1'b0}: next = HOLD2;
            default: next = current;
        endcase
    end
    
    always @ (*) begin
        case (current)
            IDLE: {red1, green1, open_gate1, enable, reset, pass_rec, pass} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
            WAIT: {red1, green1, open_gate1, enable, reset} = {1'b0, 1'b0, 1'b0,in_enable, 1'b0};
            HOLD: {red1, green1, open_gate1, enable, reset, pass_rec, pass} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
            HOLD2: {red1, green1, open_gate1, enable, reset, pass_rec, pass} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
            WRONG: {red1, green1, open_gate1, enable, reset} = {1'b1, 1'b0, 1'b0, in_enable, 1'b0};
            RIGHT: {red1, green1, open_gate1, enable, reset, pass_rec, pass} = {1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0};
            STOP: {red1, green1, open_gate1, enable, reset} = {1'b1, 1'b0, 1'b1, in_enable, 1'b0};
        endcase    
    end
 
    always @ (posedge clk) begin
        pass_rec <= 0;
        if (current == WAIT || current == WRONG || current == STOP) begin
            if (count == 4) begin
                pass_rec <= 1;
                if (password_temp == password)
                    pass <= 1;
                else
                    pass <= 0;
            end
            else if (count == 0)
                password_temp[3:0] <= pass_digit;
            else if (count == 1)
                password_temp[7:4] <= pass_digit;
            else if (count == 2)
                password_temp[11:8] <= pass_digit;
            else if (count == 3)
                password_temp[15:12] <= pass_digit;
        end
    end
    assign state = current;
    assign red = red1;
    assign green = green1;
    assign open_gate = open_gate1; 
    
endmodule
