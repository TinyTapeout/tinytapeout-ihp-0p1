`default_nettype none

/*
    Verilog code for playing a RTTL ringtone on a Piezo Speaker

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

module tt_um_meriac_play_tune #( parameter MAX_COUNT = 100 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [11:0] db_entry;

    reg [6:0] note_address;
    reg [15:0] ticks;
    reg [7:0] freq, counter;
    reg speaker;

    // Feed inputs through to 7-segment LED
    assign uo_out = ui_in;

    // use bidirectionals as speaker outputs
    assign uio_oe = 8'b11111111;
    assign uio_out[0] = speaker;
    assign uio_out[1] = ~speaker;
    assign uio_out[7:2] = 0;

    always @(posedge clk) begin

        if (!rst_n) begin

            ticks <= 0;
            freq <= 0;
            counter <= 0;
            speaker <= 0;
            note_address <= 0;

        end else begin

            if (ticks>0) begin
                ticks <= ticks - 1'b1;

                // tone frequency divider
                if (counter>0) begin
                    counter <= counter - 1'b1;
                    speaker <= counter >= (freq/2);
                end else begin
                    counter <= freq;
                    speaker <= 1'b0;
                end

            end else begin
                // update per-note delay
                ticks[15:12] <= db_entry[3:0];
                ticks[11:0] <= 0;

                // reset tone generator
                counter <= db_entry[11:4];
                freq <= db_entry[11:4];

                if (note_address<MAX_COUNT) begin
                    note_address <= note_address + 1'b1;
                end else begin
                    note_address <= 0;
                end
            end

        end

    end

    // instantiate tune database
    p11_meriac_tune_db meriac_tune_db(.address(note_address), .db_entry(db_entry));

endmodule
