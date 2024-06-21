`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2024 12:34:48
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [7:0] ALU_Operand1,
    input [7:0] ALU_Operand2,
    input ALU_Enable,
    input [3:0] ALU_Mode,
    input [3:0] ALU_CFlags,
    output [7:0] ALU_Out,
    output [3:0] ALU_Flags // Z, C, S, O
    );
    
    reg Carry, Overflow, Zero, Sign;
    reg [7:0] Out;
    
    always @ (*) begin
        case (ALU_Mode)
            4'h0: begin
                    {Carry, Out} = ALU_Operand1 + ALU_Operand2;
                    Zero = (Out==0) ? 1'b1:1'b0;
                    Sign = Out[7];
                    Overflow =  (ALU_Operand1[7] && ALU_Operand2[7] && !Out[7]) || (!ALU_Operand1[7] && !ALU_Operand2[7] && Out[7]);                 
                  end
            4'h1: begin
                      Out = ALU_Operand1 - ALU_Operand2;
                      Zero = (Out==0) ? 1'b1:1'b0;
                      Sign = Out[7];
                      Carry = !Out[7];
                      Overflow =  (ALU_Operand1[7] && ALU_Operand2[7] && !Out[7]) || (!ALU_Operand1[7] && !ALU_Operand2[7] && Out[7]); 
                  end
            4'h2: Out = ALU_Operand1;
            4'h3: Out = ALU_Operand2;
            4'h4: begin
                  Out = ALU_Operand1 & ALU_Operand2;
                  Zero = (Out==0) ? 1'b1:1'b0;
                  end                 
            4'h5: begin
                  Out = ALU_Operand1 | ALU_Operand2;
                  Zero = (Out==0) ? 1'b1:1'b0;
                  end
            4'h6: begin
                  Out = ALU_Operand1 ^ ALU_Operand2;
                  Zero = (Out==0) ? 1'b1:1'b0;
                  end
            4'h7: begin
                    Out = ALU_Operand2 - ALU_Operand1;
                    Carry = !Out[7];
                    Zero = (Out==0) ? 1'b1:1'b0;
                    Sign = Out[7];
                    Overflow =  (ALU_Operand1[7] && ALU_Operand2[7] && !Out[7]) || (!ALU_Operand1[7] && !ALU_Operand2[7] && Out[7]); 
                  end
            4'h8: begin
                  {Carry, Out} = ALU_Operand2 + 1;
                  Overflow =  (ALU_Operand1[7] && ALU_Operand2[7] && !Out[7]) || (!ALU_Operand1[7] && !ALU_Operand2[7] && Out[7]); 
                  Zero = (Out==0) ? 1'b1:1'b0;
                  Sign = Out[7];
                  end
            4'h9: begin
                    Out = ALU_Operand2 - 1;
                    Zero = (Out==0) ? 1'b1:1'b0;
                    Sign = Out[7];
                    Carry = !Out[7];
                    Overflow =  (ALU_Operand1[7] && ALU_Operand2[7] && !Out[7]) || (!ALU_Operand1[7] && !ALU_Operand2[7] && Out[7]); 
                  end
            4'hA: Out = (ALU_Operand2 << ALU_Operand1[2:0]) | (ALU_Operand2 >> (8 - ALU_Operand1[2:0]));
            4'hB: Out = (ALU_Operand2 >> ALU_Operand1[2:0]) | (ALU_Operand2 << (8 - ALU_Operand1[2:0]));
            4'hC: begin
                  {Carry, Out}= {ALU_Operand2[8-ALU_Operand1[2:0]], ALU_Operand2 << ALU_Operand1[2:0]};
                  Zero = (Out==0) ? 1'b1:1'b0;
                  end
            4'hD: begin
                  {Carry, Out}= {ALU_Operand2[ALU_Operand1[2:0]-1], ALU_Operand2 >> ALU_Operand1[2:0]};
                  Zero = (Out==0) ? 1'b1:1'b0;
                  end
            4'hE: begin
                  {Carry, Out}= {ALU_Operand2[8-ALU_Operand1[2:0]], ALU_Operand2 <<< ALU_Operand1[2:0]};
                  Zero = (Out==0) ? 1'b1:1'b0;
                  Sign = Out[7];
                  end
            4'hF: begin
                    Out = 8'h00 - ALU_Operand2;
                    Carry = !Out[7];
                    Zero = (Out==0) ? 1'b1:1'b0;
                    Sign = Out[7];
                    Overflow =  (ALU_Operand1[7] && ALU_Operand2[7] && !Out[7]) || (!ALU_Operand1[7] && !ALU_Operand2[7] && Out[7]); 
                  end
            default: Out = ALU_Operand2;
        endcase
    end
    assign ALU_Flags = (ALU_Enable)?{ Zero, Carry, Sign, Overflow}:0;
    assign ALU_Out = (ALU_Enable)? Out:0;
endmodule
