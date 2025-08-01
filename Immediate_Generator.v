module imm_data_gen(instruction , ImmSrc , imm_data);
input [31:0] instruction;
input [1:0] ImmSrc;
output reg [31:0] imm_data;
always @(*) begin
    case(ImmSrc)
        2'b00: imm_data = {{20{instruction[31]}}, instruction[31:20]};
        2'b01: imm_data = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        2'b10: imm_data = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        default: imm_data = 32'b0; 
    endcase
end
endmodule
