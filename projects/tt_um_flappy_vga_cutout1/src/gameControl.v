module p14_gameControl (
	input wire clock, reset, v_sync, button,
	output reg [8:0] bird_pos, hole_pos,
	output reg [9:0] pipe_pos,
	output reg [7:0] score
);
	reg [8:0] bird_vert_velocity;
	reg [7:0] next_hole_pos;
	reg has_flapped;
	reg game_over;
	reg restart_game;

	reg has_updated_during_current_v_sync;
	reg update_pulse;

	always @(posedge clock)
	begin
		if(!reset || v_sync)
		begin
			has_updated_during_current_v_sync <= 1'b0;
			update_pulse <= 1'b0;
		end
		else if (has_updated_during_current_v_sync == 1'b0)
		begin
			has_updated_during_current_v_sync <= 1'b1;
			update_pulse <= 1'b1;
		end
		else
		begin
			has_updated_during_current_v_sync <= 1'b1;
			update_pulse <= 1'b0;
		end
	end

	always @(posedge clock)
	begin
		if(!reset || restart_game)
		begin
			bird_pos <= 9'd265;
			hole_pos <= 9'd165;
			pipe_pos <= 10'd600;
			next_hole_pos <= 8'd0;
			score <= 8'd0;

			bird_vert_velocity <= 9'd0;
			has_flapped <= 1'b0;
			game_over <= 1'b0;
			restart_game <= 1'b0;
		end
		else if(update_pulse) begin
			if(!game_over)
			begin
				if(!button && !has_flapped)
				begin
					bird_vert_velocity <= 9'd501;
					has_flapped <= 1'b1;
				end
				else
				begin
					if(button)
						has_flapped <= 1'b0;
					bird_vert_velocity <= bird_vert_velocity + 9'd1;
				end

				bird_pos <= bird_pos + bird_vert_velocity;

				next_hole_pos <= next_hole_pos + bird_pos[7:0];

				if(pipe_pos == 10'd0)
				begin
					pipe_pos <= 10'd740;
					hole_pos <= {1'b0, next_hole_pos} + 9'd37;
					score <= score + 8'd1;
				end
				else
				begin
					pipe_pos <= pipe_pos - 10'd4;
				end

				if(bird_pos > 9'd480 || (pipe_pos < 10'd200 && pipe_pos > 10'd50 && !(bird_pos > hole_pos + 9'd50 && bird_pos < hole_pos + 9'd150)))
					game_over <= 1'b1;
			end
			else if(!button && !has_flapped)
			begin
				game_over <= 1'b0;
				restart_game <= 1'b1;
			end
			else
			begin
				if(button)
					has_flapped <= 1'b0;

				bird_pos <= 9'd265;
				pipe_pos <= 10'd600;
				hole_pos <= 9'd165;
			end
		end
	end
endmodule
