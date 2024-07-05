`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2024 23:54:05
// Design Name: 
// Module Name: Counter
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


module Counter(
    input clk,
    input rst,
    input enable,
    output [3:0] out
    );
    reg [3:0] count;
    always @ (posedge clk) begin
        if (rst)
            count <= 0;
        else begin
            if (enable)
                count <= count + 1;
            else
                count <= count;
        end
    end
    assign out = count;
endmodule
