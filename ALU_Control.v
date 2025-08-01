module ALU_Control(ALUOp , Funct3 , Funct7 , op , Operation);
input [1:0] ALUOp;
input [2:0] Funct3;
input Funct7 , op;
output reg [2:0] Operation;

always @(*) begin
case(ALUOp)
2'b00: Operation = 3'b000;  // add for load/store
2'b01: Operation = 3'b001;  // sub for branch
2'b10: begin               // R-type/I-type
case(Funct3)
3'b000: Operation = (op && Funct7) ? 3'b001 : 3'b000; // sub if R-type and Funct7=1, add otherwise
 3'b010: Operation = 3'b101; // slt
                3'b110: Operation = 3'b011; // or
                3'b111: Operation = 3'b010; // and
                default: Operation = 3'b000;
            endcase
        end
        default: Operation = 3'b000;
    endcase
end
endmodule
