module Hazard ( // Load-used Hazard
    input MEMr_IDEX, // ID/EX.MemRead
    input [31:0] ir, // instruction
    input [4:0] rd_IDEX, // ID/EX.RegisterRd
    output stall 
);
    // Decode instruction source registers
    wire [4:0] rs1_IFID = ir[19:15];
    wire [4:0] rs2_IFID = ir[24:20];

    //ID/EX.MemRead and ((ID/EX.RegisterRd = IF/ID.RegisterRs1) or (ID/EX.RegisterRd = IF/ID.RegisterRs2))
    wire stall = MEMr_IDEX && ((rd_IDEX == rs1_IFID) || (rd_IDEX == rs2_IFID));

endmodule
