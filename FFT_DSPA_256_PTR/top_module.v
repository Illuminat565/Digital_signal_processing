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

//`define SIMULATION
`include "config_FFT.svh"

module top_module #(
    parameter    bit_width = 24,  // Ширина чисел (размер бита)
                 N=16             // Количество отсчетов
) (
    input         CLK,             // тактовые часы 
    input         RST_N,           // СБРОС   
    input         data_in,         // Входные данные
    input  [3:0]  key,             // 
    

    output        tx_o,                 // Выходные данные
    output  [3:0] dig,
    output  [3:0] led,
    output  [7:0] seg  
);
        localparam SIZE = $clog2(N);

        wire signed [bit_width-1:0] Re_o1; 
        wire signed [bit_width-1:0] Im_o1;
        wire signed [bit_width-1:0] Re_o2; 
        wire signed [bit_width-1:0] Im_o2;
        wire signed [bit_width-1:0] Re_i1;
        wire signed [bit_width-1:0] Im_i1; 
        wire signed [bit_width-1:0] Re_i2;
        wire signed [bit_width-1:0] Im_i2;
        wire        [SIZE-1     :0] wr_ptr1;
        wire        [SIZE-1     :0] wr_ptr2;
        wire        [SIZE:       0] invert_addr;
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

        wire            [SIZE-1:  0] wr_ptr_o1;
        wire            [SIZE-1:  0] wr_ptr_o2;
        wire                         data_detect;    
        wire                         en_new_count;


     INVERT_ADDR  #( .bit_width(bit_width), .N(N),.SIZE(SIZE),
                  `ifdef SIMULATION
                    .t_1_bit (4'd9),
                    .t_half_1_bit (4'd4)
                  `else
                    .t_1_bit (16'd5207),
                    .t_half_1_bit (16'd2603)
                  `endif) 
    INVERT_ADDR(.clk(clk),
                .rst_n(rst_n),

                .data_in(data_in),
                
                .data_detect(data_detect),

                .Re_o(Re_i1),
                .Im_o(Im_i1),

                .en_o(load_data));  

     MODIFY_FFT  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) MODIFY_FFT(
         .clk(clk),
         .rst_n(rst_n),    
         
         .data_detect(data_detect),
         .en_wr(load_data),
         .en_new_count(en_new_count),

         .Re_i(Re_i1),
         .Im_i(Im_i1),

         .Real_o1(Re_o1),
         .Imag_o1(Im_o1),
         .Real_o2(Re_o2),
         .Imag_o2(Im_o2),
          
         .wr_ptr_o1(wr_ptr_o1), 
         .wr_ptr_o2(wr_ptr_o2), 
         .en_o(en_proc_data),
         .done_o(done_o)
    );  

  PROCESS_O_DATA #(.bit_width(bit_width), .N(N),.SIZE(SIZE))PROCESS_O_DATA(
         .clk(clk),
         .rst_n(rst_n), 
         
         .finish_fft(done_o),
         .en_back_mem(en_proc_data),         
         .en_rd(tx_done_o),

         .data_re_i1(Re_o1),
         .data_im_i1(Im_o1),
         .data_re_i2(Re_o2),
         .data_im_i2(Im_o2),

         .adr_ptr1(wr_ptr_o1), 
         .adr_ptr2(wr_ptr_o2), 

         .data_out (data_i_uart),
         .en_o(en_tx),
         .done_o (en_new_count));

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