/******************************************************************************
 ** Logisim-evolution goes FPGA automatic generated Verilog code             **
 ** https://github.com/logisim-evolution/                                    **
 **                                                                          **
 ** Component : Multiplexer_2                                                **
 **                                                                          **
 *****************************************************************************/

module p08_Multiplexer_2( enable,
                      muxIn_0,
                      muxIn_1,
                      muxOut,
                      sel );

   /*******************************************************************************
   ** The inputs are defined here                                                **
   *******************************************************************************/
   input enable;
   input muxIn_0;
   input muxIn_1;
   input sel;

   /*******************************************************************************
   ** The outputs are defined here                                               **
   *******************************************************************************/
   output muxOut;

   /*******************************************************************************
   ** The module functionality is described here                                 **
   *******************************************************************************/
   reg s_selected_vector;
   assign muxOut = s_selected_vector;

   always @(*)
   begin
      if (~enable) s_selected_vector <= 0;
      else case (sel)
         1'b0:
            s_selected_vector <= muxIn_0;
        default:
           s_selected_vector <= muxIn_1;
      endcase
   end

endmodule
