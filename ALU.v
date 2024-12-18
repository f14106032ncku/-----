`include "const.svh"
module ALU (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] alu_out,
    output non_operation
);
    always @(*)
    begin
        case (opcode)
            `OP_I:begin
                case (func3)
                    `ADDI_func3:begin
                        alu_out = operand1 + operand2;
                        $display("ALU: ADDI_func3: %d + %d = %d", operand1, operand2, alu_out);
                    end
                    `SLTI_func3:alu_out=($signed(operand1) < $signed(operand2))?32'b1:32'b0;
                    `SLTIU_func3:alu_out = (operand1 < operand2)?32'b1:32'b0;
                    `XORI_func3:alu_out = operand1 ^ operand2;
                    `ORI_func3:alu_out = operand1 | operand2;
                    `ANDI_func3:alu_out = operand1 & operand2;
                    `SLLI_func3:alu_out = operand1 << operand2[4:0];
                    `SRLI_func3:begin
                        case (func7)
                        `LOGIC:alu_out = operand1 >> operand2[4:0];
                        `ARITH:alu_out = $signed(operand1) >>> operand2[4:0];
                        default:begin  
                            alu_out=32'b0;
                        end                          
                        endcase
                    end
                    default:begin  
                        alu_out=32'b0;
                    end
                endcase
            end
            `OP_R:begin
                case (func3)
                    `ADD_func3:begin
                        case (func7)
                            `ADD:alu_out = operand1 + operand2;
                            `SUB:alu_out = operand1 - operand2;
                        default:begin  
                            alu_out=32'b0;
                        end                             
                        endcase                         
                        end
                    `SLL_func3:alu_out = operand1 << operand2[4:0];
                    `SLT_func3:alu_out = ($signed(operand1) < $signed(operand2))?32'b1:32'b0;
                    `SLTU_func3:alu_out = (operand1 < operand2)?32'b1:32'b0;
                    `XOR_func3:alu_out = operand1 ^ operand2;
                    `SRL_func3:begin
                        case (func7)
                        `LOGIC:alu_out = operand1 >> operand2[4:0];
                        `ARITH:alu_out = $signed(operand1) >>> operand2[4:0];
                        default:begin  
                            alu_out=32'b0;
                        end                        
                        endcase
                    end
                    `OR_func3:alu_out = operand1 | operand2;
                    `AND_func3:alu_out = operand1 & operand2;
                    default:begin  
                        alu_out=32'b0;
                    end
                endcase
            end
           `OP_B:begin
                case(func3)
                    `BEQ_func3:alu_out=(operand1 == operand2)?`TRUE:`FALSE;
                    `BNE_func3:alu_out=(operand1 == operand2)?`FALSE:`TRUE;
                    `BLT_func3:alu_out=($signed(operand1) <$signed(operand2))?`TRUE:`FALSE;  
                    `BGE_func3:alu_out=($signed(operand1) >=$signed(operand2))?`TRUE:`FALSE; 
                    `BLTU_func3:alu_out=(operand1<operand2)?`TRUE:`FALSE;  
                    `BGEU_func3:alu_out=(operand1>=operand2)?`TRUE:`FALSE;
                    default:begin  
                        alu_out=32'b0;
                    end   
                endcase
           end
            `OP_L:begin
                case (func3)
                    `LB_func3:alu_out=operand1+operand2;
                    `LH_func3:alu_out=operand1+operand2;
                    `LW_func3:alu_out=operand1+operand2;
                    `LBU_func3:alu_out=operand1+operand2;
                    `LHU_func3:alu_out=operand1+operand2;
                    default:begin  
                        alu_out=32'b0;
                    end
                endcase
            end
            `OP_S:begin
                case(func3)
                    `SB_func3:alu_out=operand1+operand2;
                    `SH_func3:alu_out=operand1+operand2;
                    `SW_func3:alu_out=operand1+operand2;
                    default:begin  
                        alu_out=32'b0;
                    end
                endcase
            end
            `LUI:alu_out={operand2[31:12],12'b0};
            `AUIPC:alu_out=operand1+{operand2[31:12],12'b0};
            `JAL:alu_out=operand1+32'd4;
            `JALR:alu_out=operand1+32'd4;
            default:begin  
                alu_out=32'b0;
            end
        endcase
    end
   assign non_operation = (alu_out == 32'b0) ? 1'b1 : 1'b0;
endmodule
