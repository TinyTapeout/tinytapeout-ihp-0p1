/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : HA                                                           **
 **                                                                          **
 *****************************************************************************/

module p08_HA( A,
           B,
           C,
           S );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input A;
   input B;

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

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/

   /*******************************************************************************
   ** Here all input connections are defined                                     **
   *******************************************************************************/
   assign s_logisimNet0 = B;
   assign s_logisimNet2 = A;

   /*******************************************************************************
   ** Here all output connections are defined                                    **
   *******************************************************************************/
   assign C = s_logisimNet1;
   assign S = s_logisimNet3;

   /*******************************************************************************
   ** Here all normal components are defined                                     **
   *******************************************************************************/
   p08_AND_GATE #(.BubblesMask(2'b00))
      GATES_1 (.input1(s_logisimNet2),
               .input2(s_logisimNet0),
               .result(s_logisimNet1));

   p08_XOR_GATE_ONEHOT #(.BubblesMask(2'b00))
      GATES_2 (.input1(s_logisimNet0),
               .input2(s_logisimNet2),
               .result(s_logisimNet3));


endmodule
