// Envelope shapes:
//     Continue
//     | Attack
//     | | Alternate
//     | | | Hold
//     0 0 x x  \___
//     0 1 x x  /___
//     1 0 0 0  \\\\
//     1 0 0 1  \___
//     1 0 1 0  \/\/
//     1 0 1 1  \```
//     1 1 0 0  ////
//     1 1 0 1  /```
//     1 1 1 0  /\/\
//     1 1 1 1  /___

// Continue == 0 provides duplicated behavior.
// Map it Continue == 1 configurations that produce exactly the same behaviors:
//     0 0 x x  \___ -> 1 0 0 1
//     0 1 x x  /___ -> 1 1 1 1
// Hold' = !Continue, Alternate' = Attack

// Hold == 1 stops after first envelope cycle.
// The value that is hold once stopped can be determined from Attack XOR Alternate.
//       Attack'
//       | Alternate'
//       0 0 1  \___
//       0 1 1  \```
//       1 0 1  /```
//       1 1 1  /___

module p15_envelope #( parameter PERIOD_BITS = 16, parameter ENVELOPE_BITS = 4 ) (
    input  wire clk,
    input  wire enable,
    input  wire reset,

    input  wire hold,
    input  wire alternate,
    input  wire attack,
    input  wire continue_,

    input  wire [PERIOD_BITS-1:0] period,

    output wire [ENVELOPE_BITS-1:0] out
);
    // handle 'Continue == 0' by mapping to counterpart 'Continue == 1' signals
    // that produce the same envelopes
    //     Continue
    //     | Attack
    //     | | Alternate
    //     | | | Hold
    //     0 0 x x  \___ -> 1 0 0 1
    //     0 1 x x  /___ -> 1 1 1 1
    // if Continue == 0 then Hold' = !Continue, Alternate' = Attack
    wire hold_      =   hold || !continue_;
    wire alternate_ =   continue_ ? alternate : attack;
    wire attack_    =   attack;

    // handle 'Hold == 1'
    //       Attack'
    //       | Alternate'
    //       0 0 1  \___
    //       0 1 1  \```
    //       1 0 1  /```
    //       1 1 1  /___
    wire hold__     =   hold_;
    wire alternate__=   hold_ ? ~alternate_ : alternate_;
    wire attack__   =   attack_;

    wire trigger;
    p15_tone #(.PERIOD_BITS(PERIOD_BITS)) tone (    // @TODO: extract counter into a separate model
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .period(period),
        .out(trigger));

   // NOTE: When the envelope-period is 0 or 1, the AY-3-8910 shape-counter counts at
   // one-count for every 16 main-clock cycles, and the YM-2149 counts twice in
   // the same 16 cycles [see: dnotq]
    wire trigger_edge;
    p15_signal_edge signal_edge(
        .clk(clk),
        .reset(reset),
        .signal(trigger),
        .on_posedge(trigger_edge)               // NOTE: assign test_1 = f_env; [see: lvd]
    );

    reg invert_output;
    reg [ENVELOPE_BITS-1:0] envelope_counter;   // @TODO: rename to counter
    reg stop;                                   // @TODO: rename to hold_reached or stop_counter
    always @(posedge clk) begin
        if (reset) begin
            envelope_counter <= 0;
            stop <= 0;
        end else begin
            if (trigger_edge)
                if (!(hold__ && stop))
                    {stop, envelope_counter} <= envelope_counter + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (reset)
            invert_output <= !attack__;
        else begin
            if (trigger_edge && envelope_counter == MAX_VALUE) // NOTE: envelope_counter == MAX_VALUE is used here instead of 'stop' signal, because 'stop' will take effect only on the next cycle!
                if (alternate__)
                    invert_output <= ~invert_output;
        end
    end


    localparam MAX_VALUE = {ENVELOPE_BITS{1'b1}};
    assign out =
        invert_output ? MAX_VALUE - envelope_counter : envelope_counter;

endmodule
