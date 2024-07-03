`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2024 19:40:11
// Design Name: 
// Module Name: test_multi
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


module test_multi();
    reg [3:0] a, b;
    reg clk, rst;
    
    wire [7:0] o;
    wire out_ready;
    
    Multiplier m1 (a, b, o, out_ready, clk, rst);
    
    always #5 clk <= ~clk;
    
    initial begin
        clk <= 0;
        rst <= 1;
        a <= 4'd13;
        b <= 4'd10;
    
    #50;
        rst <= 0;
    end
endmodule
