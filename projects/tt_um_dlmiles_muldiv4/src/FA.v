/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : FA                                                           **
 **                                                                          **
 *****************************************************************************/

module p08_FA( A,
           B,
           C,
           S,
           Y );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input A;
   input B;
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
   wire s_logisimNet7;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimNet0 = Y;
   assign s_logisimNet2 = B;
   assign s_logisimNet4 = A;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign C = s_logisimNet7;
   assign S = s_logisimNet5;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   p08_AND_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet2),
               .input2(s_logisimNet4),
               .result(s_logisimNet6));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet4),
               .input2(s_logisimNet2),
               .result(s_logisimNet1));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_3 (.input1(s_logisimNet1),
               .input2(s_logisimNet0),
               .result(s_logisimNet5));

   p08_AND_GATE #(.BubblesMask(2'b00))
      GATES_4 (.input1(s_logisimNet0),
               .input2(s_logisimNet1),
               .result(s_logisimNet3));

   p08_OR_GATE #(.BubblesMask(2'b00))
      GATES_5 (.input1(s_logisimNet3),
               .input2(s_logisimNet6),
               .result(s_logisimNet7));


endmodule
