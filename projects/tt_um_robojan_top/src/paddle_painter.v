`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/09/2023 11:43:48 AM
// Design Name:
// Module Name: paddle_drawer
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


module p18_paddle_painter #(
    //                          BBGGRR
    parameter PADDLE_COLOR = 6'b111111,
    parameter PADDLE_SEGMENT_WIDTH = 8,
    parameter PADDLE_NUM_SEGMENTS = 6,
    parameter PADDLE_HEIGHT = 9'd8,
    parameter PADDLE_Y =  9'd456
) (
    input clk,
    input nRst,
    output in_paddle,
    output [5:0] color,
    input [9:0] hpos,
    input [8:0] vpos,
    input [9:0] x,
    output [2:0] paddle_segment
    );

    reg in_paddle_x;
    reg [2:0] paddle_segment_x;
    reg [2:0] paddle_segment_cnt;
    wire paddle_x_start = hpos == x;
    wire paddle_segment_end = paddle_segment_x == PADDLE_SEGMENT_WIDTH - 1;
    wire paddle_x_end = paddle_segment_end && paddle_segment_cnt == PADDLE_NUM_SEGMENTS - 1;
    assign paddle_segment = paddle_segment_cnt;

    // Paddle segment position counter
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            paddle_segment_x <= 0;
        end else begin
            if(in_paddle_x && !paddle_segment_end) begin
                paddle_segment_x <= paddle_segment_x + 1'b1;
            end else begin
                paddle_segment_x <= 0;
            end
        end
    end

    // Paddle segment counter
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            paddle_segment_cnt <= 0;
        end else begin
            if(paddle_x_end) begin
                paddle_segment_cnt <= 0;
            end else if(paddle_segment_end) begin
                paddle_segment_cnt <= paddle_segment_cnt + 1'b1;
            end
        end
    end

    // Are we in the paddle?
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            in_paddle_x <= 0;
        end else begin
            if(paddle_x_start) begin
                in_paddle_x <= 1;
            end else if(paddle_x_end) begin
                in_paddle_x <= 0;
            end
        end
    end

    reg in_paddle_y;
    wire in_paddle_y_start = vpos == PADDLE_Y;
    wire in_paddle_y_end = vpos == PADDLE_Y + PADDLE_HEIGHT;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            in_paddle_y <= 0;
        end else begin
            if(in_paddle_y_start) begin
                in_paddle_y <= 1;
            end else if(in_paddle_y_end) begin
                in_paddle_y <= 0;
            end
        end
    end

    assign color = PADDLE_COLOR;
    assign in_paddle = in_paddle_x && in_paddle_y;
endmodule
