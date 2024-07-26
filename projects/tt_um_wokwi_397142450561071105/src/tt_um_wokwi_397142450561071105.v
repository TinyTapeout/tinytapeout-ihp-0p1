/* Automatically generated from https://wokwi.com/projects/397142450561071105 */

`default_nettype none

// verilator lint_off UNUSEDSIGNAL
// verilator lint_off PINCONNECTEMPTY

module tt_um_wokwi_397142450561071105(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,    // Dedicated outputs
  input  wire [7:0] uio_in,    // IOs: Input path
  output wire [7:0] uio_out,    // IOs: Output path
  output wire [7:0] uio_oe,    // IOs: Enable path (active high: 0=input, 1=output)
  input ena,
  input clk,
  input rst_n
);
  wire net1 = clk;
  wire net2 = ui_in[1];
  wire net3 = ui_in[2];
  wire net4 = ui_in[3];
  wire net5 = ui_in[4];
  wire net6 = ui_in[7];
  wire net7;
  wire net8;
  wire net9 = 1'b0;
  wire net10 = 1'b1;
  wire net11 = 1'b1;
  wire net12;
  wire net13;
  wire net14;
  wire net15 = 1'b0;
  wire net16 = 1'b0;
  wire net17 = 1'b0;
  wire net18;
  wire net19;
  wire net20;
  wire net21;
  wire net22;
  wire net23;
  wire net24;
  wire net25;
  wire net26;
  wire net27;
  wire net28;
  wire net29;
  wire net30;
  wire net31;
  wire net32;
  wire net33;
  wire net34;
  wire net35;
  wire net36;
  wire net37;
  wire net38;
  wire net39;
  wire net40;
  wire net41;
  wire net42;
  wire net43;
  wire net44;
  wire net45;
  wire net46;
  wire net47;
  wire net48;
  wire net49;
  wire net50;
  wire net51;
  wire net52;
  wire net53;
  wire net54;
  wire net55;
  wire net56;
  wire net57;
  wire net58;
  wire net59;

  assign uo_out[0] = 0;
  assign uo_out[1] = net7;
  assign uo_out[2] = net7;
  assign uo_out[3] = net8;
  assign uo_out[4] = net8;
  assign uo_out[5] = net8;
  assign uo_out[6] = 0;
  assign uo_out[7] = 0;
  assign uio_out[0] = 0;
  assign uio_oe[0] = 0;
  assign uio_out[1] = 0;
  assign uio_oe[1] = 0;
  assign uio_out[2] = 0;
  assign uio_oe[2] = 0;
  assign uio_out[3] = 0;
  assign uio_oe[3] = 0;
  assign uio_out[4] = 0;
  assign uio_oe[4] = 0;
  assign uio_out[5] = 0;
  assign uio_oe[5] = 0;
  assign uio_out[6] = 0;
  assign uio_oe[6] = 0;
  assign uio_out[7] = 0;
  assign uio_oe[7] = 0;

  p05_dff_cell flipflop1 (
    .d (net12),
    .clk (net1),
    .q (net13),
    .notq ()
  );
  p05_dff_cell flipflop2 (
    .d (net14),
    .clk (net1),
    .q (net7),
    .notq ()
  );
  p05_or_cell gate1 (
    .a (net13),
    .b (net7),
    .out (net8)
  );
  p05_and_cell gate2 (
    .a (net18),
    .b (net19),
    .out (net20)
  );
  p05_and_cell gate3 (
    .a (net20),
    .b (net13),
    .out (net21)
  );
  p05_or_cell gate4 (
    .a (net21),
    .b (net22),
    .out (net23)
  );
  p05_or_cell gate5 (
    .a (net23),
    .b (net24),
    .out (net25)
  );
  p05_and_cell gate6 (
    .a (net18),
    .b (net26),
    .out (net27)
  );
  p05_and_cell gate7 (
    .a (net27),
    .b (net13),
    .out (net22)
  );
  p05_and_cell gate8 (
    .a (net18),
    .b (net28),
    .out (net29)
  );
  p05_and_cell gate9 (
    .a (net29),
    .b (net13),
    .out (net24)
  );
  p05_not_cell not1 (
    .in (net30),
    .out (net18)
  );
  p05_buffer_cell not2 (
    .in (net31),
    .out (net26)
  );
  p05_buffer_cell not3 (
    .in (net32),
    .out (net28)
  );
  p05_or_cell gate10 (
    .a (net30),
    .b (net25),
    .out (net12)
  );
  p05_and_cell gate11 (
    .a (net13),
    .b (net18),
    .out (net33)
  );
  p05_and_cell gate12 (
    .a (net33),
    .b (net34),
    .out (net35)
  );
  p05_and_cell gate13 (
    .a (net35),
    .b (net36),
    .out (net37)
  );
  p05_and_cell gate14 (
    .a (net18),
    .b (net7),
    .out (net38)
  );
  p05_or_cell gate15 (
    .a (net39),
    .b (net38),
    .out (net14)
  );
  p05_and_cell gate16 (
    .a (net37),
    .b (net40),
    .out (net39)
  );
  p05_buffer_cell not4 (
    .in (net41),
    .out (net40)
  );
  p05_buffer_cell gate17 (
    .in (net2),
    .out (net30)
  );
  p05_buffer_cell gate21 (
    .in (net42),
    .out (net19)
  );
  p05_buffer_cell gate22 (
    .in (net43),
    .out (net36)
  );
  p05_buffer_cell gate23 (
    .in (net44),
    .out (net34)
  );
  p05_not_cell gate27 (
    .in (net4),
    .out (net45)
  );
  p05_buffer_cell not8 (
    .in (net4),
    .out (net46)
  );
  p05_mux_cell mux7 (
    .a (net46),
    .b (net45),
    .sel (net47),
    .out (net31)
  );
  p05_mux_cell mux8 (
    .a (net45),
    .b (net46),
    .sel (net47),
    .out (net44)
  );
  p05_dff_cell flipflop4 (
    .d (net48),
    .clk (net1),
    .q (net47),
    .notq (net49)
  );
  p05_not_cell gate18 (
    .in (net3),
    .out (net50)
  );
  p05_buffer_cell not9 (
    .in (net3),
    .out (net51)
  );
  p05_mux_cell mux9 (
    .a (net51),
    .b (net50),
    .sel (net52),
    .out (net42)
  );
  p05_mux_cell mux10 (
    .a (net50),
    .b (net51),
    .sel (net52),
    .out (net41)
  );
  p05_dff_cell flipflop5 (
    .d (net53),
    .clk (net1),
    .q (net52),
    .notq (net54)
  );
  p05_not_cell gate28 (
    .in (net5),
    .out (net55)
  );
  p05_buffer_cell not10 (
    .in (net5),
    .out (net56)
  );
  p05_mux_cell mux11 (
    .a (net56),
    .b (net55),
    .sel (net57),
    .out (net32)
  );
  p05_mux_cell mux12 (
    .a (net55),
    .b (net56),
    .sel (net57),
    .out (net43)
  );
  p05_dff_cell flipflop6 (
    .d (net58),
    .clk (net1),
    .q (net57),
    .notq (net59)
  );
  p05_mux_cell mux1 (
    .a (net54),
    .b (net3),
    .sel (net6),
    .out (net53)
  );
  p05_mux_cell mux2 (
    .a (net49),
    .b (net4),
    .sel (net6),
    .out (net48)
  );
  p05_mux_cell mux3 (
    .a (net5),
    .b (net59),
    .sel (net6),
    .out (net58)
  );
endmodule
