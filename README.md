## 架構圖

![image](https://github.com/f14106032ncku/CPU_vsd_2024/blob/main/architecture_ref.png)

#### 不同的地方
![image](https://github.com/user-attachments/assets/0c47aef6-cfe4-4cca-bf1f-53d5c75c8d92)
* 刪除ALU_controll(ALU控制訊號直接送opcode, fun3, fun7)
* 刪除pipeline_flush(flush跟branch一樣)
* B type format
* pc<=pc+1 沒有做imme shift left 1
* jal rd, imm (pc+imm) | imm[19] | imm[9:0] | imm[10] | imm[18:11] | rd | opcode | 
* jalr rd, rs1, imm (rs1+imm) | imm[11:0] | rs1 | funct3 | rd | opcode |
* beq/bne/blt/bltu/bge/bgeu rs1, rs2, imm | imm[11] | imm[9:4] | rs2 | rs1 | funct3 | imm[3:0] | imm[10] | opcode |



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
