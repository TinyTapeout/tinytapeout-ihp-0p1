`default_nettype none

module tt_um_tomkeddie_a
  (
   input wire [7:0]  ui_in, // Dedicated inputs
   output wire [7:0] uo_out, // Dedicated outputs
   input wire [7:0]  uio_in, // IOs: Input path
   output wire [7:0] uio_out, // IOs: Output path
   output wire [7:0] uio_oe, // IOs: Enable path (active high: 0=input, 1=output)
   input wire        ena,
   input wire        clk,
   input wire        rst_n
   );

  wire               _unused_ok = &{1'b0,
                                    ena,
                                    uio_in,
                                    ui_in[6:4],
                                    1'b0};

  wire               r0;
  wire               r1;
  wire               r2;
  wire               r3;
  wire               b0;
  wire               b1;
  wire               b2;
  wire               b3;
  wire               g0;
  wire               g1;
  wire               g2;
  wire               g3;
  wire               hs;
  wire               vs;
  wire               rst;
  wire               left_up;
  wire               left_down;
  wire               right_up;
  wire               right_down;
  wire               vga_sel;

  // input pmod
  assign left_up    = ui_in[0];
  assign left_down  = ui_in[1];
  assign right_up   = ui_in[2];
  assign right_down = ui_in[3];

  assign vga_sel = ui_in[7];

  // vga_sel = 0 (mole99)
  // Pin   Signal     Pin     Signal
  // 1     R1         7       R0
  // 2     G1         8       G0
  // 3     B1         9       B0
  // 4     VS         10      HS

  // vga_sel = 1 (Digilent)
  // right pmod
  // Pin   Signal     Pin     Signal
  // 1     R0         7       B0
  // 2     R1         8       B1
  // 3     R2         9       B2
  // 4     R3         10      B3
  //
  // left pmod
  // Pin   Signal     Pin     Signal
  // 1     G0         7       HS
  // 2     G1         8       VS
  // 3     G2         9       N/C
  // 4     G3         10      N/C

  // output is pmod the right
  assign uo_out[0]  = (vga_sel == 1'b1) ? r1 : r0;
  assign uo_out[1]  = (vga_sel == 1'b1) ? g1 : r1;
  assign uo_out[2]  = (vga_sel == 1'b1) ? b1 : r2;
  assign uo_out[3]  = (vga_sel == 1'b1) ? vs : r3;
  assign uo_out[4]  = (vga_sel == 1'b1) ? r0 : b0;
  assign uo_out[5]  = (vga_sel == 1'b1) ? g0 : b1;
  assign uo_out[6]  = (vga_sel == 1'b1) ? b0 : b2;
  assign uo_out[7]  = (vga_sel == 1'b1) ? hs : b3;
  // bidirectional is pmod on left
  assign uio_out[0] = g0;
  assign uio_out[1] = g1;
  assign uio_out[2] = g2;
  assign uio_out[3] = g3;
  assign uio_out[4] = hs;
  assign uio_out[5] = vs;
  assign uio_out[6] = 1'b0;
  assign uio_out[7] = 1'b0;
  assign uio_oe     = (vga_sel == 1'b1) ? 8'b00000000 : 8'b11111111;

  assign rst       = !rst_n;

  // instantiate the DUT
  p10_vga vga(.clk(clk),
          .rst(rst),
          .left_up(left_up),
          .left_down(left_down),
          .right_up(right_up),
          .right_down(right_down),
          .r0(r0),
          .r1(r1),
          .r2(r2),
          .r3(r3),
          .b0(b0),
          .b1(b1),
          .b2(b2),
          .b3(b3),
          .g0(g0),
          .g1(g1),
          .g2(g2),
          .g3(g3),
          .hs(hs),
          .vs(vs));

endmodule
