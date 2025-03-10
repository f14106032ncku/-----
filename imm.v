module imm(
  input [31:0] ir,
  output [31:0] imme
  );
  
	assign imme = (ir[6:0] == 7'b0000011 || ir[6:0] == 7'b0010011 || ir[6:0] == 7'b1100111) ? {20'b0, ir[31:20]} : //I-type
			   (ir[6:0] == 7'b0100011) ? {20'b0, ir[31:25], ir[11:7]} :					    //S-type
			   (ir[6:0] == 7'b1100011) ? {{20{ir[31]}}, ir[31], ir[7], ir[30:25], ir[11:8]} :		    //B-type
			   (ir[6:0] == 7'b0110111 || ir[6:0] == 7'b0010111) ? {ir[31:12], 12'b0} :			    //U-type
			   (ir[6:0] == 7'b1101111) ? {12'b0, ir[31], ir[19:12], ir[20], ir[30:21]} : 32'b0;	    //J-type
endmodule
