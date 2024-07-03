`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2024 21:56:36
// Design Name: 
// Module Name: testbench1
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


module testbench1;
    reg clk;
    reg reset;
    reg ena;
    reg [7:0] hh_in;
    reg [7:0] mm_in;
    reg [7:0] ss_in;
    reg load;
    reg put_alarm;
    reg stop_alarm;
    wire alarm;
    wire [7:0] ss;
    wire [7:0] mm;
    wire [7:0] hh;
    
    Digital_Clock dc1(clk, reset, ena, hh_in, mm_in, ss_in, load, put_alarm, stop_alarm, hh, mm, ss, alarm);
    
    always #5 clk = ~clk;
    
    initial begin
        clk <= 0;
        reset <= 1;
        ena <= 0;
        load <= 0;
        put_alarm <= 0;
        stop_alarm <=0;
        
        {hh_in,mm_in,ss_in} <= {8'h00,8'h02,8'h40};
        
        
        #20 reset <= 0;
        #20 ena <= 1;
        
        #1000 load = 1'b1;
        #100 load = 1'b0;
        
        #100 reset = 1;
        #100 reset = 0;
        
        #1000 put_alarm = 1;
        #10 put_alarm = 0;
        
        #1000 stop_alarm = 1;
        #10 stop_alarm = 0;
        
        
        
        
        #1000000 $finish;
        
    end

endmodule
