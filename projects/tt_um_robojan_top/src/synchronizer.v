`timescale 1ns / 1ps

module p18_synchronizer
#(
    parameter WIDTH = 1,
    parameter DEFAULT_VALUE = 1'b0
) (
    input clk,
    input nRst,
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] reg1;
    reg [WIDTH-1:0] reg2;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            reg1 <= DEFAULT_VALUE;
            reg2 <= DEFAULT_VALUE;
        end else begin
            reg1 <= in;
            reg2 <= reg1;
        end
    end

    assign out = reg2;
endmodule
