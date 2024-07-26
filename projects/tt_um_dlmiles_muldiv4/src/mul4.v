/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : mul4                                                         **
 **                                                                          **
 *****************************************************************************/

module p08_mul4( a,
             b,
             opsigned,
             p );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input [3:0] a;
   input [3:0] b;
   input       opsigned;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output [7:0] p;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire [7:0] s_logisimBus24;
   wire [3:0] s_logisimBus45;
   wire [3:0] s_logisimBus51;
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
   wire       s_logisimNet25;
   wire       s_logisimNet26;
   wire       s_logisimNet27;
   wire       s_logisimNet28;
   wire       s_logisimNet29;
   wire       s_logisimNet3;
   wire       s_logisimNet30;
   wire       s_logisimNet31;
   wire       s_logisimNet32;
   wire       s_logisimNet33;
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
   wire       s_logisimNet46;
   wire       s_logisimNet47;
   wire       s_logisimNet48;
   wire       s_logisimNet49;
   wire       s_logisimNet5;
   wire       s_logisimNet50;
   wire       s_logisimNet52;
   wire       s_logisimNet53;
   wire       s_logisimNet54;
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
   wire       s_logisimNet8;
   wire       s_logisimNet9;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimBus45[3:0] = b;
   assign s_logisimBus51[3:0] = a;
   assign s_logisimNet3       = opsigned;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign p = s_logisimBus24[7:0];

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   p08_AND_GATE #(.BubblesMask(2'b00))
      A1xB0 (.input1(s_logisimBus51[1]),
             .input2(s_logisimBus45[0]),
             .result(s_logisimNet47));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A0xB1 (.input1(s_logisimBus51[0]),
             .input2(s_logisimBus45[1]),
             .result(s_logisimNet49));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A2xB0 (.input1(s_logisimBus51[2]),
             .input2(s_logisimBus45[0]),
             .result(s_logisimNet41));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A1xB1 (.input1(s_logisimBus51[1]),
             .input2(s_logisimBus45[1]),
             .result(s_logisimNet34));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A0xB2 (.input1(s_logisimBus51[0]),
             .input2(s_logisimBus45[2]),
             .result(s_logisimNet61));

   p08_AND_GATE #(.BubblesMask(2'b00))
      TWOS_EN (.input1(s_logisimNet3),
               .input2(s_logisimBus45[3]),
               .result(s_logisimNet1));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A0xB3 (.input1(s_logisimBus51[0]),
             .input2(s_logisimBus45[3]),
             .result(s_logisimNet42));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A3xB0 (.input1(s_logisimBus51[3]),
             .input2(s_logisimBus45[0]),
             .result(s_logisimNet9));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A2xB1 (.input1(s_logisimBus51[2]),
             .input2(s_logisimBus45[1]),
             .result(s_logisimNet69));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A1xB2 (.input1(s_logisimBus51[1]),
             .input2(s_logisimBus45[2]),
             .result(s_logisimNet58));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      P3_INV (.input1(s_logisimNet42),
              .input2(s_logisimNet1),
              .result(s_logisimNet66));

   p08_AND_GATE #(.BubblesMask(2'b00))
      P3_EXTND_EN (.input1(s_logisimNet3),
                   .input2(s_logisimNet9),
                   .result(s_logisimNet13));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A1xB3 (.input1(s_logisimBus51[1]),
             .input2(s_logisimBus45[3]),
             .result(s_logisimNet32));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A3xB1 (.input1(s_logisimBus51[3]),
             .input2(s_logisimBus45[1]),
             .result(s_logisimNet36));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A2xB2 (.input1(s_logisimBus51[2]),
             .input2(s_logisimBus45[2]),
             .result(s_logisimNet30));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      P4_INV (.input1(s_logisimNet32),
              .input2(s_logisimNet1),
              .result(s_logisimNet65));

   p08_AND_GATE #(.BubblesMask(2'b00))
      P4_EXTND_EN (.input1(s_logisimNet3),
                   .input2(s_logisimNet36),
                   .result(s_logisimNet14));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A2xB3 (.input1(s_logisimBus51[2]),
             .input2(s_logisimBus45[3]),
             .result(s_logisimNet67));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A3xB2 (.input1(s_logisimBus51[3]),
             .input2(s_logisimBus45[2]),
             .result(s_logisimNet6));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      P5_INV (.input1(s_logisimNet67),
              .input2(s_logisimNet1),
              .result(s_logisimNet60));

   p08_AND_GATE #(.BubblesMask(2'b00))
      P5_EXTND_EN (.input1(s_logisimNet3),
                   .input2(s_logisimNet6),
                   .result(s_logisimNet43));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A3xB3 (.input1(s_logisimBus51[3]),
             .input2(s_logisimBus45[3]),
             .result(s_logisimNet23));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      P6_INV (.input1(s_logisimNet23),
              .input2(s_logisimNet1),
              .result(s_logisimNet12));

   p08_AND_GATE #(.BubblesMask(2'b00))
      P6_EXTND_EN (.input1(s_logisimNet3),
                   .input2(s_logisimNet12),
                   .result(s_logisimNet62));

   p08_AND_GATE #(.BubblesMask(2'b00))
      A0xB0 (.input1(s_logisimBus51[0]),
             .input2(s_logisimBus45[0]),
             .result(s_logisimBus24[0]));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   p08_HA   HA_P0A0B1 (.A(s_logisimNet47),
                   .B(s_logisimNet49),
                   .C(s_logisimNet33),
                   .S(s_logisimBus24[1]));

   p08_FA   FA_P1A1B1 (.A(s_logisimNet41),
                   .B(s_logisimNet34),
                   .C(s_logisimNet25),
                   .S(s_logisimNet63),
                   .Y(s_logisimNet33));

   p08_HA   HA_P1A0B2 (.A(s_logisimNet63),
                   .B(s_logisimNet61),
                   .C(s_logisimNet29),
                   .S(s_logisimBus24[2]));

   p08_FA   FA_P3A0B3 (.A(s_logisimNet54),
                   .B(s_logisimNet66),
                   .C(s_logisimNet10),
                   .S(s_logisimBus24[3]),
                   .Y(s_logisimNet1));

   p08_FA   FA_P3A2B1 (.A(s_logisimNet9),
                   .B(s_logisimNet69),
                   .C(s_logisimNet38),
                   .S(s_logisimNet40),
                   .Y(s_logisimNet25));

   p08_FA   FA_P3A1B2 (.A(s_logisimNet40),
                   .B(s_logisimNet58),
                   .C(s_logisimNet28),
                   .S(s_logisimNet54),
                   .Y(s_logisimNet29));

   p08_FA   FA_P4A1B3 (.A(s_logisimNet19),
                   .B(s_logisimNet65),
                   .C(s_logisimNet55),
                   .S(s_logisimBus24[4]),
                   .Y(s_logisimNet10));

   p08_FA   FA_P4A3B1 (.A(s_logisimNet36),
                   .B(s_logisimNet13),
                   .C(s_logisimNet56),
                   .S(s_logisimNet31),
                   .Y(s_logisimNet38));

   p08_FA   FA_P4A2B2 (.A(s_logisimNet31),
                   .B(s_logisimNet30),
                   .C(s_logisimNet17),
                   .S(s_logisimNet19),
                   .Y(s_logisimNet28));

   p08_FA   FA_P5A2B3 (.A(s_logisimNet18),
                   .B(s_logisimNet60),
                   .C(s_logisimNet0),
                   .S(s_logisimBus24[5]),
                   .Y(s_logisimNet55));

   p08_FA   FA_P5A3B2 (.A(s_logisimNet16),
                   .B(s_logisimNet6),
                   .C(s_logisimNet57),
                   .S(s_logisimNet18),
                   .Y(s_logisimNet17));

   p08_FA   FA_P5A3B1_EXT (.A(s_logisimNet14),
                       .B(s_logisimNet56),
                       .C(s_logisimNet68),
                       .S(s_logisimNet16),
                       .Y(s_logisimNet13));

   p08_FA   FA_P6A3B3 (.A(s_logisimNet5),
                   .B(s_logisimNet12),
                   .C(s_logisimNet37),
                   .S(s_logisimBus24[6]),
                   .Y(s_logisimNet0));

   p08_FA   FA_P6A3B2_EXT (.A(s_logisimNet59),
                       .B(s_logisimNet43),
                       .C(s_logisimNet50),
                       .S(s_logisimNet5),
                       .Y(s_logisimNet57));

   p08_FA   FA_P6A3B1_EXT (.A(s_logisimNet14),
                       .B(s_logisimNet68),
                       .C(s_logisimNet39),
                       .S(s_logisimNet59),
                       .Y(s_logisimNet13));

   p08_FA   FA_P7A3B3_EXT (.A(s_logisimNet26),
                       .B(s_logisimNet62),
                       .C(),
                       .S(s_logisimBus24[7]),
                       .Y(s_logisimNet37));

   p08_FA   FA_P7A3B2_EXT (.A(s_logisimNet46),
                       .B(s_logisimNet43),
                       .C(),
                       .S(s_logisimNet26),
                       .Y(s_logisimNet50));

   p08_FA   FA_P7A3B1_EXT (.A(s_logisimNet14),
                       .B(s_logisimNet39),
                       .C(),
                       .S(s_logisimNet46),
                       .Y(s_logisimNet13));

endmodule
