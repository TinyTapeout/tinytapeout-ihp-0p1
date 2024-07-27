`default_nettype none
`timescale 1ns / 1ps

module p21_clock(input wire        clock,
             input wire        reset,
             input wire        hour_button,
             input wire        minute_button,
             input wire [3:0]  debug_sel,

             output wire       vga_hs,
             output wire       vga_vs,
             output reg [5:0]  vga_rgb,
             output wire [7:0] debug_out);

   wire                       vga_visible;
   wire                       vga_horizontal_blank_strobe; // one clock wide pulse pr line
   wire                       vga_vertical_blank_strobe; // one clock wide pulse pr frame

   wire [9:0]      x, y;

   p21_vga vga_inst(.clock(clock),
                .reset(reset),
                .vga_visible(vga_visible),
                .vga_horizontal_blank_strobe(vga_horizontal_blank_strobe),
                .vga_vertical_blank_strobe(vga_vertical_blank_strobe),
                .vga_hs(vga_hs),
                .vga_vs(vga_vs),
                .vga_x(x),
                .vga_y(y));

   reg                        vga_vertical_blank_strobe_delay;

   wire [1:0] command =
              (y == 500-1 && x == 800) ? 1 : // restart
	      x == 800 ? 2 : // stepy
	      vga_visible ? 3 : // stepx
	      0;

   reg [6:0]  frameno;
   reg [5:0]  second, minute;
   reg [3:0]  hour;

   wire hour_hit, min_hit, sec_hit;
   // XXX This limits it to 1 Hz
   wire advance_minute = frameno == 75 && minute_button;
   wire advance_hour   = frameno == 75 && hour_button;

   assign debug_out
     = debug_sel==0 ? frameno :
       debug_sel==1 ? {second,vga_horizontal_blank_strobe,vga_horizontal_blank_strobe} :
       debug_sel==2 ? {minute, 2'd 0} :
       {hour, 2'd 0};


   reg [53:0] sec_a, sec_b, sec_c;
   reg [53:0] min_a, min_b, min_c;
   reg [53:0] hour_a, hour_b, hour_c;

   // This is normally bad style; we pass through illegal state for up
   // to four cycles.  This is done on purpose for better timing (to
   // avoid a long nested conditional) and the illegal values will
   // never be observed
   always @(posedge clock) begin
      vga_vertical_blank_strobe_delay <= vga_vertical_blank_strobe;

      if (vga_vertical_blank_strobe) begin
         frameno <= frameno + 1;
      end
      if (frameno == 75) begin
         frameno <= 0;
         second <= second + 1;
      end
      if (second == 60) begin
         second <= 0;
      end
      if (second == 60 || advance_minute) begin
         minute <= minute + 1;
      end
      if (minute == 60) begin
         minute <= 0;
      end
      if (minute == 60 || advance_hour) begin
         hour <= hour + 1;
      end
      if (hour == 12) begin
         hour <= 0;
      end

      if (reset) begin
         hour <= 9;
         minute <= 26;
         second <= 18;
         frameno <= 0;
      end
   end // always @ (posedge clock)

   // Brute force; we can do better if we get time
   always @(posedge clock)
     if (vga_vertical_blank_strobe) begin // avoid glitching
	case (second)
          0: {sec_a, sec_b, sec_c} <= {54'hea00003ff16, 54'h3fffe80003, 54'h2db77016392477};
          1: {sec_a, sec_b, sec_c} <= {54'he800007ff17, 54'h1afffefffeb, 54'h2c7be00d8d3981};
          2: {sec_a, sec_b, sec_c} <= {54'he400007ff1b, 54'h33fffefffd2, 54'h2b59100d8d4bb3};
          3: {sec_a, sec_b, sec_c} <= {54'hde0000bff20, 54'h4affff3ffba, 54'h2a6dc004d95bfa};
          4: {sec_a, sec_b, sec_c} <= {54'hd50000bff29, 54'h61ffff3ffa3, 54'h29cc8004d96618};
          5: {sec_a, sec_b, sec_c} <= {54'hc90000fff34, 54'h77fffefff8e, 54'h297d50037d6c9e};
          6: {sec_a, sec_b, sec_c} <= {54'hbb00013ff41, 54'h8bffff3ff79, 54'h2961cffac1704c};
          7: {sec_a, sec_b, sec_c} <= {54'hac00013ff50, 54'h9effff3ff66, 54'h29758ffac16f20};
          8: {sec_a, sec_b, sec_c} <= {54'h9a00013ff62, 54'hb0ffff3ff54, 54'h29d40ffac16938};
          9: {sec_a, sec_b, sec_c} <= {54'h8700013ff75, 54'hbfffff3ff45, 54'h2a72cffac15f3c};
          10: {sec_a, sec_b, sec_c} <= {54'h7200017ff89, 54'hccffff7ff37, 54'h2b4feff1fd53d5};
          11: {sec_a, sec_b, sec_c} <= {54'h5d00013ff9f, 54'hd7ffffbff2b, 54'h2c458ff35942e8};
          12: {sec_a, sec_b, sec_c} <= {54'h4600013ffb6, 54'he0ffffbff22, 54'h2d8daff3592e5c};
          13: {sec_a, sec_b, sec_c} <= {54'h2e00017ffcd, 54'he5fffffff1c, 54'h2f223fea8d17e1};
          14: {sec_a, sec_b, sec_c} <= {54'h1500017ffe6, 54'he9fffffff18, 54'h30de1fea8cfc1e};
          15: {sec_a, sec_b, sec_c} <= {54'h3fffe00017fffd, 54'hea00007ff15, 54'h328fafe30ce2d7};
          16: {sec_a, sec_b, sec_c} <= {54'h3ffe6000140015, 54'he800007ff17, 54'h3491efe30cc2c1};
          17: {sec_a, sec_b, sec_c} <= {54'h3ffcd00014002e, 54'he400007ff1b, 54'h36c61fe30c9f83};
          18: {sec_a, sec_b, sec_c} <= {54'h3ffb6000100046, 54'hde0000bff20, 54'h38e1cfe4587cda};
          19: {sec_a, sec_b, sec_c} <= {54'h3ff9f00010005d, 54'hd50000bff29, 54'h3b388fe4585778};
          20: {sec_a, sec_b, sec_c} <= {54'h3ff89000140072, 54'hc90000fff34, 54'h3daf5fdb7c337e};
          21: {sec_a, sec_b, sec_c} <= {54'h3ff75000100087, 54'hbb00013ff41, 54'h9cfdcc00d4c};
          22: {sec_a, sec_b, sec_c} <= {54'h3ff6200010009a, 54'hac00013ff50, 54'h26b8fdcc3e740};
          23: {sec_a, sec_b, sec_c} <= {54'h3ff500001000ac, 54'h9a00013ff62, 54'h4e60fdcc3bf98};
          24: {sec_a, sec_b, sec_c} <= {54'h3ff410001000bb, 54'h8700013ff75, 54'h732cfdcc39abc};
          25: {sec_a, sec_b, sec_c} <= {54'h3ff340000c00c9, 54'h7200017ff89, 54'h96defddff76f5};
          26: {sec_a, sec_b, sec_c} <= {54'h3ff290000800d5, 54'h5d00013ff9f, 54'hb7b8fe6db52a8};
          27: {sec_a, sec_b, sec_c} <= {54'h3ff200000800de, 54'h4600013ffb6, 54'hd8bafe6db319c};
          28: {sec_a, sec_b, sec_c} <= {54'h3ff1b0000400e4, 54'h2e00017ffcd, 54'hf573fe80f1531};
          29: {sec_a, sec_b, sec_c} <= {54'h3ff170000400e8, 54'h1500017ffe6, 54'h11221fe80ef87e};
          30: {sec_a, sec_b, sec_c} <= {54'h3ff16ffffc00eb, 54'h3fffe00017fffd, 54'h1283aff20edfd7};
          31: {sec_a, sec_b, sec_c} <= {54'h3ff18ffffc00e9, 54'h3ffe6000140015, 54'h13c7eff20ecba1};
          32: {sec_a, sec_b, sec_c} <= {54'h3ff1cffffc00e5, 54'h3ffcd00014002e, 54'h14f31ff20eb8f3};
          33: {sec_a, sec_b, sec_c} <= {54'h3ff22ffff800e0, 54'h3ffb6000100046, 54'h15c9cffadaa8ba};
          34: {sec_a, sec_b, sec_c} <= {54'h3ff2bffff800d7, 54'h3ff9f00010005d, 54'h16728ffada9e38};
          35: {sec_a, sec_b, sec_c} <= {54'h3ff37ffff400cc, 54'h3ff89000140072, 54'h16d75ffbfe98de};
          36: {sec_a, sec_b, sec_c} <= {54'h3ff45ffff000bf, 54'h3ff75000100087, 54'h16e3c004c295ac};
          37: {sec_a, sec_b, sec_c} <= {54'h3ff54ffff000b0, 54'h3ff6200010009a, 54'h16d98004c29660};
          38: {sec_a, sec_b, sec_c} <= {54'h3ff66ffff0009e, 54'h3ff500001000ac, 54'h16840004c29bb8};
          39: {sec_a, sec_b, sec_c} <= {54'h3ff79ffff0008b, 54'h3ff410001000bb, 54'h15ecc004c2a51c};
          40: {sec_a, sec_b, sec_c} <= {54'h3ff8efffec0077, 54'h3ff340000c00c9, 54'h1507e00d7eb175};
          41: {sec_a, sec_b, sec_c} <= {54'h3ffa3ffff00061, 54'h3ff290000800d5, 54'h13ff800c5ac108};
          42: {sec_a, sec_b, sec_c} <= {54'h3ffbaffff0004a, 54'h3ff200000800de, 54'h12bda00c5ad51c};
          43: {sec_a, sec_b, sec_c} <= {54'h3ffd2fffec0033, 54'h3ff1b0000400e4, 54'h112830150eece1};
          44: {sec_a, sec_b, sec_c} <= {54'h3ffebfffec001a, 54'h3ff170000400e8, 54'hf7410150f081e};
          45: {sec_a, sec_b, sec_c} <= {54'h3fffe80003, 54'h3ff160000000ea, 54'hda6701dbb23a7};
          46: {sec_a, sec_b, sec_c} <= {54'h1afffefffeb, 54'h3ff18ffffc00e9, 54'hbb1e01c8f4261};
          47: {sec_a, sec_b, sec_c} <= {54'h33fffefffd2, 54'h3ff1cffffc00e5, 54'h986101c8f6523};
          48: {sec_a, sec_b, sec_c} <= {54'h4affff3ffba, 54'h3ff22ffff800e0, 54'h755c01b5b87da};
          49: {sec_a, sec_b, sec_c} <= {54'h61ffff3ffa3, 54'h3ff2bffff800d7, 54'h506801b5bacd8};
          50: {sec_a, sec_b, sec_c} <= {54'h77fffefff8e, 54'h3ff37ffff400cc, 54'h2a55023ffd1fe};
          51: {sec_a, sec_b, sec_c} <= {54'h8bffff3ff79, 54'h3ff45ffff000bf, 54'h3bc022c3f8ac};
          52: {sec_a, sec_b, sec_c} <= {54'h9effff3ff66, 54'h3ff54ffff000b0, 54'h3de38022c01e40};
          53: {sec_a, sec_b, sec_c} <= {54'hb0ffff3ff54, 54'h3ff66ffff0009e, 54'h3b720022c04558};
          54: {sec_a, sec_b, sec_c} <= {54'hbfffff3ff45, 54'h3ff79ffff0008b, 54'h392cc022c0699c};
          55: {sec_a, sec_b, sec_c} <= {54'hccffff7ff37, 54'h3ff8efffec0077, 54'h36e9e0217c8e55};
          56: {sec_a, sec_b, sec_c} <= {54'hd7ffffbff2b, 54'h3ffa3ffff00061, 54'h34c98018d8b148};
          57: {sec_a, sec_b, sec_c} <= {54'he0ffffbff22, 54'h3ffbaffff0004a, 54'h32bfa018d8d1dc};
          58: {sec_a, sec_b, sec_c} <= {54'he5fffffff1c, 54'h3ffd2fffec0033, 54'h30f330178cef91};
          59: {sec_a, sec_b, sec_c} <= {54'he9fffffff18, 54'h3ffebfffec001a, 54'h2f3010178d0bbe};
        endcase
        case (minute)
          0: {min_a, min_b, min_c} <= {54'h10100003feff, 54'h14fff600014, 54'h2be840a2814104};
          1: {min_a, min_b, min_c} <= {54'hfc00013ff00, 54'h2dfff6bfff9, 54'h2ac7f085e95823};
          2: {min_a, min_b, min_c} <= {54'hf600023ff02, 54'h48fff6bffde, 54'h29ae2072496f50};
          3: {min_a, min_b, min_c} <= {54'hed00037ff06, 54'h62fff6fffc3, 54'h28e6d055c5835d};
          4: {min_a, min_b, min_c} <= {54'he200043ff0e, 54'h7afff73ffaa, 54'h28550043219150};
          5: {min_a, min_b, min_c} <= {54'hd400053ff18, 54'h91fff7bff91, 54'h28175027a99c1d};
          6: {min_a, min_b, min_c} <= {54'hc30005fff26, 54'ha6fff87ff79, 54'h2829900ce5a0b5};
          7: {min_a, min_b, min_c} <= {54'hb10006fff34, 54'hbafff8fff63, 54'h28702ff205a428};
          8: {min_a, min_b, min_c} <= {54'h9d00077ff46, 54'hccfff97ff4f, 54'h28e78fe085a112};
          9: {min_a, min_b, min_c} <= {54'h870007fff5a, 54'hdafffa7ff3d, 54'h29c85fc6e59849};
          10: {min_a, min_b, min_c} <= {54'h6f0008bff6f, 54'he8fffb3ff2c, 54'h2adcdfad298e65};
          11: {min_a, min_b, min_c} <= {54'h5600093ff86, 54'hf2fffc3ff1e, 54'h2c3d0f94217e90};
          12: {min_a, min_b, min_c} <= {54'h3d00097ff9e, 54'hfafffcfff13, 54'h2db0df83c56b3d};
          13: {min_a, min_b, min_c} <= {54'h220009bffb8, 54'hfefffe3ff0a, 54'h2f950f6bc95282};
          14: {min_a, min_b, min_c} <= {54'h70009bffd3, 54'h100ffff3ff04, 54'h318d3f5c69362f};
          15: {min_a, min_b, min_c} <= {54'h3ffec000a3ffec, 54'h10100003feff, 54'h33a94f44811c74};
          16: {min_a, min_b, min_c} <= {54'h3ffd3000980007, 54'hfc00013ff00, 54'h35daff3e68f8d3};
          17: {min_a, min_b, min_c} <= {54'h3ffb8000980022, 54'hf600023ff02, 54'h38542f2fc8d590};
          18: {min_a, min_b, min_c} <= {54'h3ff9e00094003d, 54'hed00037ff06, 54'h3aeddf2244afcd};
          19: {min_a, min_b, min_c} <= {54'h3ff86000900056, 54'he200043ff0e, 54'h3d6d0f1c208990};
          20: {min_a, min_b, min_c} <= {54'h3ff6f00088006f, 54'hd400053ff18, 54'he5f172860cd};
          21: {min_a, min_b, min_c} <= {54'h3ff5a0007c0087, 54'hc30005fff26, 54'h2aa9f1a643545};
          22: {min_a, min_b, min_c} <= {54'h3ff4600074009d, 54'hb10006fff34, 54'h5532f16040cf8};
          23: {min_a, min_b, min_c} <= {54'h3ff340006c00b1, 54'h9d00077ff46, 54'h7dc8f1887e3c2};
          24: {min_a, min_b, min_c} <= {54'h3ff260005c00c3, 54'h870007fff5a, 54'ha395f2467b9d9};
          25: {min_a, min_b, min_c} <= {54'h3ff180005000d4, 54'h6f0008bff6f, 54'hcbfdf28ab9155};
          26: {min_a, min_b, min_c} <= {54'h3ff0e0004000e2, 54'h5600093ff86, 54'hf010f35236a10};
          27: {min_a, min_b, min_c} <= {54'h3ff060003400ed, 54'h3d00097ff9e, 54'h110fdf4047462d};
          28: {min_a, min_b, min_c} <= {54'h3ff020002000f6, 54'h220009bffb8, 54'h12f90f554b21e2};
          29: {min_a, min_b, min_c} <= {54'h3ff000001000fc, 54'h70009bffd3, 54'h14b03f68eb00df};
          30: {min_a, min_b, min_c} <= {54'h3ff00ffffc0101, 54'h3ffec0009fffed, 54'h16544f7ea6e227};
          31: {min_a, min_b, min_c} <= {54'h3ff04ffff00100, 54'h3ffd3000980007, 54'h176dff90eacb03};
          32: {min_a, min_b, min_c} <= {54'h3ff0afffe000fe, 54'h3ffb8000980022, 54'h188e2fa54ab490};
          33: {min_a, min_b, min_c} <= {54'h3ff13fffcc00fa, 54'h3ff9e00094003d, 54'h196adfc2469ffd};
          34: {min_a, min_b, min_c} <= {54'h3ff1efffc000f2, 54'h3ff86000900056, 54'h19f10fd5229310};
          35: {min_a, min_b, min_c} <= {54'h3ff2cfffb000e8, 54'h3ff6f00088006f, 54'h1a355ff0aa87fd};
          36: {min_a, min_b, min_c} <= {54'h3ff3dfffa400da, 54'h3ff5a0007c0087, 54'h1a15900a668295};
          37: {min_a, min_b, min_c} <= {54'h3ff4ffff9400cc, 54'h3ff4600074009d, 54'h19e42026867fc8};
          38: {min_a, min_b, min_c} <= {54'h3ff63fff8c00ba, 54'h3ff340006c00b1, 54'h19578038068432};
          39: {min_a, min_b, min_c} <= {54'h3ff79fff8400a6, 54'h3ff260005c00c3, 54'h186c5050668ba9};
          40: {min_a, min_b, min_c} <= {54'h3ff91fff780091, 54'h3ff180005000d4, 54'h1764d06b2a9665};
          41: {min_a, min_b, min_c} <= {54'h3ffaafff70007a, 54'h3ff0e0004000e2, 54'h1609008422a5d0};
          42: {min_a, min_b, min_c} <= {54'h3ffc3fff6c0062, 54'h3ff060003400ed, 54'h1484d09446b9dd};
          43: {min_a, min_b, min_c} <= {54'h3ffdefff680048, 54'h3ff020002000f6, 54'h12a900abcad142};
          44: {min_a, min_b, min_c} <= {54'h3fff9fff68002d, 54'h3ff000001000fc, 54'h10a530ba6aed2f};
          45: {min_a, min_b, min_c} <= {54'h14fff600014, 54'h3feff000000101, 54'hea740d4830894};
          46: {min_a, min_b, min_c} <= {54'h2dfff6bfff9, 54'h3ff04ffff00100, 54'hc5af0d86b2a53};
          48: {min_a, min_b, min_c} <= {54'h62fff6fffc3, 54'h3ff13fffcc00fa, 54'h763d0f5c7738d};
          49: {min_a, min_b, min_c} <= {54'h7afff73ffaa, 54'h3ff1efffc000f2, 54'h4d900fc239ad0};
          50: {min_a, min_b, min_c} <= {54'h91fff7bff91, 54'h3ff2cfffb000e8, 54'h23e51012bc34d};
          51: {min_a, min_b, min_c} <= {54'ha6fff87ff79, 54'h3ff3dfffa400da, 54'h3f9490fce7ee05};
          52: {min_a, min_b, min_c} <= {54'hbafff8fff63, 54'h3ff4ffff9400cc, 54'h3d0121028416f8};
          53: {min_a, min_b, min_c} <= {54'hccfff97ff4f, 54'h3ff63fff8c00ba, 54'h3a628100044182};
          54: {min_a, min_b, min_c} <= {54'hdafffa7ff3d, 54'h3ff79fff8400a6, 54'h37fb50f2e46a19};
          55: {min_a, min_b, min_c} <= {54'he8fffb3ff2c, 54'h3ff91fff780091, 54'h3581d0efa89375};
          56: {min_a, min_b, min_c} <= {54'hf2fffc3ff1e, 54'h3ffaafff70007a, 54'h334500e320ba50};
          57: {min_a, min_b, min_c} <= {54'hfafffcfff13, 54'h3ffc3fff6c0062, 54'h3125d0d7c4deed};
          58: {min_a, min_b, min_c} <= {54'hfefffe3ff0a, 54'h3ffdefff680048, 54'h2f4500c24901e2};
          59: {min_a, min_b, min_c} <= {54'h100ffff3ff04, 54'h3fff9fff68002d, 54'h2d8230ade9227f};
        endcase
        case (hour)
          0: {hour_a, hour_b, hour_c} <= {54'ha400003ff5c, 54'h14fff600014, 54'h32b800a280c580};
          1: {hour_a, hour_b, hour_c} <= {54'h8300053ff69, 54'h63fff7bffbf, 54'h30a8c027a904ac};
          2: {hour_a, hour_b, hour_c} <= {54'h400008bff9e, 54'h97fffb3ff7d, 54'h32d51fad290073};
          3: {hour_a, hour_b, hour_c} <= {54'h3ffec000a3ffec, 54'ha400003ff5c, 54'h38a80f4480be00};
          4: {hour_a, hour_b, hour_c} <= {54'h3ff9d000880041, 54'h8300053ff69, 54'hc0cf1728474c};
          5: {hour_a, hour_b, hour_c} <= {54'h3ff69000500083, 54'h410008bff9d, 54'h8accf28abc42c};
          6: {hour_a, hour_b, hour_c} <= {54'h3ff5dffffc00a4, 54'h3ffec0009fffed, 54'he9c0f7ea74f80};
          7: {hour_a, hour_b, hour_c} <= {54'h3ff7dfffb00097, 54'h3ff9d000880041, 54'h10bacff0ab114c};
          8: {hour_a, hour_b, hour_c} <= {54'h3ffc0fff780062, 54'h3ff69000500083, 54'he87106b2b15d3};
          9: {hour_a, hour_b, hour_c} <= {54'h14fff600014, 54'h3ff5c0000000a4, 54'h8c000d4835880};
          10: {hour_a, hour_b, hour_c} <= {54'h62fff7bffc0, 54'h3ff7dfffb00097, 54'hb731012bcd51};
          11: {hour_a, hour_b, hour_c} <= {54'h97fffb3ff7d, 54'h3ffc0fff780062, 54'h38a210efa85303};
        endcase
     end

   // Three precomputed triangles; XXX get edgeeqn integrated
   p21_tile hour_tile(clock, hour_a, hour_b, hour_c, command, hour_hit);
   p21_tile min_tile(clock, min_a, min_b, min_c, command, min_hit);
   p21_tile sec_tile(clock, sec_a, sec_b, sec_c, command, sec_hit);

   always @(posedge clock) begin
      vga_rgb <= 6'b000000; // default black background

      if (sec_hit)
	vga_rgb <= 6'b111111; // white
      else if (hour_hit)
	vga_rgb <= 6'b110000; // red
      else if (min_hit)
	vga_rgb <= 6'b111100; // yellow

      // 12 hour/5 min markers
      if (x == 320 && y ==   0 || // 12
	  x == 440 && y ==  32 || //  1
	  x == 528 && y == 120 || //  2
          x == 560 && y == 240 || //  3
	  x == 528 && y == 360 || //  4
	  x == 440 && y == 448 || //  5
	  x == 320 && y == 560 || //  6
	  x == 200 && y == 448 || //  7
	  x == 112 && y == 360 || //  8
          x ==  80 && y == 240 || //  9
	  x == 112 && y == 120 || // 10
	  x == 200 && y ==  32    // 11
	  )
        vga_rgb <= 6'b111111; // white

      if (!vga_visible)
        vga_rgb <= 0;
   end
endmodule


`ifdef SIMCLOCK
module p21_tb;
   reg clock = 1;
   reg reset = 1;
   wire [5:0] vga_rgb;
   wire [7:0] debug_out;

   wire       hour_button = 0;
   wire       minute_button = 0;
   wire [3:0] debug_sel = 0;

   wire       vga_hs, vga_vs;
   wire       vga_visible, vga_vertical_visible, vga_horizontal_visible;
   wire       vga_horizontal_blank_strobe, vga_vertical_blank_strobe;

   always #5 clock = ~clock;

   p21_clock clock_inst(clock,
                    reset,
                    hour_button,
                    minute_button,
                    debug_sel,

                    vga_hs,
                    vga_vs,
                    vga_rgb,
                    debug_out);

   initial begin
      $dumpfile("clock.vcd");
      $dumpvars(0, clock_inst);
      #20 reset = 0;
      #100000000 $finish;
   end
endmodule
`endif
