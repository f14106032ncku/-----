## 架構圖

![image](https://github.com/f14106032ncku/CPU_vsd_2024/blob/main/architecture_ref.png)
#### 不同的地方
* 刪除ALU_controll(ALU控制訊號直接送opcode, fun3, fun7)
* 刪除pipeline_flush(flush跟branch一樣)
* B type format
* pc<=pc+1 沒有做imme shift left 1
<img width="541" alt="image" src="https://github.com/user-attachments/assets/0bbd965a-bad3-4ad8-8850-4da2a447d8ce" />



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
