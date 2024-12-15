`include "mux.v"
`include "memory.v"
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
  input clk,rst,
  input [31:0] ir,
  input [31:0] readdata_MEM,
  output [31:0] pc_out,
  output [31:0] alu_MEM,
  output [31:0] writedata_MEM
  );
  
// ========================
// 定義模組間的連接訊號
// ========================
// Fetch 模組訊號
wire [31:0] ir_IF;

// IFID 模組訊號
wire [31:0] ir_ID, pc_ID;

// Decoder 模組訊號
wire [4:0] rs1, rs2, rd;
wire [6:0] opcode, funct7;
wire [2:0] funct3;

// Register File 和 imm模組訊號
wire [31:0] rdata1, rdata2, imm_data;

// IDEX 模組訊號
wire [31:0] addrout2,addrout3;
wire [4:0] rs1_EX;
wire [4:0] rs2_EX;
wire [4:0] rd_EX;
wire [31:0] imm_data_EX;
wire [31:0] rdata1_EX;
wire [31:0] rdata2_EX;
wire [6:0] opcode_EX;
wire [2:0] fun3_EX;
wire [6:0] fun7_EX;
wire branch_EX,memread_EX,memtoreg_EX, memwrite_EX, regwrite_EX,alusrc_EX;

// ALU 模組訊號
wire [31:0] AluResult;
wire non_operation;
wire [31:0] M1,M2,alu_b;

// EXMEM 模組訊號
wire [31:0] pc_branch_MEM;
wire zero_MEM;
wire [31:0] alu_MEM;
wire [31:0] writedata_MEM;
wire [4:0] rd_MEM;
wire branch_MEM,memread_MEM,memtoreg_MEM, memwrite_MEM, regwrite_MEM;
wire branch_taken_MEM;

// MEMWB 模組訊號
wire [31:0] readdata_WB; 
wire [31:0] alu_WB;
wire [4:0] rd_WB;
wire memtoreg_WB, regwrite_WB;

//mem 模組訊號
wire [31:0] Read_data;

// FORWORD 模組訊號
wire [1:0] Forward_A;
wire [1:0] Forward_B;

// 控制訊號
wire branch_final;
wire Branch, Memread, Memtoreg, Memwrite, Alusrc, Regwrite;  
wire [1:0] Aluop;
wire flush;

assign flush = branch_taken_MEM & non_operation ;

// WB 模組訊號

wire [31:0] wb_data;

//Hazard 模組訊號
wire stall;

//---------------------------------------------IF
mux_2to1 muxpc(
    .in_0(pc_adder_out),
    .in_1(pc_branch_MEM),
    .sel(branch_taken_MEM),
    .out(pc_in)
    );  

