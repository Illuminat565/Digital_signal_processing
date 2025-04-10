
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 
//`define  NORMALIZAED_16_BIT     // Коэффициент вращения нормируется 16 бит, v=0,2.
`define  NORMALIZAED_14_BIT     // Коэффициент вращения нормируется 14 бит, v=0,2.
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
 
   `ifdef NORMALIZAED_16_BIT
        localparam          bit_width_tw_factor = 16;
        wire signed [15:0]  sin_data2  = 16'b1101_1010_0110_0010; 
        wire signed [15:0]  cos_data2  = 16'b1100_1100_0011_1001; 
   `elsif NORMALIZAED_14_BIT
        localparam          bit_width_tw_factor = 14;
        wire signed [13:0] sin_data2  =  14'b11011010011000;
        wire signed [13:0] cos_data2  =  14'b11001100001110; 
   `elsif NORMALIZAED_12_BIT
        localparam          bit_width_tw_factor = 12;
        wire signed [11:0] sin_data2  =  12'b110110100110;
        wire signed [11:0] cos_data2  =  12'b110011000100;
   `elsif NORMALIZAED_11_BIT
        localparam          bit_width_tw_factor = 11;       
        wire signed [10:0] sin_data2  =  11'b11011010011;
        wire signed [10:0] cos_data2  =  11'b11001100010;
   `elsif NORMALIZAED_10_BIT
        localparam          bit_width_tw_factor = 10;
        wire signed [9:0] sin_data2  =  10'b1101101010;
        wire signed [9:0] cos_data2  =  10'b1100110001;
   `elsif NORMALIZAED_9_BIT
        localparam          bit_width_tw_factor = 9;
        wire signed [8:0] sin_data2  =  9'b110110101;
        wire signed [8:0] cos_data2  =  9'b110011000;
   `elsif NORMALIZAED_8_BIT
        localparam          bit_width_tw_factor = 8;
        wire signed [7:0] sin_data2  =  8'b11011010;
        wire signed [7:0] cos_data2  =  8'b11001100;
    `elsif NORMALIZAED_7_BIT
        localparam          bit_width_tw_factor = 7;
        wire signed [6:0] sin_data2  =  7'b1101101;
        wire signed [6:0] cos_data2  =  7'b1100110;
    `elsif NORMALIZAED_6_BIT
        localparam          bit_width_tw_factor = 6;
        wire signed [5:0] sin_data2  =  6'b110111;
        wire signed [5:0] cos_data2  =  6'b110011;
    `elsif  STAGGER_0_25
        localparam          bit_width_tw_factor = 14;      
        wire signed [13:0] sin_data2  =  14'b11010010110000;
        wire signed [13:0] cos_data2  =  14'b11010010110000;
    `elsif  STAGGER_0_15
        localparam          bit_width_tw_factor = 14;
        wire signed [13:0] sin_data2  =  14'b11100010111100;
        wire signed [13:0] cos_data2  =  14'b11000110111110;
    `elsif STAGGER_0_10
        localparam          bit_width_tw_factor = 14;
        wire signed [13:0] sin_data2  =  14'b11101100001110;
        wire signed [13:0] cos_data2  =  14'b11000011001000;
    `else
        localparam          bit_width_tw_factor = 14;
        wire signed [13:0] sin_data2  =  14'b11110101111111;
        wire signed [13:0] cos_data2  =  14'b11000000110010;
    `endif
        
  
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

     .Re_o1(Re_temp2),
     .Im_o1(Im_temp2),
     .Re_o2(Re_temp4),
     .Im_o2(Im_temp4),
     .en_add(en_add),

     .Re_o(Re_o),
     .Im_o(Im_o),
     .en_o(en_o)
 );

  `ifdef MODIFY_FFT
      `ifdef NORMALIZAED_16_BIT
       M_TWIDLE_16_bit
      `elsif NORMALIZAED_14_BIT
       M_TWIDLE_14_bit
      `elsif NORMALIZAED_12_BIT
       M_TWIDLE_12_bit
      `elsif NORMALIZAED_11_BIT
       M_TWIDLE_11_bit
      `elsif NORMALIZAED_10_BIT
       M_TWIDLE_10_bit
      `elsif NORMALIZAED_9_BIT
       M_TWIDLE_9_bit
      `elsif NORMALIZAED_8_BIT
       M_TWIDLE_8_bit
      `elsif NORMALIZAED_7_BIT
       M_TWIDLE_7_bit
      `elsif NORMALIZAED_6_BIT
       M_TWIDLE_6_bit
      `elsif STAGGER_0_25
       M_TWIDLE_0_25_v 
       `elsif STAGGER_0_15
       M_TWIDLE_0_15_v 
       `elsif STAGGER_0_10
       M_TWIDLE_0_10_v 
       `else
       M_TWIDLE_0_05_v
       `endif 

         #(.SIZE(SIZE)) MODIFY_TWIDLE (
          .en_modify(en_modify),
          .rd_ptr_angle(rd_ptr_angle),

          .cos_data(cos_data),
          .sin_data(sin_data)
    );
 `else
       TWIDLE_14_bit TWIDLE (
          .rd_ptr_angle(rd_ptr_angle),

          .cos_data(cos_data),
          .sin_data(sin_data)
    );
 `endif 


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