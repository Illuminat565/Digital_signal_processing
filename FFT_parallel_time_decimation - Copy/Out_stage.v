
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 
`include "config_FFT.svh"

module Out_stage #(parameter  t_1_bit =5207, bit_width=24, N = 16, SIZE = 4) 
(
    input                            clk,rst_n,
    input                            start_flag,

    input                            valid_i,
    input    signed  [bit_width-1:0] Re_i,
    input    signed  [bit_width-1:0] Im_i,
    input            [SIZE-1:     0] wr_ptr_i,
    
    input                            en_out, 

    output   signed  [bit_width-1:0] Re_o ,
    output   signed  [bit_width-1:0] Im_o, 

    output                           valid_o, 
    output                           done_o
);

 
    wire                         en_rd;

    wire         [SIZE-1:     0] rd_ptr;

//--------------------------------------------------------------------------

       
    out_addres_generator #(  .t_1_bit(t_1_bit),.N(N), .SIZE(SIZE))out_addres_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_flag),
    .en_out(en_out),
    
    .rd_ptr(rd_ptr),
    .en_rd(en_rd),
    .done_o(done_o)
 );


//--------------------------------------------------------------------------------------
    Final_RAM  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) Final_RAM(
     .clk(clk),
     .rst_n(rst_n),

     .load_data(valid_i),
     .invert_adr(wr_ptr_i),
     .Re_i(Re_i),
     .Im_i(Im_i),

     .rd_ptr (rd_ptr),
     .en_rd (en_rd),

     .Re_o(Re_o),
     .Im_o(Im_o),

     .valid_o(valid_o)
 );

endmodule