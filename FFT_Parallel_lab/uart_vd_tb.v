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
//----------------------------------------\
top_module #( .bit_width(26), .N(256)) TOP_MODULE(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(tx),
    
  //  .key(key),
  //  .led(led),
  //  .dig(dig),
 //   .seg(seg),  
    .tx_o(tx_o)
);
//----------------------------------------
uart_vd #(.N(256),.norm(7),.k(10),.v(0.2)) UART_VD (
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