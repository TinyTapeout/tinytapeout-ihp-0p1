`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/30/2023 05:16:47 PM
// Design Name:
// Module Name: spi_if
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


module p18_spi_if
#(
    parameter STATE_SIZE = 10+10+9+8+4
)
(
    input clk,
    input nRst,
    input sck,
    output miso,
    output miso_en,
    input mosi,
    input ss,
    input [STATE_SIZE-1:0] state,
    output [15:0] write_value,
    output reg write_en,
    output start_transaction
    );

    reg sck_delay1;
    reg ss_delay1;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            sck_delay1 <= 1'b0;
            ss_delay1 <= 1'b0;
        end else begin
            sck_delay1 <= sck;
            ss_delay1 <= ss;
        end
    end

    wire sck_posedge = !sck_delay1 && sck;
    wire sck_negedge = sck_delay1 && !sck;
    wire ss_negedge = ss_delay1 && !ss;
    assign start_transaction = ss_negedge;

    reg [STATE_SIZE-1:0] shift_out_state;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            shift_out_state <= 0;
        end else begin
            if(ss_negedge) begin
                shift_out_state <= state;
            end else if(sck_negedge) begin
                shift_out_state <= {shift_out_state[STATE_SIZE-2:0], 1'b1};
            end
        end
    end

    reg shifting;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            shifting <= 1'b0;
        end else begin
            if(ss_negedge) begin
                shifting <= 1'b1;
            end else if(ss_delay1) begin
                shifting <= 1'b0;
            end
        end
    end

    reg [3:0] shift_counter;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            shift_counter <= 4'b0;
        end else begin
            if(ss_negedge) begin
                shift_counter <= 4'b0;
            end else if(sck_posedge && shifting) begin
                shift_counter <= shift_counter + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            write_en <= 1'b0;
        end else begin
            write_en <= shift_counter == 4'b1111 && sck_posedge;
        end
    end

    reg [15:0] shift_reg;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            shift_reg <= 16'b0;
        end else begin
            if(sck_posedge) begin
                shift_reg <= {shift_reg[14:0], mosi};
            end
        end
    end
    assign write_value = shift_reg;

    assign miso_en = shifting;
    assign miso = shift_out_state[STATE_SIZE-1];


endmodule
