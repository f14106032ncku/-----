module pc(
    input  clk, rst , stall, 
    input  [31:0] pc_in, 
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
        if(rst) pc_out <= 0; 
        else if(stall) pc_out <= pc_out; // pc stall
		else pc_out <= pc_in;
    end

endmodule
