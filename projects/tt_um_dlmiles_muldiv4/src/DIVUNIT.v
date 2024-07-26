/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : DIVUNIT                                                      **
 **                                                                          **
 *****************************************************************************/

module p08_DIVUNIT( A,
                B,
                C,
                S,
                SEL,
                Y );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input A;
   input B;
   input SEL;
   input Y;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output C;
   output S;

   /*******************************************************************************
   ** The wires are defined here                                                 **
   *******************************************************************************/
   wire s_logisimNet0;
   wire s_logisimNet1;
   wire s_logisimNet2;
   wire s_logisimNet3;
   wire s_logisimNet4;
   wire s_logisimNet5;
   wire s_logisimNet6;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimNet0 = SEL;
   assign s_logisimNet1 = A;
   assign s_logisimNet4 = B;
   assign s_logisimNet5 = Y;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign C = s_logisimNet6;
   assign S = s_logisimNet3;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   p08_Multiplexer_2   PLEXERS_1 (.enable(1'b1),
                              .muxIn_0(s_logisimNet1),
                              .muxIn_1(s_logisimNet2),
                              .muxOut(s_logisimNet3),
                              .sel(s_logisimNet0));


   /*******************************************************************************
   ** Here all sub-circuits are defined                                          **
   *******************************************************************************/

   p08_FA   FA_DU (.A(s_logisimNet1),
               .B(s_logisimNet4),
               .C(s_logisimNet6),
               .S(s_logisimNet2),
               .Y(s_logisimNet5));

endmodule
