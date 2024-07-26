`default_nettype none

module tt_top (
    inout ctrl_sel_rst_n_PAD,
    inout ctrl_sel_inc_PAD,
    inout ctrl_ena_PAD,
    inout [7:0] ui_in_PAD,
    inout [7:0] uo_out_PAD,
    inout [7:0] uio_PAD,
    inout clk_PAD,
    inout rst_n_PAD,
    inout loopback_in_PAD,
    inout loopback_out_PAD,
    inout unused_PAD
);

  wire ctrl_sel_rst_n;
  wire ctrl_sel_inc;
  wire ctrl_ena;
  wire [7:0] ui_in;
  wire [7:0] uo_out;
  wire [7:0] uio_in;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  wire clk;
  wire rst_n;
  wire loopback;
  wire _unused;

  sg13g2_IOPadIn sg13g2_ctrl_sel_rst_n (
      .p2c(ctrl_sel_rst_n),
      .pad({ctrl_sel_rst_n_PAD})
  );
  sg13g2_IOPadIn sg13g2_ctrl_sel_inc (
      .p2c(ctrl_sel_inc),
      .pad({ctrl_sel_inc_PAD})
  );
  sg13g2_IOPadIn sg13g2_ctrl_ena (
      .p2c(ctrl_ena),
      .pad({ctrl_ena_PAD})
  );
  sg13g2_IOPadIn sg13g2_ui_in_0 (
      .p2c(ui_in[0]),
      .pad({ui_in_PAD[0]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_1 (
      .p2c(ui_in[1]),
      .pad({ui_in_PAD[1]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_2 (
      .p2c(ui_in[2]),
      .pad({ui_in_PAD[2]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_3 (
      .p2c(ui_in[3]),
      .pad({ui_in_PAD[3]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_4 (
      .p2c(ui_in[4]),
      .pad({ui_in_PAD[4]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_5 (
      .p2c(ui_in[5]),
      .pad({ui_in_PAD[5]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_6 (
      .p2c(ui_in[6]),
      .pad({ui_in_PAD[6]})
  );
  sg13g2_IOPadIn sg13g2_ui_in_7 (
      .p2c(ui_in[7]),
      .pad({ui_in_PAD[7]})
  );

  sg13g2_IOPadIn sg13g2_clk (
      .p2c(clk),
      .pad({clk_PAD})
  );
  sg13g2_IOPadIn sg13g2_rst_n (
      .p2c(rst_n),
      .pad({rst_n_PAD})
  );

  sg13g2_IOPadIn sg13g2_loopback_in (
      .p2c(loopback),
      .pad({loopback_in_PAD})
  );

  (* keep *)
  sg13g2_IOPadIn sg13g2_unused (
      .p2c(_unused),
      .pad({unused_PAD})
  );

  sg13g2_IOPadInOut4mA sg13g2_uio_0 (
      .c2p   (uio_out[0]),
      .c2p_en(uio_oe[0]),
      .p2c   (uio_in[0]),
      .pad   ({uio_PAD[0]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_1 (
      .c2p   (uio_out[1]),
      .c2p_en(uio_oe[1]),
      .p2c   (uio_in[1]),
      .pad   ({uio_PAD[1]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_2 (
      .c2p   (uio_out[2]),
      .c2p_en(uio_oe[2]),
      .p2c   (uio_in[2]),
      .pad   ({uio_PAD[2]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_3 (
      .c2p   (uio_out[3]),
      .c2p_en(uio_oe[3]),
      .p2c   (uio_in[3]),
      .pad   ({uio_PAD[3]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_4 (
      .c2p   (uio_out[4]),
      .c2p_en(uio_oe[4]),
      .p2c   (uio_in[4]),
      .pad   ({uio_PAD[4]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_5 (
      .c2p   (uio_out[5]),
      .c2p_en(uio_oe[5]),
      .p2c   (uio_in[5]),
      .pad   ({uio_PAD[5]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_6 (
      .c2p   (uio_out[6]),
      .c2p_en(uio_oe[6]),
      .p2c   (uio_in[6]),
      .pad   ({uio_PAD[6]})
  );
  sg13g2_IOPadInOut4mA sg13g2_uio_7 (
      .c2p   (uio_out[7]),
      .c2p_en(uio_oe[7]),
      .p2c   (uio_in[7]),
      .pad   ({uio_PAD[7]})
  );

  sg13g2_IOPadOut4mA sg13g2_uo_out_0 (
      .c2p(uo_out[0]),
      .pad({uo_out_PAD[0]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_1 (
      .c2p(uo_out[1]),
      .pad({uo_out_PAD[1]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_2 (
      .c2p(uo_out[2]),
      .pad({uo_out_PAD[2]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_3 (
      .c2p(uo_out[3]),
      .pad({uo_out_PAD[3]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_4 (
      .c2p(uo_out[4]),
      .pad({uo_out_PAD[4]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_5 (
      .c2p(uo_out[5]),
      .pad({uo_out_PAD[5]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_6 (
      .c2p(uo_out[6]),
      .pad({uo_out_PAD[6]})
  );
  sg13g2_IOPadOut4mA sg13g2_uo_out_7 (
      .c2p(uo_out[7]),
      .pad({uo_out_PAD[7]})
  );

  sg13g2_IOPadOut4mA sg13g2_loopback_out (
      .c2p(loopback),
      .pad({loopback_out_PAD})
  );

  (* keep *)
  tt_logo tt_logo_I ();

  wire [4:0] addr;

  counter counter_I (
      .ctrl_sel_rst_n(ctrl_sel_rst_n),
      .ctrl_sel_inc  (ctrl_sel_inc),
      .addr          (addr)
  );

  wire [17:0] iw;
  wire [23:0] ow;

  assign iw = {uio_in, ui_in, rst_n, clk};
  assign {uio_oe, uio_out, uo_out} = ow;

  basic_mux mux_I (
      .ena (ctrl_ena),
      .addr(addr),
      .iw  (iw),
      .ow  (ow)
  );

endmodule
