`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/09/2023 12:28:34 PM
// Design Name:
// Module Name: blocks_drawer
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


module p18_blocks_painter (
    input clk,
    input nRst,
    output block_en,
    output [5:0] color,
    input [9:0] hpos,
    input [8:0] vpos,
    input new_frame,
    input new_line,
    input display_active,
    input [12:0] block_line_state,
    output go_next_line,
    input block_collision,
    output reg [12:0] new_block_line_state,
    output write_block_line_state
    );

    parameter BORDER_WIDTH = 8;
    parameter BLOCK_WIDTH = 48;
    parameter BLOCK_HEIGHT = 20;
    parameter BLOCKS_PER_ROW = 13;
    parameter NUM_ROWS = 15;

    reg in_vertical_block_region;
    wire vertical_block_region_start = vpos == BORDER_WIDTH && display_active;
    wire vertical_block_region_end = vpos == BORDER_WIDTH + NUM_ROWS * BLOCK_HEIGHT;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            in_vertical_block_region <= 1'b0;
        end else begin
            if(vertical_block_region_start) begin
                in_vertical_block_region <= 1'b1;
            end else if(vertical_block_region_end) begin
                in_vertical_block_region <= 1'b0;
            end
        end
    end

    reg in_horizontal_block_region;
    wire horizontal_block_region_start = hpos == BORDER_WIDTH - 1 && display_active;
    wire horizontal_block_region_end = hpos == (BORDER_WIDTH + BLOCKS_PER_ROW * BLOCK_WIDTH) - 1;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            in_horizontal_block_region <= 1'b0;
        end else begin
            if(horizontal_block_region_start) begin
                in_horizontal_block_region <= 1'b1;
            end else if(horizontal_block_region_end) begin
                in_horizontal_block_region <= 1'b0;
            end
        end
    end

    wire in_block_region = in_horizontal_block_region && in_vertical_block_region;

    reg [5:0] block_x_cnt;
    wire is_last_block_x = block_x_cnt == BLOCK_WIDTH-1;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            block_x_cnt <= 0;
        end else begin
            if(is_last_block_x || new_line) begin
                block_x_cnt <= 0;
            end else if(in_horizontal_block_region) begin
                block_x_cnt <= block_x_cnt + 1'b1;
            end
        end
    end

    reg [4:0] block_y_cnt;
    wire is_last_block_y = block_y_cnt == BLOCK_HEIGHT-1;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            block_y_cnt <= 0;
        end else begin
            if((new_line && is_last_block_y) || new_frame) begin
                block_y_cnt <= 0;
            end else if(new_line && in_vertical_block_region) begin
                block_y_cnt <= block_y_cnt + 1'b1;
            end
        end
    end

    reg [3:0] block_offset_idx;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            block_offset_idx <= 8'd0;
        end else begin
            if(new_line || new_frame) begin
                block_offset_idx <= 8'd0;
            end else if(is_last_block_x && in_block_region) begin
                block_offset_idx <= block_offset_idx + 1'b1;
            end
        end
    end

    wire in_block_border = block_y_cnt == 0 || block_x_cnt == 0 || block_x_cnt == BLOCK_WIDTH - 1 || block_y_cnt == BLOCK_HEIGHT - 1;
    wire current_block_present = block_line_state[block_offset_idx];
    wire in_block = in_block_region && current_block_present && !in_block_border;

    assign block_en = in_block;
    assign color = 6'b110000;

    /////////////////////////////////////////////
    // Handle block collisions
    /////////////////////////////////////////////
    // Do three actions at the end of a line of blocks:
    // 1. Write the new line state to the current position
    // 2. Go to the next line
    // 3. Load the next line state
    wire at_end_of_line = new_line && in_vertical_block_region && is_last_block_y;
    wire load_line_state;
    reg at_end_of_line_d1;
    reg at_end_of_line_d2;
    assign write_block_line_state = at_end_of_line;
    assign go_next_line = at_end_of_line_d1;
    assign load_line_state = at_end_of_line_d2;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            at_end_of_line_d1 <= 1'b0;
            at_end_of_line_d2 <= 1'b0;
        end else begin
            at_end_of_line_d1 <= at_end_of_line;
            at_end_of_line_d2 <= at_end_of_line_d1;
        end
    end

    // Remove blocks that have been hit
    reg first_time_reset;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            new_block_line_state <= 0;
            first_time_reset <= 0;
        end else begin
            if(load_line_state || !first_time_reset) begin
                new_block_line_state <= block_line_state;
            end else if(block_collision) begin
                new_block_line_state <= new_block_line_state & ~(1 << block_offset_idx);
            end
            first_time_reset <= 1'b1;
        end
    end


endmodule
