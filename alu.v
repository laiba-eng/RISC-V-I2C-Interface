module alu(a, b, op, res, zero);
input [31:0] a, b; 
input [2:0] op;
output reg zero;
output reg [31:0] res;

always @(*) begin
    case(op)
        3'b000: res = a + b;    // ADD
        3'b001: res = a - b;    // SUB
        3'b101: res = a < b;    // SLT
        3'b011: res = a | b;    // OR
        3'b010: res = a & b;    // AND
        default: res = 32'b0;
    endcase
    
    zero = (res == 32'b0) ? 1'b1 : 1'b0;
end
endmodule
