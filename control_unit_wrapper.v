module CU(Zero , opcode , Funct3 , Funct7 , PCSrc , ResultSrc , MemWrite , ALUSrc , ImmSrc , RegWrite , Operation);
input Zero;
input [6:0] opcode ,Funct7;
input [2:0] Funct3;
output  PCSrc , ResultSrc , MemWrite , ALUSrc , RegWrite;
output  [1:0] ImmSrc;
output  [2:0] Operation;
wire Branch;
wire [1:0] ALUOp;
Control_Unit c(opcode , Branch , ImmSrc , ResultSrc , ALUOp , MemWrite , ALUSrc , RegWrite);
ALU_Control  a(ALUOp , Funct3 , Funct7[5] , opcode[5] , Operation);
assign PCSrc = Zero & Branch;
endmodule