adder pc_adder(
    .a(pc_out),
    .b(32'd4),
    .sum(pc_adder_out)
    );

pc pc(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .pc_in(pc_in),
    .pc_out(pc_out)
    );

//---------------------------------------------IFID 
  IFID IFID (
    .clk(clk),
    .rst(rst),
    .ir_IF(ir_IF),          
    .pc_IF(pc_out),          
    .flush(flush),                
    .hazard_ifid(stall),          
    .ir_ID(ir_ID),   
    .pc_ID(pc_ID)        
);
  
  
 Decoder Decoder (
    .ir(ir_ID),      
    .rs1(rs1),               
    .rs2(rs2),               
    .rd(rd),                 
    .opcode(opcode),         
    .fun3(funct3),           
    .fun7(funct7)            
);
 
  
registerFile regfile (
    .clk(clk),
    .rs1(rs1),                
    .rs2(rs2),                
    .rd(rd_WB),             
    .wdata(wb_data),            
    .wen(regwrite_WB),     
    .rdata1(rdata1),          
    .rdata2(rdata2)           
); 
 
 
imm imm (
    .ir(ir_ID),      
    .imme(imm_data)          
);


//---------------------------------------------IDEX
  
IDEX IDEX (
    .clk(clk),
    .rst(rst),
    .opcode_ID(opcode),       
    .fun3_ID(funct3),         
    .fun7_ID(funct7),         
    .pc_ID(pc_ID),        
    .readdata1_ID(rdata1),    
    .readdata2_ID(rdata2),    
    .imm_data_ID(imm_data),   
    .rs1_ID(rs1),             
    .rs2_ID(rs2),             
    .rd_ID(rd),               
    .branch_ID(Branch),       
    .memread_ID(Memread),     
    .memtoreg_ID(Memtoreg),   
    .memwrite_ID(Memwrite),   
    .alusrc_ID(Alusrc),       
    .regwrite_ID(Regwrite),   
    .flush(flush),     
    .pc_EX(addrout2),        
    .rs1_EX(rs1_EX),              
    .rs2_EX(rs2_EX),              
    .rd_EX(rd_EX),               
    .imm_data_EX(imm_data_EX),          
    .readdata1_EX(readdata1_EX),        
    .readdata2_EX(readdata2_EX),
    .opcode_EX(opcode_EX),             
    .fun3_EX(fun3_EX),               
    .fun7_EX(fun7_EX),               
    .branch_EX(branch_EX),             
    .memread_EX(memread_EX),            
    .memtoreg_EX(memtoreg_EX),           
    .memwrite_EX(memwrite_EX),           
    .regwrite_EX(regwrite_EX),           
    .alusrc_EX(alusrc_EX)              
);

 mux_3to1 mux1(
    .in_0(readdata1_EX),
    .in_1(wb_data),
	.in_2(alu_MEM),
    .sel(Forward_A),
    .out(M1)
    );
	
	mux_3to1 mux2(
    .in_0(readdata2_EX),
    .in_1(wb_data),
	.in_2(alu_MEM),
    .sel(Forward_B),
    .out(M2)
    );
	
	mux_2to1 mux3(
    .in_0(M2),
    .in_1(imm_data_EX),
    .sel(Alusrc),
    .out(alu_b)
    );
	
adder add1(
    .a(addrout2),
    .b(imm_data_EX<<1),
    .sum(addrout3)
    );
 
ALU ALU(
    .opcode(Aluop),
    .func3(fun3_EX),
    .func7(fun7_EX),
    .operand1(M1),
    .operand2(alu_b),
    .alu_out(AluResult),
    .non_operation(non_operation)
); 

//---------------------------------------------EXMEM                       
EXMEM EXMEM(
  .clk(clk),
  .rst(rst),
  .pc_branch_EX(pc_branch_EX), 
  .alu_EX(AluResult),
  .zero_EX(non_operation),
  .writedata_EX(M2),
  .rd_EX(rd_EX), 
  .branch_EX(branch_EX),
  .memread_EX(memread_EX),
  .memtoreg_EX(memtoreg_EX),
  .memwrite_EX(memwrite_EX),
  .regwrite_EX(regwrite_EX),
  .flush(flush), 
  .branch_taken_EX(),
  .pc_branch_MEM(pc_branch_MEM),
  .zero_MEM(zero_MEM),
  .alu_MEM(alu_MEM),
  .writedata_MEM(writedata_MEM),
  .rd_MEM(rd_MEM),
  .branch_MEM(branch_MEM),
  .memread_MEM(memread_MEM),
  .memtoreg_MEM(memtoreg_MEM),
  .memwrite_MEM(memwrite_MEM), 
  .regwrite_MEM(regwrite_MEM),
  .branch_taken_MEM(branch_taken_MEM)
  );

  /*
  mem data_mem(
	.clk(clk),
    .wen(memread_MEM),
    .addr(alu_MEM),
	.wdata(writedata_MEM),
    .rdata(Read_data)
    );
  */

//---------------------------------------------MEMWB   
MEMWB MEMWB(
  .clk(clk),
  .rst(rst),
  .readdata_MEM(Read_data),
  .alu_MEM(alu_MEM), 
  .rd_MEM(rd_MEM), 
  .memtoreg_MEM(memtoreg_MEM), 
  .regwrite_MEM(memwrite_MEM), 
  .readdata_WB(readdata_WB), 
  .alu_WB(alu_WB),
  .rd_WB(rd_WB),
  .memtoreg_WB(memtoreg_WB), 
  .regwrite_WB(regwrite_WB)
);
  
 mux_2to1 mux4(
    .in_0(readdata_WB),
    .in_1(alu_WB),
    .sel(memtoreg_WB),
    .out(wb_data)
    );

//---------------------------------------------CTRL	
controller controller(
	 .opcode(opcode),
	 .stall(stall), 
	 .branch(Branch),
	 .memread(Memread),
	 .memtoreg(Memtoreg),
	 .memwrite(Memwrite),
	 .aluSrc(Alusrc),
	 .regwrite(Regwrite),
	 .Aluop(Aluop)
 );
  
Forward Forward(
   .RS1(rs1_EX), 
   .RS2(rs2_EX), 
   .rdMem(rd_MEM), 
   .rdWb(rd_WB), 
   .regWrite_Wb(regwrite_WB), 
   .regWrite_Mem(regwrite_MEM), 
   .Forward_A(Forward_A),
   .Forward_B(Forward_B)
);
    
Hazard Hazard( 
    .memread_EX(memread_EX),  
    .ir_ID(ir_ID),     
    .rd_IDEX(rd_EX),                  
    .stall(stall)            
);	

endmodule 