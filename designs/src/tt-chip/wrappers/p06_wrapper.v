`default_nettype none

module p06_wrapper (
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

tt_um_psychogenic_neptuneproportional tt_um_I (
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
