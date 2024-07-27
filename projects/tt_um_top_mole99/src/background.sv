// SPDX-FileCopyrightText: © 2022 Leo Moser <leo.moser@pm.me>
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

/* verilator lint_off UNUSEDSIGNAL */

module p09_background #(
    parameter HTOTAL,               // total horizontal pixel
    parameter VTOTAL                // total vertical pixel
)(
    input  logic [1:0] bg_select,   // currently selected background
    input  logic [7:0] cur_time,    // current time for animations

    input  logic signed [$clog2(HTOTAL) : 0] counter_h, // current horizontal position
    input  logic signed [$clog2(VTOTAL) : 0] counter_v, // current vertical position

    input  logic [5:0] color1,      // user defined color 1
    input  logic [5:0] color2,      // user defined color 2
    input  logic [5:0] color3,      // user defined color 3
    input  logic [5:0] color4,      // user defined color 4

    output logic [5:0] color_out    // background color for current position
);

    // TODO enable/disable movement

    logic [1:0] color_sel1, color_sel2;

    //assign color_sel1 = counter_h[5:4] + counter_v[5:4] + cur_frame[3:2];
    //assign color_sel2 = counter_v[5:4] + cur_frame;

    logic [11:0] tmp;
    assign tmp = (counter_h + counter_v) + {4'd0, cur_time};

    assign color_sel1 = tmp[7:6];

    logic [11:0] tmp2;
    assign tmp2 = counter_v + {4'd0, cur_time};

    assign color_sel2 = tmp2[6:5];


    logic [1:0] color_sel;
    assign color_sel = bg_select[0] ? color_sel2 : color_sel1;

    logic [5:0] tmp_color;

    always_comb begin
        case (color_sel)
            2'b00: tmp_color = color1;
            2'b01: tmp_color = color2;
            2'b10: tmp_color = color3;
            2'b11: tmp_color = color4;
        endcase
    end

    always_comb begin
        case (bg_select)
            2'b00:
                color_out = color3;
            2'b01:
                color_out = (counter_h[7:2] ^ counter_v[7:2]) + cur_time[7:2];
            2'b10:
                color_out = tmp_color;
            2'b11:
                color_out = tmp_color;
        endcase
    end

endmodule
