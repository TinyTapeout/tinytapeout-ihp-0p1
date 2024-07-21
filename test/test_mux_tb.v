`default_nettype none

module tt_top_tb (
    // User projects interface
    input wire clk,
    input wire rst_n,
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    inout wire [7:0] uio,

    // control interface
    input wire ctrl_sel_rst_n,
    input wire ctrl_sel_inc,
    input wire ctrl_ena,

    // loopback interface
    input wire loopback_in,
    output wire loopback_out
);

`ifdef SIM_ICARUS
  initial begin
    string f_name;
    $timeformat(-9, 2, " ns", 20);
    if ($value$plusargs("WAVE_FILE=%s", f_name)) begin
      $display("%0t: Capturing wave file %s", $time, f_name);
      $dumpfile(f_name);
      $dumpvars(0, tt_top_tb);
    end else begin
      $display("%0t: No filename provided - disabling wave capture", $time);
    end
  end
`endif

  wire _unused;

  tt_top tt (
      .ctrl_sel_rst_n_PAD(ctrl_sel_rst_n),
      .ctrl_sel_inc_PAD(ctrl_sel_inc),
      .ctrl_ena_PAD(ctrl_ena),
      .ui_in_PAD(ui_in),
      .uo_out_PAD(uo_out),
      .uio_PAD(uio),
      .clk_PAD(clk),
      .rst_n_PAD(rst_n),
      .loopback_in_PAD(loopback_in),
      .loopback_out_PAD(loopback_out),
      .unused_PAD(_unused)
  );

endmodule
