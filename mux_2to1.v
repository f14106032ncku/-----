module mux_2to1 (in_0, in_1, sel, out);
input [31:0] in_0, in_1;
input sel;
output reg [31:0] out;
	always @(in_0 or in_1 or sel) begin
		case (sel)
		1'b0:
		  out = in_0;
		1'b1:
		  out = in_1;
		endcase
	end
endmodule

