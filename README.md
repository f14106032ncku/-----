### 架構圖

![image](https://github.com/f14106032ncku/CPU_vsd_2024/blob/main/architecture_ref.png)
## 不同的地方
* 刪除ALU_controll(ALU控制訊號直接送opcode, fun3, fun7)
* 刪除pipeline_flush(flush跟branch一樣)

### 剩下TOP.v

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
