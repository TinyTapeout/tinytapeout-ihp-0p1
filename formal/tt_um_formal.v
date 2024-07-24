/*
 * tt_um_formal.v
 *
 * User module for formal connectivity proof
 *
 * Author: Matt Venn <matt@mattvenn.net>
 */

`default_nettype none

module tt_um_formal (
	input  wire [7:0] ui_in,	// Dedicated inputs
	output wire [7:0] uo_out,	// Dedicated outputs
	input  wire [7:0] uio_in,	// IOs: Input path
	output wire [7:0] uio_out,	// IOs: Output path
	output wire [7:0] uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,
	input  wire       clk,
	input  wire       rst_n
);
    
    // let solver drive the outputs
    rand reg [7:0] anyseq1; assign uo_out   = anyseq1;
    // bidirectional outputs
    rand reg [3:0] anyseq2; assign uio_out[3:0]  = anyseq2;
    // bidirectional enables - hard code bottom 4 are outputs
    assign uio_oe[7:0] = 8'b00001111;
    
    always @(*) begin
        if(ena) begin
            // if design is enabled, looped back inputs must = outputs
            ui_loop: assert(ui_in == uo_out);
            // bidirectional outputs
            bidir: assert(uio_in[7:4] == uio_out[3:0]);
            // some covers
            cover(ui_in == 8'hAA);
            cover(uio_in == 8'hAA);
        end else begin
            // otherwise inputs must be 0
            assert(ui_in == 0);
            assert(uio_in == 0);
            // design is in reset 
            assert(rst_n == 0);
            // no clock
            assert(clk == 0);
        end
    end

endmodule // tt_um_formal

