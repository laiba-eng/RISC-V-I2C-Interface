module Data_Memory(
    input wire [31:0] Mem_Addr,    
    input wire [31:0] Write_Data,  
    input wire clk,                
    input wire MemWrite,           
    output wire [31:0] Read_Data   
);

    reg [7:0] memory [63:0];       

    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1)
            memory[i] = i;
    end

    assign Read_Data = {memory[Mem_Addr + 3], memory[Mem_Addr + 2], memory[Mem_Addr + 1], memory[Mem_Addr]};

    always @(posedge clk) begin
        if (MemWrite) begin
            {memory[Mem_Addr + 3], memory[Mem_Addr + 2], memory[Mem_Addr + 1], memory[Mem_Addr]} = Write_Data;
        end
    end
endmodule
