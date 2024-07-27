`default_nettype none

module tt_um_dinogame (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    logic pix, hs, vs;

    p20_dinogame game (
        .jump_in(ui_in[0]),
        .halt_in(ui_in[1]),
        .debug_in(ui_in[2]),

        .vga_hsync(hs),
        .vga_vsync(vs),
        .vga_red(),
        .vga_green(),
        .vga_blue(),

        .vga_pixel(pix),

        .cfg_accel(ui_in[3] ? uio_in[7:4] : 4'd4),
        .cfg_speed(ui_in[3] ? uio_in[3:0] : 4'd2),

        .clk(clk),
        .sys_rst(!rst_n)
    );

    assign uio_oe = '0;
    assign uio_out = '0;

    assign uo_out = {hs, pix, pix, pix, vs, pix, pix, pix};

endmodule
