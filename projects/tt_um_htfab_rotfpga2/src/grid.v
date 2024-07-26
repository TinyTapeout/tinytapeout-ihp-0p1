`default_nettype none

module p12_grid (
   input clk,           // clock
   input rst_n,         // active-low reset
   input in_se,         // scan enable input
   input in_sc,         // scan chain input
   input [1:0] in_cfg,  // configuration latch selector
   input in_lb,         // loop breaker enable
   input [1:0] in_lbc,  // loop breaker class
   input [7:0] ins,     // user input
   output out_sc,       // scan chain output
   output [7:0] outs    // user output
);

`define WIDTH 8
`define HEIGHT 8

wire ic_u[`HEIGHT-1:0][`WIDTH-1:0];   // interconnect for data going upwards
wire ic_d[`HEIGHT-1:0][`WIDTH-1:0];   // ~ downwards
wire ic_r[`HEIGHT-1:0][`WIDTH:0];     // ~ to the right
wire ic_l[`HEIGHT-1:0][`WIDTH:0];     // ~ to the left
wire ic_sc[`HEIGHT-1:0][`WIDTH:0];    // interconnect for the scan chain
wire ic_lb[`HEIGHT-1:0][`WIDTH-1:0];  // loop breaker input for the current tile class
wire [1:0] bi_l[`HEIGHT-1:0][`WIDTH-1:0];  // loop breaker inserts: bypass or latch (going back to the tile)
wire [1:0] bo_b[`HEIGHT-1:0][`WIDTH-1:0];  // loop breaker inserts: bypass (coming from the tile)
wire [1:0] bo_l[`HEIGHT-1:0][`WIDTH-1:0];  // loop breaker inserts: latch (coming from the tile)
wire in_se_r = rst_n ? in_se : 1'b1;  // scan enable input, overridden on reset
wire in_sc_r = rst_n ? in_sc : 1'b0;  // scan chain input, overridden on reset
wire in_lb_r = rst_n ? in_lb : 1'b1;  // loop breaker enable, overridden on reset
wire cfg_v = rst_n ? (in_cfg == 2'd1) : 1'b1;   // whether to update "vertical flip" latches
wire cfg_h = rst_n ? (in_cfg == 2'd2) : 1'b1;   // whether to update "horizontal flip" latches
wire cfg_d = rst_n ? (in_cfg == 2'd3) : 1'b1;   // whether to update "diagonal flip" latches"
wire [3:0] w_lb = {in_lb_r ? {in_lbc != 2'd3, in_lbc != 2'd2, in_lbc != 2'd1} : 3'b0, in_lbc != 2'd0 || !rst_n};
                                      // whether to latch outputs, for each of the four loop breaker classes

generate genvar x, y;
for (y=0; y<`HEIGHT; y=y+1) begin:g_y
   // logic for the left and right edges of the grid
   assign ic_r[y][0] = ins[y];
   assign ic_l[y][`WIDTH] = ic_l[y][0];
   assign outs[y] = ic_r[y][`WIDTH];
   assign ic_sc[y][0] = (y > 0) ? ic_sc[y-1][`WIDTH] : in_sc_r;
   for (x=0; x<`WIDTH; x=x+1) begin:g_x
      // instantiate the tiles, with wrap-around at top and bottom edges
      p12_tile t (
         .clk(clk),
         .in_se(in_se_r),
         .in_sc(ic_sc[y][x]),
         .in_lb(ic_lb[y][x]),
         .in_v(cfg_v),
         .in_h(cfg_h),
         .in_d(cfg_d),
         .in_t(ic_d[y][x]),
         .in_r(ic_l[y][x+1]),
         .in_b(ic_u[(y+1)%`HEIGHT][x]),
         .in_l(ic_r[y][x]),
         .bi_l(bi_l[y][x]),
         .bo_b(bo_b[y][x]),
         .bo_l(bo_l[y][x]),
         .out_sc(ic_sc[y][x+1]),
         .out_t(ic_u[y][x]),
         .out_r(ic_r[y][x+1]),
         .out_b(ic_d[(y+1)%`HEIGHT][x]),
         .out_l(ic_l[y][x])
      );
      // select whether to use the loop breaker
      if ((x+y)%2==0) begin
         assign bi_l[y][x] = bo_l[y][x];
      end else begin
         assign bi_l[y][x] = bo_b[y][x];
      end
      // choose the loop breaker class
      if ((x+y)%4==0 && (8+x-y)%4==0) begin
         assign ic_lb[y][x] = w_lb[0];
      end else if ((x+y)%4==0 && (8+x-y)%4==2) begin
         assign ic_lb[y][x] = w_lb[1];
      end else if ((x+y)%4==2 && (8+x-y)%4==0) begin
         assign ic_lb[y][x] = w_lb[2];
      end else if ((x+y)%4==2 && (8+x-y)%4==2) begin
         assign ic_lb[y][x] = w_lb[3];
      end else begin
         assign ic_lb[y][x] = 1'b1;
      end
   end
end
endgenerate

assign out_sc = ic_sc[`HEIGHT-1][`WIDTH];

endmodule

`default_nettype wire

