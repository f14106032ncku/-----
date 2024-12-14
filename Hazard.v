module Hazard ( // Load-used Hazard
    input memread_EX, // ID/EX.MemRead
    input [31:0] ir_ID, // instruction
    input [4:0] rd_EX, // ID/EX.RegisterRd
    output stall 
);
    // Decode instruction source registers
    wire [4:0] rs1_IFID = ir_ID[19:15];
    wire [4:0] rs2_IFID = ir_ID[24:20];

    //ID/EX.MemRead and ((ID/EX.RegisterRd = IF/ID.RegisterRs1) or (ID/EX.RegisterRd = IF/ID.RegisterRs2))
    assign stall = memread_EX && ((rd_EX == rs1_IFID) || (rd_EX == rs2_IFID));

endmodule
