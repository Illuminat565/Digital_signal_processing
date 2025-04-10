
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 
`include "config_FFT.svh"

module Inter_stage6 #(parameter stage_FFT = 2, t_1_bit =5207, bit_width=24, N = 16, SIZE = 4) 
(
    input                            clk,rst_n,
    input                            start_flag,

    input                            valid_i,
    input    signed  [bit_width-1:0] Re_i,
    input    signed  [bit_width-1:0] Im_i,
    input            [SIZE-1:     0] wr_ptr_i,
    
    output   signed  [bit_width-1:0] Re_o ,
    output   signed  [bit_width-1:0] Im_o, 
    output           [SIZE-1:     0] wr_ptr_o,

    output                           en_o, 
    output                           start_next_stage
);

    

    wire  signed [bit_width-1:0] Re_temp2;
    wire  signed [bit_width-1:0] Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3;
    wire  signed [bit_width-1:0] Im_temp3;
    wire  signed [bit_width-1:0] Re_temp4;
    wire  signed [bit_width-1:0] Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5;
    wire  signed [bit_width-1:0] Im_temp5;
 

    wire         [stage_FFT-2 :0] rd_ptr_angle;
 
    wire                         en_rd;

    wire         [SIZE-1:       0] rd_ptr;
	wire                         en_add;

    wire signed  [bit_width-1:0] Re_demul;
    wire signed  [bit_width-1:0] Im_demul; 

assign start_next_stage = (wr_ptr_o == ((N/4))-1);
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

       
   addres_generator #(  .stage_FFT(stage_FFT),.N(N), .SIZE(SIZE))addres_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_flag),
    
    .rd_ptr(rd_ptr),
    .en_rd(en_rd),
    .rd_ptr_angle(rd_ptr_angle) 
 );

 //-------------------------------------------------------------------------------
 /*   shift_register # ( .width (SIZE), .depth (5)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(rd_ptr),
         .out_data(wr_ptr_o)
);  */
//--------------------------------------------------------------------------------------
    RAM6  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM(
     .clk(clk),
     .rst_n(rst_n),

     .load_data(valid_i),
     .invert_adr(wr_ptr_i),
     .Re_i(Re_i),
     .Im_i(Im_i),

     .rd_ptr (rd_ptr),
     .en_rd (en_rd),

     .rd_angle_ptr(rd_ptr_angle), 

     .Re_o(Re_demul),
     .Im_o(Im_demul),

     .cos_data(cos_data),
     .sin_data(sin_data),

     .en_radix(en_radix)
 );
//-------------------------------------------------------------------------------------
 demultiplexor #(.bit_width (bit_width)) demultiplexor(
    .clk(clk),
    .rst_n(rst_n),

    .Re_i(Re_demul),
    .Im_i(Im_demul),
    .cos_data(cos_data),
    .sin_data(sin_data),
    .in_valid(en_radix),

    .Re_o1(Re_temp2),
    .Im_o1(Im_temp2),
    .Re_o2(Re_temp4),
    .Im_o2(Im_temp4),
    .o_cos_data(cos_data_radix),
    .o_sin_data(sin_data_radix),
    .out_valid(en_add)
);

     RADIX #( .bit_width(bit_width),
             .bit_width_tw_factor(bit_width_tw_factor))RADIX   (
   .sin_data(sin_data_radix),
   .cos_data(cos_data_radix),

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
     
    .wr_ptr (wr_ptr_o), 
    .Re_o(Re_o),
    .Im_o(Im_o),
    .out_valid(en_o)
);


endmodule