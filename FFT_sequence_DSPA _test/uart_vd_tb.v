`timescale 1ns/1ps
`define clk_period 20

module uart_vd_tb ();

//--------------------------------------------
reg clk, rst_n;
wire rx, tx;
wire tx_o;
wire[3:0] dig;
wire[7:0] seg;
reg [3:0] key;
wire [3:0] led;
wire signed [23:0] Re_o;
wire signed [23:0] Im_o;
wire en_o;
//----------------------------------------\
top_module #( .bit_width(24), .N(16)) TOP_MODULE(
    .CLK(clk),
    .RST_N(rst_n),
    .data_in(tx),
    
  //  .key(key),
  //  .led(led),
  //  .dig(dig),
  //  .seg(seg),  
    .tx_o(tx_o)
);

test # (.t_1_bit(4'd9),
        .t_half_1_bit(4'd4)) TEST (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(tx_o),

        .Re_o(Re_o),
        .Im_o(Im_o),
        .en_o(en_o)
        );
//----------------------------------------
uart_vd UART_VD(
    .tx_o(tx)
);
//-----------------------------------------
initial clk =1;
always #(`clk_period/2) clk = ~ clk;
//----------------------------------------

initial begin
    rst_n = 1;
    #`clk_period;

    rst_n = 0;     // begin to reset
    #`clk_period; 
    key  = 4'b0000;

    rst_n = 1;
    #`clk_period; 
    key  = 4'b0001;
    

    
    #(`clk_period*250);
   // $stop;
end


endmodule