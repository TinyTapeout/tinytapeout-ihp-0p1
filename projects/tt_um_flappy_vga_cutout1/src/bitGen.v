
module p14_bitGen (
	input wire clock, reset, bright,
	input wire [9:0] h_count, v_count,
	input wire [8:0] bird_pos, hole_pos,
	input wire [9:0] pipe_pos,
	output reg red, green, blue
);

	reg next_red, next_blue, next_green;

	always@(posedge clock)
	begin
		if(!reset)
		begin
			red <= 1'b0;
			green <= 1'b0;
			blue <= 1'b0;
		end
		else
		begin
			red <= next_red;
			green <= next_green;
			blue <= next_blue;
		end
	end

	always@(*)
	begin
		if(bright)
		begin
			if(h_count > 10'd50 && h_count < 10'd100 && v_count < {1'b0, bird_pos} && (v_count > {1'b0, bird_pos - 9'd50} || bird_pos < 9'd50))
			begin
				// yellow (for the bird)
				next_red = 1'b1;
				next_green = 1'b1;
				next_blue = 1'b0;
			end
			else if(h_count < pipe_pos && (h_count > pipe_pos - 10'd100 || pipe_pos < 10'd100) && (v_count < {1'b0, hole_pos} || v_count > {1'b0, hole_pos + 9'd150}))
			begin
				// green (for the pipe)
				next_red = 1'b0;
				next_green = 1'b1;
				next_blue = 1'b0;
			end
			else
			begin
				// blue (for the background)
				next_red = 1'b0;
				next_green = 1'b0;
				next_blue = 1'b1;
			end
		end
		else
		begin
			next_red = 1'b0;
			next_green = 1'b0;
			next_blue = 1'b0;
		end
	end

endmodule
