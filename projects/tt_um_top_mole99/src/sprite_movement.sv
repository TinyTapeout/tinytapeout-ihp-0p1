// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

module p09_sprite_movement #(
    parameter SPRITE_WIDTH,         // width of the sprite
    parameter SPRITE_HEIGHT,        // height of the sprite
    parameter WIDTH_SMALL,          // scaled down window width
    parameter HEIGHT_SMALL          // scaled down window height
)(
    input  logic clk,               // clock
    input  logic reset_n,           // reset active low

    input  logic enable_movement,   // enable movement of the sprite
    input  logic next_frame,        // frame was completed

    input  logic shift_x,           // shift new x position
    input  logic data_in_x,         // x position data
    input  logic shift_y,           // shift new y position
    input  logic data_in_y,         // y position data

    output logic [7:0] sprite_x,    // current x position
    output logic [7:0] sprite_y     // current y position
);

    logic sprite_x_dir;
    logic sprite_y_dir;
    logic divider; // half movement speed by two

    // Sprite movement logic
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            sprite_x <= '0;
            sprite_y <= '0;
            sprite_x_dir <= '0;
            sprite_y_dir <= '0;
            divider <= '0;
        end else begin
            if (next_frame) begin
                divider <= !divider;
            end

            // Move the sprite to current direction
            if (enable_movement && divider && next_frame) begin
                if (sprite_x_dir == 1'b0) begin
                    sprite_x <= sprite_x + 1;

                    /* verilator lint_off WIDTH */
                    if (sprite_x == (WIDTH_SMALL - SPRITE_WIDTH - 1)) begin
                        sprite_x_dir <= 1;
                    end
                    /* verilator lint_on WIDTH */
                end else begin
                    sprite_x <= sprite_x - 1;

                    if (sprite_x == 1) begin
                        sprite_x_dir <= 0;
                    end
                end

                if (sprite_y_dir == 1'b0) begin
                    sprite_y <= sprite_y + 1;

                    /* verilator lint_off WIDTH */
                    if (sprite_y == (HEIGHT_SMALL - SPRITE_HEIGHT - 1)) begin
                        sprite_y_dir <= 1;
                    end
                    /* verilator lint_on WIDTH */
                end else begin
                    sprite_y <= sprite_y - 1;

                    if (sprite_y == 1) begin
                        sprite_y_dir <= 0;
                    end
                end
            end

            // Shift in new x position
            if (shift_x) begin
                sprite_x <= {sprite_x[6:0], data_in_x};
            end

            // Shift in new y position
            if (shift_y) begin
                sprite_y <= {sprite_y[6:0], data_in_y};
            end
        end
    end

endmodule
