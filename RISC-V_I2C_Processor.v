module RISC_V_Processor_I2CCONFIG(clk , rst);
input clk , rst;
wire [31:0] PCPlus4 , PCin , PCTarget , PC_Out , Instruction , Result , ReadData1 , ReadData2 , res , Read_Data , imm_data , SrcB;
wire [2:0] Operation;
wire [1:0]  ImmSrc;
wire RegWrite , PCSrc , ALUSrc , Zero , MemWrite , ResultSrc , data_mem_en , i2c_en , ready , i2c_sda , i2c_scl;
wire [7:0] data_out;
reg [7:0] selected_data_byte;

always @(*) begin
    case (res[1:0])  // Using lower 2 bits of address to determine the byte within the 32-bit word
        2'b00: selected_data_byte = ReadData2[7:0];
        2'b01: selected_data_byte = ReadData2[15:8];
        2'b10: selected_data_byte = ReadData2[23:16];
        2'b11: selected_data_byte = ReadData2[31:24];
        default: selected_data_byte = 8'b0;
    endcase
end

adder pcp4(PC_Out , 32'b100 , PCPlus4);
mux32bit PCSrcMUX(PCPlus4 , PCTarget , PCSrc , PCin);
Program_Counter PC(clk , rst , PCin , PC_Out);
Instruction_Memory IM(PC_Out , Instruction);
mux32bit ResultSrcMUX(res , Read_Data , ResultSrc , Result);
registerFile RF(clk , RegWrite , Instruction[19:15] , Instruction[24:20] , Instruction[11:7] , Result , ReadData1 , ReadData2);
imm_data_gen ID(Instruction , ImmSrc , imm_data);
adder pct(PC_Out , imm_data , PCTarget);
mux32bit ALUSrcMUX(ReadData2 , imm_data , ALUSrc , SrcB);
alu lua(ReadData1 , SrcB , Operation , res , Zero);
Data_Memory DM(res, ReadData2, clk, data_mem_en, Read_Data);
CU controlunit(Zero , Instruction[6:0] , Instruction[14:12] , Instruction[31:25] , PCSrc , ResultSrc , MemWrite , ALUSrc , ImmSrc , RegWrite , Operation);
Address_Decoder AD(res , MemWrite , data_mem_en , i2c_en);
i2c_configurable IC(clk , rst , res[6:0] , selected_data_byte , i2c_en , MemWrite , 2'b00 , data_out , ready , i2c_sda , i2c_scl);
endmodule

