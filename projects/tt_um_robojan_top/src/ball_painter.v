`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/09/2023 11:43:48 AM
// Design Name:
// Module Name: ball_drawer
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


module p18_ball_painter(
    input clk,
    input nRst,
    output in_ball,
    output in_ball_top,
    output in_ball_bottom,
    output in_ball_left,
    output in_ball_right,
    output [5:0] color,
    input [9:0] x,
    input [8:0] y,
    input [9:0] hpos,
    input [8:0] vpos,
    input line_pulse,
    input display_active
    );

    // Pixel ball positions:
    //      0 1   2 3
    //    T T T T T T R
    // 0  L   X X X   R
    // 1  L X X X X X R
    //    L X X X X X R
    // 2  L X X X X X R
    // 3  L   X X X   R
    //    L B B B B B B

    // Pixel ball positions:
    //   0 1   2 3
    // 0   X X X
    // 1 X X X X X
    //   X X X X X
    // 2 X X X X X
    // 3   X X X

    // Pixel ball colision regions:
    //   0 1   2 3
    // 0 T T T T R
    // 1 L       R
    //   L       R
    // 2 L       R
    // 3 L B B B B

    //                        BBGGRR
    parameter BALL_COLOR = 6'b001100;

    wire is_ball_line_start = x == hpos;
    wire is_ball_start = display_active && is_ball_line_start && y == vpos;

    reg [2:0] ball_x;
    reg [2:0] ball_y;
    reg is_in_ball_line;
    reg is_in_ball_rows;

    wire x0 = ball_x == 0 && is_in_ball_line;
    wire x3 = ball_x == 4 && is_in_ball_line;
    wire y0 = ball_y == 0 && is_in_ball_rows;
    wire y3 = ball_y == 4 && is_in_ball_rows;

    wire gt_x0 = is_in_ball_line;
    wire gt_x1 = is_in_ball_line && !x0;
    wire lt_x2 = is_in_ball_line && !x3;
    wire lt_x3 = is_in_ball_line;
    wire gt_y0 = is_in_ball_rows;
    wire gt_y1 = is_in_ball_rows && !y0;
    wire lt_y2 = is_in_ball_rows && !y3;
    wire lt_y3 = is_in_ball_rows;

    wire is_ball_line_end = x3;
    wire is_ball_rows_end = y3;

    // Latch that enables the ball x counter
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            is_in_ball_line <= 0;
        end else begin
            if(is_ball_line_start) begin
                is_in_ball_line <= 1;
            end else if(is_ball_line_end) begin
                is_in_ball_line <= 0;
            end
        end
    end

    // Ball x counter
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            ball_x <= 0;
        end else begin
            if(is_in_ball_line) begin
                ball_x <= ball_x + 1'b1;
            end else begin
                ball_x <= 0;
            end
        end
    end

    // Latch that enables the ball y counter
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            is_in_ball_rows <= 0;
        end else begin
            if(is_ball_start) begin
                is_in_ball_rows <= 1;
            end else if(is_ball_rows_end && line_pulse) begin
                is_in_ball_rows <= 0;
            end
        end
    end

    // Ball y counter
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            ball_y <= 0;
        end else begin
            if(line_pulse) begin
                if(is_in_ball_rows) begin
                    ball_y <= ball_y + 1'b1;
                end else begin
                    ball_y <= 0;
                end
            end
        end
    end

    // Ball area
    wire left_lobe = gt_x0 && lt_x2 && gt_y1 && lt_y2;
    wire right_lobe = gt_x1 && lt_x3 && gt_y1 && lt_y2;
    wire top_lobe = gt_x1 && lt_x2 && gt_y0 && lt_y2;
    wire bottom_lobe = gt_x1 && lt_x2 && gt_y1 && lt_y3;
    assign in_ball = left_lobe || right_lobe || top_lobe || bottom_lobe;

    // Ball collision regions
    assign in_ball_top = y0 && !x3;
    assign in_ball_left = x0 && !y0;
    assign in_ball_bottom = y3 && !x0;
    assign in_ball_right = x3 && !y3;

    assign color = BALL_COLOR;
endmodule
