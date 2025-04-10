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
//`define SIMULATION
`include "config_FFT.svh"

module top_module #(
    parameter bit_width = 34,  // Размер бита
              N=1024         // Количество отсчетов
) (
    input  CLK,
    input  RST_N,
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
        wire        [ SIZE:0]       invert_addr;
        wire                        load_data;
        wire                        finish_FFT;
        wire                        tx_done_o,en_tx;

        wire                        clk   = CLK;
        wire                        rst_n = RST_N;
        wire                        start_flag;
        wire                        en_out;
        wire                        [7:0] data_i_uart;
        wire                        en_proc_data;

    /*     slow_clk_gen # (.fast_clk_mhz (50), .slow_clk_hz (1))
         i_slow_clk_gen (.slow_clk (slow_clk), 
                         .clk(clk),
                         .rst_n(rst_n));  */


     INVERT_ADDR2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE),
                  `ifdef SIMULATION
                    .t_1_bit (4'd9),
                    .t_half_1_bit (4'd4)
                  `else
                    .t_1_bit (16'd5207),
                    .t_half_1_bit (16'd2603)
                  `endif) 
    INVERT_ADDR2(.clk(clk),
                .rst_n(rst_n),

                .data_in(data_in),

                .Re_o(Re_i),
                .Im_o(Im_i),
                .invert_addr(invert_addr),
                .en_o(load_data),
                .start_flag(start_flag));  

     MODIFY_FFT2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) MODIFY_FFT(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_flag),
         .load_data(load_data),
         .en_out_data(en_out),
         .Re_i(Re_i),
         .Im_i(Im_i),
         .invert_addr(invert_addr),

         .Re_o(Re_o),
         .Im_o(Im_o),
          
         .en_o(en_proc_data),
         .finish_FFT(finish_FFT)
    );  

  PROCESS_O_DATA #(.bit_width(bit_width))PROCESS_O_DATA(
         .clk(clk),
         .rst_n(rst_n), 
         .en_wr(en_proc_data),
         .data_re_i(Re_o),
         .data_im_i(Im_o),
         .en_rd(tx_done_o),
               
         .data_out (data_i_uart),
         .en_o(en_tx),
         .done_o (en_out));

  uart_tx #( 
               `ifdef SIMULATION
               .t_1_bit(9)
               `else
               .t_1_bit(5207)
               `endif )
    UART_TX(    .clk(clk),
                .rst_n(rst_n),  
                .en_i(en_tx),
                .data_i(data_i_uart),
                
                .tx_o(tx_o),
                .tx_done_o(tx_done_o));  
    

    

 /*   uart_tx2 #( .bit_width(bit_width), .N(N),.SIZE(SIZE),
              `ifdef SIMULATION
               .t_1_bit(9)
               `else
               .t_1_bit(5207)
               `endif )
    UART_TX(    .clk(clk),
                .rst_n(rst_n),  
                .en_i(en_tx),
                .data_re_i(Re_o),
                .data_im_i(Im_o),
                
                .tx_o(tx_o),
                .tx_done_o(tx_done_o));  
    
 /*    seg7_data #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) SEG7_DATA (
     .clk(clk),
     .rst_n(rst_n),

     .en_seg7(en_tx),
     .x_in(Re_o),
     .y_in(Im_o),
     
     .dig(dig),
     .seg(seg)  
);   */ 

   seg7_data2  SEG7_DATA2 (
     .clk(clk),
     .rst_n(rst_n),

     .en_FFT(start_flag),
     .finish_FFT(finish_FFT),
     
     .dig(dig),
     .seg(seg)  
); 
 

endmodule