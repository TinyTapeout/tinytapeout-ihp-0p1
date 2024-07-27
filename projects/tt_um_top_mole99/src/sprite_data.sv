// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

module p09_sprite_data #(
    parameter WIDTH,        // width of the sprite
    parameter HEIGHT        // height of the sprite
)(
    input  logic clk,       // clock
    input  logic reset_n,   // reset active low
    input  logic shiftf,    // shift sprite data
    output logic data_out,  // output pixel data
    input  logic load,      // load new sprite data
    input  logic data_in    // new sprite data
);
    logic [WIDTH*HEIGHT-1 : 0] sprite_data;

    /* clock gating - future enhancement */

    /*
    logic g_clk, enable_latch;

    always_latch begin
        if (~clk)
            enable_latch <= shiftf;
    end

    assign g_clk = clk & enable_latch;
    */

    // Decide if we just want to rotate the whole register
    // or if we want to shift in/load new sprite data
    logic new_sprite_data;
    assign new_sprite_data = load ? data_in : sprite_data[0];

    // Implement the shift register
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin

            // By default all pixels are background
            sprite_data <= '0;

            // Initialize the sprite data
            // Basically the pixels of your sprite
            // but flipped at the Y-axis

            sprite_data[11 : 0  ] <= 12'b000111111000;
            sprite_data[23 : 12 ] <= 12'b001000000100;
            sprite_data[35 : 24 ] <= 12'b010001111110;
            sprite_data[47 : 36 ] <= 12'b100001111111;
            sprite_data[59 : 48 ] <= 12'b100000011000;
            sprite_data[71 : 60 ] <= 12'b101111111001;
            sprite_data[83 : 72 ] <= 12'b101111111001;
            sprite_data[95 : 84 ] <= 12'b100011011001;
            sprite_data[107: 96 ] <= 12'b100011011001;
            sprite_data[119: 108] <= 12'b010011000010;
            sprite_data[131: 120] <= 12'b001011000100;
            sprite_data[143: 132] <= 12'b000011111000;

        end else begin
            if (shiftf) begin
                // Shift the whole sprite
                sprite_data <= {new_sprite_data, sprite_data[WIDTH*HEIGHT-1:1]};
            end
        end
    end

    // Data for the current pixel is the LSB
    assign data_out = sprite_data[0];

endmodule
