`timescale 1ns / 1ps

`ifdef syn
    `include "tsmc18.v" 
    `include "top_syn.v" 
`else
    `include "top.v" 
`endif

`include "memory.v"  
`include "RegisterFile.v" 

module tb();
  reg clk, rst;
  
  RISC_V CPU1
  (
    .clk(clk),
    .rst(rst)
  );
  // Annotate timing information for synthesis
  `ifdef SYN
    initial $sdf_annotate("top_syn.sdf", CPU);
  `endif 
  
  // clk reset
  initial begin : clk_reset
    clk = 1'b1;
    rst = 1'b1; 
    #10 rst = 1'b0; // Release reset after 10 time units
    #10000 $finish;
  end

  // read prog to mem
  initial begin : prog_load
    // Load program instructions into memory
    $readmemb("ir.txt", top.data_mem);     
  end

  // Dump waveform for debugging
  initial begin : wave
    $dumpfile("top.fsdb");
    $dumpvars;
  end

  // Generate clock signal
  always #5 clk = ~clk;

  // Check CPU status
  always @(posedge clk) begin
    // Monitor signals at the rising edge of the clock
    $display("Time: %0t |", 
             $time);
  end
endmodule
