`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/07/2023 07:53:38 PM
// Design Name:
// Module Name: robojan_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tt_um_robojan_top (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire vblank;
    wire hblank;
    wire miso_en;
    wire miso;
    wire sound;
    p18_breakout breakout(
        .clk(clk),
        .nRst(rst_n),
        .en(ena),
        .btn_left_pin(ui_in[5]),
        .btn_right_pin(ui_in[6]),
        .btn_select_pin(ui_in[7]),
        .vga_r(uo_out[3:2]),
        .vga_g(uo_out[5:4]),
        .vga_b(uo_out[7:6]),
        .vga_hsync(uo_out[0]),
        .vga_vsync(uo_out[1]),
        .vblank(vblank),
        .hblank(hblank),
        .sck_pin(ui_in[1]),
        .ss_pin(ui_in[2]),
        .mosi_pin(ui_in[0]),
        .miso_en(miso_en),
        .miso(miso),
        .sound_out(sound)
    );

    assign uio_oe = {4'b0, 1'b1, 1'b1, 1'b1, miso_en};
    assign uio_out = {4'b0, sound, vblank, hblank, miso};

endmodule
