`include "mux.v"
`include "memory.v"
`include "SRAM.v"
`include "imm.v"
`include "Hazard.v"
`include "Forward.v"
`include "Decoder.v"
`include "adder.v"
`include "Controller.v"
`include "Branch_compare.v"
`include "fetch.v"
`include "registerFile.v"
`include "ALU.v"
`include "IFID.v"
`include "IDEX.v"
`include "EXMEM.v"
`include "MEMWB.v"

`include "const.svh"


module RISC_V(
  input clk,
  input reset,
  input wire[63:0] element1,
  input wire[63:0] element2,
  input wire[63:0] element3,
  input wire[63:0] element4,
  input wire[63:0] element5,
  input wire[63:0] element6,
  input wire[63:0] element7,
  input wire[63:0] element8,
  input stall, flush);
  
  // CU wires
  wire branch;
  wire memread;
  wire memtoreg;
  wire memwrite;
  wire ALUsrc;
  wire regwrite;
  wire [1:0] ALUop;
  
  //regfile
  wire regwrite_memwb_out;
  wire [63:0] readdata1, readdata2;
  wire [63:0] r8, r19, r20, r21, r22;
  wire [63:0] write_data;
  
   //PC wires
  wire [63:0] pc_in;
  wire [63:0] pc_out;
  
  // adders
  wire [63:0] adderout1;
  wire [63:0] adderout2;
  
  // inst mem wire
  wire [31:0] instruction;
  wire[31:0] inst_ifid_out;
  
  //Parser
  wire [6:0] opcode;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [6:0] funct7;
  
  
  // Immediate Data Extractor
  wire [63:0] imm_data;
  
  //ifid wires
 
  wire [63:0] random;
  
  //id ex wires
 
  wire [63:0] a1;
  wire [4:0] RS1;
  wire [4:0] RS2;
  wire [4:0] RD;
  wire [63:0] d, M1, M2;
  wire Branch;
  wire Memread;
  wire Memtoreg;
  wire Memwrite;
  wire Regwrite;
  wire Alusrc;
  wire [1:0] aluop;
  wire [3:0] funct4_out;
  
  //mux wires
  wire [63:0] threeby1_out1;
  wire[63:0] threeby1_out2;
  wire[63:0]  alu_64_b;
  
   //ex mem wires
  wire [63:0] write_Data;
  wire [63:0] exmem_out_adder;
  wire exmem_out_zero;
  wire [63:0] exmem_out_result;
  wire [4:0] exmemrd;
  wire BRANCH,MEMREAD,MEMTOREG,MEMEWRITE,REGWRITE;   
  
   // ALU 64
  wire [63:0] AluResult;
  wire zero;
  
  
  // ALU Control
  wire [3:0] operation;
  
  // Data Memory
  wire [63:0] readdata;
 
  
  
  
  //memwb wires
  wire[63:0] muxin1,muxin2;
  wire [4:0] memwbrd;
  wire memwb_memtoreg;
  wire memwb_regwrite;
  
  //forwarding unit wires
  wire [1:0] forwardA;
  wire [1:0] forwardB;
  
  // Branch
  wire addermuxselect;
  wire branch_final;
  
  
  fetch fecth (
    .clk(clk),
    .rst(rst),
    .stall(),
    .wb(),
    .pc_addr(),
	.ir_out(),
	.pc_out()
  );
  
 
  
IFID IFID(
    .clk(),
    .rst(),
    .ir_IF(),
    .pc_IF(), 
    .flush(), 
    .hazard_ifid(), // stall when hazard
    .ir_ID(),
    .pc_ID()
  );
  
Decoder Decoder(
	  .ir(),
	  .rs1(),
	  .rs2(),
	  .rd(),
	  .opcode(),
	  .fun3(),
	  .fun7()
  );  
 
  registerFile regfile 
  (
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(),
    .wdata(),
	.wen(),
    .rdata1(),
    .rdata2()
  );
  
imm imm(
  .ir(),
  .imme()
  );
  
