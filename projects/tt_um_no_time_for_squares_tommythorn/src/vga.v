`default_nettype none
`timescale 1ns / 1ps

// https://www.mythtv.org/wiki/Modeline_Database#VESA_ModePool
// 640 	480 	75 Hz 	37.5 kHz 	ModeLine "640x480" 31.50 640 656 720 840 480 481 484 500 -HSync -VSync

// The implementation of the VGA timing signals is very naive, but
// this way is easy to understand and immediately relatable to the
// ModeLine parameters.
//
// Pixels are visible if vga_visible
// vga_horizontal_blank_strobe marks the beginning of the horizontal blanking
// vga_vertical_blank_strobe marks the beginning of the vertical blanking
module p21_vga(input  wire      clock,
           input wire       reset,
           output wire      vga_visible,
           output reg       vga_horizontal_blank_strobe, // one clock wide pulse pr line
           output reg       vga_vertical_blank_strobe, // one clock wide pulse pr frame
           output reg       vga_hs,
           output reg       vga_vs,
           output reg [9:0] vga_x,
           output reg [9:0] vga_y );

   parameter      M1 = 10 'd 640;
   parameter      M2 = 10 'd 656;
   parameter      M3 = 10 'd 720;
   parameter      M4 = 10 'd 840;
   parameter      M5 = 10 'd 480;
   parameter      M6 = 10 'd 481;
   parameter      M7 = 10 'd 484;
   parameter      M8 = 10 'd 500;
   parameter      hs_active = 1'd 0; // negative sync
   parameter      vs_active = 1'd 0;

   reg            vga_horizontal_visible, vga_vertical_visible;
   assign vga_visible = vga_horizontal_visible & vga_vertical_visible;

   always @(posedge clock) begin
      vga_vertical_blank_strobe <= 0;
      vga_horizontal_blank_strobe <= 0;

      vga_x <= vga_x + 1;

      if (vga_x == M1-1) begin
         vga_horizontal_blank_strobe <= 1;
         vga_horizontal_visible <= 0;
      end

      if (vga_x == M2-1)
        vga_hs <= hs_active;

      if (vga_x == M3-1)
        vga_hs <= !hs_active;

      if (vga_x == M4-1) begin
         vga_horizontal_visible <= 1;
         vga_x <= 0;
         vga_y <= vga_y + 1;

         if (vga_y == M5-1) begin
            vga_vertical_blank_strobe <= 1;
            vga_vertical_visible <= 0;
         end

         if (vga_y == M6-1)
           vga_vs <= vs_active;

         if (vga_y == M7-1)
           vga_vs <= !vs_active;

         if (vga_y == M8-1) begin
            vga_y <= 0;
            vga_vertical_visible <= 1;
         end
      end

      if (reset) begin
         vga_x <= 0;
         vga_y <= 0;
         vga_hs <= !hs_active;
         vga_vs <= !hs_active;
         vga_vertical_visible <= 1;
         vga_horizontal_visible <= 1;
         vga_vertical_blank_strobe <= 0;
         vga_horizontal_blank_strobe <= 0;
      end
   end
endmodule


`ifdef SIMVGA
module p21_tb;
   reg clock = 1;
   reg reset = 1;
   wire hour_button;
   wire minute_button;
   wire [3:0] debug_sel;

   wire       vga_hs;
   wire       vga_vs;
   wire [7:0] debug_out;

   wire       vga_visible, vga_vertical_visible, vga_horizontal_visible;
   wire       vga_horizontal_blank_strobe, vga_vertical_blank_strobe;

   always #5 clock = ~clock;

   p21_vga vga_inst(.clock(clock),
                .reset(reset),
                .vga_visible(vga_visible),
                .vga_horizontal_blank_strobe(vga_horizontal_blank_strobe),
                .vga_vertical_blank_strobe(vga_vertical_blank_strobe),
                .vga_hs(vga_hs),
                .vga_vs(vga_vs));

   initial begin
      $dumpfile("vga.vcd");
      $dumpvars(0, vga_inst);
      #20 reset = 0;
      #10000000 $finish;
   end
endmodule
`endif
