`include "const.svh" // opcode = `OP_B, `JAL_type, `JALr_type, ...

module NextPC(
    input BP_EX, // Branch Prediction from EX stage
    input [6:0] opcode,
    input  [31:0] operand1,    // For JALr_type (rs1 value)
    input  [31:0] alu_result,  // Branch compare result (used for branch_type instructions)
    input  [31:0] pc,          // Current PC
    input  [31:0] imm,         // Branch immediate value (for JAL_type, JALr_type, BEQ, etc.)
    output BP_update,             // BP_Update BP (Branch Prediction)
    output BP_taken,              // Indicates if the branch_type is taken
    output taken,               // Prediction miss
    output [31:0] nextpc       // Next PC address
);

    // B JAL_type JALr_type
    wire branch_type = (opcode == `OP_B);
    wire jal_type = (opcode == `JAL);
    wire jalr_type = (opcode == `JALR);

    // Branch is taken or not
    wire branch_taken = (branch_type && alu_result != 32'b0);   

    // Update BP when branch_type
    assign BP_update = branch_type;
    assign BP_taken = branch_taken;    

    // Determine Branch flush
    assign taken = ((BP_EX != branch_taken) || (jal_type) || (jalr_type));         
       
    // Select next PC:
    assign nextpc = (jal_type) ? pc + imm :    // JAL_type: jump to pc + imm
                    (jalr_type) ? (operand1 + imm) : // JALr_type: jump to rs1 + imm
                    (branch_taken) ? pc + imm :   // If branch_type is taken
                    pc + 1; // Default: Sequential execution (next instruction)                 

endmodule
