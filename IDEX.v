module IDEX(
  input clk,rst,
  input [6:0] opcode_ID,// opcode from instruction mem
  input [2:0] fun3_ID,// fun3 from instruction mem
  input [6:0] fun7_ID,// fun7 from instruction mem
  input [31:0] pc_ID,//adder input, ouput of IFID carried forward_EX
  input [31:0] readdata1_ID, //from regwrite_EX
  input [31:0] readdata2_ID,//from regwrite_EX
  input [31:0] imm_data_ID,//from data extractor
  input [4:0] rs1_ID,//from instruction parser
  input [4:0] rs2_ID, //from instruction parser
  input [4:0] rd_ID, //from instruction parser
  input branch_ID,memread_ID,memtoreg_ID,memwrite_ID,alusrc_ID,regwrite_ID, //from control unit
  input flush, 
  output reg [31:0] pc_EX,
  output reg [4:0] rs1_EX,
  output reg [4:0] rs2_EX,
  output reg [4:0] rd_EX,
  output reg [31:0] imm_data_EX,
  output reg [31:0] readdata1_EX, //2bit mux
  output reg [31:0] readdata2_EX, //2bit mux
  output reg [6:0] opcode_EX,
  output reg [2:0] fun3_EX,
  output reg [6:0] fun7_EX,
  output reg branch_EX,memread_EX,memtoreg_EX, memwrite_EX, regwrite_EX,alusrc_EX
);
  
  always @ (posedge clk)
    begin
      if (rst || flush)
        begin
          pc_EX <= 31'b0;
          rs1_EX <= 5'b0;
          rs2_EX <= 5'b0;
          rd_EX <= 5'b0;
          imm_data_EX <= 31'b0;
          readdata1_EX <= 31'b0;
          readdata2_EX <= 31'b0;
          opcode_EX <= 7'b0;
          fun3_EX <= 4'b0;    
          fun7_EX <= 7'b0;                 
          branch_EX <= 1'b0;
          memread_EX <= 1'b0;
          memtoreg_EX <=1'b0;
          memwrite_EX <= 1'b0;
          regwrite_EX <= 1'b0;
          alusrc_EX <= 1'b0;
        end
      else
        begin
          pc_EX <= pc_ID;
          rs1_EX <= rs1_ID;
          rs2_EX <= rs2_ID;
          rd_EX <= rd_ID;
          imm_data_EX <= imm_data_ID;
          readdata1_EX <= readdata1_ID;
          readdata2_EX <= readdata2_ID;
          opcode_EX <= opcode_ID;
          fun3_EX <= fun3_ID;    
          fun7_EX <= fun7_ID;            
          branch_EX <= branch_ID;
          memread_EX <= memread_ID;
          memtoreg_EX <= memtoreg_ID;
          memwrite_EX <= memwrite_ID;
          regwrite_EX <= regwrite_ID;
          alusrc_EX <= alusrc_ID;     
        end
    end
endmodule