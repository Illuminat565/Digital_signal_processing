
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 
`include "config_FFT.svh"

module First_stage #(parameter t_1_bit =5207, bit_width=24, N = 16, SIZE = 4) 
(
    input                           clk,rst_n,
    input                           start_flag,
    input                           load_data,
    input    signed  [bit_width-1:0] Re_i,
    input    signed  [bit_width-1:0] Im_i,
    input            [SIZE-1:     0] invert_addr,
    
    output   signed  [bit_width-1:0] Re_o ,
    output   signed  [bit_width-1:0] Im_o, 
    output           [SIZE-1:     0] wr_ptr,

    output                           en_o, 
    output                           start_next_stage
);

    
    wire  signed [bit_width-1:0] Re_temp1;
    wire  signed [bit_width-1:0] Im_temp1;
    wire  signed [bit_width-1:0] Re_temp2;
    wire  signed [bit_width-1:0] Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3;
    wire  signed [bit_width-1:0] Im_temp3;
    wire  signed [bit_width-1:0] Re_temp4;
    wire  signed [bit_width-1:0] Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5;
    wire  signed [bit_width-1:0] Im_temp5;
 

    wire                         en_wr;
    wire                         en_rd;

    wire         [SIZE-1:       0] rd_ptr;
	wire                         en_add;

    wire signed  [bit_width-1:0] Re_demul;
    wire signed  [bit_width-1:0] Im_demul; 

    assign start_next_stage = (wr_ptr == ((N/128-1)));


//--------------------------------------------------------------------------

        localparam          bit_width_tw_factor = 14;

 //----------------------------------------------------------------------------
  
    wire  signed [bit_width_tw_factor-1:         0] sin_data_radix;
    wire  signed [bit_width_tw_factor-1:         0] cos_data_radix;
    wire  signed [bit_width_tw_factor-1:         0] sin_data;
    wire  signed [bit_width_tw_factor-1:         0] cos_data;
    wire  en_radix;
	wire  en_mul;
//--------------------------------------------------------------------------

   addres_1st_generator #(  .N(N), .SIZE(SIZE))addres_1st_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_flag),
     
    .en_rd(en_rd),  
    .rd_ptr(rd_ptr)
 );

 //-------------------------------------------------------------------------------
 /*   shift_register # ( .width (SIZE), .depth (5)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(rd_ptr),
         .out_data(wr_ptr)
);  */
//--------------------------------------------------------------------------------------
    RAM1  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM(
     .clk(clk),
     .rst_n(rst_n),

     .load_data(load_data),
     .invert_adr(invert_addr),
     .Re_i(Re_i),
     .Im_i(Im_i),

     .rd_ptr (rd_ptr),
     .en_rd (en_rd),

     .Re_o(Re_demul),
     .Im_o(Im_demul),

     .en_radix(en_radix)
 );
//-------------------------------------------------------------------------------------
 first_demultiplexor #(.bit_width (bit_width)) demultiplexor(
    .clk(clk),
    .rst_n(rst_n),

    .in_valid(en_radix),
    .Re_i(Re_demul),
    .Im_i(Im_demul),

    .Re_o1(Re_temp2),
    .Im_o1(Im_temp2),
    .Re_o2(Re_temp4),
    .Im_o2(Im_temp4),
    .out_valid(en_add)
);

    First_RADIX #( .bit_width(bit_width))RADIX (

   .Re_i1(Re_temp2),
   .Im_i1(Im_temp2),
   .Re_i2(Re_temp4),
   .Im_i2(Im_temp4),
   .en(en_add),

   .Re_o1(Re_temp3),
   .Im_o1(Im_temp3),
   .Re_o2(Re_temp5),
   .Im_o2(Im_temp5),
   .out_valid(en_mul)  
   );


 multiplexor #(.bit_width(bit_width),.SIZE(SIZE)) multiplexor (
    .clk(clk),
    .rst_n(rst_n),
    .rd_ptr (rd_ptr),
    .Re_i_1(Re_temp3),
    .Im_i_1(Im_temp3),
    .Re_i_2(Re_temp5),
    .Im_i_2(Im_temp5),
    .in_valid(en_mul),
     
    .wr_ptr (wr_ptr), 
    .Re_o(Re_o),
    .Im_o(Im_o),
    .out_valid(en_o)
);


endmodule