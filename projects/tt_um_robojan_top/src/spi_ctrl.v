`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/30/2023 05:16:47 PM
// Design Name:
// Module Name: spi_ctrl
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


module p18_spi_ctrl
(
    input clk,
    input nRst,
    input start,
    input word_en,
    input [15:0] word,
    output [12:0] line,
    output write_line,
    output reg shift_line,
    output stop_game
    );

    localparam COMMAND = 0;
    localparam DATA = 1;
    localparam CONTROL = 2;
    localparam DONE = 3;

    localparam CMD_DATA = 1;
    localparam CMD_CONTROL = 2;

    reg [1:0] state;
    reg [1:0] next_state;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            state <= COMMAND;
        end else begin
            state <= start ? COMMAND : next_state;
        end
    end

    wire [1:0] cmd_code = word[1:0];
    assign line = word[12:0];

    always @(*)
    begin
        case(state)
            COMMAND: begin
                if(word_en) begin
                    if(cmd_code == CMD_DATA) begin
                        next_state = DATA;
                    end else if(cmd_code == CMD_CONTROL) begin
                        next_state = CONTROL;
                    end else begin
                        next_state = DONE;
                    end
                end else begin
                    next_state = COMMAND;
                end
            end
            DATA: begin
                next_state = DATA;
            end
            CONTROL: begin
                next_state = word_en ? DONE : CONTROL;
            end
        endcase
    end

    assign stop_game = state == CONTROL && word[0] && word_en;
    assign write_line = state == DATA && word_en;

    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            shift_line <= 1'b0;
        end else begin
            shift_line <= write_line;
        end
    end


endmodule
