module registerFile(
  input clk,
//  input reset,
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,
  input [31:0] wdata,
  input wen,
  output reg[31:0] rdata1,
  output reg[31:0] rdata2
);
  // integer i;
  reg [31:0] registers [31:0];
 
  always @ (*)
    begin
          rdata1 = registers[rs1];
          rdata2 = registers[rs2];
    end
  always @(negedge clk) begin
    // 當 wen = 1 且 rd != 0 時，才允許寫入
    if (wen == 1 && rd != 0) begin
      registers[rd] <= wdata;
    end
    else registers[rd] <= registers[rd];
    // 無論如何，都要確保 r0 永遠為 0
    registers[0] <= 32'b0;
  end

endmodule
