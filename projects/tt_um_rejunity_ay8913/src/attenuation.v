/* verilator lint_off REALCVT */

// FROM General Instruments AY-3-8910 / 8912 Programmable Sound Generator (PSG) data Manual.
// Section 3.7 D/A Converter Operation
//
// Steps from the diagram: 1V, .707V, .5V, .303V (?), .25V, .1515V (?), .125V .. (not specified) .. 0V


// https://github.com/lvd2/ay-3-8910_reverse_engineered/blob/master/rtl/render/aytab.v
// v/0xFFFF for v in [0x0000, 0x0290, 0x03B0, 0x0560, 0x07E0, 0x0BB0, 0x1080, 0x1B80, 0x2070, 0x3480, 0x4AD0, 0x5F70, 0x7E10, 0xA2A0, 0xCE40, 0xFFFF]]

// assign tbl[ 0] = 12'h000;
// assign tbl[ 1] = 12'h029;      // 0,010009918364233
// assign tbl[ 2] = 12'h03B;      // 0,014404516670481
// assign tbl[ 3] = 12'h056;      // 0,021054242215592
// assign tbl[ 4] = 12'h07E;      // 0,030846913013541
// assign tbl[ 5] = 12'h0BB;      // 0,045780735980415
// assign tbl[ 6] = 12'h108;      // 0,064631627266468
// assign tbl[ 7] = 12'h1B8;      // 0,107719378777446
// assign tbl[ 8] = 12'h207;      // 0,127059903603397
// assign tbl[ 9] = 12'h348;      // 0,205646086756943
// assign tbl[10] = 12'h4AD;      // 0,293045673628644
// assign tbl[11] = 12'h5F7;      // 0,373835207711728
// assign tbl[12] = 12'h7E1;      // 0,493795424986612
// assign tbl[13] = 12'hA2A;      // 0,637013235406625
// assign tbl[14] = 12'hCE4;      // 0,807895340830847
// assign tbl[15] = 12'hFFF;

// 0.0,
// 0.010009918364232854,
// 0.014404516670481423,
// 0.020996414129854278,
// 0.030762188143739988,
// 0.04565499351491569,
// 0.06445410849164569,
// 0.10742351415274282,
// 0.12671091783016708,
// 0.2050812542915999,
// 0.2922407873655299,
// 0.372808422980087,
// 0.49243915465018695,
// 0.6352635996032654,
// 0.8056763561455711,
// 1.

// struct ay_ym_param
//     {
//         double r_up;
//         double r_down;
//         int    res_count;
//         double res[32];
//     };

// static const ay8910_device::ay_ym_param ay8910_param =
// {
//     800000, 8000000,
//     16,
//     { 15950, 15350, 15090, 14760, 14275, 13620, 12890, 11370,
//         10600,  8590,  7190,  5985,  4820,  3945,  3017,  2345 }
// };


// The AY-3-8910 has 16-steps that are -3.0dB apart,
//    -- and the YM-2149 has 32-steps that are -1.5dB apart.

// -- ln10 = Natural logarithm of 10, ~= 2.302585
// -- amp  = Amplitude in voltage, 0.2, 1.45, etc.
// -- dB   = decibel value in dB, -1.5, -3, etc.
// --
// -- dB  = 20 * log(amp) / ln10
// -- amp = 10 ^ (dB / 20)
// --
// -- -1.5dB = 0.8413951416
// -- -2.0dB = 0.7943282347
// -- -3.0dB = 0.7079457843

// YM-2149 datasheet reference values according to https://github.com/dnotq/ym2149_audio/blob/master/rtl/ym2149_audio.vhd
// -- 1V reference values based on the datasheet:
// --
// -- 1.0000, 0.8414, 0.7079, 0.5957, 0.5012, 0.4217, 0.3548, 0.2985,
// -- 0.2512, 0.2113, 0.1778, 0.1496, 0.1259, 0.1059, 0.0891, 0.0750,
// -- 0.0631, 0.0531, 0.0447, 0.0376, 0.0316, 0.0266, 0.0224, 0.0188,
// -- 0.0158, 0.0133, 0.0112, 0.0094, 0.0079, 0.0067, 0.0056, 0.0047
//    x"000",x"017",x"01B",x"021",x"027",x"02E",x"037",x"041",
//    x"04D",x"05C",x"06D",x"081",x"09A",x"0B7",x"0D9",x"102",
//    x"133",x"16D",x"1B2",x"204",x"265",x"2D8",x"361",x"405",
//    x"4C7",x"5AD",x"6BF",x"804",x"987",x"B53",x"D76",x"FFF");

// @TODO: perhaps rename to volume or amplitude to match AY manuals
// @TODO: python script and convert MAME params into amplitude levels, compare with lvd version

