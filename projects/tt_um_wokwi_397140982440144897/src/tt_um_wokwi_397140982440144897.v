/* Automatically generated from https://wokwi.com/projects/397140982440144897 */

`default_nettype none

// verilator lint_off UNUSEDSIGNAL
// verilator lint_off PINCONNECTEMPTY

module tt_um_wokwi_397140982440144897(
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
  wire net2 = rst_n;
  wire net3 = ui_in[1];
  wire net4 = ui_in[3];
  wire net5 = ui_in[4];
  wire net6 = ui_in[5];
  wire net7 = ui_in[6];
  wire net8 = ui_in[7];
  wire net9;
  wire net10;
  wire net11;
  wire net12;
  wire net13;
  wire net14;
  wire net15;
  wire net16;
  wire net17;
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
  wire net33 = 1'b1;
  wire net34 = 1'b1;
  wire net35 = 1'b0;
  wire net36 = 1'b0;
  wire net37;
  wire net38;
  wire net39;
  wire net40 = 1'b0;
  wire net41 = 1'b0;
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
  wire net53 = 1'b0;
  wire net54;
  wire net55;
  wire net56;
  wire net57;
  wire net58;
  wire net59;
  wire net60;
  wire net61;
  wire net62 = 1'b0;
  wire net63;
  wire net64;
  wire net65;
  wire net66;
  wire net67;
  wire net68;
  wire net69;
  wire net70;
  wire net71;
  wire net72 = 1'b0;
  wire net73 = 1'b0;
  wire net74;
  wire net75;
  wire net76;
  wire net77;
  wire net78 = 1'b0;
  wire net79;
  wire net80;
  wire net81;
  wire net82 = 1'b0;
  wire net83;
  wire net84;
  wire net85;
  wire net86;
  wire net87;
  wire net88;
  wire net89;
  wire net90;
  wire net91;
  wire net92;
  wire net93;
  wire net94;
  wire net95;
  wire net96;
  wire net97;
  wire net98;
  wire net99;
  wire net100;
  wire net101 = 1'b0;
  wire net102 = 1'b0;
  wire net103;
  wire net104;
  wire net105 = 1'b0;

  assign uo_out[0] = net9;
  assign uo_out[1] = net10;
  assign uo_out[2] = net11;
  assign uo_out[3] = net12;
  assign uo_out[4] = net13;
  assign uo_out[5] = net14;
  assign uo_out[6] = net15;
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

  p04_buffer_cell gate53 (
    .in (net16),
    .out (net17)
  );
  p04_not_cell gate54 (
    .in (net16),
    .out (net18)
  );
  p04_not_cell gate55 (
    .in (net19),
    .out (net20)
  );
  p04_buffer_cell gate56 (
    .in (net19),
    .out (net21)
  );
  p04_not_cell gate57 (
    .in (net22),
    .out (net23)
  );
  p04_not_cell gate58 (
    .in (net24),
    .out (net25)
  );
  p04_buffer_cell gate59 (
    .in (net22),
    .out (net26)
  );
  p04_buffer_cell gate60 (
    .in (net24),
    .out (net27)
  );
  p04_and_cell gate61 (
    .a (net18),
    .b (net21),
    .out (net28)
  );
  p04_and_cell gate74 (
    .a (net28),
    .b (net26),
    .out (net29)
  );
  p04_or_cell gate75 (
    .a (net29),
    .b (net30),
    .out (net9)
  );
  p04_and_cell gate76 (
    .a (net17),
    .b (net20),
    .out (net31)
  );
  p04_and_cell gate77 (
    .a (net31),
    .b (net23),
    .out (net32)
  );
  p04_and_cell gate78 (
    .a (net32),
    .b (net25),
    .out (net30)
  );
  p04_or_cell gate79 (
    .a (net29),
    .b (net37),
    .out (net38)
  );
  p04_or_cell gate80 (
    .a (net38),
    .b (net30),
    .out (net10)
  );
  p04_and_cell gate81 (
    .a (net18),
    .b (net26),
    .out (net39)
  );
  p04_and_cell gate82 (
    .a (net39),
    .b (net27),
    .out (net37)
  );
  p04_or_cell gate83 (
    .a (net42),
    .b (net43),
    .out (net44)
  );
  p04_or_cell gate84 (
    .a (net44),
    .b (net45),
    .out (net46)
  );
  p04_and_cell gate87 (
    .a (net18),
    .b (net20),
    .out (net47)
  );
  p04_and_cell gate88 (
    .a (net47),
    .b (net26),
    .out (net42)
  );
  p04_and_cell gate89 (
    .a (net20),
    .b (net26),
    .out (net48)
  );
  p04_and_cell gate90 (
    .a (net48),
    .b (net25),
    .out (net43)
  );
  p04_and_cell gate91 (
    .a (net25),
    .b (net26),
    .out (net49)
  );
  p04_and_cell gate92 (
    .a (net49),
    .b (net18),
    .out (net45)
  );
  p04_and_cell gate93 (
    .a (net17),
    .b (net50),
    .out (net51)
  );
  p04_and_cell gate85 (
    .a (net20),
    .b (net52),
    .out (net50)
  );
  p04_and_cell gate86 (
    .a (net23),
    .b (net27),
    .out (net52)
  );
  p04_or_cell gate94 (
    .a (net46),
    .b (net51),
    .out (net11)
  );
  p04_xor_cell gate95 (
    .a (net26),
    .b (net27),
    .out (net54)
  );
  p04_and_cell gate96 (
    .a (net18),
    .b (net55),
    .out (net56)
  );
  p04_and_cell gate97 (
    .a (net21),
    .b (net57),
    .out (net55)
  );
  p04_and_cell gate98 (
    .a (net23),
    .b (net27),
    .out (net57)
  );
  p04_and_cell gate99 (
    .a (net17),
    .b (net20),
    .out (net58)
  );
  p04_and_cell gate100 (
    .a (net59),
    .b (net20),
    .out (net60)
  );
  p04_not_cell gate101 (
    .in (net54),
    .out (net59)
  );
  p04_or_cell gate102 (
    .a (net58),
    .b (net60),
    .out (net61)
  );
  p04_or_cell gate103 (
    .a (net61),
    .b (net56),
    .out (net12)
  );
  p04_and_cell gate104 (
    .a (net17),
    .b (net20),
    .out (net63)
  );
  p04_and_cell gate105 (
    .a (net20),
    .b (net23),
    .out (net64)
  );
  p04_and_cell gate106 (
    .a (net18),
    .b (net21),
    .out (net65)
  );
  p04_or_cell gate107 (
    .a (net26),
    .b (net27),
    .out (net66)
  );
  p04_and_cell gate108 (
    .a (net18),
    .b (net67),
    .out (net68)
  );
  p04_and_cell gate109 (
    .a (net26),
    .b (net25),
    .out (net67)
  );
  p04_or_cell gate110 (
    .a (net63),
    .b (net64),
    .out (net69)
  );
  p04_or_cell gate111 (
    .a (net69),
    .b (net70),
    .out (net71)
  );
  p04_or_cell gate112 (
    .a (net71),
    .b (net68),
    .out (net13)
  );
  p04_and_cell gate113 (
    .a (net65),
    .b (net66),
    .out (net70)
  );
  p04_or_cell gate114 (
    .a (net60),
    .b (net70),
    .out (net14)
  );
  p04_or_cell gate115 (
    .a (net74),
    .b (net75),
    .out (net76)
  );
  p04_or_cell gate116 (
    .a (net76),
    .b (net77),
    .out (net15)
  );
  p04_and_cell gate118 (
    .a (net18),
    .b (net26),
    .out (net74)
  );
  p04_and_cell gate119 (
    .a (net79),
    .b (net27),
    .out (net75)
  );
  p04_xor_cell gate120 (
    .a (net17),
    .b (net21),
    .out (net79)
  );
  p04_and_cell gate117 (
    .a (net20),
    .b (net80),
    .out (net77)
  );
  p04_and_cell gate121 (
    .a (net23),
    .b (net25),
    .out (net80)
  );
  p04_dffsr_cell flipflop4 (
    .d (net81),
    .clk (net1),
    .s (net82),
    .r (net83),
    .q (net84),
    .notq (net85)
  );
  p04_and_cell gate2 (
    .a (net86),
    .b (net85),
    .out (net81)
  );
  p04_dffsr_cell flipflop7 (
    .d (net87),
    .clk (net1),
    .s (net82),
    .r (net83),
    .q (net88),
    .notq (net89)
  );
  p04_and_cell gate3 (
    .a (net86),
    .b (net90),
    .out (net87)
  );
  p04_dffsr_cell flipflop8 (
    .d (net91),
    .clk (net1),
    .s (net82),
    .r (net83),
    .q (net92),
    .notq ()
  );
  p04_and_cell gate4 (
    .a (net86),
    .b (net93),
    .out (net91)
  );
  p04_dffsr_cell flipflop9 (
    .d (net94),
    .clk (net1),
    .s (net82),
    .r (net83),
    .q (net95),
    .notq ()
  );
  p04_and_cell gate5 (
    .a (net86),
    .b (net96),
    .out (net94)
  );
  p04_or_cell gate6 (
    .a (net97),
    .b (net3),
    .out (net98)
  );
  p04_and_cell gate17 (
    .a (net92),
    .b (net95),
    .out (net99)
  );
  p04_and_cell gate18 (
    .a (net89),
    .b (net99),
    .out (net100)
  );
  p04_and_cell gate19 (
    .a (net85),
    .b (net100),
    .out (net97)
  );
  p04_mux_cell mux2 (
    .a (net95),
    .b (net5),
    .sel (net4),
    .out (net16)
  );
  p04_mux_cell mux3 (
    .a (net92),
    .b (net6),
    .sel (net4),
    .out (net19)
  );
  p04_mux_cell mux4 (
    .a (net88),
    .b (net7),
    .sel (net4),
    .out (net22)
  );
  p04_mux_cell mux7 (
    .a (net84),
    .b (net8),
    .sel (net4),
    .out (net24)
  );
  p04_not_cell not1 (
    .in (net2),
    .out (net83)
  );
  p04_not_cell not2 (
    .in (net98),
    .out (net86)
  );
  p04_and_cell and1 (
    .a (net88),
    .b (net84),
    .out (net103)
  );
  p04_xor_cell xor1 (
    .a (net84),
    .b (net88),
    .out (net90)
  );
  p04_xor_cell xor2 (
    .a (net103),
    .b (net92),
    .out (net93)
  );
  p04_and_cell and2 (
    .a (net92),
    .b (net103),
    .out (net104)
  );
  p04_xor_cell xor3 (
    .a (net104),
    .b (net95),
    .out (net96)
  );
endmodule
