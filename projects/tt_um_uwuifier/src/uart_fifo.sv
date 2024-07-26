`default_nettype none

module p16_uart_fifo #(
    parameter WIDTH = 9,
    parameter DEPTH = 128,
    parameter ALMOST_FULL = 100
) (
    // Read port
    input wire i_rd_en,
    output reg [(WIDTH - 1):0] o_rd_data,
    output reg o_rd_valid = 0,

    // Write port
    input wire i_wr_en,
    input wire [(WIDTH - 1):0] i_wr_data,

    // Status
    output wire o_empty,
    output wire o_full,
    output wire o_almostfull,

    input wire i_clk,
    input wire i_rst
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    reg [(ADDR_WIDTH - 1):0] wr_ptr = 0;
    reg [(ADDR_WIDTH - 1):0] rd_ptr = 0;
    reg [ADDR_WIDTH:0] len = 0;

    reg [(WIDTH - 1):0] ram[0:(DEPTH - 1)];

    /* verilator lint_off WIDTH */
    assign o_empty = (len == 0);
    assign o_full = (len == DEPTH);
    assign o_almostfull = (len >= ALMOST_FULL);
    /* verilator lint_on WIDTH */

    // Write
    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            wr_ptr <= 0;
        end
        else if (i_wr_en) begin
            wr_ptr <= wr_ptr + 1;
            ram[wr_ptr] <= i_wr_data;

            if (o_full) begin
                //$display("ERROR: WROTE TO FULL FIFO");
            end
        end
    end

    // Read
    always_ff @(posedge i_clk) begin
        o_rd_valid <= 0;

        if (i_rst) begin
            rd_ptr <= 0;
        end
        else if (i_rd_en) begin
            rd_ptr <= rd_ptr + 1;
            o_rd_data <= ram[rd_ptr];
            o_rd_valid <= ~o_empty;

            if (o_empty) begin
                //$display("ERROR: READ FROM EMPTY FIFO");
            end
        end
    end

    // Track length
    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            len <= 0;
        end

    // Read, no write
        else if (i_rd_en && ~i_wr_en && ~o_empty) begin
            len <= len - 1;
        end

    // Write, no read
        else if (i_wr_en && ~i_rd_en && ~o_full) begin
            len <= len + 1;
        end

        // Otherwise, if read and write on same cycle, len remains same
    end

endmodule
