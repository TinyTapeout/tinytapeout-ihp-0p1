/*
    Verilog database LUT for playing a RTTL ringtone on a Piezo Speaker

    Copyright 2022-2023 Milosch Meriac <milosch@meriac.com>
    Location: https://github.com/meriac/tt05-play-tune/

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
       contributors may be used to endorse or promote products derived
       from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

module p11_meriac_tune_db (
    input wire [6:0] address,
    output reg [11:0] db_entry
);
    always @(*) begin
        case(address)
                // Song: Super Mario
                // One timer-tick equals 50ms
                // Per-note clock dividers assume 100000Hz clock
                // Bottom-nibble is tick-count per note, upper nibbles are the per-note clock dividers
                 0: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                 1: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                 2: db_entry = 12'h002; // p5  (pause   , 100ms,  2 ticks,   0 fdiv)
                 3: db_entry = 12'h4b6; // e6  (1318.51Hz, 300ms,  6 ticks,  75 fdiv)
                 4: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                 5: db_entry = 12'h4b6; // e6  (1318.51Hz, 300ms,  6 ticks,  75 fdiv)
                 6: db_entry = 12'h3f6; // g6  (1567.98Hz, 300ms,  6 ticks,  63 fdiv)
                 7: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                 8: db_entry = 12'h7f6; // g5  (783.99Hz, 300ms,  6 ticks, 127 fdiv)
                 9: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                10: db_entry = 12'h5f6; // c6  (1046.5Hz, 300ms,  6 ticks,  95 fdiv)
                11: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                12: db_entry = 12'h7f6; // g5  (783.99Hz, 300ms,  6 ticks, 127 fdiv)
                13: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                14: db_entry = 12'h976; // e5  (659.26Hz, 300ms,  6 ticks, 151 fdiv)
                15: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                16: db_entry = 12'h716; // a5  (880.0Hz , 300ms,  6 ticks, 113 fdiv)
                17: db_entry = 12'h656; // b5  (987.77Hz, 300ms,  6 ticks, 101 fdiv)
                18: db_entry = 12'h6b3; // a#5 (932.33Hz, 150ms,  3 ticks, 107 fdiv)
                19: db_entry = 12'h716; // a5  (880.0Hz , 300ms,  6 ticks, 113 fdiv)
                20: db_entry = 12'h7f4; // g5. (783.99Hz, 200ms,  4 ticks, 127 fdiv)
                21: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                22: db_entry = 12'h3f3; // g6  (1567.98Hz, 150ms,  3 ticks,  63 fdiv)
                23: db_entry = 12'h386; // a6  (1760.0Hz, 300ms,  6 ticks,  56 fdiv)
                24: db_entry = 12'h473; // f6  (1396.91Hz, 150ms,  3 ticks,  71 fdiv)
                25: db_entry = 12'h3f6; // g6  (1567.98Hz, 300ms,  6 ticks,  63 fdiv)
                26: db_entry = 12'h4b6; // e6  (1318.51Hz, 300ms,  6 ticks,  75 fdiv)
                27: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                28: db_entry = 12'h553; // d6  (1174.66Hz, 150ms,  3 ticks,  85 fdiv)
                29: db_entry = 12'h656; // b5  (987.77Hz, 300ms,  6 ticks, 101 fdiv)
                30: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                31: db_entry = 12'h5f6; // c6  (1046.5Hz, 300ms,  6 ticks,  95 fdiv)
                32: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                33: db_entry = 12'h7f6; // g5  (783.99Hz, 300ms,  6 ticks, 127 fdiv)
                34: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                35: db_entry = 12'h976; // e5  (659.26Hz, 300ms,  6 ticks, 151 fdiv)
                36: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                37: db_entry = 12'h716; // a5  (880.0Hz , 300ms,  6 ticks, 113 fdiv)
                38: db_entry = 12'h656; // b5  (987.77Hz, 300ms,  6 ticks, 101 fdiv)
                39: db_entry = 12'h6b3; // a#5 (932.33Hz, 150ms,  3 ticks, 107 fdiv)
                40: db_entry = 12'h716; // a5  (880.0Hz , 300ms,  6 ticks, 113 fdiv)
                41: db_entry = 12'h7f4; // g5. (783.99Hz, 200ms,  4 ticks, 127 fdiv)
                42: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                43: db_entry = 12'h3f3; // g6  (1567.98Hz, 150ms,  3 ticks,  63 fdiv)
                44: db_entry = 12'h386; // a6  (1760.0Hz, 300ms,  6 ticks,  56 fdiv)
                45: db_entry = 12'h473; // f6  (1396.91Hz, 150ms,  3 ticks,  71 fdiv)
                46: db_entry = 12'h3f6; // g6  (1567.98Hz, 300ms,  6 ticks,  63 fdiv)
                47: db_entry = 12'h4b6; // e6  (1318.51Hz, 300ms,  6 ticks,  75 fdiv)
                48: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                49: db_entry = 12'h553; // d6  (1174.66Hz, 150ms,  3 ticks,  85 fdiv)
                50: db_entry = 12'h656; // b5  (987.77Hz, 300ms,  6 ticks, 101 fdiv)
                51: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                52: db_entry = 12'h3f3; // g6  (1567.98Hz, 150ms,  3 ticks,  63 fdiv)
                53: db_entry = 12'h433; // f#6 (1479.98Hz, 150ms,  3 ticks,  67 fdiv)
                54: db_entry = 12'h473; // f6  (1396.91Hz, 150ms,  3 ticks,  71 fdiv)
                55: db_entry = 12'h503; // d#6 (1244.51Hz, 150ms,  3 ticks,  80 fdiv)
                56: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                57: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                58: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                59: db_entry = 12'h783; // g#5 (830.61Hz, 150ms,  3 ticks, 120 fdiv)
                60: db_entry = 12'h713; // a5  (880.0Hz , 150ms,  3 ticks, 113 fdiv)
                61: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                62: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                63: db_entry = 12'h713; // a5  (880.0Hz , 150ms,  3 ticks, 113 fdiv)
                64: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                65: db_entry = 12'h553; // d6  (1174.66Hz, 150ms,  3 ticks,  85 fdiv)
                66: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                67: db_entry = 12'h3f3; // g6  (1567.98Hz, 150ms,  3 ticks,  63 fdiv)
                68: db_entry = 12'h433; // f#6 (1479.98Hz, 150ms,  3 ticks,  67 fdiv)
                69: db_entry = 12'h473; // f6  (1396.91Hz, 150ms,  3 ticks,  71 fdiv)
                70: db_entry = 12'h503; // d#6 (1244.51Hz, 150ms,  3 ticks,  80 fdiv)
                71: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                72: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                73: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                74: db_entry = 12'h2f3; // c7  (2093.0Hz, 150ms,  3 ticks,  47 fdiv)
                75: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                76: db_entry = 12'h2f3; // c7  (2093.0Hz, 150ms,  3 ticks,  47 fdiv)
                77: db_entry = 12'h2f3; // c7  (2093.0Hz, 150ms,  3 ticks,  47 fdiv)
                78: db_entry = 12'h00c; // p5  (pause   , 600ms, 12 ticks,   0 fdiv)
                79: db_entry = 12'h3f3; // g6  (1567.98Hz, 150ms,  3 ticks,  63 fdiv)
                80: db_entry = 12'h433; // f#6 (1479.98Hz, 150ms,  3 ticks,  67 fdiv)
                81: db_entry = 12'h473; // f6  (1396.91Hz, 150ms,  3 ticks,  71 fdiv)
                82: db_entry = 12'h503; // d#6 (1244.51Hz, 150ms,  3 ticks,  80 fdiv)
                83: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                84: db_entry = 12'h4b3; // e6  (1318.51Hz, 150ms,  3 ticks,  75 fdiv)
                85: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                86: db_entry = 12'h783; // g#5 (830.61Hz, 150ms,  3 ticks, 120 fdiv)
                87: db_entry = 12'h713; // a5  (880.0Hz , 150ms,  3 ticks, 113 fdiv)
                88: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                89: db_entry = 12'h003; // p5  (pause   , 150ms,  3 ticks,   0 fdiv)
                90: db_entry = 12'h713; // a5  (880.0Hz , 150ms,  3 ticks, 113 fdiv)
                91: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                92: db_entry = 12'h553; // d6  (1174.66Hz, 150ms,  3 ticks,  85 fdiv)
                93: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                94: db_entry = 12'h503; // d#6 (1244.51Hz, 150ms,  3 ticks,  80 fdiv)
                95: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                96: db_entry = 12'h553; // d6  (1174.66Hz, 150ms,  3 ticks,  85 fdiv)
                97: db_entry = 12'h006; // p5  (pause   , 300ms,  6 ticks,   0 fdiv)
                98: db_entry = 12'h5f3; // c6  (1046.5Hz, 150ms,  3 ticks,  95 fdiv)
                99: db_entry = 12'h00c; // p5  (pause   , 600ms, 12 ticks,   0 fdiv)
            default:
                db_entry = 12'h000;
        endcase

    end

endmodule
