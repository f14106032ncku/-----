module IFID(
    input clk,
    input rst,
    input [31:0] ir_IF,
    input [31:0] pc_IF, 
    input flush, 
    input hazard_ifid, // stall when hazard
    output reg [31:0] ir_ID,
    output reg [31:0] pc_ID
  );
  always @(posedge clk) begin
      if (rst || flush) begin
          ir_ID  <= 32'b0;
          pc_ID <= 32'b0;
      end
      else if (hazard_ifid) begin // stall when hazard
          ir_ID <= ir_ID;
          pc_ID <= pc_ID;
      end 
	  else begin
          ir_ID <= ir_IF;
          pc_ID <= pc_IF;
      end
    end
endmodule