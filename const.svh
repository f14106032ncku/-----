/*
    * const.svh
    * 
    * This file contains all the constants used in the project.
    *
    *When add another constant, please add a comment to explain the purpose of the constant.
    *
    *And make sure to add the constant in the appropriate bits like 5b'00000 and don't use 00000!!!

*/
`define OP_R     7'b0110011 
`define OP_I     7'b0010011
`define LUI      7'b0110111
`define AUIPC    7'b0010111
`define JAL      7'b1101111
`define JALR     7'b1100111
`define OP_B     7'b1100011
`define OP_L     7'b0000011
`define OP_S     7'b0100011

// Boolean
`define TRUE     1'b1
`define FALSE    1'b0

// RV32I Instruction func3 Encodings

// Integer Register-Immediate Instructions
`define ADDI_func3   3'b000 // Add immediate
`define SLTI_func3   3'b010 // Set less than immediate
`define SLTIU_func3  3'b011 // Set less than immediate unsigned
`define XORI_func3   3'b100 // Bitwise XOR immediate
`define ORI_func3    3'b110 // Bitwise OR immediate
`define ANDI_func3   3'b111 // Bitwise AND immediate
`define SLLI_func3   3'b001 // Shift left logical immediate
`define SRLI_func3   3'b101 // Shift right logical immediate (unsigned)
// `define SRAI_func3   3'b101 // Shift right arithmetic immediate (overloaded by funct7)

// Integer Register-Register Instructions
`define ADD_func3    3'b000 // Add
// `define SUB_func3    3'b000 // Subtract (overloaded by funct7)
`define SLL_func3    3'b001 // Shift left logical
`define SLT_func3    3'b010 // Set less than
`define SLTU_func3   3'b011 // Set less than unsigned
`define XOR_func3    3'b100 // Bitwise XOR
`define SRL_func3    3'b101 // Shift right logical
// `define SRA_func3    3'b101 // Shift right arithmetic (overloaded by funct7)
`define OR_func3     3'b110 // Bitwise OR
`define AND_func3    3'b111 // Bitwise AND

// Branch Instructions
`define BEQ_func3    3'b000 // Branch if equal
`define BNE_func3    3'b001 // Branch if not equal
`define BLT_func3    3'b100 // Branch if less than
`define BGE_func3    3'b101 // Branch if greater than or equal
`define BLTU_func3   3'b110 // Branch if less than unsigned
`define BGEU_func3   3'b111 // Branch if greater than or equal unsigned

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

// RV32I Instruction func7 Encodings

// Logic & Arithmetic
`define LOGIC        7'b0000000 // Logical operations
`define ARITH        7'b0100000 // Arithmetic operations

// ADD & SUB
`define ADD          7'b0000000 // Add operation
`define SUB          7'b0100000 // Subtract operation
