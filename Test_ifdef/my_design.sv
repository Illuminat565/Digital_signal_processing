`define INCLUDE_RSTN 
`include "and_and.sv"

module my_design ( input clk, d,
`ifdef INCLUDE_RSTN
                   input rstn,
`endif 
                   output reg q,
                   output reg p
);
always @(posedge clk) begin
    `ifdef INCLUDE_RSTN
    if(!rstn) begin
        q <=1'b1;
    end else
    `endif 
    begin
         q <= d;
    end
end
and_and jsahfcj (
    .a(d),
    .b(q),
    .c(p)
);
endmodule