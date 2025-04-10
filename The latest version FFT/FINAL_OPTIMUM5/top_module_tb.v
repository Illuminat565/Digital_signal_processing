 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : datatop_module_tb
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    :
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
`timescale 1ns/1ps
`define clk_period 20 

module top_module_tb();
reg clk;
reg rst_n;

wire [3:0] dig;
wire [7:0] seg;  
wire tx_o;

top_module_models  #( .bit_width(32), .N(16),.SIZE(4)) TOP_MODULE(
    .clk(clk),
    .rst_n(rst_n),
    .tx_o(tx_o),
    .dig(dig),
    .seg(seg)  

);

initial clk=1'b1;
always #(`clk_period/2) clk=~clk;

initial begin
    rst_n = 1'b0;
    #`clk_period;
    rst_n =1'b1;
end


endmodule