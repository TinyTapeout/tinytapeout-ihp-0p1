// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

module p09_sprite_access #(
    parameter WIDTH             // width of the sprite
)(
    input  logic clk,           // clock

    input  logic new_line,      // indicates the start of a new line of 8x8 pixels
    input  logic sprite_access, // always access sprite data at the end of a 8x8 pixel

    input  logic sprite_data,   // raw sprite data
    output logic sprite_shift,  // shift sprite by one

    output logic sprite_pixel,  // the pixel for the current position
    input  logic sprite_visible // is the sprite currently visible for this position
);
    /*
    The sprite is implemented as one shift-register to save resources.
    If we were to render at the normal resolution of 800x600, we would
    simply shift the sprite by one when we need new pixel data.
    However, since our internal resolution is 100x75, one sprite pixel
    is actually 8x8 real pixels. This means that we need to access the
    same sprite row for 8 rows in succession.

    One solution would be a bidirectional shift register, were you simply
    shift the row back before accessing it again. This would drastically
    increase resources since each flipflop would need another mux2 on its
    data input.

    The approach used here is to use a temporary shift register.
    When the first row of the 8x8 pixel needs to be drawn the row from
    the sprite is loaded into a temporary shift register.

    This shift register is accessed whenever new pixel data is needed
    and therefore repeats automatically for the remaining 7 of 8 rows.
    Once a new row is needed, the row from the sprite is again loaded
    into the temporary shift register.
    */

    // Shift sprite data upon the start of a new 8x8 pixel line
    assign sprite_shift = sprite_visible && sprite_access && new_line;

    // Temporary sprite line
    logic [WIDTH - 1: 0] sprite_line;

    always_ff @(posedge clk) begin
        // Shift data if sprite is visible
        if (sprite_visible && sprite_access) begin
            // If at the start of a new 8x8 pixel line load new data, else shift circular
            sprite_line <= {sprite_line[WIDTH - 2: 0], new_line ? sprite_data : sprite_line[WIDTH - 1]};
        end
    end

    // For the first line of a 8x8 pixels use the data directly from the sprite
    // For the lines afterwards reuse the data inside sprite_line
    assign sprite_pixel = new_line ? sprite_data : sprite_line[WIDTH - 1];

endmodule
