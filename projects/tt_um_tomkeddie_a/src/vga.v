
module p10_vga(
	       input  clk,
	       input  rst,
           input  left_up,
           input  left_down,
           input  right_up,
           input  right_down,
	       output r0,
	       output r1,
	       output r2,
	       output r3,
	       output g0,
	       output g1,
	       output g2,
	       output g3,
	       output b0,
	       output b1,
	       output b2,
	       output b3,
	       output hs,
	       output vs
	       );

  localparam	  h_visible    = 640;
  localparam	  h_frontporch = 640 + 16;
  localparam	  h_sync       = 640 + 16 + 96;
  localparam	  h_backporch  = 640 + 16 + 96 + 47;

  // while h_sync is being sent, vertical counts h_sync pulses, for
  // porch and sync, it counts clocks
  localparam	  v_visible    = 480;
  localparam	  v_frontporch = 480 + 22;
  localparam	  v_sync       = 480 + 22 + 3;
  localparam	  v_backporch = 480 + 22 + 3 + 1;

  localparam      paddle_size_v = 40;
  localparam      paddle_size_h = 6;

  localparam      paddle_l_pos_h    = 15;
  localparam      paddle_r_pos_h    = 625;

  localparam      ball_size_v = 4;
  localparam      ball_size_h = 4;

  wire            blank;
  reg             blank_h;
  reg             blank_v;

  assign blank = (blank_h | blank_v);

  // 2^10  = 1024
  reg [9:0]       count_h;
  // 2^9 = 512
  reg [8:0]       count_v;

  reg [8:0]       paddle_l_pos_v;
  reg [8:0]       paddle_r_pos_v;

  reg [9:0]       ball_pos_h;
  reg [8:0]       ball_pos_v;
  reg             ball_motion_l;

  reg             red;
  reg             grn;
  wire            blu;
  wire            wht;
  reg             hs_out;
  reg             vs_out;

  reg             left_up_1d;
  reg             left_down_1d;
  reg             right_up_1d;
  reg             right_down_1d;

  reg             left_up_pressed;
  reg             left_down_pressed;
  reg             right_up_pressed;
  reg             right_down_pressed;
  reg [24:0]      interval_counter;

  assign r0 = red;
  assign r1 = red;
  assign r2 = red;
  assign r3 = red;
  assign b0 = blu;
  assign b1 = blu;
  assign b2 = blu;
  assign b3 = blu;
  assign g0 = grn;
  assign g1 = grn;
  assign g2 = grn;
  assign g3 = grn;
  assign hs = !hs_out;
  assign vs = !vs_out;

  always @ (posedge clk) begin
    if (rst) begin
      red <= 1'b0;
      grn <= 1'b0;
    end else begin
      red <= wht;
      grn <= wht;
    end
  end

  assign blu = (blank) ? 1'b0 : 1'b1;

  assign wht = (blank) ? 1'b0 :
               // dashed net down the centre
               (count_h > 317 && count_h < 323 && count_v[4] == 1'b0) ? 1'b1 :
               // left paddle
               (count_h > paddle_l_pos_h-paddle_size_h && count_h <= paddle_l_pos_h && count_v > (paddle_l_pos_v-paddle_size_v/2) && count_v < (paddle_l_pos_v+paddle_size_v/2)) ? 1'b1 :
               // right paddle
               (count_h > paddle_r_pos_h && count_h <= paddle_r_pos_h+paddle_size_h && count_v > (paddle_r_pos_v-paddle_size_v/2) && count_v < (paddle_r_pos_v+paddle_size_v/2)) ? 1'b1 :
               // ball
               (count_h > (ball_pos_h-ball_size_h/2) && count_h < (ball_pos_h+ball_size_h/2) && count_v > (ball_pos_v-ball_size_v/2) && count_v < (ball_pos_v+ball_size_v/2)) ? 1'b1 :
               1'b0;

  // Horizontal
  always @ (posedge clk) begin
    hs_out <= 1'b0;
    if (rst) begin
      count_h <= 10'b11_1111_1111;
      blank_h <= 1'b1;
    end else if (count_h < h_visible) begin
	  // horizontal visible
      count_h <= count_h + 1;
    end else if (count_h < h_frontporch) begin
	  // horizontal front porch
      count_h <= count_h + 1;
      blank_h <= 1'b1;
    end else if (count_h < h_sync) begin
	  // horizontal sync
      count_h <= count_h + 1;
	  hs_out <= 1'b1;
    end else if (count_h < h_backporch) begin
	  // horizontal back porch
      count_h <= count_h + 1;
    end else begin
      count_h <= 1;
      blank_h <= 1'b0;
    end
  end

  // Vertical
  always @ (posedge clk) begin
    if (rst) begin
      count_v              <= 9'b1_1111_1111;
      blank_v              <= 1'b1;
      vs_out               <= 1'b0;
    end else if (count_h >= h_backporch) begin
      if (count_v < v_visible) begin
        count_v <= count_v + 1;
      end else if (count_v < v_backporch) begin
        count_v <= count_v + 1;
        blank_v <= 1'b1;
        if (count_v > v_frontporch && count_v < v_sync) begin
          vs_out <= 1'b1;
        end else begin
          vs_out <= 1'b0;
        end
      end else begin
        count_v <= 1;
        blank_v <= 1'b0;
      end
    end
  end

  // counter
  always @ (posedge clk) begin
    if (rst) begin
      interval_counter <= 0;
    end else begin
      if (interval_counter != 25175000/100) begin
        interval_counter <= interval_counter + 1;
      end else begin
        interval_counter <= 0;
      end
    end
  end

  // paddle debounce
  always @ (posedge clk) begin
    begin
      left_up_pressed    <= 1'b0;
      left_down_pressed  <= 1'b0;
      right_up_pressed   <= 1'b0;
      right_down_pressed <= 1'b0;
      // 100ms debounce/repeat
      if (interval_counter == 0) begin
        left_up_1d       <= left_up;
        left_down_1d     <= left_down;
        right_up_1d      <= right_up;
        right_down_1d    <= right_down;
        if (left_up && left_up_1d) begin
          left_up_pressed <= 1'b1;
        end
        if (left_down && left_down_1d) begin
          left_down_pressed <= 1'b1;
        end
        if (right_up && right_up_1d) begin
          right_up_pressed <= 1'b1;
        end
        if (right_down && right_down_1d) begin
          right_down_pressed <= 1'b1;
        end
      end
    end
  end

  // paddle logic
  always @ (posedge clk) begin
    if (rst) begin
      paddle_l_pos_v <= v_visible/2;
      paddle_r_pos_v <= v_visible/2;
    end else begin
      if (left_up_pressed && paddle_l_pos_v > paddle_size_v/2) begin
          paddle_l_pos_v <= paddle_l_pos_v - 1;
      end
      if (left_down_pressed && paddle_l_pos_v < v_visible - paddle_size_v/2) begin
          paddle_l_pos_v <= paddle_l_pos_v + 1;
      end
      if (right_up_pressed && paddle_r_pos_v > paddle_size_v/2) begin
          paddle_r_pos_v <= paddle_r_pos_v - 1;
      end
      if (right_down_pressed && paddle_r_pos_v < v_visible - paddle_size_v/2) begin
          paddle_r_pos_v <= paddle_r_pos_v + 1;
      end
    end
  end

  // ball logic
  always @ (posedge clk) begin
    if (rst) begin
      ball_pos_v <= v_visible/2;
      ball_pos_h <= paddle_r_pos_h-1;
      ball_motion_l <= 1'b1;
    end else begin
      if (interval_counter == 0) begin
        // is the ball moving left
        if (ball_motion_l == 1'b1) begin
          // is the ball in the left paddle column
          if (ball_pos_h == paddle_l_pos_h-1) begin
            // did the ball hit the left paddle
            if (ball_pos_v >= paddle_l_pos_v-paddle_size_v/2 && ball_pos_v <= paddle_l_pos_v+paddle_size_v/2) begin
              // bounce off left paddle
              ball_motion_l <= 1'b0;
            end else begin
              // right side serves
              ball_pos_h <= paddle_r_pos_h-1;
              ball_pos_v <= paddle_r_pos_v;
            end
          end else begin
            // ball is moving left
            ball_pos_h <= ball_pos_h-1;
          end
        end else begin // if (ball_motion_l == 1'b1)
          // ball is moving right, is the ball in the right paddle columnx
          if (ball_pos_h == paddle_r_pos_h-1) begin
            // did the ball hit the right paddle
            if (ball_pos_v >= paddle_r_pos_v-paddle_size_v/2 && ball_pos_v <= paddle_r_pos_v+paddle_size_v/2) begin
              // bounce off right paddle
              ball_motion_l <= 1'b1;
            end else begin
              // left side serves
              ball_pos_h <= paddle_l_pos_h-1;
              ball_pos_v <= paddle_l_pos_v;
            end
          end else begin
            // ball is moving right
            ball_pos_h <= ball_pos_h+1;
          end
        end
      end
    end
  end
endmodule
