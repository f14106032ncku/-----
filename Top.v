module Top(
  input clk,rst,
  input [31:0] ir,
  input [31:0] readdata_MEM,
  output [31:0] pc_out,
  output [31:0] alu_DMEM,
  output [31:0] writedata_DMEM,
  output memwrite_MEM
  );
  
// ========================
// 定義模組間的連接訊號
// ========================
// Fetch 模組訊號
wire [31:0] ir_IF, pc_adder_out, pc_in;

// IFID 模組訊號
wire [31:0] ir_ID, pc_ID;

// Decoder 模組訊號
wire [4:0] rs1, rs2, rd;
wire [6:0] opcode, funct7;
wire [2:0] funct3;

// Register File 和 imm模組訊號
wire [31:0] rdata1, rdata2, imm_data;

// IDEX 模組訊號
wire [31:0] pc_EX,pc_branch_EX, readdata1_EX, readdata2_EX;
wire [4:0] rs1_EX;
wire [4:0] rs2_EX;
wire [4:0] rd_EX;
wire [31:0] imm_data_EX;
wire [31:0] rdata1_EX;
wire [31:0] rdata2_EX;
wire [6:0] opcode_EX;
wire [2:0] fun3_EX;
wire [6:0] fun7_EX;
wire branch_EX,memread_EX,memtoreg_EX, memwrite_EX, regwrite_EX,alusrc_EX,BP_EX;

// ALU 模組訊號
wire non_operation;
wire [31:0] M1,M2,alu_b;

// EXMEM 模組訊號
wire [31:0] pc_branch_MEM, alu_EX;
wire zero_MEM,flush_EX;

//wire [31:0] writedata_MEM;
//assign writedata_DMEM = writedata_MEM;
wire [4:0] rd_MEM;
wire branch_MEM,memread_MEM,memtoreg_MEM, regwrite_MEM;

// MEMWB 模組訊號
wire [31:0] readdata_WB; 
wire [31:0] alu_WB;
wire [4:0] rd_WB;
wire memtoreg_WB, regwrite_WB;
wire taken_MEM;

// Branch prediction
wire [31:0] pc_BP;
wire [1:0] pc_sel; // 0 : pc+1 | 1 : pc_branch_MEM | 2 : pc_BP
wire BP_update, taken, BP_taken, branch_predict;


// FORWORD 模組訊號
wire [1:0] Forward_A;
wire [1:0] Forward_B;

// 控制訊號
//wire branch_final;
wire Branch, Memread, Memtoreg, memwrite, Alusrc, Regwrite;  
// wire [1:0] Aluop;

// Hazard
wire flush_MEM;
wire flush_IFID, flush_IDEX, flush_EXMEM;
wire BP_ID;
               
// assign flush_MEM = branch_MEM & (~zero_MEM) ;

// WB 模組訊號

wire [31:0] wb_data;

//Hazard 模組訊號
wire stall;

//---------------------------------------------IF
mux_4to1 muxpc(
    .in_0(pc_adder_out),
    .in_1(pc_branch_MEM),
    .in_2(pc_BP),
    .in_3(pc_out),
    .sel(pc_sel),
    .out(pc_in)
    );  

