`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2024 21:14:17
// Design Name: 
// Module Name: MicroController
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


module MicroController(
    input reset,
    input clk
    );
    parameter LOAD = 2'b00, FETCH = 2'b01, DECODE = 2'b10, EXECUTE = 2'b11, STOP = 3'b100;
    reg [2:0] present, next;
    reg [11:0] program_mem [255:0];
    reg PC_clr, SR_clr, ACC_clr, DR_clr, IR_clr; 
    reg load_done;
    reg [7:0] PC, DR, ACC;
    reg [7:0] load_addr;
    reg [11:0] IR;
    reg [3:0] SR;
    
    wire [11:0] load_instr;
    wire [3:0] SR_updated;
    wire PC_E, ACC_E, SR_E, DR_E, IR_E;
    wire [7:0] PC_updated, DR_updated;
    wire [11:0] IR_updated;
    wire PMem_E, DMem_E, DMem_WE, ALU_E, PMem_LE, MUX1_Sel, MUX2_Sel;
    wire [3:0] ALU_Mode;
    wire [7:0] Adder_Out;
    wire [7:0] ALU_Out, ALU_Oper2;
    
    initial begin
        $readmemb("program_mem.mem", program_mem);
    end
    
    ALU ALU_unit (.ALU_Operand1(ACC), .ALU_Operand2(ALU_Oper2),
        .ALU_Enable(ALU_E), .ALU_Mode(ALU_Mode),
        .ALU_CFlags(SR), .ALU_Out(ALU_Out),
        .ALU_Flags(SR_updated));
        
    Mux Mux2_unit (.In0(IR[7:0]), .In1(DR), 
        .sel(MUX2_Sel), .Out(ALU_Oper2));
        
    Data_Mem DMem_unit ( .clk(clk), .Enable(DMem_E),
        .WEnable(DMem_WE), .Address(IR[3:0]),
        .In(ALU_Out), .Out(DR_updated));
    
    P_Mem PMem_unit (.clk(clk), .Enable(PMem_E),
        .Address(PC), .I_port(IR_updated), .LEnable(PMem_LE),
        .LAddress(load_addr), .LI_port(load_instr));
        
    add Adder_unit (.In(PC), .Out(Adder_Out));
    
    Mux Mux1_unit (.In0(IR[7:0]), .In1(Adder_Out),
        .sel(MUX1_Sel), .Out(PC_updated));
    
    Control_unit CU (.state(present), .IR(IR),
        .SR(SR), .PC_E(PC_E), .ACC_E(ACC_E),
        .SR_E(SR_E), .IR_E(IR_E), .DR_E(DR_E),
        .PMem_E(PMem_E), .DMem_E(DMem_E), 
        .DMem_WE(DMem_WE), .ALU_E(ALU_E),
        .MUX1_Sel(MUX1_Sel), .MUX2_Sel(MUX2_Sel),
        .PMem_LE(PMem_LE), .ALU_Mode(ALU_Mode));
           
    always @ (posedge clk) begin
        if (reset)begin
            load_addr = 0;
            load_done <= 1'b0;
        end
        else if(PMem_LE) begin
            load_addr <= load_addr + 8'd1;
            if ( program_mem[load_addr] == 12'd0)begin
                load_addr <= 1'b0;
                load_done <= 1'b1;
            end
            else
                load_done <= 1'b0;
        end
    end
    
    assign load_instr = program_mem[load_addr];
    
    always @ (posedge clk) begin
        if (reset)
            present <= LOAD;
        else
            present <= next;
    end
    
    always @ (*) begin
        PC_clr = 0;
        ACC_clr = 0;
        DR_clr = 0;
        SR_clr = 0;
        IR_clr = 0;
        
        case (present) 
            LOAD: begin
                    if (load_done)begin
                        PC_clr = 1;
                        ACC_clr = 1;
                        DR_clr = 1;
                        SR_clr = 1;
                        IR_clr = 1;
                        next = FETCH;
                    end
                    else 
                        next = LOAD;
                  end
            FETCH: next = DECODE;
            DECODE: next = EXECUTE;
            EXECUTE:begin 
                        next = FETCH;
                        if(IR == 12'd0) begin
                            next = STOP;  
                        end
                    end
        endcase
    end
        
    always @ (posedge clk) begin
        if (reset) begin
            PC <=  8'd0;
            ACC <= 8'd0;
            SR <= 4'd0;
        end
        else begin
            if (PC_E)
                PC <= PC_updated;
            else if (PC_clr)
                PC <= 8'd0;
            if (SR_E)
                SR <= SR_updated;
            else if (SR_clr)
                SR <= 4'd0;
            if (ACC_E)
                ACC <= ALU_Out;
            else if (ACC_clr)
                ACC <= 8'd0;
        end
    end
    
    always @ (posedge clk) begin
        if (DR_E)
            DR <= DR_updated;
        else if(DR_clr)
            DR <= 8'd0;
        if (IR_E)
            IR <= IR_updated;
        else if(IR_clr)
            IR <= 12'd0;        
    end
endmodule
