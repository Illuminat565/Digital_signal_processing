 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : top_module
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    :
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------

`define MODIFY_FFT

`include "config_FFT.svh"

module top_module #(
    parameter bit_width = 34,  // Размер бита
              N=32            // Количество отсчетов
) (
    input  clk,
    input  rst_n,
    input  data_in,  // Входные данные

    output  tx_o,    // Выходные данные
    output  [3:0] dig,
    output  [7:0] seg  
);
        localparam SIZE = $clog2(N);

        wire signed [bit_width-1:0] Re_o; 
        wire signed [bit_width-1:0] Im_o;
        wire signed [bit_width-1:0] Re_i;
        wire signed [bit_width-1:0] Im_i; 
        wire        [ SIZE:0] invert_addr;
        wire load_data;
        wire done_FFT;
        wire tx_done_o,en_tx;
        wire flag_start_FFT;
        wire [25:0] count;

     INVERT_ADDR  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) INVERT_ADDR(
        .clk(clk),
        .rst_n(rst_n),

        .data_in(data_in),

        .Re_o(Re_i),
        .Im_o(Im_i),
        .invert_addr(invert_addr),
        
        .en_o(load_data)
        );  

     MODIFY_FFT2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) MODIFY_FFT(
         .clk(clk),
         .rst_n(rst_n),    
         
         .load_data(load_data),
         .Re_i(Re_i),
         .Im_i(Im_i),
         .invert_addr(invert_addr),

         .Re_o(Re_o),
         .Im_o(Im_o),
         .count(count),
          
         .flag_start_FFT(flag_start_FFT), 
         .en_o(en_tx),
         .done_o(done_FFT)
    );  
    

    uart_tx2 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) UART_TX(
        .clk(clk),
        .rst_n(rst_n),  
        .en_i(en_tx),
        .data_re_i(Re_o),
        .data_im_i(Im_o),
        
        .tx_o(tx_o),
        .tx_done_o(tx_done_o)  
);  
    
     seg7_data #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) SEG7_DATA (
     .clk(clk),
     .rst_n(rst_n),

     .en_seg7(en_tx),
     .x_in(Re_o),
     .y_in(Im_o),
     .count(count),
     
     .dig(dig),
     .seg(seg)  
);   

 /*  seg7_data2  SEG7_DATA2 (
     .clk(clk),
     .rst_n(rst_n),

     .en_FFT(flag_start_FFT),
     .done_FFT(done_FFT),
     
     .dig(dig),
     .seg(seg)  
); */
 

endmodule