`default_nettype none

module counter (
  input wire ctrl_sel_rst_n,
  input wire ctrl_sel_inc,
  output reg [4:0] addr
);

  always @(posedge ctrl_sel_inc or negedge ctrl_sel_rst_n) begin
    if (~ctrl_sel_rst_n) begin
      addr <= 5'b0;
    end else begin
      addr <= addr + 5'b1;
    end
  end

endmodule
