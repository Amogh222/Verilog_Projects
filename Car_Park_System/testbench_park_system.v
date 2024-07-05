`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2024 10:39:59
// Design Name: 
// Module Name: testbench_park_system
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


module testbench_park_system();
    reg clk, rst, sensor_front, sensor_back, in_enable;
    reg [3:0] pass_digit;
    wire open_gate, green, red;
    wire [3:0] state;
    reg [15:0] password;
     
    Park_System ps (clk, rst, sensor_front, sensor_back, in_enable, pass_digit, open_gate, green, red, state, password);
    
    always #5 clk = ~clk;
    
    initial begin
        clk <= 0;
        rst <= 1;
        sensor_front <= 0;
        sensor_back <= 0;
        in_enable <= 0;
        password <= 16'h1234;
        
        #50;
        rst <= 0;
        
        #50;
        sensor_front <= 1;
        
        #50;
        sensor_front = 0;
        pass_digit = 4'h4;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h3;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h2;
        in_enable = 1;
        
        #10 in_enable = 0;

        #100;
        pass_digit = 4'h0;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #50;
        sensor_front = 0;
        pass_digit = 4'h4;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h3;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h2;
        in_enable = 1;
        
        #10 in_enable = 0;

        #100;
        pass_digit = 4'h0;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #50;
        pass_digit = 4'h4;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h3;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h2;
        in_enable = 1;
        
        #10 in_enable = 0;

        #100;
        pass_digit = 4'h1;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #50; 
        sensor_back = 1;
        sensor_front = 1;
        
        #50;
        sensor_front = 0;
        pass_digit = 4'h4;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h3;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h2;
        in_enable = 1;
        
        #10 in_enable = 0;

        #100;
        pass_digit = 4'h0;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #50;
        sensor_back = 0;
        sensor_front = 0;
        pass_digit = 4'h4;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h3;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #100;
        pass_digit = 4'h2;
        in_enable = 1;
        
        #10 in_enable = 0;

        #100;
        pass_digit = 4'h1;
        in_enable = 1;
        
        #10 in_enable = 0;
        
        #50 sensor_back = 1;

                
        
    end

endmodule
