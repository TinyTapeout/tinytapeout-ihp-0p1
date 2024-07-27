`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/07/2023 09:48:35 PM
// Design Name:
// Module Name: vga_timing
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


module p18_vga_timing(
    input clk,
    input nRst,
    output reg hsync,
    output reg hactive,
    output [9:0] hpos,
    output reg vsync,
    output reg vactive,
    output [8:0] vpos,
    output active,
    output line_pulse,
    output frame_pulse
    );


    reg [9:0] hor_counter;
    wire hor_at_end = hor_counter == 10'd799;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            hor_counter <= 10'b0;
        end else begin
            if(hor_at_end) begin
                hor_counter <= 10'b0;
            end else begin
                hor_counter <= hor_counter + 1'b1;
            end
        end
    end

    reg [9:0] vert_counter;
    wire vert_at_end = vert_counter == 10'd524;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            vert_counter <= 10'b0;
        end else begin
            if(hor_at_end) begin
                if(vert_at_end) begin
                    vert_counter <= 10'b0;
                end else begin
                    vert_counter <= vert_counter + 1'b1;
                end
            end
        end
    end

    wire hsync_start = hor_counter == 10'd656;
    wire hsync_end = hor_counter == 10'd752;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            hsync <= 1'b1;
        end else begin
            if(hsync_start) begin
                hsync <= 1'b0;
            end else if(hsync_end) begin
                hsync <= 1'b1;
            end
        end
    end

    wire hactive_end = hor_counter == 10'd639;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            hactive <= 1'b1;
        end else begin
            if(hor_at_end) begin
                hactive <= 1'b1;
            end else if(hactive_end) begin
                hactive <= 1'b0;
            end
        end
    end

    wire vsync_start = vert_counter == 10'd490;
    wire vsync_end = vert_counter == 10'd492;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            vsync <= 1'b1;
        end else begin
            if(vsync_start) begin
                vsync <= 1'b0;
            end else if(vsync_end) begin
                vsync <= 1'b1;
            end
        end
    end

    wire vactive_end = vert_counter == 10'd479;
    always @(posedge clk or negedge nRst)
    begin
        if(!nRst) begin
            vactive <= 1'b1;
        end else begin
            if(vert_at_end && hor_at_end) begin
                vactive <= 1'b1;
            end else if(vactive_end && hor_at_end) begin
                vactive <= 1'b0;
            end
        end
    end



    assign line_pulse = hor_at_end;
    assign frame_pulse = vert_at_end && line_pulse; // Make sure that the pulse is only one clock cycle wide
    assign hpos = hor_counter;
    assign vpos = vert_counter[8:0];
    assign active = hactive && vactive;

endmodule
