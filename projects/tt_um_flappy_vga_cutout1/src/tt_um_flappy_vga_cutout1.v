
// Top level module for a VGA based flappy bird game to be included in Tiny Tapeout 05
//
// Author: Daniel Robinson (cutout on Discord)

module tt_um_flappy_vga_cutout1 (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock (25MHz)
    input  wire       rst_n     // reset_n - low to reset
);
	wire [9:0] h_count, v_count;
	wire [8:0] bird_pos, hole_pos;
	wire [9:0] pipe_pos;
	wire [7:0] score;
	wire red, green, blue;
	wire h_sync, v_sync;
	wire game_button;
	wire bright;

	assign uio_oe = 8'b11111111;
	assign uio_out = score;

	assign game_button = ui_in[0];

	// Tiny VGA PMOD compatible outputs
	assign uo_out[0] = red;    // R1
	assign uo_out[1] = green;  // G1
	assign uo_out[2] = blue;   // B1
	assign uo_out[3] = v_sync; // vsync
	assign uo_out[4] = red;    // R0
	assign uo_out[5] = green;  // G0
	assign uo_out[6] = blue;   // B0
	assign uo_out[7] = h_sync; // hsync

	p14_gameControl game (clk, rst_n, v_sync, game_button, bird_pos, hole_pos, pipe_pos, score);

	p14_vgaControl controller (clk, rst_n, h_sync, v_sync, bright, h_count, v_count);

	p14_bitGen bitGenerator (clk, rst_n, bright, h_count, v_count, bird_pos, hole_pos, pipe_pos, red, green, blue);

endmodule
