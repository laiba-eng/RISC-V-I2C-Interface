module Program_Counter (clk , rst , PC_In , PC_Out);
input clk , rst;
input [31:0] PC_In;
output reg [31:0] PC_Out;
always @(posedge clk) begin
if (rst)
PC_Out <= 0;
else
PC_Out <= PC_In;
end
endmodule 

