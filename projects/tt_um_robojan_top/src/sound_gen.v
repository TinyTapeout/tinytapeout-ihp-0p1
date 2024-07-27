

module p18_sound_gen #(
    parameter SOUND_DIVIDER = 5,
    parameter HIGH_LENGTH = 3,
    parameter LOW_LENGTH = 6
) (
    input clk,
    input nRst,
    output sound,
    input line_pulse,
    input frame_pulse,
    input low_beep,
    input high_beep
);


reg [SOUND_DIVIDER:0] sound_counter;
wire high_beep_wave = sound_counter[SOUND_DIVIDER - 1];
wire low_beep_wave = sound_counter[SOUND_DIVIDER];

reg high_en;
reg low_en;
assign sound = ((high_en & high_beep_wave) ^ (low_beep_wave & low_en)) && (high_en || low_en);

always @(posedge line_pulse or negedge nRst)
begin
    if(!nRst) begin
        sound_counter <= 0;
    end else begin
        sound_counter <= sound_counter + 1'b1;
    end
end

reg [2:0] high_counter;
wire high_at_end = high_counter == HIGH_LENGTH;
always @(posedge clk or negedge nRst)
begin
    if(!nRst) begin
        high_counter <= 0;
        high_en <= 0;
    end else begin
        if(frame_pulse) begin
            if(high_at_end) begin
                high_counter <= 0;
                high_en <= high_beep;
            end else if(high_en) begin
                high_counter <= high_counter + 1'b1;
            end
        end else if(high_beep) begin
            high_en <= 1'b1;
            high_counter <= 0;
        end
    end
end

reg [2:0] low_counter;
wire low_at_end = low_counter == LOW_LENGTH;
always @(posedge clk or negedge nRst)
begin
    if(!nRst) begin
        low_counter <= 0;
        low_en <= 0;
    end else begin
        if(frame_pulse) begin
            if(low_at_end) begin
                low_counter <= 0;
                low_en <= low_beep;
            end else if(low_en) begin
                low_counter <= low_counter + 1'b1;
            end
        end else if(low_beep) begin
            low_en <= 1'b1;
            low_counter <= 0;
        end
    end
end

endmodule
