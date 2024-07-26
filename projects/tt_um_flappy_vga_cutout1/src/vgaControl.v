
module p14_vgaControl (
	input wire clock, reset,       // action on posedge clock, reset is active low, enable active high
	output reg h_sync, v_sync,             // syncs are active low
	output reg bright,                   // bright is active high
	output reg [9:0] h_count, v_count
);

	always @(posedge clock)
	begin
		if(~reset)
		begin
			h_count <= 10'b0;
			v_count <= 10'b0;
		end
		else
		begin
			if(h_count < 10'd656) // display + front porch
			begin
				h_sync <= 1;
			end
			else if(h_count < 10'd752) // sync pulse
			begin
				h_sync <= 0;
			end
			else // back porch
			begin
				h_sync <= 1;
			end

			if(v_count < 10'd490) // display + front porch
			begin
				v_sync <= 1;
			end
			else if(v_count < 10'd492) // sync pulse
			begin
				v_sync <= 0;
			end
			else // back porch
			begin
				v_sync <= 1;
			end

			// increment h_count and v_count
			if(h_count == 10'd799)
			begin
				h_count <= 10'b0;
				if(v_count == 10'd520)
					v_count <= 10'b0;
				else
					v_count <= v_count + 10'b1;
			end
			else
				h_count <= h_count + 10'b1;

			// set bright if in display window
			if(h_count < 640 && v_count < 480)
				bright <= 1;
			else
				bright <= 0;
		end
	end

endmodule
