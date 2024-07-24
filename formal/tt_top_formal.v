
module tt_top_formal ();

wire ctrl_sel_rst_n;
wire ctrl_sel_inc;
wire ctrl_ena;
wire [7:0] ui_in;
wire [7:0] uo_out;
wire [7:0] uio;
wire clk;
wire rst_n;
wire loopback_in;
wire loopback_out;
wire unused;

tt_top tt_top(
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
    .unused_PAD(unused),
);

    // loopback the output to the input
    assign ui_in = uo_out;
    // loopback the bidirectionals, if they're set as output
    assign tt_top.uio_in = tt_top.uio_out & tt_top.uio_oe;

    // only useful for cover
    initial assume(rst_n == 0);
    initial assume(ctrl_sel_rst_n == 0);

endmodule
