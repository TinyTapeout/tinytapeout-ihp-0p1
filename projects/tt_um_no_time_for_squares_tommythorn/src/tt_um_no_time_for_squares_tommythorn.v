`default_nettype none
`timescale 1ns / 1ps

module tt_um_no_time_for_squares_tommythorn
  (input  wire [7:0] ui_in,    // Dedicated inputs
   output wire [7:0] uo_out,   // Dedicated outputs
   input  wire [7:0] uio_in,   // IOs: Input path -- UNUSED in this design.
   output wire [7:0] uio_out,  // IOs: Output path
   output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
   input  wire       ena,      // will go high when the design is enabled
   input  wire       clk,      // clock
   input  wire       rst_n     // reset_n - low to reset
   );

   // use bidirectionals as outputs
   assign uio_oe = 8'b11111111;

   wire       hour_button   = ui_in[7];
   wire       minute_button = ui_in[6];
   wire [3:0] debug_sel     = ui_in[3:0];

   wire       vga_hs;
   wire       vga_vs;
   wire [5:0] vga_rgb;

    // https://tinytapeout.com/specs/pinouts/#common-peripherals
   assign uo_out[0] = vga_rgb[5];
   assign uo_out[1] = vga_rgb[3];
   assign uo_out[2] = vga_rgb[1];
   assign uo_out[3] = vga_vs;
   assign uo_out[4] = vga_rgb[4];
   assign uo_out[5] = vga_rgb[2];
   assign uo_out[6] = vga_rgb[0];
   assign uo_out[7] = vga_hs;

   p21_clock clock_inst(clk, !rst_n,
                    hour_button, minute_button, debug_sel,
                    vga_hs, vga_vs, vga_rgb,
                    uio_out);
endmodule
