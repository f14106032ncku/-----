module Branch_compare (
    input [31:0] operand1, // First operand
    input [31:0] operand2, // Second operand
    input [2:0] func3,     // Function code to determine branch type
    output branch_taken
);

    // Define branch conditions using wires
    wire beq_taken = (operand1 == operand2); // BEQ (Branch if Equal)
    wire bne_taken = (operand1 != operand2); // BNE (Branch if Not Equal)
    wire blt_taken = ($signed(operand1) < $signed(operand2)); // BLT (Branch if Less Than, signed)
    wire bge_taken = ($signed(operand1) >= $signed(operand2)); // BGE (Branch if Greater Than or Equal, signed)
    wire bltu_taken = (operand1 < operand2); // BLTU (Branch if Less Than, unsigned)
    wire bgeu_taken = (operand1 >= operand2); // BGEU (Branch if Greater Than or Equal, unsigned)

    // Assign branch_taken based on func3
    assign branch_taken = (func3 == 3'b000) ? beq_taken :
                          (func3 == 3'b001) ? bne_taken :
                          (func3 == 3'b100) ? blt_taken :
                          (func3 == 3'b101) ? bge_taken :
                          (func3 == 3'b110) ? bltu_taken :
                          (func3 == 3'b111) ? bgeu_taken :
                          1'b0; // Default case for undefined func3

endmodule
