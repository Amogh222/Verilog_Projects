`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2024 16:47:11
// Design Name: 
// Module Name: Digital_Clock
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


module Digital_Clock(
    input clk,
    input reset,
    input ena,
    input [7:0] hh_in,
    input [7:0] mm_in,
    input [7:0] ss_in,
    input load,
    input put_alarm,
    input stop_alarm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss,
    output reg alarm
    );
    
    parameter Alarm_Ring = 2, Alarm_ON = 1, Alarm_OFF = 0;
    reg [7:0] hh_al, mm_al, ss_al;
    reg [1:0] present, next;
   
    Counter_BCD ss1 (clk,ena,reset,ss_in[3:0],4'b0000,load,ss[3:0]);
    Counter_BCD ss2 (clk,ss[3]&&ss[0]&&ena,reset||(ss[6]&&ss[4]&&ss[3]&&ss[0]),ss_in[7:4],4'b0000,load,ss[7:4]);
    Counter_BCD mm1 (clk,ss[6]&&ss[4]&&ss[3]&&ss[0]&&ena,reset,mm_in[3:0],4'b0000,load,mm[3:0]);
    Counter_BCD mm2 (clk,mm[3]&&mm[0]&&ss[6]&&ss[4]&&ss[3]&&ss[0]&&ena,reset||(mm[6]&&mm[4]&&mm[3]&&mm[0]&&ss[6]&&ss[4]&&ss[3]&&ss[0]),mm_in[7:4],4'b0000,load,mm[7:4]);
    Counter_BCD hh1 (clk,mm[6]&&mm[4]&&mm[3]&&mm[0]&&ss[6]&&ss[4]&&ss[3]&&ss[0]&&ena,reset||(hh[5]&&hh[1]&&hh[0]&&mm[6]&&mm[4]&&mm[3]&&mm[0]&&ss[6]&&ss[4]&&ss[3]&&ss[0]),hh_in[3:0],4'b0000,load,hh[3:0]);
    Counter_BCD hh2 (clk,hh[3]&&hh[0]&&mm[6]&&mm[4]&&mm[3]&&mm[0]&&ss[6]&&ss[4]&&ss[3]&&ss[0]&&ena,reset||(hh[5]&&hh[1]&&hh[0]&&mm[6]&&mm[4]&&mm[3]&&mm[0]&&ss[6]&&ss[4]&&ss[3]&&ss[0]),hh_in[7:4],4'b0000,load,hh[7:4]);
    
    always @ (*) begin
        casez({present,put_alarm&&!load,stop_alarm})
            {Alarm_OFF, 1'b0, 1'bz}: next = Alarm_OFF;
            {Alarm_OFF, 1'b1, 1'bz}: next = Alarm_ON;
            {Alarm_ON, 1'bz, 1'b0}: next = Alarm_ON;
            {Alarm_ON, 1'bz, 1'b1}: next = Alarm_OFF;
            {Alarm_Ring, 1'bz, 1'b0}: next = Alarm_Ring;
            {Alarm_Ring, 1'bz, 1'b1}: next = Alarm_OFF;
        endcase
    end
    
    always @ (posedge clk) begin
        if (reset)
            present <= Alarm_OFF;
        else begin
            present <= next;
            if (present == Alarm_OFF && put_alarm&&!load == 1)
                {hh_al,mm_al,ss_al} <= {hh_in,mm_in,ss_in};
            if (present == Alarm_ON) begin
                if ({hh,mm,ss}=={hh_al,mm_al,ss_al})
                    present <= Alarm_Ring;
            end
        end
    end    
    always @ (*) begin
        case (present)
            Alarm_OFF: alarm = 0;
            Alarm_ON: alarm = 0;
            Alarm_Ring: alarm = 1;
        endcase
    end
            
endmodule
