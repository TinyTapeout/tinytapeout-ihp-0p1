`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/09/2023 10:06:41 AM
// Design Name:
// Module Name: video_mux
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


module p18_video_mux(
    output reg [5:0] out,
    input in_frame,
    input [5:0] background,
    input [5:0] border,
    input border_en,
    input [5:0] ball,
    input ball_en,
    input [5:0] paddle,
    input paddle_en,
    input [5:0] blocks,
    input blocks_en,
    input [5:0] lives,
    input lives_en
    );

    always @(*)
    begin
        if (!in_frame) begin // In blanking. Output black to give the screen something to calibrate on.
            out <= 6'b000000;
        end else if (border_en) begin
            out <= border;
        end else if (paddle_en) begin
            out <= paddle;
        end else if (blocks_en) begin
            out <= blocks;
        end else if (ball_en) begin
            out <= ball;
        end else if (lives_en) begin
            out <= lives;
        end else begin
            out <= background;
        end
    end
endmodule
