
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
    wire  signed [bit_width-1:0] Re_temp7;
    wire  signed [bit_width-1:0] Im_temp7;
    wire  signed [bit_width-1:0] Re_temp8;
    wire  signed [bit_width-1:0] Im_temp8;
    wire  signed [bit_width-1:0] Re_temp9;
    wire  signed [bit_width-1:0] Im_temp9;
 //-----------------------------------------------------------------   
    
    wire                         valid_i2;
    wire                         valid_i3;
    wire                         valid_i4;
    wire                         valid_i5;
    wire                         valid_i6;
    wire                         valid_i7;
    wire                         valid_i8;
    wire                         valid_i9;
 //-----------------------------------------------------------------   
    
    wire                         start_stage2;
    wire                         start_stage3;
    wire                         start_stage4;
    wire                         start_stage5;
    wire                         start_stage6;
    wire                         start_stage7;
    wire                         start_stage8;
    wire                         start_read_stage;


//--------------------------------------------------------------------------
    wire         [SIZE-1:      0] wr_ptr2;
    wire         [SIZE-1:      0] wr_ptr3;
    wire         [SIZE-1:      0] wr_ptr4;
    wire         [SIZE-1:      0] wr_ptr5;
    wire         [SIZE-1:      0] wr_ptr6;
    wire         [SIZE-1:      0] wr_ptr7;
    wire         [SIZE-1:      0] wr_ptr8;
    wire         [SIZE-1:      0] wr_ptr9;
//-------------------------------------------------------------------------

//--------------------------------------------------------------------------

    localparam          bit_width_tw_factor = 14;
 //----------------------------------------------------------------------------
  
    wire  signed [bit_width_tw_factor-1:         0] sin_data_radix;
    wire  signed [bit_width_tw_factor-1:         0] cos_data_radix;
    wire  signed [bit_width_tw_factor-1:         0] sin_data;
    wire  signed [bit_width_tw_factor-1:         0] cos_data;

//-------------------------------first stage------------------------------------
     First_stage  #( .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) First_stage(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_flag),
         .load_data(load_data),
         .Re_i(Re_i),
         .Im_i(Im_i),
         .invert_addr(invert_addr),

         .Re_o(Re_temp2),
         .Im_o(Im_temp2),
         .wr_ptr(wr_ptr2),
          
         .en_o(valid_i2),
         .start_next_stage(start_stage2)
    );
//--------------------------------------second stage---------------------------------------------
    Inter_stage2  #( .stage_FFT(2), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Inter_stage_2(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage2),

         .valid_i(valid_i2),
         .Re_i(Re_temp2),
         .Im_i(Im_temp2),
         .wr_ptr_i(wr_ptr2),

         .Re_o(Re_temp3),
         .Im_o(Im_temp3),
         .wr_ptr_o(wr_ptr3),
          
         .en_o(valid_i3),
         .start_next_stage(start_stage3)
    );  

//--------------------------------------third stage--------------------------------------------
    Inter_stage3  #( .stage_FFT(3), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Inter_stage_3(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage3),

         .valid_i(valid_i3),
         .Re_i(Re_temp3),
         .Im_i(Im_temp3),
         .wr_ptr_i(wr_ptr3),

         .Re_o(Re_temp4),
         .Im_o(Im_temp4),
         .wr_ptr_o(wr_ptr4),
          
         .en_o(valid_i4),
         .start_next_stage(start_stage4)
    );  

//--------------------------------------forth stage--------------------------------------------
    Inter_stage4  #( .stage_FFT(4), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Inter_stage_4(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage4),

         .valid_i(valid_i4),
         .Re_i(Re_temp4),
         .Im_i(Im_temp4),
         .wr_ptr_i(wr_ptr4),

         .Re_o(Re_temp5),
         .Im_o(Im_temp5),
         .wr_ptr_o(wr_ptr5),
          
         .en_o(valid_i5),
         .start_next_stage(start_stage5)
    );  

//--------------------------------------fifth stage--------------------------------------------
    Inter_stage5  #( .stage_FFT(5), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Inter_stage_5(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage5),

         .valid_i(valid_i5),
         .Re_i(Re_temp5),
         .Im_i(Im_temp5),
         .wr_ptr_i(wr_ptr5),

         .Re_o(Re_temp6),
         .Im_o(Im_temp6),
         .wr_ptr_o(wr_ptr6),
          
         .en_o(valid_i6),
         .start_next_stage(start_stage6)
    );  

//--------------------------------------sixth stage--------------------------------------------
    Inter_stage6  #( .stage_FFT(6), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Inter_stage_6(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage6),

         .valid_i(valid_i6),
         .Re_i(Re_temp6),
         .Im_i(Im_temp6),
         .wr_ptr_i(wr_ptr6),

         .Re_o(Re_temp7),
         .Im_o(Im_temp7),
         .wr_ptr_o(wr_ptr7),
          
         .en_o(valid_i7),
         .start_next_stage(start_stage7)
    );  

//--------------------------------------seventh stage--------------------------------------------
    Inter_stage7  #( .stage_FFT(7), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Inter_stage_7(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage7),

         .valid_i(valid_i7),
         .Re_i(Re_temp7),
         .Im_i(Im_temp7),
         .wr_ptr_i(wr_ptr7),

         .Re_o(Re_temp8),
         .Im_o(Im_temp8),
         .wr_ptr_o(wr_ptr8),
          
         .en_o(valid_i8),
         .start_next_stage(start_stage8)
    );  
//------------------------------------final stage-----------------------------------------------
           
Final_stage  #( .stage_FFT(8), .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Final_stage(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_stage8),

         .valid_i(valid_i8),
         .Re_i(Re_temp8),
         .Im_i(Im_temp8),
         .wr_ptr_i(wr_ptr8),

         .Re_o(Re_temp9),
         .Im_o(Im_temp9),
         .wr_ptr_o(wr_ptr9),
          
         .en_o(valid_i9),
         .start_read_stage(start_read_stage)
    );  

//------------------------------------out stage-----------------------------------------------
           
Out_stage  #( .t_1_bit(t_1_bit),.bit_width(bit_width), .N(N),.SIZE(SIZE)) Out_stage(
         .clk(clk),
         .rst_n(rst_n),    
         .start_flag(start_read_stage),

         .valid_i(valid_i9),
         .Re_i(Re_temp9),
         .Im_i(Im_temp9),
         .wr_ptr_i(wr_ptr9),

         .en_out(en_out),
 
         .Re_o(Re_o),
         .Im_o(Im_o),
          
         .valid_o(en_o),
         .done_o(done_o)
    );  



endmodule