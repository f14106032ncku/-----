module Forward (
    input [4:0] RS1, // ID/EX.RegisterRs1
    input [4:0] RS2, // ID/EX.RegisterRs2
    input [4:0] rdMem, // EX/MEM.RegisterRd
    input [4:0] rdWb, // MEM/WB.RegisterRd

    input regWrite_Wb, // MEM/WB.RegWrite
    input regWrite_Mem, // EX/MEM.RegWrite
    output [1:0] Forward_A,
    output [1:0] Forward_B
);

    // Forward_A logic
    wire Forward_A_EXMEM = (rdMem == RS1) && (regWrite_Mem) && (rdMem != 0);
    wire Forward_A_MEMWB = (rdWb == RS1) && (regWrite_Wb) && (rdWb != 0) && !Forward_A_EXMEM;

    assign Forward_A = Forward_A_EXMEM ? 2'b10 : (Forward_A_MEMWB ? 2'b01 : 2'b00);

    // Forward_B logic
    wire Forward_B_EXMEM = (rdMem == RS2) && (regWrite_Mem) && (rdMem != 0);
    wire Forward_B_MEMWB = (rdWb == RS2) && (regWrite_Wb) && (rdWb != 0) && !Forward_B_EXMEM;

    assign Forward_B = Forward_B_EXMEM ? 2'b10 : (Forward_B_MEMWB ? 2'b01 : 2'b00);

endmodule
