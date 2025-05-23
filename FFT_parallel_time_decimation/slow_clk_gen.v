// Asynchronous reset here is needed for one of FPGA boards we use

//`include "config.svh"

module slow_clk_gen
# (
    parameter fast_clk_mhz = 50,
              slow_clk_hz  = 3
)
(
    input  clk,
    input  rst_n,
    output slow_clk
);

    generate

        if (fast_clk_mhz == 1)
        begin : if1

            assign slow_clk = clk;

        end
        else
        begin : if0

            localparam half_period
              = fast_clk_mhz * 1000 * 1000 / slow_clk_hz / 2;

            localparam w_cnt = $clog2 (half_period);

            logic [w_cnt - 1:0] cnt;
            logic               slow_clk_raw;

            always_ff @ (posedge clk or posedge rst_n)
                if (rst_n)
                begin
                    cnt          <= '0;
                    slow_clk_raw <= '0;
                end
                else if (cnt == '0)
                begin
                    cnt <= w_cnt' (half_period - 1);
                    slow_clk_raw <= ~ slow_clk_raw;
                end
                else
                begin
                    cnt <= cnt - 1'd1;
                end

            //----------------------------------------------------------------

                global i_global (.in (slow_clk_raw), .out (slow_clk));

        end
    endgenerate

endmodule