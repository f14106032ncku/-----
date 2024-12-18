
module mux_3to1 (in_0, in_1 , in_2, sel, out);

    input [31:0] in_0, in_1,in_2;
    input [1:0] sel;
    output reg [31:0] out;

    always @(*)
    casex(sel)
        2'b00:
            out = in_0;
        2'b01:
            out = in_1;
        2'b10:
            out = in_2;
        default:
            out = 32'bx;
    endcase
endmodule

