
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 
//`define  NORMALIZAED_16_BIT     // Коэффициент вращения нормируется 16 бит, v=0,2.
//`define  NORMALIZAED_14_BIT     // Коэффициент вращения нормируется 14 бит, v=0,2.
//`define  NORMALIZAED_12_BIT     // Коэффициент вращения нормируется 12 бит, v=0,2.
//`define  NORMALIZAED_11_BIT      // Коэффициент вращения нормируется 6 бит,  v=0,2.
//`define  NORMALIZAED_10_BIT     // Коэффициент вращения нормируется 10 бит, v=0,2.
//`define  NORMALIZAED_9_BIT      // Коэффициент вращения нормируется 6 бит,  v=0,2.
//`define  NORMALIZAED_8_BIT      // Коэффициент вращения нормируется 8 бит,  v=0,2.
//`define  NORMALIZAED_7_BIT      // Коэффициент вращения нормируется 6 бит,  v=0,2.
//`define  NORMALIZAED_6_BIT      // Коэффициент вращения нормируется 6 бит,  v=0,2.
//`define  STAGGER_0_25           // Степень вобуляции периода повторения импулсов v=0,25, коэффициент вращения нормируется 14 бит.
//`define  STAGGER_0_15           // Степень вобуляции периода повторения импулсов v=0,15, коэффициент вращения нормируется 14 бит.
//`define  STAGGER_0_10           // Степень вобуляции периода повторения импулсов v=0,10, коэффициент вращения нормируется 14 бит.
//`define  STAGGER_0_05           // Степень вобуляции периода повторения импулсов v=0,05, коэффициент вращения нормируется 14 бит.

// * Внимание: при применении модифицированного алгоритма БПФ, то по умолчанию  степень вобуляции периода 
//   повторения импульсов равна v=0,2.
// * При заданной степени вобуляции периода повторения импульсов, по умолчанию  коэффициент вращения нормируется 14 бит
// * Откоментируте соответствующую строку, чтобы генерировать программы в соответствии с требуемой задачей

`include "config_FFT.svh"

module MODIFY_FFT #(parameter t_1_bit =5207, bit_width=24, N = 16, SIZE = 4) 
(
    input                           clk,rst_n,
    input                           start_flag,
    input                           load_data,
    input    signed  [bit_width-1:0] Re_i,
    input    signed  [bit_width-1:0] Im_i,
    input            [SIZE-1:     0] invert_addr,
    input                            en_out,
    
    output   signed  [bit_width-1:0] Re_o ,
    output   signed  [bit_width-1:0] Im_o, 

    output                           en_o, 
    output                           done_o
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
 
    wire  signed [bit_width-1:0] Re_temp6;
    wire  signed [bit_width-1:0] Im_temp6;
    wire                         en_o_temp; 

    wire         [10:         0] rd_ptr_angle;
    wire                         en_wr;
    wire                         en_rd;
    wire         [SIZE:       0] wr_ptr;
    wire         [SIZE:       0] rd_ptr;
	wire                         en_add;
    wire                         en_modify;
    wire signed  [bit_width-1:0] Re_demul;
    wire signed  [bit_width-1:0] Im_demul; 


//--------------------------------------------------------------------------

        localparam          bit_width_tw_factor = 14;
        wire signed [13:0] sin_data2  =  14'b11011010011000;
        wire signed [13:0] cos_data2  =  14'b11001100001110; 
 //----------------------------------------------------------------------------
  
    wire  signed [bit_width_tw_factor-1:         0] sin_data_radix;
    wire  signed [bit_width_tw_factor-1:         0] cos_data_radix;
    wire  signed [bit_width_tw_factor-1:         0] sin_data;
    wire  signed [bit_width_tw_factor-1:         0] cos_data;
    wire  out_valid;
    wire  en_radix;
	 wire  en_mul;
//--------------------------------------------------------------------------

       
           

//--------------------------------------------------------------------------    

    CONTROL2 #( .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL(
     .clk(clk),
     .rst_n(rst_n),

     .flag_start_FFT(start_flag),
     .en_out(en_out),

     .en_modify(en_modify),

     .rd_ptr(rd_ptr),
     .rd_ptr_angle(rd_ptr_angle),
     .en_rd (en_rd),

     .out_valid(out_valid),
     .done_o(done_o)
 );

 //-------------------------------------------------------------------------------
    shift_register # ( .width (SIZE+1), .depth (5)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(rd_ptr),
         .out_data(wr_ptr)
);
//--------------------------------------------------------------------------------------
    RAM  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM(
     .clk(clk),
     .rst_n(rst_n),

     .load_data(load_data),
     .invert_adr(invert_addr),
     .Re_i1(Re_i),
     .Im_i1(Im_i),

     .en_wr(en_wr),
     .Re_i2(Re_temp1),
     .Im_i2(Im_temp1),

     .out_valid(out_valid), 
     .wr_ptr(wr_ptr),
     .rd_ptr (rd_ptr),
     .en_rd (en_rd),

     .rd_angle_ptr(rd_ptr_angle), 

     .Re_o(Re_o),
     .Im_o(Im_o),

     .cos_data(cos_data),
     .sin_data(sin_data),

     .en_radix(en_radix),
     .out_valid_data(en_o)
 );
//-------------------------------------------------------------------------------------
 demultiplexor #(.bit_width (bit_width)) demultiplexor(
    .clk(clk),
    .rst_n(rst_n),

    .Re_i(Re_o),
    .Im_i(Im_o),
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

  `ifdef MODIFY_FFT 
   MODIFY_RADIX2  #( .bit_width(bit_width),
                     .bit_width_tw_factor(bit_width_tw_factor))
   MODIFY_RADIX2   (
   .clk(clk),
   .rst_n(rst_n),
   .en_modify(en_modify),

   .sin_data(sin_data_radix),
   .cos_data(cos_data_radix),
   .sin_data2(sin_data2),
   .cos_data2(cos_data2),

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

   `else
    RADIX #( .bit_width(bit_width),
             .bit_width_tw_factor(bit_width_tw_factor))RADIX   (
   .sin_data(sin_data),
   .cos_data(cos_data),

   .Re_i1(Re_temp2),
   .Im_i1(Im_temp2),
   .Re_i2(Re_temp4),
   .Im_i2(Im_temp4),
   .en(en_add),

   .Re_o1(Re_temp3),
   .Im_o1(Im_temp3),
   .Re_o2(Re_temp5),
   .Im_o2(Im_temp5)  
   );
   `endif 

 multiplexor #(.bit_width(bit_width)) multiplexor (
    .clk(clk),
    .rst_n(rst_n),
    .Re_i_1(Re_temp3),
    .Im_i_1(Im_temp3),
    .Re_i_2(Re_temp5),
    .Im_i_2(Im_temp5),
    .in_valid(en_mul),

    .Re_o(Re_temp1),
    .Im_o(Im_temp1),
    .out_valid(en_wr)
);


endmodule