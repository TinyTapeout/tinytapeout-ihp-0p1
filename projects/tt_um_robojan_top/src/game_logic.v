`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/09/2023 07:48:32 PM
// Design Name:
// Module Name: ball_logic
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


module p18_game_logic
#(
    parameter INITIAL_BALL_X = 10'd320 - 3'd2,
    parameter INITIAL_BALL_Y = 9'd452 - 3'd2,
    parameter INITIAL_VEL_X = 4'sd2,
    parameter INITIAL_VEL_Y = -4'sd2,
    parameter PADDLE_SPEED = 2,
    parameter PADDLE_WIDTH = 64,
    parameter INITIAL_PADDLE_X = 10'd320 - PADDLE_WIDTH / 2 - 1,
    parameter BORDER_WIDTH = 8
)(
    input clk,
    input nRst,
    output [9:0] ball_x,
    output [8:0] ball_y,
    output [9:0] paddle_x,
    input frame_pulse,
    input btn_action,
    input btn_left,
    input btn_right,
    input collision,
    input block_collision,
    input paddle_collision,
    input [2:0] paddle_segment,
    input ball_top_col,
    input ball_left_col,
    input ball_bottom_col,
    input ball_right_col,
    output reg [0:0] game_state,
    output wire ball_out_of_bounds,
    output reg latched_ball_block_collision,
    input cmd_stop_game,
    output reg [1:0] lives,
    output reset_state
);

    wire paddle_is_at_left_limit;
    wire paddle_is_at_right_limit;
    wire out_of_lives = lives == 2'd0;
    wire end_of_game = out_of_lives && ball_out_of_bounds;
    assign reset_state = end_of_game;

    /////////////////////////////////////////////
    // Game state
    /////////////////////////////////////////////
    localparam STATE_START = 0;
    localparam STATE_PLAYING = 1;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            game_state <= STATE_START;
            lives <= 2'd3;
        end else begin
            if(frame_pulse) begin
                case(game_state)
                    STATE_START: begin
                        if (btn_action) begin
                            game_state <= STATE_PLAYING;
                        end
                    end
                    STATE_PLAYING: begin
                        if(ball_out_of_bounds) begin
                            game_state <= STATE_START;
                            lives <= out_of_lives ? 2'd3 : lives - 1'b1;
                        end else if (cmd_stop_game) begin
                            game_state <= STATE_START;
                            lives <= 2'd3;
                        end
                    end
                endcase
            end
        end
    end




    /////////////////////////////////////////////
    // Ball logic
    /////////////////////////////////////////////
    // Latched collisions
    // Collisions are evaluated at the end of the frame but we keep track of collisions during the drawing.
    reg latched_ball_top_collision;
    reg latched_ball_bottom_collision;
    reg latched_ball_left_collision;
    reg latched_ball_right_collision;
    reg latched_paddle_collision;
    reg [2:0] latched_paddle_segment;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            latched_ball_top_collision <= 1'b0;
            latched_ball_bottom_collision <= 1'b0;
            latched_ball_left_collision <= 1'b0;
            latched_ball_right_collision <= 1'b0;
            latched_paddle_collision <= 1'b0;
            latched_paddle_segment <= 3'b0;
            latched_ball_block_collision <= 1'b0;
        end else begin
            if (frame_pulse) begin
                latched_ball_top_collision <= 1'b0;
                latched_ball_bottom_collision <= 1'b0;
                latched_ball_left_collision <= 1'b0;
                latched_ball_right_collision <= 1'b0;
                latched_paddle_collision <= 1'b0;
                latched_paddle_segment <= 3'b0;
                latched_ball_block_collision <= 1'b0;
            end else if(collision) begin
                latched_ball_top_collision <= latched_ball_top_collision | ball_top_col;
                latched_ball_bottom_collision <= latched_ball_bottom_collision | ball_bottom_col;
                latched_ball_left_collision <= latched_ball_left_collision | ball_left_col;
                latched_ball_right_collision <= latched_ball_right_collision | ball_right_col;
                latched_paddle_collision <= latched_paddle_collision | paddle_collision;
                latched_ball_block_collision <= latched_ball_block_collision | block_collision;
            end
            if(paddle_collision) begin
                latched_paddle_segment <= paddle_segment;
            end
        end
    end

    reg signed [3:0] velocity_x;
    reg signed [3:0] velocity_y;
    reg signed [11:0] ball_state_x;
    reg signed [10:0] ball_state_y;
    assign ball_out_of_bounds = ball_state_y[10:2] == 9'd488 >> 1; // Ignore the last bit

    reg signed [3:0] next_velocity_x;
    reg signed [3:0] next_velocity_y;
    always @(*)
    begin
        case(game_state)
            STATE_START: begin
                if (btn_action) begin
                    next_velocity_x <= INITIAL_VEL_X;
                    next_velocity_y <= INITIAL_VEL_Y;
                end else if (btn_left && !paddle_is_at_left_limit) begin
                    next_velocity_x <= - {PADDLE_SPEED, 1'b0};
                    next_velocity_y <= 0;
                end else if (btn_right && !paddle_is_at_right_limit) begin
                    next_velocity_x <= {PADDLE_SPEED, 1'b0};
                    next_velocity_y <= 0;
                end else begin
                    next_velocity_x <= 0;
                    next_velocity_y <= 0;
                end
            end
            STATE_PLAYING: begin
                if(ball_out_of_bounds) begin
                    next_velocity_x <= INITIAL_VEL_X;
                    next_velocity_y <= INITIAL_VEL_Y;
                end else if (latched_paddle_collision && latched_ball_bottom_collision) begin
                    case(latched_paddle_segment)
                        3'b000: next_velocity_x <= -3;
                        3'b001: next_velocity_x <= -2;
                        3'b010: next_velocity_x <= -1;
                        3'b011: next_velocity_x <= 1;
                        3'b100: next_velocity_x <= 2;
                        3'b101: next_velocity_x <= 3;
                    endcase
                    next_velocity_y <= -velocity_y;
                end else if (
                    (!latched_ball_left_collision &&  latched_ball_top_collision && !latched_ball_right_collision && !latched_ball_bottom_collision) || // Top collisions
                    ( latched_ball_left_collision &&  latched_ball_top_collision &&  latched_ball_right_collision && !latched_ball_bottom_collision) ||
                    ( latched_ball_left_collision &&  latched_ball_top_collision && !latched_ball_right_collision && !latched_ball_bottom_collision) ||
                    (!latched_ball_left_collision &&  latched_ball_top_collision &&  latched_ball_right_collision && !latched_ball_bottom_collision) ||
                    (!latched_ball_left_collision && !latched_ball_top_collision && !latched_ball_right_collision &&  latched_ball_bottom_collision) || // Bottom collisions
                    ( latched_ball_left_collision && !latched_ball_top_collision &&  latched_ball_right_collision &&  latched_ball_bottom_collision) ||
                    ( latched_ball_left_collision && !latched_ball_top_collision && !latched_ball_right_collision &&  latched_ball_bottom_collision) ||
                    (!latched_ball_left_collision && !latched_ball_top_collision &&  latched_ball_right_collision &&  latched_ball_bottom_collision)
                ) begin
                    next_velocity_x <= velocity_x;
                    next_velocity_y <= -velocity_y;
                end else if (
                    // This contains duplicates from the top and bottom collisions, This is fine and will be optimized away.
                    (!latched_ball_left_collision && !latched_ball_top_collision &&  latched_ball_right_collision && !latched_ball_bottom_collision) || // Right collisions
                    (!latched_ball_left_collision &&  latched_ball_top_collision &&  latched_ball_right_collision &&  latched_ball_bottom_collision) ||
                    (!latched_ball_left_collision && !latched_ball_top_collision &&  latched_ball_right_collision &&  latched_ball_bottom_collision) ||
                    (!latched_ball_left_collision &&  latched_ball_top_collision &&  latched_ball_right_collision && !latched_ball_bottom_collision) ||
                    ( latched_ball_left_collision && !latched_ball_top_collision && !latched_ball_right_collision && !latched_ball_bottom_collision) || // Left collisions
                    ( latched_ball_left_collision &&  latched_ball_top_collision && !latched_ball_right_collision &&  latched_ball_bottom_collision) ||
                    ( latched_ball_left_collision && !latched_ball_top_collision && !latched_ball_right_collision &&  latched_ball_bottom_collision) ||
                    ( latched_ball_left_collision &&  latched_ball_top_collision && !latched_ball_right_collision && !latched_ball_bottom_collision)
                ) begin
                    next_velocity_x <= -velocity_x;
                    next_velocity_y <= velocity_y;
                end else begin
                    next_velocity_x <= velocity_x;
                    next_velocity_y <= velocity_y;
                end
            end
        endcase
    end

    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            ball_state_x <= {INITIAL_BALL_X, 1'b0};
            ball_state_y <= {INITIAL_BALL_Y, 1'b0};
            velocity_x <= INITIAL_VEL_X;
            velocity_y <= INITIAL_VEL_Y;
        end else begin
            if(frame_pulse) begin
                velocity_x <= next_velocity_x;
                velocity_y <= next_velocity_y;
                if(ball_out_of_bounds) begin
                    ball_state_x <= {INITIAL_BALL_X, 1'b0};
                    ball_state_y <= {INITIAL_BALL_Y, 1'b0};
                end else begin
                    ball_state_x <= ball_state_x + next_velocity_x;
                    ball_state_y <= ball_state_y + next_velocity_y;
                end
            end
        end
    end

    assign ball_x = ball_state_x[10:1];
    assign ball_y = ball_state_y[9:1];

    /////////////////////////////////////////////
    // Paddle logic
    /////////////////////////////////////////////
    reg [9:0] paddle_state_x;
    // Ignore the bottom bit to account for the velocity of the paddle
    assign paddle_is_at_left_limit = paddle_state_x[9:1] == BORDER_WIDTH >> 1;
    assign paddle_is_at_right_limit = paddle_state_x[9:1] == (640 - BORDER_WIDTH - PADDLE_WIDTH) >> 1;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            paddle_state_x <= INITIAL_PADDLE_X;
        end else begin
            if(frame_pulse) begin
                if(ball_out_of_bounds) begin
                    paddle_state_x <= INITIAL_PADDLE_X;
                end else if (btn_left && !paddle_is_at_left_limit) begin
                    paddle_state_x <= paddle_state_x - PADDLE_SPEED;
                end else if (btn_right && !paddle_is_at_right_limit) begin
                    paddle_state_x <= paddle_state_x + PADDLE_SPEED;
                end
            end
        end
    end

    assign paddle_x = paddle_state_x;

endmodule
