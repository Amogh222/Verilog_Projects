`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2024 18:06:54
// Design Name: 
// Module Name: Control_unit
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


module Control_unit(
    input [2:0] state,
    input [11:0] IR,
    input [3:0] SR,
    output reg PC_E, ACC_E, SR_E, IR_E, DR_E, PMem_E, DMem_E, DMem_WE, ALU_E, MUX1_Sel, MUX2_Sel, PMem_LE,
    output reg [3:0] ALU_Mode
    );
    parameter LOAD = 2'b00, FETCH = 2'b01, DECODE = 2'b10, EXECUTE = 2'b11, STOP = 3'b100;
    
    always @ (*) begin
        PMem_LE = 0;
        PC_E = 0;
        ACC_E = 0;
        SR_E = 0;
        IR_E = 0;
        DR_E = 0;
        PMem_E = 0;
        DMem_E = 0;
        DMem_WE = 0;
        ALU_E = 0;
        ALU_Mode = 0;
        MUX1_Sel = 0;
        MUX2_Sel = 0;
        
        if (state == LOAD) begin
            PMem_LE = 1;
            PMem_E = 1;
        end
        else if (state == FETCH) begin
            PMem_E = 1;
            IR_E = 1;
        end
        else if (state == DECODE) begin
            if( IR[11:9] === 4'b001) begin
                DMem_E = 1;
                DR_E = 1;
            end
        end
        else if (state == EXECUTE)begin
            if (IR[11:8] == 4'b0000) begin
                PC_E = 1;
                MUX1_Sel = 1;
            end
            else if (IR[11:8] == 4'b0001) begin
                PC_E = 1;
            end
            else if (IR[11:9] == 3'b001) begin
                PC_E = 1;
                ACC_E = IR[8];
                SR_E = 1;
                DMem_E = !IR[8];
                DMem_WE = !IR[8];
                ALU_E = 1;
                ALU_Mode = IR[7:4];
                MUX1_Sel = 1;
                MUX2_Sel = 1;
            end
            else if (IR[11:10] == 2'b01) begin
                PC_E = 1;
                MUX1_Sel = !SR[3 - IR[9:8]];
            end
            else if (IR[11] == 1'b1) begin
                PC_E = 1;
                ACC_E = 1;
                SR_E = 1;
                ALU_E = 1;
                ALU_Mode = IR[10:8];
                MUX1_Sel = 1;
            end
        end
    end
    
endmodule
