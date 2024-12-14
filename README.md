## 架構圖

![image](https://github.com/f14106032ncku/CPU_vsd_2024/blob/main/architecture_ref.png)
#### 不同的地方
* 刪除ALU_controll(ALU控制訊號直接送opcode, fun3, fun7)
* 刪除pipeline_flush(flush跟branch一樣)

## 剩下TOP.v

## 驗過的

fetch


---

```
            
**************************               
*                        *       |\__||  
*  Congratulations !!    *      / O.O  | 
*                        *    /_____   | 
*  Simulation PASS!!     *   /^ ^ ^ \\  |
*                        *  |^ ^ ^ ^ |w| 
**************************   \\m___m__|_|

```

/*
Interfaces for all block
*/

// ALU.v
// Arithmetic Logic Unit - 處理算術與邏輯運算
input [6:0] opcode,       // 操作碼
input [2:0] func3,        // 功能碼 (3位)
input [6:0] func7,        // 功能碼 (7位)
input [31:0] operand1,    // 第一操作數
input [31:0] operand2,    // 第二操作數

output reg [31:0] alu_out,// ALU 運算結果
output non_operation      // 是否為非操作 //idk

// controller.v
// 控制單元 - 負責產生控制信號
input [6:0] opcode,       // 操作碼
input stall,              // 暫停信號

output reg branch,        // 分支信號
output reg memread,       // 記憶體讀取信號
output reg memtoreg,      // 寄存器寫入數據來自記憶體
output reg memwrite,      // 記憶體寫入信號
output reg aluSrc,        // ALU 操作數來源 (立即數或寄存器)
output reg regwrite,      // 寄存器寫入信號
output reg [1:0] Aluop;   // ALU 操作碼選擇

// Decoder.v
// 指令解碼器 - 提取指令的各個字段
input [31:0] ir,          // 指令寄存器內容
output [4:0] rs1,         // 第一來源寄存器
output [4:0] rs2,         // 第二來源寄存器
output [4:0] rd,          // 目標寄存器
output [6:0] opcode,      // 操作碼
output [2:0] fun3,        // 功能碼 (3位)
output [6:0] fun7         // 功能碼 (7位)

// Exmem.v
// EX/MEM 暫存器 - 儲存執行階段到記憶體階段的中間數據
input clk, rst,           // 時脈與重置信號
input [31:0] pc_branch_EX,// 分支目標地址
input [31:0] alu_out,      // ALU 結果
input non_operation,            // Zero Flag
input [31:0] writedata_EX,// 寫入數據
input [4:0] rd_EX,        // 寄存器目標
input branch_EX, memread_EX, memtoreg_EX, memwrite_EX, regwrite_EX, // 控制信號
input flush,              // 清除信號
input branch_taken_EX,    // 分支是否被採納

output reg [31:0] pc_branch_MEM,// 分支目標地址輸出
output reg zero_MEM,           // Zero Flag 輸出
output reg [31:0] alu_MEM,     // ALU 結果輸出
output reg [31:0] writedata_MEM,// 寫入數據輸出
output reg [4:0] rd_MEM,       // 寄存器目標輸出
output reg branch_MEM, memread_MEM, memtoreg_MEM, memwrite_MEM, regwrite_MEM,// 控制信號輸出
output reg branch_taken_MEM    // 分支採納輸出

// Forward.v
// 前饋單元 - 處理資料相關性
input [4:0] RS1,          // 來源寄存器1
input [4:0] RS2,          // 來源寄存器2
input [4:0] rdMem,        // EX/MEM 寄存器目標
input [4:0] rdWb,         // MEM/WB 寄存器目標
input regWrite_Wb,        // MEM/WB 寄存器寫入
input regWrite_Mem,       // EX/MEM 寄存器寫入
output [1:0] Forward_A,   // 前饋選擇信號 A
output [1:0] Forward_B    // 前饋選擇信號 B

// Hazard.v
// 資料冒險處理 - 偵測與處理冒險情況
input MEMr_IDEX,          // ID/EX 記憶體讀取信號
input [31:0] ir,          // 指令
input [4:0] rd_IDEX,      // ID/EX 寄存器目標
output stall              // 暫停信號輸出

// IDEX.v
// ID/EX 暫存器 - 儲存解碼階段到執行階段的中間數據
input clk, rst,           // 時脈與重置信號
input [6:0] opcode_ID,    // 操作碼
input [2:0] fun3_ID,      // 功能碼 (3位)
input [6:0] fun7_ID,      // 功能碼 (7位)
input [31:0] pc_ID,       // 程式計數器
input [31:0] readdata1_ID,// 來源寄存器1數據
input [31:0] readdata2_ID,// 來源寄存器2數據
input [31:0] imm_data_ID, // 立即數
input [4:0] rs1_ID,       // 來源寄存器1
input [4:0] rs2_ID,       // 來源寄存器2
input [4:0] rd_ID,        // 目標寄存器
input branch_ID, memread_ID, memtoreg_ID, memwrite_ID, alusrc_ID, regwrite_ID,// 控制信號
input flush,              // 清除信號

output reg [31:0] pc_EX,  // 執行階段的程式計數器
output reg [4:0] rs1_EX,  // 來源寄存器1輸出
output reg [4:0] rs2_EX,  // 來源寄存器2輸出
output reg [4:0] rd_EX,   // 目標寄存器輸出
output reg [31:0] imm_data_EX,// 立即數輸出
output reg [31:0] readdata1_EX,// 來源寄存器1數據輸出
output reg [31:0] readdata2_EX,// 來源寄存器2數據輸出
output reg [6:0] opcode_EX,// 操作碼輸出
output reg [2:0] fun3_EX, // 功能碼 (3位)
output reg [6:0] fun7_EX, // 功能碼 (7位)
output reg branch_EX, memread_EX, memtoreg_EX, memwrite_EX, regwrite_EX, alusrc_EX// 控制信號輸出

// IFID.v
// IF/ID 暫存器 - 儲存取指階段到解碼階段的中間數據
input clk, rst,           // 時脈與重置信號
input [31:0] ir_IF,       // 指令記憶體輸出
input [31:0] pc_IF,       // 程式計數器輸出
input flush,              // 清除信號
input hazard_ifid,        // 冒險暫停信號
output reg [31:0] ir_ID,  // 解碼階段的指令
output reg [31:0] pc_ID   // 解碼階段的程式計數器

// MEMWB.v
// MEM/WB 暫存器 - 儲存記憶體階段到寫回階段的中間數據
input clk, rst,           // 時脈與重置信號
input [31:0] readdata_MEM,// 記憶體讀取數據
input [31:0] alu_MEM,     // ALU 結果
input [4:0] rd_MEM,       // 目標寄存器
input memtoreg_MEM, regwrite_MEM,// 控制信號
output reg [31:0] readdata_WB,// 寄存器數據輸出
output reg [31:0] alu_WB, // ALU 結果輸出
output reg [4:0] rd_WB,   // 寄存器目標輸出
output reg memtoreg_WB, regwrite_WB// 控制信號輸出

// fetch.v
// 指令取值 - 負責從指令記憶體讀取指令
input clk, rst, stall, wb,// 時脈、重置、暫停、寫回信號
input [31:0] pc_addr;     // 程式計數器地址輸入

// mem.v
// 記憶體 - 負責讀寫數據
input clk,                // 時脈信號
input wen,                // 寫使能信號
input [31:0] wdata, addr, // 寫入數據和地址
output[31:0] rdata        // 讀取數據輸出
output [31:0] pc_out, ir_out; // 程式計數器與指令輸出

// pc.v
// 程式計數器 - 負責記錄當前指令地址
input clk, rst, stall,    // 時脈、重置、暫停信號
input [31:0] pc_in,       // 輸入程式計數器地址
output reg [31:0] pc_out  // 輸出程式計數器地址

// registerFile.v
// 寄存器檔案 - 儲存暫存數據
input clk,                // 時脈信號
input [4:0] rs1,          // 第一來源寄存器
input [4:0] rs2,          // 第二來源寄存器
input [4:0] rd,           // 目標寄存器
input [31:0] wdata,       // 寫入數據
input wen,                // 寫使能信號
output reg[31:0] rdata1,  // 第一來源寄存器數據
output reg[31:0] rdata2   // 第二來源寄存器數據
