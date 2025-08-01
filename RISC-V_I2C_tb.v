module RISC_V_Processor_I2CCONFIG_tb();
    reg clk, rst;
    wire [31:0] PC_Out, Instruction, Result, ReadData1, ReadData2, res, Read_Data, imm_data, SrcB;
    wire [2:0] Operation;
    wire [1:0] ImmSrc;
    wire RegWrite, PCSrc, ALUSrc, Zero, MemWrite, ResultSrc;

    // Instantiate the RISC-V Processor
    RISC_V_Processor_I2CCONFIG rv (
        .clk(clk),
        .rst(rst)
    );

    // Assign wires to the internal signals of the processor for visibility in the testbench
    assign PC_Out = rv.PC_Out;
    assign Instruction = rv.Instruction;
    assign Result = rv.Result;
    assign ReadData1 = rv.ReadData1;
    assign ReadData2 = rv.ReadData2;
    assign res = rv.res;
    assign Read_Data = rv.Read_Data;
    assign imm_data = rv.imm_data;
    assign SrcB = rv.SrcB;
    assign Operation = rv.Operation;
    assign ImmSrc = rv.ImmSrc;
    assign RegWrite = rv.RegWrite;
    assign PCSrc = rv.PCSrc;
    assign ALUSrc = rv.ALUSrc;
    assign Zero = rv.Zero;
    assign MemWrite = rv.MemWrite;
    assign ResultSrc = rv.ResultSrc;
    assign data_out = rv.data_out;
    assign i2c_sda = rv.i2c_sda;
    assign i2c_scl = rv.i2c_scl;

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5 time units

    // Initial block for setting up reset and monitoring signals
    initial begin
        clk = 0;
        rst = 1;  // Start with reset enabled
        #10 rst = 0; // Release reset after 10 time units

        // Monitor all desired output signals
        $monitor("Time=%0d | PC_Out=%h | Instruction=%h | Result=%h | ReadData1=%h | ReadData2=%h | res=%h | Read_Data=%h | imm_data=%h | SrcB=%h | Operation=%b | ImmSrc=%b | RegWrite=%b | PCSrc=%b | ALUSrc=%b | Zero=%b | MemWrite=%b | ResultSrc=%b | data_out = %h | i2c_sda = %b | i2c_scl = %b",
                 $time, PC_Out, Instruction, Result, ReadData1, ReadData2, res, Read_Data, imm_data, SrcB, Operation, ImmSrc, RegWrite, PCSrc, ALUSrc, Zero, MemWrite, ResultSrc , data_out , i2c_sda , i2c_scl);

        #200 $finish; // End the simulation after 200 time units
    end
endmodule
