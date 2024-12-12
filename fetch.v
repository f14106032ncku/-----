`include "mux.v"
`include "pc.v"
`include "adder.v"
`include "memory.v"


module fetch (clk, rst, ,pc_en, wb, pc_addr , pc_out , ir_out);
	input clk,rst,pc_en,wb;
	input [31:0] pc_addr;
	output [31:0] pc_out,ir_out;
	
	wire [31:0] adder_out,pc_in;
	
pc pc(
    .clk(clk),
    .rst(rst),
    .pc_en(pc_en),
    .pc_in(pc_in),
    .pc_out(pc_out)
    );
	
mux_2to1 mux1(
    .in_0(adder_out),
    .in_1(pc_addr),
    .sel(wb),
    .out(pc_in)
    );
	
adder add(
    .a(pc_out),
    .b(32'd4),
    .sum(adder_out)
    );

mem ins_mem(
	.clk(clk),
    .wen(1'b0),
    .addr(pc_out),
    .rdata(ir_out)
    );	
	
	
endmodule