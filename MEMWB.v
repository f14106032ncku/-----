module MEMWB(
  input clk,rst,
  input [31:0] readdata_MEM,
  input [31:0] alu_MEM, 
  input [4:0] rd_MEM, 
  input memtoreg_MEM, regwrite_MEM, 
  output reg [31:0] readdata_WB, 
  output reg [31:0] alu_WB,
  output reg [4:0] rd_WB,
  output reg memtoreg_WB, regwrite_WB
);
  
  always @(posedge clk)
    begin
      if (rst)
        begin
          readdata_WB <= 32'b0;
          alu_WB <= 32'b0;
          rd_WB <= 5'b0;
          memtoreg_WB <= 1'b0;
          regwrite_WB <= 1'b0;
        end
      else
        begin
          readdata_WB <= readdata_MEM;
          alu_WB <= alu_MEM;
          rd_WB <= rd_MEM;
          memtoreg_WB <= memtoreg_MEM;
          regwrite_WB <= regwrite_MEM;
        end
    end
endmodule
