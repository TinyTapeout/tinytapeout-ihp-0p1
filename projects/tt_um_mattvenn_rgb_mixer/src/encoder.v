`default_nettype none
module p07_encoder #(
    parameter WIDTH = 8,
    parameter INCREMENT = 1'b1
)(
    input clk,
    input reset,
    input a,
    input b,
    output reg [WIDTH-1:0] value
);

    reg old_a;
    reg old_b;

    always @(posedge clk) begin
        if(reset) begin

            old_a <= 0;
            old_b <= 0;
            value <= 0;

        end else begin

            // last values
            old_a <= a;
            old_b <= b;

            // state machine
            case ({a,old_a,b,old_b})

                4'b1000: value <= value + INCREMENT;
                4'b0111: value <= value + INCREMENT;

                4'b0010: value <= value - INCREMENT;
                4'b1101: value <= value - INCREMENT;

                default: value <= value;
            endcase
        end
    end

endmodule
