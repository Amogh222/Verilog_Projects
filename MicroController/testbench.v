`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2024 17:27:59
// Design Name: 
// Module Name: testbench
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


module testbench;

    reg clk;
    reg reset;
    // Instantiate the Unit Under Test (UUT)
    MicroController uut (
    .clk(clk), 
    .reset(reset)
    );
    initial begin
    // Initialize Inputs
    reset = 1;
    // Wait 100 ns for global reset to finish
    #100;
    reset = 0;
    end
    initial begin 
    clk = 0;
    forever #10 clk = ~clk;
    #10000 $finish;
    end 
    
    
endmodule
