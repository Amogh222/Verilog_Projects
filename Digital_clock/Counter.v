`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2024 16:32:45
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


module Counter_BCD(input clk,enable,reset,input [3:0] d_load,input [3:0] d_reset, input load,output reg [3:0] q);
    always @ (posedge clk) begin
        if (reset)
            q<=d_reset;
        else begin
            if (load==1)
            	q <= d_load;
            else begin
                if (enable == 1) begin
            		q <= q + 1;
                	if(q == 9)
                    	q<=0;
                end
            end
        end 
    end
endmodule
