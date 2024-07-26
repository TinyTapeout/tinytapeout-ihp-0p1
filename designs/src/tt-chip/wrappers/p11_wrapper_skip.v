`default_nettype none

module p11_wrapper (
  input wire ena,
  input wire [17:0] iw,
  output wire [23:0] ow
);

wire _unused = &{iw, 'b0};
assign ow = 24'b0;

endmodule
