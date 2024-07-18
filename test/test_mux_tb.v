`default_nettype none

module tt_top_tb (
    // User projects interface
    input wire clk,
    input wire rst_n,
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    inout wire [7:0] uio,

    // control interface
    input wire [4:0] addr
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

  tt_top tt (
      .addr_PAD(addr),
      .ui_in_PAD(ui_in),
      .uo_out_PAD(uo_out),
      .uio_PAD(uio),
      .clk_PAD(clk),
      .rst_n_PAD(rst_n)
  );

endmodule