adder pc_adder(
    .a(pc_out),
    .b(32'd1),
    .sum(pc_adder_out)
    );

pc pc(
    .clk(clk),
    .rst(rst),
    //.stall(stall),
    .pc_in(pc_in),
    .pc_out(pc_out)
    );

//---------------------------------------------IFID 
IFID IFID (
    .clk(clk),
    .rst(rst),
    .ir_IF(ir),          
    .pc_IF(pc_out),          
    .flush(flush_IFID),                
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

branch_prediction branch_prediction (
    .clk(clk),            
    .rst(rst),             
    .update(BP_update),        
    .taken(BP_taken),    
    .branch_predict(branch_predict)
); 

adder BP_adder(
    .a(pc_ID),
    .b(imm_data),
    .sum(pc_BP)
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
    .branch_ID(branch_predict),       
    .memread_ID(Memread),     
    .memtoreg_ID(Memtoreg),   
    .memwrite_ID(memwrite),   
    .alusrc_ID(Alusrc),       
    .regwrite_ID(Regwrite),   
    .flush(flush_IDEX), 
    .BP_ID(BP_ID),    
    .pc_EX(pc_EX),        
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
    .alusrc_EX(alusrc_EX),
    .BP_EX(BP_EX)                  
);

/*	
adder add1(
    .a(pc_EX),
    .b(imm_data_EX),
    .sum(pc_branch_EX)
    );
*/ 

NextPC NextPC (
    .BP_EX(BP_EX),
    .opcode(opcode_EX),
    .operand1(M1),    
    .alu_result(alu_EX),
    .pc(pc_EX),
    .imm(imm_data_EX),
    .BP_update(BP_update),
    .BP_taken(BP_taken),
    .taken(taken),
    .nextpc(pc_branch_EX)
);

ALU ALU(
    .opcode(opcode_EX),
    .func3(fun3_EX),
    .func7(fun7_EX),
    .pc(pc_EX),    
    .operand1(M1),
    .operand2(alu_b),
    .alu_out(alu_EX),
    .non_operation(non_operation)
); 

//---------------------------------------------EXMEM                       
EXMEM EXMEM(
  .clk(clk),
  .rst(rst),
  .pc_branch_EX(pc_branch_EX), 
  .alu_EX(alu_EX),
  .non_operation(non_operation),
  .writedata_EX(M2),
  .rd_EX(rd_EX), 
  .branch_EX(branch_EX),
  .memread_EX(memread_EX),
  .memtoreg_EX(memtoreg_EX),
  .memwrite_EX(memwrite_EX),
  .regwrite_EX(regwrite_EX),
  .taken(taken),
  .flush(flush_EXMEM),
  .taken_MEM(taken_MEM), 
  .branch_taken_EX(),
  .pc_branch_MEM(pc_branch_MEM),
  .zero_MEM(zero_MEM),
  .alu_MEM(alu_DMEM), // output
  .writedata_MEM(writedata_DMEM),
  .rd_MEM(rd_MEM),
  .branch_MEM(branch_MEM),
  .memread_MEM(memread_MEM),
  .memtoreg_MEM(memtoreg_MEM),
  .memwrite_MEM(memwrite_MEM), 
  .regwrite_MEM(regwrite_MEM),
  .branch_taken_MEM()
  );

 

//---------------------------------------------MEMWB   
MEMWB MEMWB(
  .clk(clk),
  .rst(rst),
  .readdata_MEM(readdata_MEM),
  .alu_MEM(alu_DMEM), //input
  .rd_MEM(rd_MEM), 
  .memtoreg_MEM(memtoreg_MEM), 
  .regwrite_MEM(regwrite_MEM), 
  .readdata_WB(readdata_WB), 
  .alu_WB(alu_WB),
  .rd_WB(rd_WB),
  .memtoreg_WB(memtoreg_WB), 
  .regwrite_WB(regwrite_WB)
);
  
mux_2to1 mux4(
    .in_0(alu_WB),
    .in_1(readdata_WB),
    .sel(memtoreg_WB),
    .out(wb_data)
    );

//---------------------------------------------CTRL	
controller controller(
	 .opcode(opcode),
	 .stall(stall),
        .branch_predict(branch_predict), 
	 .BP_ID(BP_ID),
	 .memread(Memread),
	 .memtoreg(Memtoreg),
	 .memwrite(memwrite),
	 .aluSrc(Alusrc),
	 .regwrite(Regwrite),
	 .Aluop()
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
    .rd_EX(rd_EX),  
    .taken_MEM(taken_MEM), 
    .BP_ID(BP_ID),
    .flush_IFID(flush_IFID),    
    .flush_IDEX(flush_IDEX),     
    .flush_EXMEM(flush_EXMEM), 
    .pc_sel(pc_sel),                   
    .stall(stall)            
);
	
mux_3to1 mux1(
    .in_0(readdata1_EX),
    .in_1(wb_data),
    .in_2(alu_DMEM),
    .sel(Forward_A),
    .out(M1)
    );
	
mux_3to1 mux2(
    .in_0(readdata2_EX),
    .in_1(wb_data),
    .in_2(alu_DMEM),
    .sel(Forward_B),
    .out(M2)
    );
	
mux_2to1 mux3(
    .in_0(M2),
    .in_1(imm_data_EX),
    .sel(alusrc_EX),
    .out(alu_b)
    );

endmodule 
