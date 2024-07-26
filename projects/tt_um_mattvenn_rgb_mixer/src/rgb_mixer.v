`default_nettype none
module p07_rgb_mixer (
    input wire clk,
    input wire reset,
    input wire enc0_a,
    input wire enc0_b,
    input wire enc1_a,
    input wire enc1_b,
    input wire enc2_a,
    input wire enc2_b,
    output wire pwm0_out,
    output wire pwm1_out,
    output wire pwm2_out,
    output wire [7:0] enc0,
    output wire [7:0] enc1,
    output wire [7:0] enc2
);
    wire enc0_a_db, enc0_b_db;
    wire enc1_a_db, enc1_b_db;
    wire enc2_a_db, enc2_b_db;

    // debouncers, 2 for each encoder
    p07_debounce #(.HIST_LEN(8)) debounce0_a(.clk(clk), .reset(reset), .button(enc0_a), .debounced(enc0_a_db));
    p07_debounce #(.HIST_LEN(8)) debounce0_b(.clk(clk), .reset(reset), .button(enc0_b), .debounced(enc0_b_db));

    p07_debounce #(.HIST_LEN(8)) debounce1_a(.clk(clk), .reset(reset), .button(enc1_a), .debounced(enc1_a_db));
    p07_debounce #(.HIST_LEN(8)) debounce1_b(.clk(clk), .reset(reset), .button(enc1_b), .debounced(enc1_b_db));

    p07_debounce #(.HIST_LEN(8)) debounce2_a(.clk(clk), .reset(reset), .button(enc2_a), .debounced(enc2_a_db));
    p07_debounce #(.HIST_LEN(8)) debounce2_b(.clk(clk), .reset(reset), .button(enc2_b), .debounced(enc2_b_db));

    // encoders
    p07_encoder #(.WIDTH(8)) encoder0(.clk(clk), .reset(reset), .a(enc0_a_db), .b(enc0_b_db), .value(enc0));
    p07_encoder #(.WIDTH(8)) encoder1(.clk(clk), .reset(reset), .a(enc1_a_db), .b(enc1_b_db), .value(enc1));
    p07_encoder #(.WIDTH(8)) encoder2(.clk(clk), .reset(reset), .a(enc2_a_db), .b(enc2_b_db), .value(enc2));

    // pwm modules
    p07_pwm #(.WIDTH(8)) pwm0(.clk(clk), .reset(reset), .out(pwm0_out), .level(enc0));
    p07_pwm #(.WIDTH(8)) pwm1(.clk(clk), .reset(reset), .out(pwm1_out), .level(enc1));
    p07_pwm #(.WIDTH(8)) pwm2(.clk(clk), .reset(reset), .out(pwm2_out), .level(enc2));

endmodule
