/*
 * Copyright (c) 2024 Anton Maurovic
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
// `timescale 1ns / 1ps

module tt_um_algofoogle_raybox_zero (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  //@@@: SMELL: TODO: Find an option for:
  // - i_debug_map_overlay
  // - i_debug_trace_overlay
  // - i_reg_outs_enb -- COMPARE WITH i_reg BELOW!
  // - i_mode (extra debug mode selection bits)
  // - i_gpout*_sel
  // - o_gpout (3 bits)
  // FIX `define TRACE_STATE_DEBUG in rbzero.v

  // List all unused inputs to prevent warnings
  wire _unused = &{ui_in[7], uio_in[7:5], uio_in[1:0], ena, 1'b0};

  wire  [5:0] rgb;
  wire        vsync_n, hsync_n;
  reg   [7:0] registered_vga_output;
  wire  [7:0] unregistered_vga_output = {
    // Original `rgb` order is {BbGgRr}. Map this order, plus H/Vsync, per Tiny VGA PMOD
    // (https://tinytapeout.com/specs/pinouts/#vga-output):
    hsync_n, rgb[4], rgb[2], rgb[0], // [7:4] = {hbgr}
    vsync_n, rgb[5], rgb[3], rgb[1]  // [3:0] = {vBGR}
  };

  always @(posedge clk) registered_vga_output <= unregistered_vga_output;

  wire i_reg = ui_in[6];
  assign uo_out = i_reg ? registered_vga_output : unregistered_vga_output;

  wire [9:0] hpos, vpos;

  wire o_tex_oeb0;
  wire [3:0] i_tex_in = {1'b0, uio_in[7:5]}; //NOTE: io[3] is unused, currently.

  p22_rbzero rbzero(
    .clk        (clk),
    .reset      (~rst_n),

    // SPI peripheral interface for updating vectors:
    .i_sclk     (ui_in[0]),
    .i_mosi     (ui_in[1]),
    .i_ss_n     (ui_in[2]),

    // SPI peripheral interface for everything else:
    .i_reg_sclk (uio_in[2]),
    .i_reg_mosi (uio_in[3]),
    .i_reg_ss_n (uio_in[4]),

    // SPI controller interface for reading SPI flash memory (i.e. textures):
    .o_tex_csb  (uio_out[0]),
    .o_tex_sclk (uio_out[1]),
    .o_tex_out0 (uio_out[5]),
    .o_tex_oeb0 (o_tex_oeb0), // Direction control for io[0] (WARNING: OEb, not OE).
    .i_tex_in   (i_tex_in), //NOTE: io[3] is unused, currently.

    // Debug/demo signals:
    .i_debug_m  (1'b0), // Map debug overlay
    .i_debug_t  (1'b0), // Trace debug overlay
    .i_debug_v  (ui_in[3]), // Vectors debug overlay
    .i_inc_px   (ui_in[4]),
    .i_inc_py   (ui_in[5]),
    .i_gen_tex  (ui_in[7]), // 1=Use bitwise-generated textures instead of SPI texture memory.
    // .o_vinf     (vinf),
    // .o_hmax     (hmax),
    // .o_vmax     (vmax),
    // VGA outputs:
    // .o_hblank   (uio_out[0]),
    // .o_vblank   (uio_out[1]),
    .hpos       (hpos),
    .vpos       (vpos),
    .hsync_n    (hsync_n), // Unregistered.
    .vsync_n    (vsync_n), // Unregistered.
    .rgb        (rgb)
  );

  assign uio_oe = { // 1 = output, 0 = input.
    1'b0,       // uio[7]: tex_io2        input.
    1'b0,       // uio[6]: tex_io1        input.
    ~o_tex_oeb0,// uio[5]: tex_io0        BIDIRECTIONAL. Inverted; rbzero gives OEb, need OE.
    1'b0,       // uio[4]: SPI2 reg_ss_n  input.
    1'b0,       // uio[3]: SPI2 reg_mosi  input.
    1'b0,       // uio[2]: SPI2 reg_sclk  input.
    1'b1,       // uio[1]: tex_sclk       OUTPUT.
    1'b1        // uio[0]: tex_csb        OUTPUT.
  };
  // Unused uio output paths:
  assign uio_out[7:6] = 2'b00;
  assign uio_out[4:2] = 3'b000;

endmodule
