`default_nettype none

module tt_um_htfab_rotfpga2 (
    input  wire [7:0] ui_in,    // input pins (for user input)
    output wire [7:0] uo_out,   // output pins (for user output)
    input  wire [7:0] uio_in,   // bidirectional input pins (for scan chain, configuration and loop breaker input)
    output wire [7:0] uio_out,  // bidirectional output pins (for scan chain output)
    output wire [7:0] uio_oe,   // direction of bidirectional pins (0=input, 1=output)
    input  wire       ena,      // whether design is enabled (unused)
    input  wire       clk,      // clock
    input  wire       rst_n     // active-low reset
);

    p12_grid g (
        .clk(clk),
        .rst_n(rst_n),
        .in_se(uio_in[0]),
        .in_sc(uio_in[1]),
        .in_cfg(uio_in[3:2]),
        .in_lb(uio_in[4]),
        .in_lbc(uio_in[6:5]),
        .ins(ui_in),
        .out_sc(uio_out[7]),
        .outs(uo_out)
    );

    assign uio_out[6:0] = 7'b0000000;
    assign uio_oe[6:0] = 7'b0000000;
    assign uio_oe[7] = 1'b1;

    wire _unused = &{uio_in[7], ena, 1'b0};

endmodule
