// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

`define SPRITE_WIDTH 12
`define SPRITE_HEIGHT 12

/*
    TODO checklist
    - GL test
    - next_vertical/next_frame at the start
*/

module p09_top (
    input  logic clk,
    input  logic reset_n,

    // SPI signals
    input  logic spi_sclk,
    input  logic spi_mosi,
    output logic spi_miso,
    input  logic spi_cs,

    // SVGA signals
    output logic [5:0] rrggbb,
    output logic hsync,
    output logic vsync,
    output logic next_vertical,
    output logic next_frame
);

    /*
        SVGA Timing for 800x600 60 Hz
        clock = 40 MHz or clock = 10 MHz
    */

    localparam WIDTH    = 800;
    localparam HEIGHT   = 600;

    localparam HFRONT   = 40;
    localparam HSYNC    = 128;
    localparam HBACK    = 88;

    localparam VFRONT   = 1;
    localparam VSYNC    = 4;
    localparam VBACK    = 23;

    localparam HTOTAL = WIDTH + HFRONT + HSYNC + HBACK;
    localparam VTOTAL = HEIGHT + VFRONT + VSYNC + VBACK;

    // Downscaling by factor of 8, i.e. one pixel is 8x8
    localparam WIDTH_SMALL  = WIDTH / 8;
    localparam HEIGHT_SMALL = HEIGHT / 8;

    /*
        Global Parameters
    */

    localparam SPRITE_WIDTH = `SPRITE_WIDTH;
    localparam SPRITE_HEIGHT = `SPRITE_HEIGHT;

    localparam bit [5:0] COLOR1_DEFAULT = 6'b110001;
    localparam bit [5:0] COLOR2_DEFAULT = 6'b010101;
    localparam bit [5:0] COLOR3_DEFAULT = 6'b001100;
    localparam bit [5:0] COLOR4_DEFAULT = 6'b101100;

    localparam bit [1:0] BACKGROUND_DEFAULT         = 2'd2;
    localparam bit       ENABLE_MOVEMENT_DEFAULT    = 1'b1;
    localparam bit       ENABLE_SPRITE_BG_DEFAULT   = 1'b0;
    localparam bit       REDUCED_FREQ_DEFAULT       = 1'b0;

    localparam bit [4:0] MISC_DEFAULT = {   REDUCED_FREQ_DEFAULT,
                                            ENABLE_SPRITE_BG_DEFAULT,
                                            ENABLE_MOVEMENT_DEFAULT,
                                            BACKGROUND_DEFAULT
                                        };

    /*
        Horizontal and Vertical Timing
    */

    logic signed [$clog2(HTOTAL) : 0] counter_h;
    logic signed [$clog2(VTOTAL) : 0] counter_v;

    logic inc_1_or_4;

    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            inc_1_or_4 <= REDUCED_FREQ_DEFAULT;
        end else begin
            // Only ever assign at next_frame
            // to prevent glitches
            if (next_frame) begin
                inc_1_or_4 <= misc[4];
            end
        end
    end

    logic hblank;
    logic vblank;

    // Horizontal timing
    p09_timing #(
        .RESOLUTION     (WIDTH),
        .FRONT_PORCH    (HFRONT),
        .SYNC_PULSE     (HSYNC),
        .BACK_PORCH     (HBACK),
        .TOTAL          (HTOTAL),
        .POLARITY       (1)
    ) timing_hor (
        .clk        (clk),
        .enable     (1'b1),
        .reset_n    (reset_n),
        .inc_1_or_4 (inc_1_or_4),
        .sync       (hsync),
        .blank      (hblank),
        .next       (next_vertical),
        .counter    (counter_h)
    );

    // Vertical timing
    p09_timing #(
        .RESOLUTION     (HEIGHT),
        .FRONT_PORCH    (VFRONT),
        .SYNC_PULSE     (VSYNC),
        .BACK_PORCH     (VBACK),
        .TOTAL          (VTOTAL),
        .POLARITY       (1)
    ) timing_ver (
        .clk        (clk),
        .enable     (next_vertical),
        .reset_n    (reset_n),
        .inc_1_or_4 (1'b0),
        .sync       (vsync),
        .blank      (vblank),
        .next       (next_frame),
        .counter    (counter_v)
    );

    logic [7:0] cur_time;
    logic time_dir;

    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            cur_time <= '0;
            time_dir <= '0;
        end else begin
            if (next_frame) begin
                if (time_dir == 1'b0) begin
                    cur_time <= cur_time + 1;
                    if (cur_time == 255-1) begin
                        time_dir <= 1'b1;
                    end
                end else begin
                    cur_time <= cur_time - 1;
                    if (cur_time == 0+1) begin
                        time_dir <= 1'b0;
                    end
                end
            end
        end
    end

    /*
        Sprite Movement
    */

    logic [7:0] sprite_x;
    logic [7:0] sprite_y;

    p09_sprite_movement #(
        .SPRITE_WIDTH  (SPRITE_WIDTH),
        .SPRITE_HEIGHT (SPRITE_HEIGHT),
        .WIDTH_SMALL   (WIDTH_SMALL),
        .HEIGHT_SMALL  (HEIGHT_SMALL)
    ) sprite_movement_inst (
        .clk            (clk),
        .reset_n        (reset_n),

        .enable_movement (misc[2]),
        .next_frame     (next_frame),

        .shift_x        (shift_x),
        .data_in_x      (spi_mosi_sync),
        .shift_y        (shift_y),
        .data_in_y      (spi_mosi_sync),

        .sprite_x       (sprite_x),
        .sprite_y       (sprite_y)
    );

    logic signed [$clog2(HTOTAL) - 3 : 0] counter_h_small;
    logic signed [$clog2(VTOTAL) - 3 : 0] counter_v_small;

    assign counter_h_small = counter_h[$clog2(HTOTAL) : 3];
    assign counter_v_small = counter_v[$clog2(VTOTAL) : 3];

    /*
        Sprite Visibility
    */

    logic sprite_visible_v;
    logic sprite_visible_h;
    logic sprite_visible;

    assign sprite_visible_h = counter_h_small >= {1'b0, sprite_x} && counter_h_small < (sprite_x + SPRITE_WIDTH);
    assign sprite_visible_v = counter_v_small >= sprite_y && counter_v_small < (sprite_y + SPRITE_HEIGHT);
    assign sprite_visible = sprite_visible_h && sprite_visible_v;

    /*
        Sprite Data
    */

    logic sprite_data;
    logic sprite_shift;

    p09_sprite_data #(
        .WIDTH  (SPRITE_WIDTH),
        .HEIGHT (SPRITE_HEIGHT)
    ) sprite_data_inst (
        .clk        (clk),
        .reset_n    (reset_n),
        .shiftf     (sprite_shift || spi_sprite_shift),
        .data_out   (sprite_data),
        .data_in    (spi_mosi_sync),
        .load       (spi_sprite_mode)
    );

    /*
        Sprite Access
    */

    logic sprite_pixel;
    logic start_big_line;
    logic end_big_pixel;

    assign start_big_line = counter_v[2:0] == 3'b000;
    assign end_big_pixel   = (inc_1_or_4 == 1'b0) ? counter_h[2:0] == 3'b111 : counter_h[2] == 1'b1;

    p09_sprite_access #(
        .WIDTH  (SPRITE_WIDTH)
    ) sprite_access_inst (
        .clk        (clk),

        .new_line       (start_big_line),
        .sprite_access  (end_big_pixel),

        .sprite_data    (sprite_data),
        .sprite_shift   (sprite_shift),

        .sprite_pixel   (sprite_pixel),
        .sprite_visible (sprite_visible)
    );

    /*
        Background Color
    */

    logic [5:0] bg_color;

    logic [1:0] bg_sel;

    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            bg_sel <= BACKGROUND_DEFAULT;
        end else begin
            // Only ever assign at next_frame
            // to prevent glitches
            if (next_vertical && counter_v[2:0] == 3'b111) begin
                bg_sel <= misc[1:0];
            end
        end
    end

    p09_background #(
        .HTOTAL (HTOTAL),
        .VTOTAL (VTOTAL)
    ) background_inst (
        .bg_select  (bg_sel),
        .cur_time   (cur_time),

        .counter_h  (counter_h),
        .counter_v  (counter_v),

        .color1     (color1),
        .color2     (color2),
        .color3     (color3),
        .color4     (color4),

        .color_out (bg_color)
    );

    /*
        Final Color Composition
    */

    always_comb begin
        rrggbb = bg_color;

        if (sprite_pixel && sprite_visible) begin
            rrggbb = color1;
        end

        if (misc[3] && !sprite_pixel && sprite_visible) begin
            rrggbb = color2;
        end

        if (hblank || vblank) begin
            rrggbb = '0;
        end
    end

    /*
        SPI Receiver

        cpol       = False,
        cpha       = True,
        msb_first  = True,
        word_width = 8,
        cs_active_low = True
    */

    logic [5:0] color1;
    logic [5:0] color2;
    logic [5:0] color3;
    logic [5:0] color4;
    logic [4:0] misc;

    logic spi_sprite_shift;
    logic spi_sprite_mode;
    logic spi_mosi_sync;

    logic shift_x;
    logic shift_y;

    p09_spi_receiver #(
        .COLOR1_DEFAULT (COLOR1_DEFAULT),
        .COLOR2_DEFAULT (COLOR2_DEFAULT),
        .COLOR3_DEFAULT (COLOR3_DEFAULT),
        .COLOR4_DEFAULT (COLOR4_DEFAULT),
        .MISC_DEFAULT   (MISC_DEFAULT)
    ) spi_receiver_inst (
        .clk        (clk),
        .reset_n    (reset_n),

        .spi_sclk   (spi_sclk),
        .spi_mosi   (spi_mosi),
        .spi_miso   (spi_miso),
        .spi_cs     (spi_cs),

        .sprite_data        (sprite_data),

        .spi_sprite_shift   (spi_sprite_shift),
        .spi_sprite_mode    (spi_sprite_mode),
        .spi_mosi_sync      (spi_mosi_sync),

        .shift_x    (shift_x),
        .shift_y    (shift_y),

        .color1     (color1),
        .color2     (color2),
        .color3     (color3),
        .color4     (color4),
        .misc       (misc)
    );


endmodule
