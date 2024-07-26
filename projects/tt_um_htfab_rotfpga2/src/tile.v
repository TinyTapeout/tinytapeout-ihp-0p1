`default_nettype none

module p12_tile (
   input clk,     // clock
   input in_se,   // scan chain enable
   input in_sc,   // scan chain input
   input in_lb,   // loop breaker
   input in_v,    // vertical flip
   input in_h,    // horizontal flip
   input in_d,    // diagonal flip
   input in_t,    // top input
   input in_r,    // right input
   input in_b,    // bottom input
   input in_l,    // left input
   input [1:0] bi_l,  // loop breaker inserts
   output [1:0] bo_b, //   bypass: bi_l <- bo_b
   output [1:0] bo_l, //   latch:  bi_l <- bo_l
   output out_sc, // scan chain output
   output out_t,  // top output
   output out_r,  // right output
   output out_b,  // bottom output
   output out_l   // left output
);

reg r_v, r_h, r_d, r_gnl, r_ghl, r_sc;
wire w_vt, w_vb, w_hr, w_hl, w_dh, w_dv, w_na;
wire w_gn, w_gh, w_oh, w_ov, w_si;

// configuration latches to store the current state of vertical, horizontal and diagonal flips
// r_v, r_h, r_d are the currently latched values
// in_v, in_h, in_d specify whether to update the latches
// r_sc is the potential new value, coming from the tile's flip-flop

always_latch begin
    if (in_v) r_v = r_sc;
    if (in_h) r_h = r_sc;
    if (in_d) r_d = r_sc;
end

// convert inputs of the rotated/reflected tile to inputs of the original upright tile
// top, right, bottom, left inputs of the rotated/reflected tile are in_t, in_r, in_b, in_l

// vertical flip
assign w_vt = r_v ? in_b : in_t;
assign w_vb = r_v ? in_t : in_b;
// horizontal flip
assign w_hr = r_h ? in_l : in_r;
assign w_hl = r_h ? in_r : in_l;
// diagonal flip
assign w_dh = r_d ? w_vt : w_hl;
assign w_dv = r_d ? w_hl : w_vt;

// top input of the upright tile is w_dv
// left input of the upright tile is w_dh
// right and bottom inputs of the upright tile are w_hr and w_vb in some order
//
//         A     V
//   +-----|-----|-----+
//   |  /==:=====/     |
//   |  |  |           |
// >====:==:=====+=======>
//   |  |  |     |     |
//   |  D  ~&    |     |
// <====/  |\====:=======<
//   |     |     |     |
//   |     |     |     |
//   +-----|-----|-----+
//         A     V
//
// top output of the upright tile is w_na
// left output of the upright tile is r_sc
// right and bottom outputs of the upright tile are both w_dh

// flip-flop with scan chain override
assign w_si = in_se ? in_sc : w_dv;
always_ff @(posedge clk) begin
    r_sc <= w_si;
end
// nand gate
assign w_na = ~(w_hr & w_vb);

// implement the loop breaker functionality
// r_gnl and r_ghl are the latched versions of w_na and w_dh respectively
// they are only updated when in_lb is low

always_latch begin
    if (!in_lb) r_gnl = w_na;
    if (!in_lb) r_ghl = w_dh;
end

// to save on chip space, we don't use the loop breaker in every tile
// but we have to make this selection in the parent module
// so we pass back both the latched and unlatched values to the parent module
// we get back either the latched or the unlatched values
// if we get back the unlatched ones, the latches will be optimized out during synthesis

assign bo_b = {w_na, w_dh};
assign bo_l = {r_gnl, r_ghl};
assign {w_gn, w_gh} = bi_l;

// finally we convert the outputs of the upright tile to those of the rotated/reflected one
// top output of the upright tile (with possible latching) is w_gn
// left output of the upright tile is r_sc
// right and bottom outputs of the upright tile (with possible latching) is w_gh

// diagonal flip
assign w_oh = r_d ? w_gn : r_sc;
assign w_ov = r_d ? r_sc : w_gn;
// vertical flip
assign out_t = r_v ? w_gh : w_ov;
assign out_b = r_v ? w_ov : w_gh;
// horizontal flip
assign out_r = r_h ? w_oh : w_gh;
assign out_l = r_h ? w_gh : w_oh;
// scan chain output
assign out_sc = r_sc;

// top, right, bottom left outputs of the rotated/reflected tile are out_t, out_r, out_b, out_l

endmodule

`default_nettype wire

