// FROM General Instruments AY-3-8910 / 8912 Programmable Sound Generator (PSG) data Manual.
// Section 3.1 Tone Generator Control
// [..] the lowest period value is 000000000001 (divide by 1)

// NOTE despite AY-3-891x manual stating that the tone counter is counted down
// 1) reverse engineering: https://github.com/lvd2/ay-3-8910_reverse_engineered
// and
// 2) studies of the chip output according to comments in MAME implementation,
//    line 84 https://github.com/mamedev/mame/blob/master/src/devices/sound/ay8910.cpp
// both determined that tone and noise counters are counted UP!


// Effect of counting UP is such that changing period register will have an immediate effect.
// In contrast counting down delays the effect of the period change until the next wave cycle.
//
//  Initial condition: Period register = 4
//   |
//   v
//   1234 1234 12 12 12 12 12 12 12 12 12 12 12345678              <- counter
//        ----    --    --    --    --    --          ---
//       |    | x|  |  |  |  |  |  |  |  |  | x      |    . . .    <- state flip-flop
//   ----      --    --    --    --    --    --------
//              ^                             ^
//              |                             |
//      write 2 to Period register     write 8 to Period register
//       has an immediate effect,       has an immediate effect,
//     shortening the current wave!   prolonging the current wave!

module p15_tone #( parameter PERIOD_BITS = 12 ) ( // @TODO: extract counter into a separate model and use in tone, noise & envelope
    input  wire clk,
    input  wire enable,
    input  wire reset,

    input  wire [PERIOD_BITS-1:0]  period,

    output wire out
);
    reg [PERIOD_BITS-1:0] counter;
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 1;
            state <= 1;                     // According to dnotq VHDL (and lvd?) flip-flop is set to 1 upon reset
        end else begin
            if (enable) begin
                if (counter >= period) begin // real AY-3-891x uses "carry-out" signal from the comparator to reset counter
                    counter <= 1;           // reset counter to 1
                                            // @INVESTIGATE what UP_RST means in reverse engineered AY-3-891x schematics [see lvd ay_model_counter]
                                            // .UP_RST(0) is present on first flip-flop on ALL the counter chains: tone, noise & envelope!
                                            // However .UP_RST(0) is NOT present on the internal envelope counter that definetely is counting from _0_ to 15
                                                //  // first flipflop
                                                //  ay_model_clk_ff #( .UP_RST(0) ) counter_bit_0
                                            //
                                            // There are two options with real AY-3-891x upon counter reset, either
                                            // A) counter's first flip-flop is set to 1 due to .UP_RST(0)
                                            // OR
                                            // B) counter is reset to 0, but since real AY-3-819x use two-phase clock f1 and /f1
                                            // it might increase the counter on f1, but compare to period on /f1.

// Better explanation from dnotq VHDL implementation
// --------------------------------------------------
// Timing for 0 and 1 period-count, showing why they are the same.  The real
// IC counts on the 4-count of the clock divider, so this implementation
// does the same.  In the real IC, the >= reset and count enable happen in
// the same 4-count cycle due to the asynchronous nature of the IC.  In a
// synchronous FPGA design, the >= reset is performed 1-cycle prior to the
// count enable.
//   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
// _/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_ PSG clock (input clock enable)
//           _______________                 _______________
// ___3___4_/ 5   6   7   0 \_1___2___3___4_/ 5   6   7   0 \_1___2___3___4_ divided clock count
//   ___                             ___                             ___
// _/   \___________________________/   \___________________________/   \___ >= enable (resets count to 0)
//       ___                             ___                             ___
// _____/   \___________________________/   \___________________________/    count enable
// _____ ___ ___________________________ ___ ___________________________ ___
// _____X_0_X______________1____________X_0_X______________1____________X_0_ tone counter
// _____                                 _______________________________
//      \_______________________________/                               \___ tone flip-flop

// The tone counter >= reset strobe must be enabled prior to the count enable
// so the tone counter is only a zero-count for *one input clock cycle*, and
// not the count-enable cycle (i.e. input clock divided by 8).
//
// This is the reason why a period-count of zero is the same as a period-
// count of one.  The time the counter has a zero value is merged with the
// last 8-cycle period where the >= condition is detected.


                    state <= ~state;            // flip output state
                end else
                    counter <= counter + 1'b1;
            end
        end
    end

    assign out = state;
endmodule
