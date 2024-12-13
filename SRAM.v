module SRAM (
    input clk,
    input [3:0] wen,
    input [15:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);
    reg [7:0] mem [0:65535];
    always @(posedge clk)
    begin
        case (wen)
            4'b0001:
            begin
                mem[addr][7:0] <= wdata[7:0];
            end
            4'b0011:
            begin
                mem[addr + 1][7:0] <= wdata[15:8];
                mem[addr][7:0] <= wdata[7:0];
            end
            4'b0111:
            begin
                mem[addr + 2][7:0] <= wdata[23:16];
                mem[addr + 1][7:0] <= wdata[15:8];
                mem[addr][7:0] <= wdata[7:0];
            end
            4'b1111:
            begin
                mem[addr + 3][7:0] <= wdata[31:24];
                mem[addr + 2][7:0] <= wdata[23:16];
                mem[addr + 1][7:0] <= wdata[15:8];
                mem[addr][7:0] <= wdata[7:0];
            end
            default: 
            begin
                ;
            end
        endcase
    end
    always @(*)
    begin
        rdata[31:24] = mem[addr + 3][7:0];
        rdata[23:16] = mem[addr + 2][7:0];
        rdata[15:8] = mem[addr + 1][7:0];
        rdata[7:0] = mem[addr][7:0];
    end
endmodule