 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : INVERT_ADDR
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    : 
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
module INVERT #(parameter  N            = 16, 
                           SIZE         = 4
                               )
(
    input                              clk,
    input                              rst_n,
    input                              en_invert,


    output            [SIZE-1:0]       invert_addr,
    output reg                         en_o
);

   reg [SIZE-1   : 0] rd_ptr;
   reg [SIZE-1   : 0] delay_rd_ptr;

  //----------------------------------------------------------------

generate
    genvar j;
    for (j = 0; j < SIZE; j = j + 1) begin : bit_reversal
        assign invert_addr[j] = delay_rd_ptr[SIZE - 1 - j];
    end
endgenerate


always @(posedge clk ) begin
    if (!rst_n) begin
        rd_ptr <= 0; 
    end
    if (en_invert) begin
        rd_ptr        <= rd_ptr +1'd1;
        delay_rd_ptr  <= rd_ptr;
        en_o          <= 1'b1;
    end else if (delay_rd_ptr == N-1) begin
        delay_rd_ptr  <= 0;
        en_o          <= 1'b0;
    end
end

endmodule