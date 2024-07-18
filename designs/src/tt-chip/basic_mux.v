`default_nettype none

module basic_mux (
    input  wire [ 4:0] addr,
    input  wire [17:0] iw,
    output reg  [23:0] ow
);

  wire p00_selected = (addr == 5'd00);
  wire [17:0] p00_iw = p00_selected ? iw : 18'b0;
  wire [23:0] p00_ow;
  p00_wrapper p00_I (
      .ena(p00_selected),
      .iw (p00_iw),
      .ow (p00_ow)
  );

  wire p01_selected = (addr == 5'd01);
  wire [17:0] p01_iw = p01_selected ? iw : 18'b0;
  wire [23:0] p01_ow;
  p01_wrapper p01_I (
      .ena(p01_selected),
      .iw (p01_iw),
      .ow (p01_ow)
  );

`ifndef RTL_TESTBENCH

  wire p02_selected = (addr == 5'd02);
  wire [17:0] p02_iw = p02_selected ? iw : 18'b0;
  wire [23:0] p02_ow;
  p02_wrapper p02_I (
      .ena(p02_selected),
      .iw (p02_iw),
      .ow (p02_ow)
  );

  wire p03_selected = (addr == 5'd03);
  wire [17:0] p03_iw = p03_selected ? iw : 18'b0;
  wire [23:0] p03_ow;
  p03_wrapper p03_I (
      .ena(p03_selected),
      .iw (p03_iw),
      .ow (p03_ow)
  );

`endif // RTL_TESTBENCH

  always_comb begin
    case (addr)
      5'd00:   ow = p00_ow;
      5'd01:   ow = p01_ow;
`ifndef RTL_TESTBENCH
      5'd02:   ow = p02_ow;
      5'd03:   ow = p03_ow;
`endif // RTL_TESTBENCH
      default: ow = 24'b0;
    endcase
  end

endmodule
