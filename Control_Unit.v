module Control_Unit(opcode , Branch , ImmSrc , ResultSrc , ALUOp , MemWrite , ALUSrc , RegWrite);
input [6:0] opcode;
output reg Branch , ResultSrc , MemWrite , ALUSrc , RegWrite;
output reg [1:0] ImmSrc , ALUOp;
always @(*) begin 
case (opcode)
7'b0110011 : {ALUSrc , ResultSrc , ImmSrc , RegWrite , MemWrite , Branch , ALUOp} = 9'b0_0_xx_1_0_0_10;
7'b0000011 : {ALUSrc , ResultSrc , ImmSrc , RegWrite , MemWrite , Branch , ALUOp} = 9'b1_1_00_1_0_0_00;
7'b0100011 : {ALUSrc , ResultSrc , ImmSrc , RegWrite , MemWrite , Branch , ALUOp} = 9'b1_x_01_0_1_0_00;
7'b1100011 : {ALUSrc , ResultSrc , ImmSrc , RegWrite , MemWrite , Branch , ALUOp} = 9'b0_x_10_0_0_1_01;
7'b0010011 : {ALUSrc , ResultSrc , ImmSrc , RegWrite , MemWrite , Branch , ALUOp} = 9'b1_0_00_1_0_0_10;
default    : {ALUSrc , ResultSrc , ImmSrc , RegWrite , MemWrite , Branch , ALUOp} = 9'bx_x_xx_X_x_X_xx;
endcase
end
endmodule
