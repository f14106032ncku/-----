module Hazard ( // Load-used Hazard
    input memread_EX,           // ID/EX.MemRead
    input [31:0] ir_ID,         // Instruction
    input [4:0] rd_EX,          // ID/EX.RegisterRd
    input taken_MEM,            // Prediction miss
    input BP_ID,                // Branch prediction in ID stage

    output reg flush_IFID,      // Flush IF/ID stage
    output reg flush_IDEX,      // Flush ID/EX stage
    output reg flush_EXMEM,     // Flush EX/MEM stage
    output reg [1:0] pc_sel,    // PC selection signal
    output stall            // Stall signal for hazard detection
);

    // Decode instruction source registers
    wire [4:0] rs1_IFID = ir_ID[19:15]; // Source register 1
    wire [4:0] rs2_IFID = ir_ID[24:20]; // Source register 2

    // Load-use hazard detection:
    // ID/EX.MemRead and ((ID/EX.RegisterRd == IF/ID.RegisterRs1) or (ID/EX.RegisterRd == IF/ID.RegisterRs2))
    assign stall = memread_EX && ((rd_EX == rs1_IFID) || (rd_EX == rs2_IFID));

    // ---- Flush control signals ----
    always @(*) begin        
        // Branch flush: Use the PC from MEM stage (flush all pipeline stages)
        if (taken_MEM) begin
            pc_sel = 2'b01;  // next_pc
            flush_IFID  = 1;
            flush_IDEX  = 1;
            flush_EXMEM = 1;
        end 
        // Handle load-use hazard: Insert a stall
        else if (stall) begin
            pc_sel = 2'b11;  // pc 
            flush_IDEX = 1;  // Flush ID/EX stage to prevent using stale data
        end 
        // Handle branch prediction
        else if (BP_ID) begin
            pc_sel = 2'b10;  // pc_BP
            flush_IFID = 1;  // Flush IF/ID stage to correct the prediction
        end
        // Default case: Sequential execution (PC + 1)
        else begin
            pc_sel = 2'b00;  // pc + 1
            flush_IFID  = 0;
            flush_IDEX  = 0;
            flush_EXMEM = 0;
        end
    end

endmodule
