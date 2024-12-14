          
module EXMEM(
  input clk,rst,
  input [31:0] pc_branch_EX, //pc branch input
  input [31:0] alu_out,//64bit alu output
  input non_operation,//64bit alu output
  input [31:0] writedata_EX, //2 bit mux2by1 output
  input [4:0] rd_EX, //IDEX output
  input branch_EX,memread_EX,memtoreg_EX,memwrite_EX,regwrite_EX, //IDEXX outputs
  input flush, 
  input branch_taken_EX,
  output reg [31:0] pc_branch_MEM,
  output reg zero_MEM,
  output reg [31:0] alu_MEM,
  output reg [31:0] writedata_MEM,
  output reg [4:0] rd_MEM,
  output reg branch_MEM,memread_MEM,memtoreg_MEM, memwrite_MEM, regwrite_MEM,
  output reg branch_taken_MEM);
  
  always @ (posedge clk)
    begin
      if (rst || flush)
        begin
          pc_branch_MEM <= 32'b0;
          zero_MEM <= 1'b0;
          alu_MEM <= 32'b0;
          writedata_MEM <= 32'b0;
          rd_MEM <= 5'b0;
          branch_MEM <= 1'b0;
          memread_MEM <= 1'b0;
          memtoreg_MEM <=1'b0;
          memwrite_MEM <= 1'b0;
          regwrite_MEM <= 1'b0;
          branch_taken_MEM <= 1'b0;
        end
      else
        begin
          pc_branch_MEM <= pc_branch_EX;
          zero_MEM <= non_operation;
          alu_MEM <= alu_out;
          writedata_MEM <= writedata_EX;
          rd_MEM <= rd_EX;
          branch_MEM <= branch_EX;
          memread_MEM <= memread_EX;
          memtoreg_MEM <= memtoreg_EX;
          memwrite_MEM <= memwrite_EX;
          regwrite_MEM <= regwrite_EX;
          branch_taken_MEM = branch_taken_EX;
        end
    end
endmodule
