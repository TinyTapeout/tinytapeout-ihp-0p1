`default_nettype none

module tt_um_uwuifier (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    p16_uwuifier #(
        .CLK_FREQ(6000000),
        .BAUD(115200)
    ) dut (
        .clk(clk),
        .rst(!rst_n),
        .rx(ui_in[3]),
        .tx(uo_out[4])
    );

    assign uo_out[7:5] = '0;
    assign uo_out[3:0] = '0;
    assign uio_oe[7:0] = '0;
    assign uio_out[7:0] = '0;

endmodule
