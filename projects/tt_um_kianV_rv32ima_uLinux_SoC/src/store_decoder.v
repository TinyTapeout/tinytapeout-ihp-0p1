/*
 *  kianv harris multicycle RISC-V rv32im
 *
 *  copyright (c) 2022 hirosh dabui <hirosh@dabui.de>
 *
 *  permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  the software is provided "as is" and the author disclaims all warranties
 *  with regard to this software including all implied warranties of
 *  merchantability and fitness. in no event shall the author be liable for
 *  any special, direct, indirect, or consequential damages or any damages
 *  whatsoever resulting from loss of use, data or profits, whether in an
 *  action of contract, negligence or other tortious action, arising out of
 *  or in connection with the use or performance of this software.
 *
 */
`default_nettype none

`include "riscv_defines.vh"
module p23_store_decoder (
    input wire [2:0] funct3,
    input wire amo_operation_store,
    output reg [`STORE_OP_WIDTH -1:0] STOREop
);
  wire is_sb = funct3[1:0] == 2'b00;
  wire is_sh = funct3[1:0] == 2'b01;
  wire is_sw = funct3[1:0] == 2'b10;

  always @(*) begin
    if (!amo_operation_store) begin
      case (1'b1)
        is_sb: STOREop = `STORE_OP_SB;
        is_sh: STOREop = `STORE_OP_SH;
        is_sw: STOREop = `STORE_OP_SW;
        default:
        /* verilator lint_off WIDTH */
        STOREop = 'hxx;
        /* verilator lint_on WIDTH */
      endcase
    end else begin
      STOREop = `STORE_OP_SW;
    end
  end
endmodule
