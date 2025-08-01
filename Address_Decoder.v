module Address_Decoder(
    input [31:0] address,  // Memory address from ALU
    input MemWrite,        // Write enable signal from control unit
    output reg data_mem_en, // Enable signal for data memory
    output reg i2c_en       // Enable signal for I2C module
);

    // Address ranges for the I2C registers
    localparam CONTROL_REG_ADDR = 32'h00000040;
    localparam STATUS_REG_ADDR = 32'h00000044;
    localparam DATA_REG_ADDR = 32'h00000048;

    always @(*) begin
        if (MemWrite) begin
            // Check if the address falls within the data memory range
            if (address >= 32'h00000000 && address <= 32'h0000003F) begin
                data_mem_en = 1;
                i2c_en = 0;
            end
            // Check if the address falls within the I2C register range
            else if (address >= CONTROL_REG_ADDR && address <= DATA_REG_ADDR) begin
                data_mem_en = 0;
                i2c_en = 1;
            end
            // Otherwise, disable both data memory and I2C
            else begin
                data_mem_en = 0;
                i2c_en = 0;
            end
        end
        // If not a write operation, disable both data memory and I2C
        else begin
            data_mem_en = 0;
            i2c_en = 0;
        end
    end
endmodule
