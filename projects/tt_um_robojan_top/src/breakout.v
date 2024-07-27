`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/07/2023 07:53:38 PM
// Design Name:
// Module Name: breakout
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


module p18_breakout
#(
    parameter PADDLE_SEGMENT_WIDTH = 8,
    parameter PADDLE_NUM_SEGMENTS = 6,
    parameter NUM_ROWS = 15,
    parameter BORDER_WIDTH = 8, // Must be a power of 2
    parameter INITIAL_BALL_X = 10'd320 - 3'd2,
    parameter INITIAL_BALL_Y = 9'd452 - 3'd2,
    parameter INITIAL_VEL_X = 4'sd2,
    parameter INITIAL_VEL_Y = -4'sd2
)(
    input clk,
    input nRst,
    input en,
    input btn_left_pin,
    input btn_right_pin,
    input btn_select_pin,
    output [1:0] vga_r,
    output [1:0] vga_g,
    output [1:0] vga_b,
    output vga_hsync,
    output vga_vsync,
    output vblank,
    output hblank,
    input sck_pin,
    input ss_pin,
    input mosi_pin,
    output miso,
    output miso_en,
    output sound_out
    );

    // Synchronize the inputs
    wire btn_left;
    wire btn_right;
    wire btn_select;
    wire sck;
    wire ss;
    wire mosi;
    p18_synchronizer btn_left_sync(clk, nRst, btn_left_pin, btn_left);
    p18_synchronizer btn_right_sync(clk, nRst, btn_right_pin, btn_right);
    p18_synchronizer btn_select_sync(clk, nRst, btn_select_pin, btn_select);
    p18_synchronizer sck_sync(clk, nRst, sck_pin, sck);
    p18_synchronizer ss_sync(clk, nRst, ss_pin, ss);
    p18_synchronizer mosi_sync(clk, nRst, mosi_pin, mosi);


    // Generate the VGA timing
    wire vga_hactive;
    wire [9:0] vga_hpos;
    wire vga_vactive;
    wire [8:0] vga_vpos;
    wire vga_line_pulse;
    wire vga_frame_pulse;
    wire vga_active;
    p18_vga_timing vga_timing(
        .clk(clk),
        .nRst(nRst),
        .hsync(vga_hsync),
        .hactive(vga_hactive),
        .hpos(vga_hpos),
        .vsync(vga_vsync),
        .vactive(vga_vactive),
        .vpos(vga_vpos),
        .active(vga_active),
        .line_pulse(vga_line_pulse),
        .frame_pulse(vga_frame_pulse)
    );
    assign vblank = !vga_vactive;
    assign hblank = !vga_hactive;

    // Video mux
    wire [5:0] video_out;
    wire [5:0] border_color;
    wire draw_border;
    wire [5:0] ball_color;
    wire draw_ball;
    wire [5:0] paddle_color;
    wire draw_paddle;
    wire [5:0] blocks_color;
    wire draw_blocks;
    wire [5:0] lives_color;
    wire draw_lives;
    p18_video_mux video_mux(
        .out(video_out),
        .in_frame(vga_active),
        .background(6'b000000),
        .border(border_color),
        .border_en(draw_border),
        .ball(ball_color),
        .ball_en(draw_ball),
        .paddle(paddle_color),
        .paddle_en(draw_paddle),
        .blocks(blocks_color),
        .blocks_en(draw_blocks),
        .lives(lives_color),
        .lives_en(draw_lives)
    );
    assign vga_r = video_out[1:0];
    assign vga_g = video_out[3:2];
    assign vga_b = video_out[5:4];

    // Border generator
    p18_border_painter #(
        .BORDER_WIDTH(BORDER_WIDTH)
    ) border (
        .in_border(draw_border),
        .color(border_color),
        .hpos(vga_hpos),
        .vpos(vga_vpos)
    );

    // Ball painter
    wire [9:0]ball_x;
    wire [8:0]ball_y;
    wire ball_top_en;
    wire ball_left_en;
    wire ball_bottom_en;
    wire ball_right_en;
    p18_ball_painter ball_painter(
        .clk(clk),
        .nRst(nRst),
        .in_ball(draw_ball),
        .in_ball_top(ball_top_en),
        .in_ball_left(ball_left_en),
        .in_ball_bottom(ball_bottom_en),
        .in_ball_right(ball_right_en),
        .color(ball_color),
        .x(ball_x),
        .y(ball_y),
        .hpos(vga_hpos),
        .vpos(vga_vpos),
        .line_pulse(vga_line_pulse),
        .display_active(vga_active)
    );

    // Paddle painter
    wire [9:0] paddle_x;
    wire [2:0] paddle_segment;
    p18_paddle_painter #(
        .PADDLE_SEGMENT_WIDTH(PADDLE_SEGMENT_WIDTH),
        .PADDLE_NUM_SEGMENTS(PADDLE_NUM_SEGMENTS)
    ) paddle_painter(
        .clk(clk),
        .nRst(nRst),
        .in_paddle(draw_paddle),
        .color(paddle_color),
        .x(paddle_x),
        .hpos(vga_hpos),
        .vpos(vga_vpos),
        .paddle_segment(paddle_segment)
    );

    // Collisions
    wire wall_collision = draw_border && draw_ball;
    wire paddle_collision = draw_paddle && draw_ball;
    wire block_collision = draw_blocks && draw_ball;
    wire collision = wall_collision || paddle_collision || block_collision;

    // Blocks painter
    wire [12:0] block_line_state;
    wire state_go_next_line;
    wire [12:0] write_block_line;
    wire write_line;
    p18_blocks_painter #(
        .NUM_ROWS(NUM_ROWS)
    ) blocks_painter(
        .clk(clk),
        .nRst(nRst),
        .block_en(draw_blocks),
        .color(blocks_color),
        .hpos(vga_hpos),
        .vpos(vga_vpos),
        .new_frame(vga_frame_pulse),
        .new_line(vga_line_pulse),
        .display_active(vga_active),
        .block_line_state(block_line_state),
        .go_next_line(state_go_next_line),
        .block_collision(block_collision),
        .new_block_line_state(write_block_line),
        .write_block_line_state(write_line)
    );

    // Lives painter
    wire [1:0] lives;
    p18_lives_painter lives_painter(
        .clk(clk),
        .nRst(nRst),
        .in_lives(draw_lives),
        .color(lives_color),
        .hactive(vga_hactive),
        .hpos(vga_hpos),
        .vpos(vga_vpos),
        .lives(lives)
    );

    // State storage
    wire [12:0] spi_new_line;
    wire spi_line_write_en;
    wire spi_line_shift;
    wire reset_state;
    p18_block_state  #(
        .NUM_ROWS(NUM_ROWS)
    ) block_state (
        .clk(clk),
        .nRst(nRst),
        .line(block_line_state),
        .next_line(state_go_next_line || spi_line_shift),
        .new_line(spi_line_write_en ? spi_new_line : write_block_line),
        .write_line(spi_line_write_en || write_line),
        .reset_state(reset_state)
    );

    // Sound generator
    p18_sound_gen sound_gen(
        .clk(clk),
        .nRst(nRst),
        .sound(sound_out),
        .line_pulse(vga_line_pulse),
        .frame_pulse(vga_frame_pulse),
        .high_beep(collision),
        .low_beep(block_collision || ball_out_of_bounds)
    );

    // Game logic
    wire [0:0] game_state;
    wire ball_out_of_bounds;
    wire latched_ball_block_collision;
    wire cmd_stop_game;
    p18_game_logic #(
        .PADDLE_WIDTH(PADDLE_SEGMENT_WIDTH * PADDLE_NUM_SEGMENTS),
        .BORDER_WIDTH(BORDER_WIDTH),
        .INITIAL_BALL_X(INITIAL_BALL_X),
        .INITIAL_BALL_Y(INITIAL_BALL_Y),
        .INITIAL_VEL_X(INITIAL_VEL_X),
        .INITIAL_VEL_Y(INITIAL_VEL_Y)
    ) game_logic(
        .clk(clk),
        .nRst(nRst),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .paddle_x(paddle_x),
        .frame_pulse(vga_frame_pulse),
        .btn_action(btn_select),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .collision(collision),
        .block_collision(block_collision),
        .paddle_collision(paddle_collision),
        .paddle_segment(paddle_segment),
        .ball_top_col(ball_top_en),
        .ball_left_col(ball_left_en),
        .ball_bottom_col(ball_bottom_en),
        .ball_right_col(ball_right_en),
        .game_state(game_state),
        .ball_out_of_bounds(ball_out_of_bounds),
        .latched_ball_block_collision(latched_ball_block_collision),
        .cmd_stop_game(cmd_stop_game),
        .lives(lives),
        .reset_state(reset_state)
    );

    // External interface
    localparam SPI_STATE_SIZE = 2+1+2+3+13;
    wire [SPI_STATE_SIZE - 1:0] spi_state = {
        lives,
        game_state,
        ball_out_of_bounds,
        latched_ball_block_collision,
        btn_select,
        btn_left,
        btn_right,
        block_line_state
    };
    wire spi_start_transaction;
    wire [15:0] spi_value;
    wire spi_write_en;
    p18_spi_if #(
        .STATE_SIZE(SPI_STATE_SIZE)
    ) spi_if (
        .clk(clk),
        .nRst(nRst),
        .sck(sck),
        .ss(ss),
        .mosi(mosi),
        .state(spi_state),
        .write_value(spi_value),
        .write_en(spi_write_en),
        .miso(miso),
        .miso_en(miso_en),
        .start_transaction(spi_start_transaction)
    );

    p18_spi_ctrl spi_ctrl(
        .clk(clk),
        .nRst(nRst),
        .start(spi_start_transaction),
        .word_en(spi_write_en),
        .word(spi_value),
        .line(spi_new_line),
        .write_line(spi_line_write_en),
        .shift_line(spi_line_shift),
        .stop_game(cmd_stop_game)
    );

endmodule
