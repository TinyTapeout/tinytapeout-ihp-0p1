`default_nettype none

module basic_mux (
    input  wire        ena,
    input  wire [ 4:0] addr,
    input  wire [17:0] iw,
    output reg  [23:0] ow
);

  wire p00_selected = (addr == 5'd00) & ena;
  wire [17:0] p00_iw = p00_selected ? iw : 18'b0;
  wire [23:0] p00_ow;
  p00_wrapper p00_I (
      .ena(p00_selected),
      .iw (p00_iw),
      .ow (p00_ow)
  );

  wire p01_selected = (addr == 5'd01) & ena;
  wire [17:0] p01_iw = p01_selected ? iw : 18'b0;
  wire [23:0] p01_ow;
  p01_wrapper p01_I (
      .ena(p01_selected),
      .iw (p01_iw),
      .ow (p01_ow)
  );

`ifndef RTL_TESTBENCH

  wire p02_selected = (addr == 5'd02) & ena;
  wire [17:0] p02_iw = p02_selected ? iw : 18'b0;
  wire [23:0] p02_ow;
  p02_wrapper p02_I (
      .ena(p02_selected),
      .iw (p02_iw),
      .ow (p02_ow)
  );

  wire p03_selected = (addr == 5'd03) & ena;
  wire [17:0] p03_iw = p03_selected ? iw : 18'b0;
  wire [23:0] p03_ow;
  p03_wrapper p03_I (
      .ena(p03_selected),
      .iw (p03_iw),
      .ow (p03_ow)
  );

  wire p04_selected = (addr == 5'd04) & ena;
  wire [17:0] p04_iw = p04_selected ? iw : 18'b0;
  wire [23:0] p04_ow;
  p04_wrapper p04_I (
      .ena(p04_selected),
      .iw (p04_iw),
      .ow (p04_ow)
  );

  wire p05_selected = (addr == 5'd05) & ena;
  wire [17:0] p05_iw = p05_selected ? iw : 18'b0;
  wire [23:0] p05_ow;
  p05_wrapper p05_I (
      .ena(p05_selected),
      .iw (p05_iw),
      .ow (p05_ow)
  );

  wire p06_selected = (addr == 5'd06) & ena;
  wire [17:0] p06_iw = p06_selected ? iw : 18'b0;
  wire [23:0] p06_ow;
  p06_wrapper p06_I (
      .ena(p06_selected),
      .iw (p06_iw),
      .ow (p06_ow)
  );

  wire p07_selected = (addr == 5'd07) & ena;
  wire [17:0] p07_iw = p07_selected ? iw : 18'b0;
  wire [23:0] p07_ow;
  p07_wrapper p07_I (
      .ena(p07_selected),
      .iw (p07_iw),
      .ow (p07_ow)
  );

  wire p08_selected = (addr == 5'd08) & ena;
  wire [17:0] p08_iw = p08_selected ? iw : 18'b0;
  wire [23:0] p08_ow;
  p08_wrapper p08_I (
      .ena(p08_selected),
      .iw (p08_iw),
      .ow (p08_ow)
  );

  wire p09_selected = (addr == 5'd09) & ena;
  wire [17:0] p09_iw = p09_selected ? iw : 18'b0;
  wire [23:0] p09_ow;
  p09_wrapper p09_I (
      .ena(p09_selected),
      .iw (p09_iw),
      .ow (p09_ow)
  );

  wire p10_selected = (addr == 5'd10) & ena;
  wire [17:0] p10_iw = p10_selected ? iw : 18'b0;
  wire [23:0] p10_ow;
  p10_wrapper p10_I (
      .ena(p10_selected),
      .iw (p10_iw),
      .ow (p10_ow)
  );

  wire p11_selected = (addr == 5'd11) & ena;
  wire [17:0] p11_iw = p11_selected ? iw : 18'b0;
  wire [23:0] p11_ow;
  p11_wrapper p11_I (
      .ena(p11_selected),
      .iw (p11_iw),
      .ow (p11_ow)
  );

  wire p12_selected = (addr == 5'd12) & ena;
  wire [17:0] p12_iw = p12_selected ? iw : 18'b0;
  wire [23:0] p12_ow;
  p12_wrapper p12_I (
      .ena(p12_selected),
      .iw (p12_iw),
      .ow (p12_ow)
  );

  wire p13_selected = (addr == 5'd13) & ena;
  wire [17:0] p13_iw = p13_selected ? iw : 18'b0;
  wire [23:0] p13_ow;
  p13_wrapper p13_I (
      .ena(p13_selected),
      .iw (p13_iw),
      .ow (p13_ow)
  );

  wire p14_selected = (addr == 5'd14) & ena;
  wire [17:0] p14_iw = p14_selected ? iw : 18'b0;
  wire [23:0] p14_ow;
  p14_wrapper p14_I (
      .ena(p14_selected),
      .iw (p14_iw),
      .ow (p14_ow)
  );

  wire p15_selected = (addr == 5'd15) & ena;
  wire [17:0] p15_iw = p15_selected ? iw : 18'b0;
  wire [23:0] p15_ow;
  p15_wrapper p15_I (
      .ena(p15_selected),
      .iw (p15_iw),
      .ow (p15_ow)
  );

  wire p16_selected = (addr == 5'd16) & ena;
  wire [17:0] p16_iw = p16_selected ? iw : 18'b0;
  wire [23:0] p16_ow;
  p16_wrapper p16_I (
      .ena(p16_selected),
      .iw (p16_iw),
      .ow (p16_ow)
  );

  wire p17_selected = (addr == 5'd17) & ena;
  wire [17:0] p17_iw = p17_selected ? iw : 18'b0;
  wire [23:0] p17_ow;
  p17_wrapper p17_I (
      .ena(p17_selected),
      .iw (p17_iw),
      .ow (p17_ow)
  );

  wire p18_selected = (addr == 5'd18) & ena;
  wire [17:0] p18_iw = p18_selected ? iw : 18'b0;
  wire [23:0] p18_ow;
  p18_wrapper p18_I (
      .ena(p18_selected),
      .iw (p18_iw),
      .ow (p18_ow)
  );

  wire p19_selected = (addr == 5'd19) & ena;
  wire [17:0] p19_iw = p19_selected ? iw : 18'b0;
  wire [23:0] p19_ow;
  p19_wrapper p19_I (
      .ena(p19_selected),
      .iw (p19_iw),
      .ow (p19_ow)
  );

  wire p20_selected = (addr == 5'd20) & ena;
  wire [17:0] p20_iw = p20_selected ? iw : 18'b0;
  wire [23:0] p20_ow;
  p20_wrapper p20_I (
      .ena(p20_selected),
      .iw (p20_iw),
      .ow (p20_ow)
  );

  wire p21_selected = (addr == 5'd21) & ena;
  wire [17:0] p21_iw = p21_selected ? iw : 18'b0;
  wire [23:0] p21_ow;
  p21_wrapper p21_I (
      .ena(p21_selected),
      .iw (p21_iw),
      .ow (p21_ow)
  );

  wire p22_selected = (addr == 5'd22) & ena;
  wire [17:0] p22_iw = p22_selected ? iw : 18'b0;
  wire [23:0] p22_ow;
  p22_wrapper p22_I (
      .ena(p22_selected),
      .iw (p22_iw),
      .ow (p22_ow)
  );

  wire p23_selected = (addr == 5'd23) & ena;
  wire [17:0] p23_iw = p23_selected ? iw : 18'b0;
  wire [23:0] p23_ow;
  p23_wrapper p23_I (
      .ena(p23_selected),
      .iw (p23_iw),
      .ow (p23_ow)
  );

`endif // RTL_TESTBENCH

  always_comb begin
    if (ena) begin
      case (addr)
        5'd00:   ow = p00_ow;
        5'd01:   ow = p01_ow;
`ifndef RTL_TESTBENCH
        5'd02:   ow = p02_ow;
        5'd03:   ow = p03_ow;
        5'd04:   ow = p04_ow;
        5'd05:   ow = p05_ow;
        5'd06:   ow = p06_ow;
        5'd07:   ow = p07_ow;
        5'd08:   ow = p08_ow;
        5'd09:   ow = p09_ow;
        5'd10:   ow = p10_ow;
        5'd11:   ow = p11_ow;
        5'd12:   ow = p12_ow;
        5'd13:   ow = p13_ow;
        5'd14:   ow = p14_ow;
        5'd15:   ow = p15_ow;
        5'd16:   ow = p16_ow;
        5'd17:   ow = p17_ow;
        5'd18:   ow = p18_ow;
        5'd19:   ow = p19_ow;
        5'd20:   ow = p20_ow;
        5'd21:   ow = p21_ow;
        5'd22:   ow = p22_ow;
        5'd23:   ow = p23_ow;
`endif // RTL_TESTBENCH
        default: ow = 24'b0;
      endcase
    end else begin
      ow = 24'b0;
    end
  end

endmodule
