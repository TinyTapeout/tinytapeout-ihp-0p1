`default_nettype none

module tt_um_MichaelBell_nanoV (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg spi_select, spi_mosi;
    wire spi_clk_enable;
    wire buffered_spi_clk_enable;
    assign uio_out[1] = spi_select;
    assign uio_out[0] = spi_mosi;
    assign uio_out[2] = !clk && buffered_spi_clk_enable;
    assign uio_out[7] = spi_clk_enable;
    reg buffered_spi_in;

//`ifdef SIM
    assign buffered_spi_clk_enable = spi_clk_enable;
//`else
//    sky130_fd_sc_hd__buf_1 i_buf ( .X(buffered_spi_clk_enable), .A(spi_clk_enable) );
//`endif

    wire uart_txd, uart_rts;
    assign uio_out[5] = uart_txd;
    assign uio_out[6] = uart_rts;
    wire uart_rxd = uio_in[4];

    // Switch SPI bidis to inputs when in reset (allows external programming of SPI RAM
    // while in reset).
    assign uio_oe[7:0] = rst_n ? 8'b11100111: 8'b01100000;

    // Bidi outputs used as inputs
    assign uio_out[3] = 0;
    assign uio_out[4] = 0;

    always @(negedge clk)
        buffered_spi_in <= uio_in[3];

    wire spi_data_nano, spi_select_nano;
    always @(posedge clk)
        if (!rst_n)
            spi_select <= 1;
        else
            spi_select <= spi_select_nano;

    always @(posedge clk)
        spi_mosi <= spi_data_nano;

    wire [31:0] data_in;
    wire [31:0] addr_out;
    wire [31:0] data_out;
    wire is_data, is_data_in;
    wire is_addr;
    reg [7:0] output_data;
    assign uo_out = output_data;

    p19_nanoV_cpu #(.NUM_REGS(16)) nano(
        .clk(clk),
        .rstn(rst_n),
        .spi_data_in(buffered_spi_in),
        .spi_select(spi_select_nano),
        .spi_out(spi_data_nano),
        .spi_clk_enable(spi_clk_enable),
        .ext_data_in(data_in),
        .addr_out(addr_out),
        .data_out(data_out),
        .store_data_out(is_data),
        .store_addr_out(is_addr),
        .data_in_read(is_data_in));

    localparam PERI_NONE = 0;
    localparam PERI_GPIO_OUT = 2;
    localparam PERI_GPIO_IN = 3;
    localparam PERI_UART = 4;
    localparam PERI_UART_STATUS = 5;

    reg [2:0] connect_peripheral;

    always @(posedge clk) begin
        if (!rst_n) begin
            connect_peripheral <= PERI_NONE;
        end
        else if (is_addr) begin
            if (addr_out == 32'h10000000) connect_peripheral <= PERI_GPIO_OUT;
            else if (addr_out == 32'h10000004) connect_peripheral <= PERI_GPIO_IN;
            else if (addr_out == 32'h10000010) connect_peripheral <= PERI_UART;
            else if (addr_out == 32'h10000014) connect_peripheral <= PERI_UART_STATUS;
            else connect_peripheral <= PERI_NONE;
        end

        if (is_data && connect_peripheral == PERI_GPIO_OUT) output_data <= data_out[7:0];
    end

    wire uart_tx_busy;
    wire uart_rx_valid;
    wire [7:0] uart_rx_data;
    assign data_in[31:8] = 0;
    assign data_in[7:0] = connect_peripheral == PERI_GPIO_OUT ? output_data :
                          connect_peripheral == PERI_GPIO_IN ? ui_in :
                          connect_peripheral == PERI_UART ? uart_rx_data :
                          connect_peripheral == PERI_UART_STATUS ? {6'b0, uart_rx_valid, uart_tx_busy} : 0;

    wire uart_tx_start = is_data && connect_peripheral == PERI_UART;
    wire [7:0] uart_tx_data = data_out[7:0];

    p19_uart_tx #(.CLK_HZ(12_000_000), .BIT_RATE(93_750)) i_uart_tx(
        .clk(clk),
        .resetn(rst_n),
        .uart_txd(uart_txd),
        .uart_tx_en(uart_tx_start),
        .uart_tx_data(uart_tx_data),
        .uart_tx_busy(uart_tx_busy)
    );

    p19_uart_rx #(.CLK_HZ(12_000_000), .BIT_RATE(93_750)) i_uart_rx(
        .clk(clk),
        .resetn(rst_n),
        .uart_rxd(uart_rxd),
        .uart_rts(uart_rts),
        .uart_rx_read(connect_peripheral == PERI_UART && is_data_in),
        .uart_rx_valid(uart_rx_valid),
        .uart_rx_data(uart_rx_data)
    );

endmodule
