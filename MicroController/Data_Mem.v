`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2024 15:48:55
// Design Name: 
// Module Name: Data_Mem
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


module Data_Mem(
    input clk,
    input Enable,
    input WEnable,
    input [3:0] Address,
    input [7:0] In,
    output [7:0] Out
    );
    reg [7:0] data_mem [255:0];
    always @(posedge clk) begin
        if(Enable==1 && WEnable ==1) 
            data_mem[Address] <= In;
    end 
    assign Out = (Enable)? data_mem[Address]:0;
endmodule