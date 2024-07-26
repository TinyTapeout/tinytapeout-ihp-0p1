/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : div4                                                         **
 **                                                                          **
 *****************************************************************************/

module p08_div4( dividend,
             divisor,
             ediv0,
             eover,
             opsigned,
             quotient,
             remainder );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [3:0] dividend;
   input [3:0] divisor;
   input       opsigned;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output       ediv0;
   output       eover;
   output [3:0] quotient;
   output [3:0] remainder;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [3:0] s_logisimBus30;
   wire [3:0] s_logisimBus33;
   wire [3:0] s_logisimBus47;
   wire [3:0] s_logisimBus54;
   wire [3:0] s_logisimBus70;
   wire       s_logisimNet0;
   wire       s_logisimNet1;
   wire       s_logisimNet10;
   wire       s_logisimNet11;
   wire       s_logisimNet12;
   wire       s_logisimNet13;
   wire       s_logisimNet14;
   wire       s_logisimNet15;
   wire       s_logisimNet16;
   wire       s_logisimNet17;
   wire       s_logisimNet18;
   wire       s_logisimNet19;
   wire       s_logisimNet2;
   wire       s_logisimNet20;
   wire       s_logisimNet21;
   wire       s_logisimNet22;
   wire       s_logisimNet23;
   wire       s_logisimNet24;
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet27;
   wire       s_logisimNet28;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet31;
   wire       s_logisimNet32;
   wire       s_logisimNet34;
   wire       s_logisimNet35;
   wire       s_logisimNet36;
   wire       s_logisimNet37;
   wire       s_logisimNet38;
   wire       s_logisimNet39;
   wire       s_logisimNet4;
   wire       s_logisimNet40;
   wire       s_logisimNet41;
   wire       s_logisimNet42;
   wire       s_logisimNet43;
   wire       s_logisimNet44;
   wire       s_logisimNet45;
   wire       s_logisimNet46;
   wire       s_logisimNet48;
   wire       s_logisimNet49;
   wire       s_logisimNet5;
   wire       s_logisimNet50;
   wire       s_logisimNet51;
   wire       s_logisimNet52;
   wire       s_logisimNet53;
   wire       s_logisimNet55;
   wire       s_logisimNet56;
   wire       s_logisimNet57;
   wire       s_logisimNet58;
   wire       s_logisimNet59;
   wire       s_logisimNet6;
   wire       s_logisimNet60;
   wire       s_logisimNet61;
   wire       s_logisimNet62;
   wire       s_logisimNet63;
   wire       s_logisimNet64;
   wire       s_logisimNet65;
   wire       s_logisimNet66;
   wire       s_logisimNet67;
   wire       s_logisimNet68;
   wire       s_logisimNet69;
   wire       s_logisimNet7;
   wire       s_logisimNet71;
   wire       s_logisimNet72;
   wire       s_logisimNet73;
   wire       s_logisimNet74;
   wire       s_logisimNet75;
   wire       s_logisimNet76;
   wire       s_logisimNet77;
   wire       s_logisimNet78;
   wire       s_logisimNet79;
   wire       s_logisimNet8;
   wire       s_logisimNet80;
   wire       s_logisimNet81;
   wire       s_logisimNet82;
   wire       s_logisimNet83;
   wire       s_logisimNet84;
   wire       s_logisimNet85;
   wire       s_logisimNet86;
   wire       s_logisimNet87;
   wire       s_logisimNet88;
   wire       s_logisimNet89;
   wire       s_logisimNet9;
   wire       s_logisimNet90;
   wire       s_logisimNet91;
   wire       s_logisimNet92;
   wire       s_logisimNet93;
   wire       s_logisimNet94;
   wire       s_logisimNet95;
   wire       s_logisimNet96;
   wire       s_logisimNet97;
   wire       s_logisimNet98;
   wire       s_logisimNet99;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus33[3:0] = dividend;
   assign s_logisimBus47[3:0] = divisor;
   assign s_logisimNet74      = opsigned;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign ediv0     = s_logisimNet43;
   assign eover     = s_logisimNet71;
   assign quotient  = s_logisimBus30[3:0];
   assign remainder = s_logisimBus70[3:0];

   /*******************************************************************************
   ** Here all in-lined components are defined                                   **
   *******************************************************************************/

   // Constant
   assign  s_logisimNet94  =  1'b1;


   // Constant
   assign  s_logisimNet97  =  1'b0;


   // Constant
   assign  s_logisimNet98  =  1'b0;


   // Constant
   assign  s_logisimNet83  =  1'b1;


   // Constant
   assign  s_logisimNet82  =  1'b0;


   // NOT Gate
   assign s_logisimNet11 = ~s_logisimNet53;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD0_DVR (.input1(s_logisimBus47[0]),
                 .input2(s_logisimNet11),
                 .result(s_logisimNet62));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD0_DVD_TWOS (.input1(s_logisimBus33[0]),
                      .input2(s_logisimNet4),
                      .result(s_logisimNet88));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD1_DVD_TWOS (.input1(s_logisimBus33[1]),
                      .input2(s_logisimNet4),
                      .result(s_logisimNet78));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD3_DVD_TWOS (.input1(s_logisimBus33[3]),
                      .input2(s_logisimNet4),
                      .result(s_logisimNet76));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD2_DVD_TWOS (.input1(s_logisimBus33[2]),
                      .input2(s_logisimNet4),
                      .result(s_logisimNet50));

   p08_AND_GATE_4_INPUTS #(.BubblesMask(4'hF))
      DIV0ERROR (.input1(s_logisimBus47[3]),
                 .input2(s_logisimBus47[2]),
                 .input3(s_logisimBus47[1]),
                 .input4(s_logisimBus47[0]),
                 .result(s_logisimNet43));

   p08_AND_GATE #(.BubblesMask(2'b00))
      DVD_TWOS_EN (.input1(s_logisimBus33[3]),
                   .input2(s_logisimNet74),
                   .result(s_logisimNet4));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD1_DVR (.input1(s_logisimBus47[1]),
                 .input2(s_logisimNet11),
                 .result(s_logisimNet10));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD2_DVR (.input1(s_logisimBus47[2]),
                 .input2(s_logisimNet11),
                 .result(s_logisimNet13));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XORD3_DVR (.input1(s_logisimBus47[3]),
                 .input2(s_logisimNet11),
                 .result(s_logisimNet3));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_11 (.input1(s_logisimNet4),
                .input2(s_logisimNet53),
                .result(s_logisimNet65));

   p08_AND_GATE #(.BubblesMask(2'b00))
      DVR_TWOS_EN (.input1(s_logisimNet74),
                   .input2(s_logisimBus47[3]),
                   .result(s_logisimNet53));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_R3_SIGN (.input1(s_logisimNet27),
                   .input2(s_logisimNet4),
                   .result(s_logisimNet21));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_R1_SIGN (.input1(s_logisimNet29),
                   .input2(s_logisimNet4),
                   .result(s_logisimNet25));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_R2_SIGN (.input1(s_logisimNet56),
                   .input2(s_logisimNet4),
                   .result(s_logisimNet51));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_R0_SIGN (.input1(s_logisimNet61),
                   .input2(s_logisimNet4),
                   .result(s_logisimNet60));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_Q0_SIGN (.input1(s_logisimBus54[0]),
                   .input2(s_logisimNet65),
                   .result(s_logisimNet84));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_Q2_SIGN (.input1(s_logisimBus54[2]),
                   .input2(s_logisimNet65),
                   .result(s_logisimNet14));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_Q3_SIGN (.input1(s_logisimBus54[3]),
                   .input2(s_logisimNet65),
                   .result(s_logisimNet63));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      XOR_Q1_SIGN (.input1(s_logisimBus54[1]),
                   .input2(s_logisimNet65),
                   .result(s_logisimNet66));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   p08_DIVUNIT   DUQ0D0d0 (.A(s_logisimNet73),
                       .B(s_logisimNet62),
                       .C(s_logisimNet91),
                       .S(s_logisimNet61),
                       .SEL(s_logisimBus54[0]),
                       .Y(s_logisimNet11));

   p08_DIVUNIT   DUQ0D0d1 (.A(s_logisimNet15),
                       .B(s_logisimNet10),
                       .C(s_logisimNet24),
                       .S(s_logisimNet29),
                       .SEL(s_logisimBus54[0]),
                       .Y(s_logisimNet91));

   p08_DIVUNIT   DUQ1D1d2 (.A(s_logisimNet8),
                       .B(s_logisimNet13),
                       .C(s_logisimNet16),
                       .S(s_logisimNet17),
                       .SEL(s_logisimBus54[1]),
                       .Y(s_logisimNet48));

   p08_DIVUNIT   DUQ1D1d3 (.A(s_logisimNet42),
                       .B(s_logisimNet3),
                       .C(s_logisimNet38),
                       .S(s_logisimNet6),
                       .SEL(s_logisimBus54[1]),
                       .Y(s_logisimNet16));

   p08_DIVUNIT   DUQ1D1d0 (.A(s_logisimNet79),
                       .B(s_logisimNet62),
                       .C(s_logisimNet80),
                       .S(s_logisimNet15),
                       .SEL(s_logisimBus54[1]),
                       .Y(s_logisimNet11));

   p08_DIVUNIT   DUQ0D0d2 (.A(s_logisimNet81),
                       .B(s_logisimNet13),
                       .C(s_logisimNet90),
                       .S(s_logisimNet56),
                       .SEL(s_logisimBus54[0]),
                       .Y(s_logisimNet24));

   p08_DIVUNIT   DUQ3D3d01 (.A(s_logisimNet98),
                        .B(s_logisimNet10),
                        .C(s_logisimNet77),
                        .S(s_logisimNet40),
                        .SEL(s_logisimBus54[3]),
                        .Y(s_logisimNet68));

   p08_DIVUNIT   DUQ1D1d4_EXT (.A(s_logisimNet1),
                           .B(s_logisimNet83),
                           .C(s_logisimBus54[1]),
                           .S(s_logisimNet35),
                           .SEL(s_logisimBus54[1]),
                           .Y(s_logisimNet38));

   p08_DIVUNIT   DUQ2D2d2 (.A(s_logisimNet40),
                       .B(s_logisimNet13),
                       .C(s_logisimNet37),
                       .S(s_logisimNet42),
                       .SEL(s_logisimBus54[2]),
                       .Y(s_logisimNet57));

   p08_DIVUNIT   DUQ1D1d1 (.A(s_logisimNet46),
                       .B(s_logisimNet10),
                       .C(s_logisimNet48),
                       .S(s_logisimNet81),
                       .SEL(s_logisimBus54[1]),
                       .Y(s_logisimNet80));

   p08_DIVUNIT   DUQ0D0d4_EXT (.A(s_logisimNet6),
                           .B(s_logisimNet94),
                           .C(s_logisimBus54[0]),
                           .S(s_logisimNet99),
                           .SEL(s_logisimBus54[0]),
                           .Y(s_logisimNet5));

   p08_DIVUNIT   DUQ3D3d0 (.A(s_logisimNet49),
                       .B(s_logisimNet62),
                       .C(s_logisimNet68),
                       .S(s_logisimNet32),
                       .SEL(s_logisimBus54[3]),
                       .Y(s_logisimNet11));

   p08_DIVUNIT   DUQ3D3d3 (.A(s_logisimNet97),
                       .B(s_logisimNet3),
                       .C(s_logisimBus54[3]),
                       .S(s_logisimNet71),
                       .SEL(s_logisimBus54[3]),
                       .Y(s_logisimNet67));

   p08_DIVUNIT   DUQ2D2d0 (.A(s_logisimNet23),
                       .B(s_logisimNet62),
                       .C(s_logisimNet36),
                       .S(s_logisimNet46),
                       .SEL(s_logisimBus54[2]),
                       .Y(s_logisimNet11));

   p08_DIVUNIT   DUQ2D2d1 (.A(s_logisimNet32),
                       .B(s_logisimNet10),
                       .C(s_logisimNet57),
                       .S(s_logisimNet8),
                       .SEL(s_logisimBus54[2]),
                       .Y(s_logisimNet36));

   p08_DIVUNIT   DUQ3D3d2 (.A(s_logisimNet82),
                       .B(s_logisimNet13),
                       .C(s_logisimNet67),
                       .S(s_logisimNet72),
                       .SEL(s_logisimBus54[3]),
                       .Y(s_logisimNet77));

   p08_DIVUNIT   DUQ0D0d3 (.A(s_logisimNet17),
                       .B(s_logisimNet3),
                       .C(s_logisimNet5),
                       .S(s_logisimNet27),
                       .SEL(s_logisimBus54[0]),
                       .Y(s_logisimNet90));

   p08_DIVUNIT   DUQ2D2d3 (.A(s_logisimNet72),
                       .B(s_logisimNet3),
                       .C(s_logisimBus54[2]),
                       .S(s_logisimNet1),
                       .SEL(s_logisimBus54[2]),
                       .Y(s_logisimNet37));

   p08_HA   HAD2_DVD_TWOS (.A(s_logisimNet50),
                       .B(s_logisimNet75),
                       .C(s_logisimNet45),
                       .S(s_logisimNet23));

   p08_HA   HAD0_DVD_TWOS (.A(s_logisimNet88),
                       .B(s_logisimNet4),
                       .C(s_logisimNet92),
                       .S(s_logisimNet73));

   p08_HA   HAD1_DVD_TWOS (.A(s_logisimNet78),
                       .B(s_logisimNet92),
                       .C(s_logisimNet75),
                       .S(s_logisimNet79));

   p08_HA   HAD3_DVD_TWOS (.A(s_logisimNet76),
                       .B(s_logisimNet45),
                       .C(s_logisimNet96),
                       .S(s_logisimNet49));

   p08_HA   HAR3_SIGN (.A(s_logisimNet21),
                   .B(s_logisimNet55),
                   .C(s_logisimNet58),
                   .S(s_logisimBus70[3]));

   p08_HA   HAR1_SIGN (.A(s_logisimNet25),
                   .B(s_logisimNet52),
                   .C(s_logisimNet19),
                   .S(s_logisimBus70[1]));

   p08_HA   HAR0_SIGN (.A(s_logisimNet60),
                   .B(s_logisimNet4),
                   .C(s_logisimNet52),
                   .S(s_logisimBus70[0]));

   p08_HA   HAR2_SIGN (.A(s_logisimNet51),
                   .B(s_logisimNet19),
                   .C(s_logisimNet55),
                   .S(s_logisimBus70[2]));

   p08_HA   HAQ1_SIGN (.A(s_logisimNet66),
                   .B(s_logisimNet85),
                   .C(s_logisimNet64),
                   .S(s_logisimBus30[1]));

   p08_HA   HAQ0_SIGN (.A(s_logisimNet84),
                   .B(s_logisimNet65),
                   .C(s_logisimNet85),
                   .S(s_logisimBus30[0]));

   p08_HA   HAQ3_SIGN (.A(s_logisimNet63),
                   .B(s_logisimNet0),
                   .C(s_logisimNet95),
                   .S(s_logisimBus30[3]));

   p08_HA   HAQ2_SIGN (.A(s_logisimNet14),
                   .B(s_logisimNet64),
                   .C(s_logisimNet0),
                   .S(s_logisimBus30[2]));

endmodule
