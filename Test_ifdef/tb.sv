`define INCLUDE_RSTN 
module tb;
  reg clk, d, rstn;
  wire q,p;
  reg [3:0] delay;

  my_design u0 (.clk(clk), .d(d),
  `ifdef INCLUDE_RSTN
            .rstn(rstn),
  `endif 
            .q(q),
            .p(p));
            

  always #10 clk=~clk;

  initial begin
    integer i;
    
    {d,rstn,clk} <=0 ;
    
    #20 rstn <= 1;

    for (i = 0 ; i < 20 ; i = i+1 ) begin
        delay = $random;
        #(delay) d <= $random;
    end
  
  #20 $stop;
  end
endmodule