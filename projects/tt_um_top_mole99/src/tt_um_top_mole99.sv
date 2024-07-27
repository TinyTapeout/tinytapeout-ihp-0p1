// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

module tt_um_top_mole99 (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    logic spi_sclk;
    logic spi_mosi;
    logic spi_miso;
    logic spi_cs;

    logic [5:0] rrggbb;
    logic hsync;
    logic vsync;
    logic next_vertical;
    logic next_frame;

    // TODO async reset, sync deassert

    p09_top top_inst (
        .clk        (clk),
        .reset_n    (rst_n),

        // SPI signals
        .spi_sclk   (spi_sclk),
        .spi_mosi   (spi_mosi),
        .spi_miso   (spi_miso),
        .spi_cs     (spi_cs),

        // SVGA signals
        .rrggbb         (rrggbb),
        .hsync          (hsync),
        .vsync          (vsync),
        .next_vertical  (next_vertical),
        .next_frame     (next_frame)
    );

    logic [1:0] R;
    logic [1:0] G;
    logic [1:0] B;

    assign R = rrggbb[5:4];
    assign G = rrggbb[3:2];
    assign B = rrggbb[1:0];

    // Output PMOD - Tiny VGA

    assign uo_out[0] = R[1];
    assign uo_out[1] = G[1];
    assign uo_out[2] = B[1];
    assign uo_out[3] = vsync;
    assign uo_out[4] = R[0];
    assign uo_out[5] = G[0];
    assign uo_out[6] = B[0];
    assign uo_out[7] = hsync;

    // Bidir PMOD - SPI and additional signals

    // Top row
    assign spi_cs     = uio_in[0];  assign uio_oe[0] = 1'b0; assign uio_out[0] = 1'b0;
    assign spi_mosi   = uio_in[1];  assign uio_oe[1] = 1'b0; assign uio_out[1] = 1'b0;
    assign uio_out[2] = spi_miso;   assign uio_oe[2] = 1'b1;
    assign spi_sclk   = uio_in[3];  assign uio_oe[3] = 1'b0; assign uio_out[3] = 1'b0;

    // Bottom row
    assign uio_out[4] = next_vertical;  assign uio_oe[4] = 1'b1;
    assign uio_out[5] = next_frame;     assign uio_oe[5] = 1'b1;

    assign uio_out[6] = 1'b0; assign uio_oe[6] = 1'b0; // - not used
    assign uio_out[7] = 1'b0; assign uio_oe[7] = 1'b0; // - not used

    // Input PMOD - not used

    /*
    ui_in[0]
    ui_in[1]
    ui_in[2]
    ui_in[3]
    ui_in[4]
    ui_in[5]
    ui_in[6]
    ui_in[7]
    */

endmodule
