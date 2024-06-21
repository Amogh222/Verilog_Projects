`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2024 16:56:05
// Design Name: 
// Module Name: P_Mem
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


module P_Mem(
    input clk,
    input Enable,
    input [7:0] Address,
    output [11:0] I_port,
    input LEnable,
    input [7:0] LAddress,
    input [11:0] LI_port
    );
    
    reg [11:0] P_Mem [255:0];
    
    always @(posedge clk) begin
        if(LEnable == 1) begin
            P_Mem[LAddress] <= LI_port;
        end
    end
    assign I_port =  (Enable) ?  P_Mem[Address]: 0 ;

endmodule
