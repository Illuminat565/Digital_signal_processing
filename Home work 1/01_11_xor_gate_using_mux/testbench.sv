//`include "../include/util.svh"

module testbench;

  logic a, b, o;
  int i, j;

  xor_gate_using_mux inst (a, b, o);

  initial
    begin
      for (i = 0; i <= 1; i++)
      for (j = 0; j <= 1; j++)
      begin
        a = 1' (i);
        b = 1' (j);

        # 1;

        if (o !== (a ^ b))
          begin
            $display("FAIL %s", `__FILE__);
            $display("++ INPUT    => {%d, %d, %d, %d}", a, b, i, j);
            $display("++ EXPECTED => {%d}", a^b);
            $display("++ ACTUAL   => {%d}", o);
            $finish(1);
          end
      end

      $display ("PASS %s", `__FILE__);
      $finish;
    end

endmodule