IDEX IDEX(
  .clk(),
  .rst(),
  .opcode_ID(),
  .fun3_ID(),
  .fun7_ID(),
  .pc_ID(),
  .readdata1_ID(), 
  .readdata2_ID(),
  .imm_data_ID(),
  .rs1_ID(),
  .rs2_ID(),
  .rd_ID(), 
  .branch_ID(),
  .memread_ID(),
  .memtoreg_ID(),
  .memwrite_ID(),
  .alusrc_ID(),
  .regwrite_ID(), 
  .flush(), 
  .pc_EX(),
  .rs1_EX(),
  .rs2_EX(),
  .rd_EX(),
  .imm_data_EX(),
  .readdata1_EX(), 
  .readdata2_EX(), 
  .opcode_EX(),
  .fun3_EX(),
  .fun7_EX(),
  .branch_EX(),
  .memread_EX(),
  .memtoreg_EX(), 
  .memwrite_EX(), 
  .regwrite_EX(),
  .alusrc_EX()
);

 mux_3to1 mux1(
    .in_0(),
    .in_1(),
	.in_2(),
    .sel(),
    .out()
    );
	
	mux_3to1 mux2(
    .in_0(),
    .in_1(),
	.in_2(),
    .sel(),
    .out()
    );
	
	mux_2to1 mux3(
    .in_0(),
    .in_1(),
    .sel(),
    .out()
    );
	
adder add1(
    .a(),
    .b(),
    .sum()
    );
 
ALU ALU(
    .opcode(),
    .func3(),
    .func7(),
    .operand1(),
    .operand2(),
    .alu_out(),
    .zero()
); 

          
EXMEM EXMEM(
  .clk(),
  .rst(),
  .pc_branch_EX(), 
  .alu_EX(),
  .zero_EX(),
  .writedata_EX(),
  .rd_EX(), 
  .branch_EX(),
  .memread_EX(),
  .memtoreg_EX(),
  .memwrite_EX(),
  .regwrite_EX(),
  .flush(), 
  .branch_taken_EX(),
  .pc_branch_MEM(),
  .zero_MEM(),
  .alu_MEM(),
  .writedata_MEM(),
  .rd_MEM(),
  .branch_MEM(),
  .memread_MEM(),
  .memtoreg_MEM(),
  .memwrite_MEM(), 
  .regwrite_MEM(),
  .branch_taken_MEM()
  );
  
  SRAM data_mem(
	.clk(clk),
    .wen(),
    .addr(),
	.wdata(),
    .rdata()
    );
 
/*    
  data_memory datamem
  (
    .write_data(write_Data),
    .address(exmem_out_result),
    .memorywrite(MEMEWRITE),
    .clk(clk),
    .memoryread(MEMREAD),
    .read_data(readdata),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8)
  );
*/  
  
 
MEMWB MEMWB(
  .clk(),
  .rst(),
  .readdata_MEM(),
  .alu_MEM(), 
  .rd_MEM(), 
  .memtoreg_MEM(), 
  .regwrite_MEM(), 
  .readdata_WB(), 
  .alu_WB(),
  .rd_WB(),
  .memtoreg_WB(), 
  .regwrite_WB()
);
  
 mux_2to1 mux4(
    .in_0(),
    .in_1(),
    .sel(),
    .out()
    );
  
controller controller(
  .opcode(),
  .stall(), 
 .branch(),
 .memread(),
 .memtoreg(),
 .memwrite(),
 .aluSrc(),
 .regwrite(),
 .Aluop()
 );
  
Branch_compare branch(
    .operand1(), 
    .operand2(), 
    .func3(),    
    .branch_taken()
);
    

Forward Forward(
   .RS1(), 
   .RS2(), 
   .rdMem(), 
   .rdWb(), 
    .regWrite_Wb(), 
    .regWrite_Mem(), 
    .Forward_A(),
    .Forward_B()
);
    
Hazard Hazard( 
    .MEMr_IDEX(), 
    .ir(), 
    .rd_IDEX(), 
    .stall() 
);	

endmodule 