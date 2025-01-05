`include "const.svh" 
/*
// Load Instructions
`define LB_func3     3'b000 // Load byte
`define LH_func3     3'b001 // Load halfword
`define LW_func3     3'b010 // Load word
`define LBU_func3    3'b100 // Load byte unsigned
`define LHU_func3    3'b101 // Load halfword unsigned

// Store Instructions
`define SB_func3     3'b000 // Store byte
`define SH_func3     3'b001 // Store halfword
`define SW_func3     3'b010 // Store word
*/ 

module LSFilter(
    input memread_MEM,
    input memwrite_MEM,     
    input [2:0] fun3_MEM, 
    input [31:0] writedata_MEM,  
    input [31:0] readdata_MEM,               
    output reg [31:0] writedata_F_MEM,  
    output reg [31:0] readdata_F_MEM        
);

    always @(*) begin
        // 默认值
        writedata_F_MEM = writedata_MEM;
        readdata_F_MEM = readdata_MEM;

        // Load 指令过滤处理
        if (memread_MEM) begin
            case (fun3_MEM)
                `LB_func3:  readdata_F_MEM = {{24{readdata_MEM[7]}}, readdata_MEM[7:0]}; // 符号扩展 8-bit
                `LH_func3:  readdata_F_MEM = {{16{readdata_MEM[15]}}, readdata_MEM[15:0]}; // 符号扩展 16-bit
                `LW_func3:  readdata_F_MEM = readdata_MEM; // 直接使用 32-bit
                `LBU_func3: readdata_F_MEM = {24'b0, readdata_MEM[7:0]}; // 零扩展 8-bit
                `LHU_func3: readdata_F_MEM = {16'b0, readdata_MEM[15:0]}; // 零扩展 16-bit
                default:    readdata_F_MEM = readdata_MEM;
            endcase
        end

        // Store 指令过滤处理
        if (memwrite_MEM) begin
            case (fun3_MEM)
                `SB_func3:  writedata_F_MEM = {24'b0, writedata_MEM[7:0]}; // 仅存储低8-bit
                `SH_func3:  writedata_F_MEM = {16'b0, writedata_MEM[15:0]}; // 仅存储低16-bit
                `SW_func3:  writedata_F_MEM = writedata_MEM; // 直接存储32-bit
                default:    writedata_F_MEM = writedata_MEM;
            endcase
        end
    end

endmodule

    /*
    LSFilter LSFilter (
        .memread_MEM(memread_MEM),
        .memwrite_MEM(memwrite_MEM),
        .fun3_MEM(fun3_MEM),
        .writedata_MEM(writedata_MEM),
        .readdata_MEM(readdata_MEM),
        .writedata_F_MEM(writedata_DMEM),
        .readdata_F_MEM(readdata_F_MEM)
    );
    */

