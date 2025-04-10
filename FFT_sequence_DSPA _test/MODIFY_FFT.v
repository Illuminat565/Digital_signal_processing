
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 

// * Внимание: при применении модифицированного алгоритма БПФ, то по умолчанию  степень вобуляции периода 
//   повторения импульсов равна v=0,2.
// * При заданной степени вобуляции периода повторения импульсов, по умолчанию  коэффициент вращения нормируется 14 бит
// * Откоментируте соответствующую строку, чтобы генерировать программы в соответствии с требуемой задачей

`include "config_FFT.svh"

module MODIFY_FFT #(parameter bit_width=24, N = 16, SIZE = 4) 
(
    input                           clk,rst_n,
    input                           start_flag,
    input                           load_data,
    input                           en_out_data,
    input    signed  [bit_width-1:0] Re_i,
    input    signed  [bit_width-1:0] Im_i,
    input            [SIZE:       0] invert_addr,
    
    output   signed  [bit_width-1:0] Re_o ,
    output   signed  [bit_width-1:0] Im_o, 

    output                           en_o, 
    output                           finish_FFT,
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


//--------------------------------------------------------------------------
        localparam          bit_width_tw_factor = 14;
        wire signed [13:0] sin_data2  =  14'b11011010011000;
        wire signed [13:0] cos_data2  =  14'b11001100001110; 

    wire  signed [bit_width_tw_factor-1:         0] sin_data;
    wire  signed [bit_width_tw_factor-1:         0] cos_data;
//--------------------------------------------------------------------------

       
           

//--------------------------------------------------------------------------    

    CONTROL #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL(
     .clk(clk),
     .rst_n(rst_n),

     .flag_start_FFT(start_flag),
     .en_out_data(en_out_data),

     .Re_1(Re_temp3),
     .Im_1(Im_temp3),
     .Re_2(Re_temp5),
     .Im_2(Im_temp5),

     .Re_o(Re_temp1),
     .Im_o(Im_temp1),

     .wr_ptr(wr_ptr),
     .en_wr(en_wr),

     .en_modify(en_modify),

     .rd_ptr(rd_ptr),
     .rd_ptr_angle(rd_ptr_angle),
     .en_rd (en_rd),

     .finish_FFT(finish_FFT),
     .done_o(done_o)
 );

    RAM  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM(
     .clk(clk),
     .rst_n(rst_n),

     .load_data(load_data),
     .invert_adr(invert_addr),
     .Re_i1(Re_i),
     .Im_i1(Im_i),

     .en_wr(en_wr),
     .wr_ptr(wr_ptr),
     .Re_i2(Re_temp1),
     .Im_i2(Im_temp1),
     
    
     .rd_ptr (rd_ptr),
     .en_rd (en_rd),
     
     .finish_FFT (finish_FFT),
     .done_all(done_o),
     .rd_angle_ptr(rd_ptr_angle),

     .Re_o1(Re_temp2),
     .Im_o1(Im_temp2),
     .Re_o2(Re_temp4),
     .Im_o2(Im_temp4),
     .en_add(en_add),

     .Re_o(Re_o),
     .Im_o(Im_o),
     
     .cos_data(cos_data),
     .sin_data(sin_data),

     .en_o(en_o)
 );

  `ifdef MODIFY_FFT 
   MODIFY_RADIX2  #( .bit_width(bit_width),
                     .bit_width_tw_factor(bit_width_tw_factor))
   MODIFY_RADIX2   (
   .en_modify(en_modify),

   .sin_data(sin_data),
   .cos_data(cos_data),
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
   .Im_o2(Im_temp5)  
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

endmodule