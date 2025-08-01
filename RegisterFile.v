module registerFile (
    input wire clk,             // Clock signal
    input wire RegWrite,        // Write enable signal
    input wire [4:0] RS1,       // Source register 1 (5 bits, selects one of 32 registers)
    input wire [4:0] RS2,       // Source register 2 (5 bits, selects another of 32 registers)
    input wire [4:0] RD,        // Destination register (5 bits, selects the register to write to)
    input wire [31:0] WriteData, // Data to be written to register RD (32 bits wide)
    output wire [31:0] ReadData1, // Data read from register RS1 (32 bits wide)
    output wire [31:0] ReadData2  // Data read from register RS2 (32 bits wide)
);

    // 32 registers, each 32 bits wide
    reg [31:0] Registers [31:0];  

    // Initialize registers with random values
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            Registers[i] = i;  // Initialize with random values for simulation
    end

    // Read operation (asynchronous)
    assign ReadData1 = Registers[RS1];  // Read register RS1
    assign ReadData2 = Registers[RS2];  // Read register RS2

    // Write operation (synchronous, on positive clock edge)
    always @(posedge clk) begin
        if (RegWrite) begin
            Registers[RD] <= WriteData;  
        end
    end

endmodule
