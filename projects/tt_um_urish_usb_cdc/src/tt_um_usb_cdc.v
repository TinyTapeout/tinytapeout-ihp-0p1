/*
 * tt_um_usb_cdc.v
 *
 * USB CDC for Tiny Tapeout
 *
 * Author: Uri Shaked
 */

`default_nettype none

localparam BIT_SAMPLES = 'd4;

module tt_um_urish_usb_cdc (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  wire usb_tx_en;
  assign uio_oe = {6'b110110, usb_tx_en, usb_tx_en};
  assign {uio_out[5], uio_out[2]} = 0;  // tie off unused outputs

  /* USB Serial */
  p17_usb_cdc #(
      .VENDORID              (16'h1209),
      .PRODUCTID             (16'h5454),             // https://pid.codes/1209/5454/
      .IN_BULK_MAXPACKETSIZE ('d8),
      .OUT_BULK_MAXPACKETSIZE('d8),
      .BIT_SAMPLES           (BIT_SAMPLES),
      .USE_APP_CLK           (0),
      .APP_CLK_RATIO         (BIT_SAMPLES * 12 / 2)  // BIT_SAMPLES * 12MHz / 2MHz
  ) u_usb_cdc (
      .frame_o(),
      .configured_o(uio_out[7]),

      .app_clk_i(clk),
      .clk_i(clk),
      .rstn_i(rst_n),
      .out_ready_i(uio_in[5]),
      .in_data_i(ui_in),
      .in_valid_i(uio_in[2]),
      .dp_rx_i(uio_in[0]),
      .dn_rx_i(uio_in[1]),

      .out_data_o(uo_out),
      .out_valid_o(uio_out[4]),
      .in_ready_o(uio_out[3]),
      .dp_pu_o(uio_out[6]),
      .tx_en_o(usb_tx_en),
      .dp_tx_o(uio_out[0]),
      .dn_tx_o(uio_out[1])
  );

endmodule  // tt_um_urish_usb_cdc
