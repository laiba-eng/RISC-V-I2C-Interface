module Instruction_Memory(Inst_Address , Instruction); 
input wire [31:0] Inst_Address;   
output reg [31:0] Instruction; 
reg [7:0] memory [31:0];
    initial begin
        memory[0] = 8'b00000011;
        memory[1] = 8'b10100011;
        memory[2] = 8'b11000100;
        memory[3] = 8'b11111111;
        memory[4] = 8'b00100011;
        memory[5] = 8'b10100100;
        memory[6] = 8'b01100100;
        memory[7] = 8'b00000000;
        memory[8] = 8'b00110011;
        memory[9] = 8'b11100010;
        memory[10] = 8'b01100010;
        memory[11] = 8'b00000000;
    memory[12] = 8'b00010011; // 0x13
    memory[13] = 8'b10000001; // 0x81
    memory[14] = 8'b00010000; // 0x10
    memory[15] = 8'b00000000; // 0x00

    // ADDI x2, x0, 0x20
    memory[16] = 8'b00010011; // 0x13
    memory[17] = 8'b00000001; // 0x01
    memory[18] = 8'b00100000; // 0x20
    memory[19] = 8'b00000000; // 0x00

    // SW x1, 0x40(x0)
    memory[20] = 8'b00100011; // 0x23
    memory[21] = 8'b00000000; // 0x00
    memory[22] = 8'b01000000; // 0x40
    memory[23] = 8'b00000000; // 0x00

    // SW x2, 0x48(x0)
    memory[24] = 8'b00100011; // 0x23
    memory[25] = 8'b00000000; // 0x00
    memory[26] = 8'b01001000; // 0x48
    memory[27] = 8'b00000000; // 0x00

    // LW x3, 0x44(x0)
    memory[28] = 8'b10000011; // 0x83
    memory[29] = 8'b01000000; // 0x40
    memory[30] = 8'b00000001; // 0x01
    memory[31] = 8'b00000000; // 0x00
    end


always @(*) begin
        Instruction = {memory[Inst_Address + 3], memory[Inst_Address + 2], memory[Inst_Address + 1], memory[Inst_Address]};
    end 
endmodule


