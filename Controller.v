`include "const.svh"
module controller(
  input [6:0] opcode,
  input stall, 
  
  output reg branch,
  output reg memread,
  output reg memtoreg,
  output reg memwrite,
  output reg aluSrc,
  output reg regwrite,
  output reg [1:0] Aluop);
  
  always @(*)
    begin
      if (stall) begin
        aluSrc = 1'b0;
        memtoreg = 1'b0;
        regwrite = 1'b0;
        memread = 1'b0;
        memwrite = 1'b0;
        branch = 1'b0;
        Aluop = 2'b00;
      end else begin
        case (opcode)
          `OP_L: begin // 7'b0000011
            aluSrc = 1'b1;
            memtoreg = 1'b1;
            regwrite = 1'b1;
            memread = 1'b1;
            memwrite = 1'b0;
            branch = 1'b0;
            Aluop = 2'b00;
          end
         `OP_S: begin // 7'b0100011
            aluSrc = 1'b1;
            memtoreg = 1'bx;
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b1;
            branch = 1'b0;
            Aluop = 2'b00;
          end
          `OP_R: begin // 7'b0110011
            aluSrc = 1'b0;
            memtoreg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            Aluop = 2'b10;
          end
          `OP_B: begin // 7'b1100011
            aluSrc = 1'b0;
            memtoreg = 1'bx;
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b1;
            Aluop = 2'b01;
          end
          `OP_I: begin // 7'b0010011
            aluSrc = 1'b1;
            memtoreg = 1'b0;
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            Aluop = 2'b00;
          end
          `JAL: begin // 7'b1101111
            aluSrc = 1'b0;
            memtoreg = 1'b0; // Write return address (alu_out = pc + 1) to rd
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b1; // Jumps always involve a branch
            Aluop = 2'b00;
          end
          `JALR: begin // 7'b1100111 
            aluSrc = 1'b1; // JALR involves a register + immediate computation
            memtoreg = 1'b0; // Write return address (alu_out = pc + 1) to rd
            regwrite = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b1; // JALR also involves a jump (branch)
            Aluop = 2'b00;
          end
          default: begin
            aluSrc = 1'b0;
            memtoreg = 1'b0;
            regwrite = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            branch = 1'b0;
            Aluop = 2'b00;
          end
        endcase
      end
    end
endmodule
