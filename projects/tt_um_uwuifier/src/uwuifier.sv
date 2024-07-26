`default_nettype none

module p16_uwuifier #(
    parameter CLK_FREQ = 250000,
    parameter BAUD = 9600
) (
    input logic clk,
    input logic rst,

    output logic [23:0] dbg,

    input logic rx,
    output logic tx
);

    logic [7:0] utx_data;
    logic utx_ready, utx_valid;

    logic [7:0] urx_data;
    logic urx_valid;

    logic [7:0] tx_fifo_data;
    logic tx_fifo_en;

    logic almost_full, fifo_empty, fifo_full;

    enum logic [3:0] {READY, WAIT_SPACE, L_OWO_W, L_OWO_O, U_OWO_W, U_OWO_O,
                        L_UWU_W, L_UWU_U, U_UWU_W, U_UWU_U} state, next_state;

    assign dbg[3:0] = state;
    always_ff @(posedge clk) if (urx_valid) dbg[15:8] <= urx_data;
    assign dbg[23:16] = '0;
    assign dbg[7:4] = '0;


    always_ff @(posedge clk) begin
        if (rst) begin
            state <= READY;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        tx_fifo_data = urx_data;
        tx_fifo_en = 0;

        case (state)
            READY: begin
                tx_fifo_data = urx_data;
                tx_fifo_en = urx_valid;
                next_state = READY;

                if (!almost_full) begin
                    if (urx_valid && urx_data == "o") next_state = L_OWO_W;
                    if (urx_valid && urx_data == "O") next_state = U_OWO_W;
                    if (urx_valid && urx_data == "u") next_state = L_UWU_W;
                    if (urx_valid && urx_data == "U") next_state = U_UWU_W;
                end
            end
            WAIT_SPACE: begin
                tx_fifo_data = urx_data;
                tx_fifo_en = urx_valid;
                next_state = WAIT_SPACE;

                if (urx_valid && !((urx_data >= "a" && urx_data <= "z") || (urx_data >= "A" && urx_data <= "Z"))) begin
                    next_state <= READY;
                end
            end
            L_OWO_W: begin
                tx_fifo_data = "w";
                tx_fifo_en = 1;
                next_state = L_OWO_O;
            end
            L_OWO_O: begin
                tx_fifo_data = "o";
                tx_fifo_en = 1;
                next_state = WAIT_SPACE;
            end
            U_OWO_W: begin
                tx_fifo_data = "W";
                tx_fifo_en = 1;
                next_state = U_OWO_O;
            end
            U_OWO_O: begin
                tx_fifo_data = "O";
                tx_fifo_en = 1;
                next_state = WAIT_SPACE;
            end
            L_UWU_W: begin
                tx_fifo_data = "w";
                tx_fifo_en = 1;
                next_state = L_UWU_U;
            end
            L_UWU_U: begin
                tx_fifo_data = "u";
                tx_fifo_en = 1;
                next_state = WAIT_SPACE;
            end
            U_UWU_W: begin
                tx_fifo_data = "W";
                tx_fifo_en = 1;
                next_state = U_UWU_U;
            end
            U_UWU_U: begin
                tx_fifo_data = "U";
                tx_fifo_en = 1;
                next_state = WAIT_SPACE;
            end
        endcase
    end



    p16_uart_tx #( .CLK_FREQ(CLK_FREQ), .BAUD(BAUD) ) utx (
        .o_ready(utx_ready),
        .o_out(tx),
        .i_data(utx_data),
        .i_valid(utx_valid),
        .i_rst(rst),
        .i_clk(clk)
    );

    p16_uart_rx #( .CLK_FREQ(CLK_FREQ), .BAUD(BAUD) ) urx (
        .o_data(urx_data),
        .o_valid(urx_valid),
        .i_in(rx),
        .i_rst(rst),
        .i_clk(clk)
    );

    p16_uart_fifo #( .WIDTH(8), .DEPTH(8), .ALMOST_FULL(4) ) fifo (
        .i_rd_en(utx_ready && !fifo_empty && !utx_valid),
        .o_rd_data(utx_data),
        .o_rd_valid(utx_valid),

        .i_wr_en(tx_fifo_en),
        .i_wr_data(tx_fifo_data),

        .o_empty(fifo_empty),
        .o_full(fifo_full),
        .o_almostfull(almost_full),

        .i_clk(clk),
        .i_rst(rst)
    );

endmodule
