// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

module p09_spi_receiver #(
    parameter COLOR1_DEFAULT,   // color1 default value
    parameter COLOR2_DEFAULT,   // color2 default value
    parameter COLOR3_DEFAULT,   // color3 default value
    parameter COLOR4_DEFAULT,   // color4 default value
    parameter MISC_DEFAULT      // misc default value
)(
    input  logic clk,           // clock
    input  logic reset_n,       // reset active low

    // SPI signals
    input  logic spi_sclk,
    input  logic spi_mosi,
    output logic spi_miso,
    input  logic spi_cs,

    input  logic sprite_data,       // current sprite data
    output logic spi_sprite_shift,  // shift pulse
    output logic spi_sprite_mode,   // shift new data into sprite
    output logic spi_mosi_sync,     // spi input data

    output logic shift_x,           // shift new x position
    output logic shift_y,           // shift new y position

    // Output register
    output logic [5:0] color1,      // color1 register
    output logic [5:0] color2,      // color2 register
    output logic [5:0] color3,      // color3 register
    output logic [5:0] color4,      // color4 register
    output logic [4:0] misc         // miscellaneous register
);

    // Synchronizer to prevent metastability

    p09_synchronizer  #(
        .FF_COUNT(2)
    ) synchronizer_spi_mosi (
        .clk        (clk),
        .reset_n    (reset_n),
        .in         (spi_mosi),
        .out        (spi_mosi_sync)
    );

    logic spi_cs_sync;
    p09_synchronizer  #(
        .FF_COUNT(2)
    ) synchronizer_spi_cs (
        .clk        (clk),
        .reset_n    (reset_n),
        .in         (spi_cs),
        .out        (spi_cs_sync)
    );

    logic spi_sclk_sync;
    p09_synchronizer  #(
        .FF_COUNT(2)
    ) synchronizer_spi_sclk (
        .clk        (clk),
        .reset_n    (reset_n),
        .in         (spi_sclk),
        .out        (spi_sclk_sync)
    );


    // Detect spi_clk edge

    logic spi_sclk_delayed;
    always_ff @(posedge clk) begin
        spi_sclk_delayed <= spi_sclk_sync;
    end

    logic spi_sclk_falling, spi_sclk_rising;
    assign spi_sclk_rising = !spi_sclk_delayed && spi_sclk_sync;
    assign spi_sclk_falling = spi_sclk_delayed && !spi_sclk_sync;

    // State Machine

    logic [2:0] spi_cmd;
    logic [2:0] spi_cnt;
    logic spi_mode;

    typedef enum bit [2:0] {
        CMD_SPRITE_DATA = 3'd0,
        CMD_COLOR1      = 3'd1,
        CMD_COLOR2      = 3'd2,
        CMD_COLOR3      = 3'd3,
        CMD_COLOR4      = 3'd4,
        CMD_SPRITE_X    = 3'd5,
        CMD_SPRITE_Y    = 3'd6,
        CMD_MISC        = 3'd7
    } spi_cmds_t;

    logic spi_cmd_sprite_data;
    logic spi_cmd_color1;
    logic spi_cmd_color2;
    logic spi_cmd_color3;
    logic spi_cmd_color4;
    logic spi_cmd_sprite_x;
    logic spi_cmd_sprite_y;
    logic spi_cmd_misc;

    assign spi_cmd_sprite_data  = spi_cmd == CMD_SPRITE_DATA;
    assign spi_cmd_color1       = spi_cmd == CMD_COLOR1;
    assign spi_cmd_color2       = spi_cmd == CMD_COLOR2;
    assign spi_cmd_color3       = spi_cmd == CMD_COLOR3;
    assign spi_cmd_color4       = spi_cmd == CMD_COLOR4;
    assign spi_cmd_sprite_x     = spi_cmd == CMD_SPRITE_X;
    assign spi_cmd_sprite_y     = spi_cmd == CMD_SPRITE_Y;
    assign spi_cmd_misc         = spi_cmd == CMD_MISC;

    logic first_data_sprite;

    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            spi_mode <= 1'b0;
            spi_cnt  <= '0;
            spi_miso <= 1'b0;

            color1 <= COLOR1_DEFAULT;
            color2 <= COLOR2_DEFAULT;
            color3 <= COLOR3_DEFAULT;
            color4 <= COLOR4_DEFAULT;

            misc   <= MISC_DEFAULT;

            first_data_sprite <= 1'b0;
        end else begin
            if (!spi_cs_sync && spi_sclk_falling) begin
                // Read the command
                if (spi_mode == 1'b0) begin
                    spi_cmd <= {spi_cmd[1:0], spi_mosi_sync};
                    spi_cnt <= spi_cnt + 1;

                    if (spi_cnt == 7) begin
                        spi_mode <= 1'b1;
                    end
                // Write the data depending on the command
                end else begin
                    case (1'b1)
                        spi_cmd_color1: color1 <= {color1[4:0], spi_mosi_sync};
                        spi_cmd_color2: color2 <= {color2[4:0], spi_mosi_sync};
                        spi_cmd_color3: color3 <= {color3[4:0], spi_mosi_sync};
                        spi_cmd_color4: color4 <= {color4[4:0], spi_mosi_sync};
                        spi_cmd_sprite_data: first_data_sprite <= 1'b1;
                        spi_cmd_misc: misc <= {misc[3:0], spi_mosi_sync};
                    endcase

                    spi_cnt <= spi_cnt + 1;

                    if (spi_cnt == 7 && !spi_sprite_mode) begin
                        spi_mode <= 1'b0;
                    end
                end
            end

            // Echo back the previous values
            if (!spi_cs_sync && spi_sclk_rising) begin
                if (spi_mode == 1'b1) begin
                    case (1'b1)
                        spi_cmd_color1: spi_miso <= color1[5];
                        spi_cmd_color2: spi_miso <= color2[5];
                        spi_cmd_color3: spi_miso <= color3[5];
                        spi_cmd_color4: spi_miso <= color4[5];
                        spi_cmd_sprite_data: spi_miso <= sprite_data;
                        spi_cmd_misc: spi_miso <= misc[4];
                    endcase
                end
            end

            // Loading sprite data can be interrupted by rising cs
            // after one bit was shifted into the sprite.
            // This means it is possible to e.g. shift 100 bits and not only 8 at once
            if (first_data_sprite && spi_sprite_mode && spi_cs_sync) begin
                spi_mode <= 1'b0;
                first_data_sprite <= 1'b0;
            end
        end
    end

    // Enable sprite data shifting
    assign spi_sprite_mode = spi_mode && spi_cmd_sprite_data;
    assign spi_sprite_shift = spi_sprite_mode && spi_sclk_falling;

    // Indicate we want to shift a new position
    assign shift_x = spi_mode && spi_cmd_sprite_x && spi_sclk_falling;
    assign shift_y = spi_mode && spi_cmd_sprite_y && spi_sclk_falling;

endmodule
