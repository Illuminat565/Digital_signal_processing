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
`define SIMULATION
`include "config_FFT.svh"

module top_module #(
    parameter    bit_width = 24,  // Ширина чисел (размер бита)
                 N=256             // Количество отсчетов
) (
    input        CLK,             // тактовые часы 
    input        RST_N,           // СБРОС   
    input        data_in,         // Входные данные
   // input  [3:0] key,             // 
    

    output  tx_o                 // Выходные данные
 //   output  [3:0] dig,
 //   output  [3:0] led,
//    output  [7:0] seg  
);
        localparam SIZE = $clog2(N);

        `ifdef SIMULATION
         localparam t_1_bit = 4'd9,
                    t_half_1_bit = 4'd4;
        `else    
         localparam t_1_bit = 16'd5207,
                    t_half_1_bit = 16'd2603;
        `endif 


        wire signed [bit_width-1:0] Re_o; 
        wire signed [bit_width-1:0] Im_o;
        wire signed [bit_width-1:0] Re_i;
        wire signed [bit_width-1:0] Im_i; 
        wire        [SIZE-1:     0] invert_addr;
        wire                        load_data;
        wire                        finish_FFT;
        wire                        tx_done_o,en_tx;

        wire                        clk   = CLK;
        wire                        rst_n = RST_N;
        wire                        start_flag;
        wire                        en_out;
        wire        [7:          0] data_i_uart;
        wire                        en_proc_data;
        wire                        done_o;

        wire        [7:          0] signal;
        wire                        en_invert;

    //------------------------------------------------------------------

     uart_rx #(.t_1_bit(t_1_bit),
               .t_half_1_bit(t_half_1_bit))
     UART_RX (.clk(clk),
          .rst_n(rst_n),
          .rx_i(data_in),

          .data_o(signal),
          .rx_done_o(en_invert)
);

     INVERT_ADDR  #(.bit_width(bit_width), .N(N),.SIZE(SIZE),
                    .t_1_bit (t_1_bit),
                    .t_half_1_bit (t_half_1_bit)
                  ) 
     INVERT_ADDR(.clk(clk),
                .rst_n(rst_n),
                .en_invert(en_invert),
                .signal(signal),

                .Re_o(Re_i),
                .Im_o(Im_i),
                .invert_addr(invert_addr),
                .en_o(load_data),
                .start_flag(start_flag));  

     MODIFY_FFT  #( .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) MODIFY_FFT(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_flag),
         .load_data(load_data),
         .Re_i(Re_i),
         .Im_i(Im_i),
         .invert_addr(invert_addr),
         .en_out(en_out),

         .Re_o(Re_o),
         .Im_o(Im_o),
          
         .en_o(en_proc_data),
         .done_o(done_o)
    );  

  PROCESS_O_DATA #(.t_1_bit (t_1_bit),.bit_width(bit_width))PROCESS_O_DATA(
         .clk(clk),
         .rst_n(rst_n), 
         .en_wr(en_proc_data),
         .en_rd(tx_done_o),
         .data_re_i(Re_o),
         .data_im_i(Im_o),
               
         .data_out (data_i_uart),
         .en_o(en_tx),
         .done_o (en_out));

    uart_tx #( .t_1_bit (t_1_bit))
    UART_TX(    .clk(clk),
                .rst_n(rst_n),  
                .en_i(en_tx),
                .data_i(data_i_uart),
                
                .tx_o(tx_o),
                .tx_done_o(tx_done_o));  
 
/*  seg7_data2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE))  SEG7_DATA2 (
     .clk(clk),
     .rst_n(rst_n),
      
     .key(key), 
     
     .en_FFT(start_flag),
     .finish_FFT(finish_FFT),
     .done_all(done_o),

     .Re_in(Re_o),
     .Im_in(Im_o),
     .en_comp(en_proc_data),
     
     .led(led),
     .dig(dig),
     .seg(seg)    
);  */
 

endmodule