module p15_attenuation #( parameter CONTROL_BITS = 4, parameter VOLUME_BITS = 15 ) (
    input  wire in,
    input  wire [CONTROL_BITS-1:0] control,
    output reg  [VOLUME_BITS-1:0] out
);
    localparam real MAX_VOLUME = (1 << VOLUME_BITS) - 1;
    `define ATLEAST1(i) ($rtoi(i)>1 ? $rtoi(i) : 1)
    always @(*) begin
        case(in ? control : 0)

            // // https://github.com/lvd2/ay-3-8910_reverse_engineered/blob/master/rtl/render/aytab.v
            // 0:  out =                        0;
            // 1:  out = `ATLEAST1(MAX_VOLUME * 0.010009918364233);
            // 2:  out = `ATLEAST1(MAX_VOLUME * 0.014404516670481);
            // 3:  out = `ATLEAST1(MAX_VOLUME * 0.021054242215592);
            // 4:  out = `ATLEAST1(MAX_VOLUME * 0.030846913013541);
            // 5:  out = `ATLEAST1(MAX_VOLUME * 0.045780735980415);
            // 6:  out = `ATLEAST1(MAX_VOLUME * 0.064631627266468);
            // 7:  out = `ATLEAST1(MAX_VOLUME * 0.107719378777446);
            // 8:  out = `ATLEAST1(MAX_VOLUME * 0.127059903603397);
            // 9:  out = `ATLEAST1(MAX_VOLUME * 0.205646086756943);
            // 10: out = `ATLEAST1(MAX_VOLUME * 0.293045673628644);
            // 11: out = `ATLEAST1(MAX_VOLUME * 0.373835207711728);
            // 12: out = `ATLEAST1(MAX_VOLUME * 0.493795424986612);
            // 13: out = `ATLEAST1(MAX_VOLUME * 0.637013235406625);
            // 14: out = `ATLEAST1(MAX_VOLUME * 0.807895340830847);
            // 15: out = `ATLEAST1(MAX_VOLUME * 1.0);

            //  0: out = 12'h000;
            //  1: out = 12'h029;
            //  2: out = 12'h03B;
            //  3: out = 12'h056;
            //  4: out = 12'h07E;
            //  5: out = 12'h0BB;
            //  6: out = 12'h108;
            //  7: out = 12'h1B8;
            //  8: out = 12'h207;
            //  9: out = 12'h348;
            // 10: out = 12'h4AD;
            // 11: out = 12'h5F7;
            // 12: out = 12'h7E1;
            // 13: out = 12'hA2A;
            // 14: out = 12'hCE4;
            // 15: out = 12'hFFF;

            //  0: out = 8'h00;
            //  1: out = 8'h03;
            //  2: out = 8'h04;
            //  3: out = 8'h06;
            //  4: out = 8'h08;
            //  5: out = 8'h0C;
            //  6: out = 8'h11;
            //  7: out = 8'h1C;
            //  8: out = 8'h20;
            //  9: out = 8'h35;
            // 10: out = 8'h4B;
            // 11: out = 8'h5F;
            // 12: out = 8'h7E;
            // 13: out = 8'hA3;
            // 14: out = 8'hCE;
            // 15: out = 8'hFF;

            // YM2149, numbers from the manual, every 2nd step is taken
            // YM2149 32 steps: 1V, .841, .707, .595, .5, .42, .354, .297, .25, .21, .177, .149, .125
            15: out = `ATLEAST1(MAX_VOLUME * 1.0  );
            14: out = `ATLEAST1(MAX_VOLUME * 0.707);
            13: out = `ATLEAST1(MAX_VOLUME * 0.5  );
            12: out = `ATLEAST1(MAX_VOLUME * 0.354);
            11: out = `ATLEAST1(MAX_VOLUME * 0.25 );
            10: out = `ATLEAST1(MAX_VOLUME * 0.177);
            9:  out = `ATLEAST1(MAX_VOLUME * 0.125);
            8:  out = `ATLEAST1(MAX_VOLUME * 0.089);
            7:  out = `ATLEAST1(MAX_VOLUME * 0.063);
            6:  out = `ATLEAST1(MAX_VOLUME * 0.045);
            5:  out = `ATLEAST1(MAX_VOLUME * 0.032);
            4:  out = `ATLEAST1(MAX_VOLUME * 0.023);
            3:  out = `ATLEAST1(MAX_VOLUME * 0.016);
            2:  out = `ATLEAST1(MAX_VOLUME * 0.012);
            1:  out = `ATLEAST1(MAX_VOLUME * 0.008);
            0:  out =                        0;

            // Somewhat weird numbers from the original AY-3-8190 documentation
            // 15: out = `ATLEAST1(MAX_VOLUME * 1.0);
            // 14: out = `ATLEAST1(MAX_VOLUME * 0.707);
            // 13: out = `ATLEAST1(MAX_VOLUME * 0.5);
            // 12: out = `ATLEAST1(MAX_VOLUME * 0.303);
            // 11: out = `ATLEAST1(MAX_VOLUME * 0.25);
            // 10: out = `ATLEAST1(MAX_VOLUME * 0.1515);
            // 9:  out = `ATLEAST1(MAX_VOLUME * 0.125);
            // 8:  out = `ATLEAST1(MAX_VOLUME * 0.07575);
            // 7:  out = `ATLEAST1(MAX_VOLUME * 0.0625);
            // 6:  out = `ATLEAST1(MAX_VOLUME * 0.037875);
            // 5:  out = `ATLEAST1(MAX_VOLUME * 0.03125);
            // 4:  out = `ATLEAST1(MAX_VOLUME * 0.0189375);
            // 3:  out = `ATLEAST1(MAX_VOLUME * 0.015625);
            // 2:  out = `ATLEAST1(MAX_VOLUME * 0.00946875);
            // 1:  out = `ATLEAST1(MAX_VOLUME * 0.0078125);
            // 1:  out =                        0;
        endcase
        `undef ATLEAST1
    end
endmodule

