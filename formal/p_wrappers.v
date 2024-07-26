`default_nettype none

module p00_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p01_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p02_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p03_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p04_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p05_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p06_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p07_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p08_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p09_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p10_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p11_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p12_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p13_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p14_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p15_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p16_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p17_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p18_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p19_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p20_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p21_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p22_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p23_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

p_wrapper p_wrapper(
    .ena(ena),
    .iw(iw),
    .ow(ow)
);

endmodule

module p_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

wire [7:0] uio_in;
wire [7:0] uio_out;
wire [7:0] uio_oe;
wire [7:0] uo_out;
wire [7:0] ui_in;
wire clk;
wire rst_n;

assign { uio_in, ui_in, rst_n, clk} = iw;
assign ow = { uio_oe, uio_out, uo_out };

tt_um_formal tt_um_formal (
  .uio_in  (uio_in),
  .uio_out (uio_out),
  .uio_oe  (uio_oe),
  .uo_out  (uo_out),
  .ui_in   (ui_in),
  .ena     (ena),
  .clk     (clk),
  .rst_n   (rst_n)
);

endmodule
