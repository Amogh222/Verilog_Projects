`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2024 21:02:34
// Design Name: 
// Module Name: T_ff
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


module T_ff (input clk, reset, t, output reg q);
    always @ (posedge clk) begin
        if (reset)
            q <= 0;
        else begin
            if (t)
                q <= ~q;
            else
                q <= q;
        end
    end
endmodule
