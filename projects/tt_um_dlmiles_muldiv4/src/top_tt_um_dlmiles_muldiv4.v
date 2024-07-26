`default_nettype none

//// uio_out
// uio_out[3:0] div_r
`define UO4_EOVER_BITID 4
`define UO5_EDIV0_BITID 5

//// uio_in
// uio_in[5:0] unused
// unsigned=0/signed=1
`define UI6_US_BITID 6
// mul=0/div=1
`define UI7_MULDIV_BITID 7

// uo_out

module tt_um_dlmiles_muldiv4 (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    localparam WIDTH = 4;
    localparam DWIDTH = WIDTH * 2;

    // backtick notation is not nice to work with, so making it a localparam let us use it without backtick :)
    localparam UO4_EOVER_BITID  = `UO4_EOVER_BITID;
    localparam UO5_EDIV0_BITID  = `UO5_EDIV0_BITID;
    localparam UI6_US_BITID     = `UI6_US_BITID;
    localparam UI7_MULDIV_BITID = `UI7_MULDIV_BITID;


    assign uio_out[7:6] = 2'b00;	// unused tie-down (they are inputs)

    // bidirectionals fixed direction
    //  0  nc (set as input)
    //  1  nc (set as input)
    //  2  nc (set as input)
    //  3  nc (set as input)
    //  4 out OVER (error)
    //  5 out DIV0 (error)
    //  6  in UNSIGNED/SIGNED
    //  7  in MULTIPLY/DIVIDE
    assign uio_oe = 8'b00110000;


    wire                    ctl_signed;
    wire                    ctl_muldiv;

    assign ctl_signed = uio_in[UI6_US_BITID];
    assign ctl_muldiv = uio_in[UI7_MULDIV_BITID];

    wire [WIDTH-1:0]        mul_a;
    wire [WIDTH-1:0]        mul_b;
    wire [DWIDTH-1:0]       mul_p;

    assign mul_a      = ui_in[WIDTH-1 -: WIDTH];
    assign mul_b      = ui_in[DWIDTH-1 -: WIDTH];

    wire [WIDTH-1:0]        div_divend;
    wire [WIDTH-1:0]        div_divsor;
    wire [WIDTH-1:0]        div_q;
    wire [WIDTH-1:0]        div_r;
    wire                    div_err_div0;
    wire                    div_err_over;

    assign div_divend = ui_in[WIDTH-1 -: WIDTH];
    assign div_divsor = ui_in[DWIDTH-1 -: WIDTH];

    p08_mul4 #(
        //.WIDTH     (WIDTH)
    ) mul4 (
        .opsigned  (ctl_signed),
        .a         (mul_a),
        .b         (mul_b),
        .p         (mul_p)
    );

    p08_div4 #(
        //.WIDTH     (WIDTH)
    ) div4 (
        .opsigned  (ctl_signed),
        .dividend  (div_divend),
        .divisor   (div_divsor),
        .quotient  (div_q),
        .remainder (div_r),
        .ediv0     (div_err_div0),
        .eover     (div_err_over)
    );

    assign uo_out[DWIDTH-1:0] = ctl_muldiv ? {div_r,div_q} : mul_p;
    assign uio_out[WIDTH-1:0] = {WIDTH{1'b0}};	// unused tie-down (also set as bidi input)
    assign uio_out[UO4_EOVER_BITID] = ctl_muldiv ? div_err_over : 1'b0;
    assign uio_out[UO5_EDIV0_BITID] = ctl_muldiv ? div_err_div0 : 1'b0;

endmodule
