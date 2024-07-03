`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2024 18:26:38
// Design Name: 
// Module Name: Multiplier
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


module Multiplier(
    input [3:0] a, b,
    output [7:0] o,
    output out_ready,
    input clk, rst
    );
    reg out_ready1;
    reg [3:0] ac, q, m;
    reg c;
    reg [7:0] out;
    reg out_enable;
    reg stop;
    integer count;
    
    always @ (posedge clk) begin
        if (rst) begin
            count = 0;
            stop = 0;
            out_ready1 = 0;
            out = 0;
            out_enable = 0;
            q = b;
            ac = 0;
            c = 0;
            m = a;
        end
        else begin
            if (stop != 1) begin
                if (count != 4) begin
                    count = count + 1;
                    if(q[0] == 1) begin
                        {c, ac} = ac + m;
                        {c, ac, q} = {q[0], c, ac, q[3:1]};
                    end
                    else begin
                        {c, ac} = ac;
                        {c, ac, q} = {q[0], c, ac,  q[3:1]};
                    end
                end
                else begin
                    out_enable = 1;
                    stop = 1;
                end
            end
            else
                out_enable = 0;
        end
    end
    
    always @ (posedge clk) begin
        if(out_enable == 1)begin
            out_ready1 <= 1;
            out <= {ac, q};
        end
    end
    
    assign o = out;
    assign out_ready = out_ready1;
    
endmodule
