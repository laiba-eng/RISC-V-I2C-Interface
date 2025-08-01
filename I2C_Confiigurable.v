module i2c_configurable(
    input wire clk,
    input wire rst,
    input wire [6:0] addr,       // Address to determine which register to access
    input wire [7:0] data_in,     // Data to write to a register
    input wire enable,            // Enable signal (from address decoder)
    input wire rw,                // Read/Write control signal (1 for read, 0 for write)
    input wire [1:0] control_reg, // Control register (bit 0: master/slave mode, bit 1: enable)
    output reg [7:0] data_out,    // Data output when reading
    output wire ready,            // Ready signal for I2C operations
    inout wire i2c_sda,
    inout wire i2c_scl
    );

    // Memory-mapped I/O registers
    reg [7:0] data_reg;    // Data register for transmission/reception
    reg [7:0] status_reg;  // Status register (busy, error, etc.)

    // Assign addresses to registers
    localparam CONTROL_REG_ADDR = 7'h40;
    localparam STATUS_REG_ADDR  = 7'h44;
    localparam DATA_REG_ADDR    = 7'h48;

    // Local Parameters for FSM States
    localparam IDLE = 0;
    localparam START = 1;
    localparam ADDRESS = 2;
    localparam READ_ACK = 3;
    localparam WRITE_DATA = 4;
    localparam WRITE_ACK = 5;
    localparam READ_DATA = 6;
    localparam READ_ACK2 = 7;
    localparam STOP = 8;
    
    localparam DIVIDE_BY = 4;

    // Internal registers
    reg [7:0] state;
    reg [7:0] saved_addr;
    reg [7:0] saved_data;
    reg [7:0] counter;
    reg [7:0] counter2 = 0;
    reg write_enable;
    reg sda_out;
    reg i2c_scl_enable = 0;
    reg i2c_clk = 1;

    // Master/Slave Configuration
    assign ready = ((rst == 0) && (state == IDLE)) ? 1 : 0;
    assign i2c_scl = (i2c_scl_enable == 0) ? 1'b1 : i2c_clk;
    assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;

    // Clock Division for I2C Clock Generation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter2 <= 0;
            i2c_clk <= 1;
        end else begin
            if (counter2 == (DIVIDE_BY / 2) - 1) begin
                i2c_clk <= ~i2c_clk;
                counter2 <= 0;
            end else begin
                counter2 <= counter2 + 1;
            end
        end
    end

    // Clock Stretching (Slave Mode Only)
    always @(negedge i2c_clk or posedge rst) begin
        if (rst) begin
            i2c_scl_enable <= 0;
        end else begin
            if (state == IDLE || state == START || state == STOP) begin
                i2c_scl_enable <= 0;
            end else begin
                i2c_scl_enable <= 1;
            end
        end
    end

    // Finite State Machine for Master/Slave Modes
    always @(posedge i2c_clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 8'b0;
            status_reg <= 8'b00000001;
        end else begin
            case (state)
                IDLE: begin
                    if (control_reg[1] == 1) begin
                        state <= START;
                        saved_addr <= {addr, rw};
                        saved_data <= data_in;
                        status_reg <= 8'b00000010;
                    end
                end
                START: begin
                    counter <= 7;
                    state <= ADDRESS;
                end
                ADDRESS: begin
                    if (counter == 0) begin
                        state <= READ_ACK;
                    end else begin
                        counter <= counter - 1;
                    end
                end
                READ_ACK: begin
                    if (i2c_sda == 0) begin
                        counter <= 7;
                        if (saved_addr[0] == 0) begin
                            state <= WRITE_DATA;
                        end else begin
                            state <= READ_DATA;
                        end
                    end else begin
                        state <= STOP;
                        status_reg <= 8'b00000100;
                    end
                end
                WRITE_DATA: begin
                    if (counter == 0) begin
                        state <= READ_ACK2;
                    end else begin
                        counter <= counter - 1;
                    end
                end
                READ_ACK2: begin
                    if (i2c_sda == 0 && control_reg[1] == 1) begin
                        state <= IDLE;
                        status_reg <= 8'b00001000;
                    end else begin
                        state <= STOP;
                    end
                end
                READ_DATA: begin
                    data_out <= {data_out[6:0], i2c_sda};
                    if (counter == 0) begin
                        state <= WRITE_ACK;
                    end else begin
                        counter <= counter - 1;
                    end
                end
                WRITE_ACK: begin
                    state <= STOP;
                end
                STOP: begin
                    state <= IDLE;
                    status_reg <= 8'b00010000;
                end
            endcase
        end
    end

    // Write Enable and SDA Control Logic
    always @(negedge i2c_clk or posedge rst) begin
        if (rst) begin
            write_enable <= 1;
            sda_out <= 1;
        end else begin
            case (state)
                START: begin
                    write_enable <= 1;
                    sda_out <= 0;
                end
                ADDRESS: begin
                    sda_out <= saved_addr[counter];
                end
                READ_ACK: begin
                    write_enable <= 0;
                end
                WRITE_DATA: begin
                    write_enable <= 1;
                    sda_out <= saved_data[counter];
                end
                WRITE_ACK: begin
                    write_enable <= 1;
                    sda_out <= 0;
                end
                READ_DATA: begin
                    write_enable <= 0;
                end
                STOP: begin
                    write_enable <= 1;
                    sda_out <= 1;
                end
            endcase
        end
    end
endmodule

