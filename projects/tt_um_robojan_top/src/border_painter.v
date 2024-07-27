`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/09/2023 11:04:48 AM
// Design Name:
// Module Name: border_generator
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module p18_border_painter
#(
    parameter BORDER_WIDTH = 8
)(
    output in_border,
    output [5:0] color,
    input [9:0] hpos,
    input [8:0] vpos
);

    //                          BBGGRR
    parameter BORDER_COLOR = 6'b111111;
    parameter BORDER_LEFT = 10'd0;
    parameter BORDER_RIGHT = 10'd632;
    parameter BORDER_TOP = 9'd0;
    parameter BORDER_BIT_WIDTH = $clog2(BORDER_WIDTH);

    assign color = BORDER_COLOR;
    assign in_border = hpos[9:BORDER_BIT_WIDTH] == BORDER_LEFT[9:BORDER_BIT_WIDTH] ||
        hpos[9:BORDER_BIT_WIDTH] == BORDER_RIGHT[9:BORDER_BIT_WIDTH] ||
        vpos[8:BORDER_BIT_WIDTH] == BORDER_TOP[8:BORDER_BIT_WIDTH];
endmodule
