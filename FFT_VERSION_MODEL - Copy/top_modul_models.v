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
module top_module_models 
#(parameter bit_width=28, N = 32, SIZE = 5
) (
    input  clk,
    input  rst_n,
    
    output  tx_o,
    output  [3:0] dig,
    output  [7:0] seg  
);

        wire signed [bit_width-1:0] Re_o, Im_o;
        wire en_FFT;
        wire done_FFT;
        wire tx_done_o;
        wire signed [bit_width-1:0] Re_i;
        wire signed [bit_width-1:0] Im_i; 

        wire full_data;
        wire signed [8:0] real_data_to_rg;
        wire signed [8:0] image_data_to_rg;
        wire load_data;
        wire [SIZE:0] invert_addr;

        wire en_rd;

        wire en_register;
        wire [25:0] count;

    data_FFT DTA_FFT(
        .clk(clk),
        .rst_n(rst_n),

        .en_register(en_register),
        .real_o_data(real_data_to_rg),
        .image_o_data(image_data_to_rg)
    );  



    register  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) REGISTER(
        .clk(clk),
        .rst_n(rst_n),
        .en_register(en_register),

        .real_in_data(real_data_to_rg),
        .image_in_data(image_data_to_rg),

        .real_o_data(Re_i),
        .image_o_data(Im_i),
        .inx_point(invert_addr),

        .full_o(en_FFT),
        .en_o(load_data),
        .empty_o(full_data)
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

/*   seg7_data2  SEG7_DATA2 (
     .clk(clk),
     .rst_n(rst_n),

     .en_FFT(flag_start_FFT),
     .done_FFT(done_FFT),
     
     .dig(dig),
     .seg(seg)  
); 
 */


endmodule