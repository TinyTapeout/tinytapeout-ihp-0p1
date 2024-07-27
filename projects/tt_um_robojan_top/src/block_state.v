`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/10/2023 08:48:28 PM
// Design Name:
// Module Name: block_state
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module p18_block_state #(
    parameter NUM_ROWS = 15
)(
    input clk,
    input nRst,
    output [12:0] line,
    input [12:0] new_line,
    input write_line,
    input next_line,
    input reset_state
);

    localparam STATE_WIDTH = NUM_ROWS * 13;

    localparam INITIAL_STATE = {
        13'b1111111111111,
        13'b0111111111111,
        13'b0011111111111,
        13'b0001111111111,
        13'b0000111111111,
        13'b0000011111111,
        13'b0000001111111,
        13'b0000000111111,
        13'b0000000011111,
        13'b0000000001111,
        13'b0000000000111,
        13'b0000000000011,
        13'b0000000000001,
        13'b0000000000000,
        13'b0000000000000
    };

    reg [STATE_WIDTH-1:0] state;
    always @(posedge clk or negedge nRst)
    begin
        if (!nRst) begin
            state <= INITIAL_STATE;
        end else begin
            if (reset_state) begin
                state <= INITIAL_STATE;
            end if (write_line) begin
                state <= {state[STATE_WIDTH - 1:13], new_line};
            end else if (next_line) begin
                state <= {state[12:0], state[STATE_WIDTH - 1:13]};
            end
        end
    end

    assign line = state[12:0];
endmodule
