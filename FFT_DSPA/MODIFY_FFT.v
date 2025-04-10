
`define  MODIFY_FFT               // Применение модифицированного алгоритма БПФ. Закомментируйте эту строку, чтобы применить классический алгоритм БПФ 
//`define  NORMALIZAED_16_BIT     // Коэффициент вращения нормируется 16 бит, v=0,2.
//`define  NORMALIZAED_14_BIT     // Коэффициент вращения нормируется 14 бит, v=0,2.
//`define  NORMALIZAED_12_BIT     // Коэффициент вращения нормируется 12 бит, v=0,2.
//`define  NORMALIZAED_10_BIT     // Коэффициент вращения нормируется 10 бит, v=0,2.
//`define  NORMALIZAED_8_BIT      // Коэффициент вращения нормируется 8 бит,  v=0,2.
  `define  STAGGER_0_25           // Степень вобуляции периода повторения импулсов v=0,25, коэффициент вращения нормируется 14 бит.
//`define  STAGGER_0_15           // Степень вобуляции периода повторения импулсов v=0,15, коэффициент вращения нормируется 14 бит.
//`define  STAGGER_0_10           // Степень вобуляции периода повторения импулсов v=0,10, коэффициент вращения нормируется 14 бит.
//`define  STAGGER_0_05           // Степень вобуляции периода повторения импулсов v=0,05, коэффициент вращения нормируется 14 бит.

// * Внимание: при применении модифицированного алгоритма БПФ, то по умолчанию  степень вобуляции периода 
//   повторения импульсов равна v=0,2.
// * При заданной степени вобуляции периода повторения импульсов, по умолчанию  коэффициент вращения нормируется 14 бит
// * Откоментируте соответствующую строку, чтобы генерировать программы в соответствии с требуемой задачей

`include "config_FFT.svh"

module MODIFY_FFT #(parameter bit_width=29, N = 16, SIZE = 4) 
(
    input                            clk,rst_n,

    input                             data_detect,
    input                             en_wr,
    input                             en_new_count,

    input     signed  [bit_width-1:0] Re_i,
    input     signed  [bit_width-1:0] Im_i,
    
    output    signed  [bit_width-1:0] Real_o1,
    output    signed  [bit_width-1:0] Imag_o1,
    output    signed  [bit_width-1:0] Real_o2,
    output    signed  [bit_width-1:0] Imag_o2,

    output            [SIZE-1:     0] wr_ptr_o1,
    output            [SIZE-1:     0] wr_ptr_o2,
    output                            en_o,
    output                            done_o
);

    
    wire    signed [bit_width-1:0] Re_o1;
    wire    signed [bit_width-1:0] Im_o1;
    wire    signed [bit_width-1:0] Re_o2;
    wire    signed [bit_width-1:0] Im_o2;
    wire    signed [bit_width-1:0] RD_Re_i1;
    wire    signed [bit_width-1:0] RD_Im_i1;
    wire    signed [bit_width-1:0] RD_Re_i2;
    wire    signed [bit_width-1:0] RD_Im_i2;
    wire    signed [bit_width-1:0] RD3_Re_i1;
    wire    signed [bit_width-1:0] RD3_Im_i1;
    wire    signed [bit_width-1:0] RD3_Re_i2;
    wire    signed [bit_width-1:0] RD3_Im_i2;

    wire    signed [bit_width-1:0] RAM1_re_i;
    wire    signed [bit_width-1:0] RAM1_im_i;
    wire    signed [bit_width-1:0] RAM2_Re_i1;
    wire    signed [bit_width-1:0] RAM2_Im_i1;
    wire    signed [bit_width-1:0] RAM2_Re_i2;
    wire    signed [bit_width-1:0] RAM2_Im_i2;
    wire    signed [bit_width-1:0] Re_i4;
    wire    signed [bit_width-1:0] Im_i4;
    wire    signed [bit_width-1:0] RAM3_Re_i1;
    wire    signed [bit_width-1:0] RAM3_Im_i1;
    wire    signed [bit_width-1:0] RAM3_Re_i2;
    wire    signed [bit_width-1:0] RAM3_Im_i2;

    wire           [1:         0] rd_ptr_angle;
    wire           [1:         0] rd_ptr_angle2;
    wire           [1:         0] rd_ptr_angle3;
    wire                          RAM1_en_rd;
    wire                          RAM2_en_rd;
    wire                          RAM3_en_rd;
    wire           [SIZE-1:    0] RAM1_wr_ptr;
    wire           [SIZE-1:    0] RAM2_wr_ptr1;
    wire           [SIZE-1:    0] RAM2_wr_ptr2;
    wire           [SIZE-1:    0] RAM1_rd_ptr;
    wire           [SIZE-1:    0] RAM2_rd_ptr;
    wire           [SIZE-1:    0] RAM3_ptr_wr1;
    wire           [SIZE-1:    0] RAM3_ptr_wr2;
    wire           [SIZE-1:    0] RAM3_rd_ptr;
    wire           [SIZE-1:    0] rd_ptr2;
    wire           [SIZE-1:    0] CT2_adr_ptr1;
    wire           [SIZE-1:    0] CT2_adr_ptr2;

    wire           [SIZE-1:    0] CT3_adr_ptr1;
    wire           [SIZE-1:    0] CT3_adr_ptr2;


    wire                           en_back_mem;
    wire                           en_back_mem3;
	wire                           en_add;
    wire                           en_add2;
	wire                           en_add3;
    wire    signed [13:        0]  sin_data;
    wire    signed [13:        0]  cos_data;
    wire    signed [13:        0]  sin_data2;
    wire    signed [13:        0]  cos_data2;
    wire    signed [13:        0]  sin_data3;
    wire    signed [13:        0]  cos_data3;
    wire    signed [13:        0]  sin_data3_2;
    wire    signed [13:        0]  cos_data3_2;
    wire    RAM1_en_wr,RAM3_en_wr, en_stage2, en_stage3,RAM2_en_wr;


//--------------------------------------------------------------------------
           

//--------------------------------------------------------------------------    

    CONTROL1 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL1(
     .clk(clk),
     .rst_n(rst_n),
     
     .data_detect(data_detect),
     .en_new_count(en_new_count),
     
     .en_wr_in(en_wr),
     .Re_i(Re_i),
     .Im_i(Im_i),

     .adr_ptr1(CT2_adr_ptr1),
     .adr_ptr2(CT2_adr_ptr2),
     .en_back_mem(en_back_mem),

     .en_rd(RAM1_en_rd),
     .rd_ptr(RAM1_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle),

     .en_wr_o(RAM1_en_wr),
     .wr_ptr(RAM1_wr_ptr),

     .Re_o(RAM1_re_i),
     .Im_o(RAM1_im_i), 
     
     .start_next_stage(en_stage2),
     .done_o()
 );

//--------------------------------------------------------------------------

    
    RAM  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM1 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM1_en_wr),
     .wr_ptr(RAM1_wr_ptr), 

     .Re_i(RAM1_re_i),
     .Im_i(RAM1_im_i),

    
     .rd_ptr (RAM1_rd_ptr),
     .en_rd (RAM1_en_rd),
     
     .Re_o1(Re_o1),
     .Im_o1(Im_o1),
     .Re_o2(Re_o2),
     .Im_o2(Im_o2),
     .en_add(en_add)
 );
   
    TWIDLE_14_bit  TWIDLE1(
      .rd_ptr_angle(rd_ptr_angle),
      .cos_data(cos_data),
      .sin_data(sin_data)
 );

    RADIX  #( .bit_width(bit_width),
              .bit_width_tw_factor(14))
    RADIX   (

    .sin_data(sin_data),
    .cos_data(cos_data),

    .Re_i1(Re_o1),
    .Im_i1(Im_o1),
    .Re_i2(Re_o2),
    .Im_i2(Im_o2),
    .en(en_add),

    .Re_o1(RAM2_Re_i1),
    .Im_o1(RAM2_Im_i1),
    .Re_o2(RAM2_Re_i2),
    .Im_o2(RAM2_Im_i2) 
    );

     RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM2 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM2_en_wr),
     .wr_ptr1(RAM2_wr_ptr1), 
     .wr_ptr2(RAM2_wr_ptr2), 

     .Re_i1(RAM2_Re_i1),
     .Im_i1(RAM2_Im_i1),
     .Re_i2(RAM2_Re_i2),
     .Im_i2(RAM2_Im_i2),
    
     .rd_ptr(RAM2_rd_ptr),
     .en_rd (RAM2_en_rd),
     
     .Re_o1(RD_Re_i1),
     .Im_o1(RD_Im_i1),
     .Re_o2(RD_Re_i2),
     .Im_o2(RD_Im_i2),
     .en_add(en_add2)
 );  


     CONTROL2 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL2(
     .clk(clk),
     .rst_n(rst_n),
     
     .start_stage(en_stage2),

     .adr_ptr1(CT2_adr_ptr1),
     .adr_ptr2(CT2_adr_ptr2),
     .en_back_mem(en_back_mem),

     .adr_ptr1_o(CT3_adr_ptr1),
     .adr_ptr2_o(CT3_adr_ptr2),
     .en_back_mem_o(en_back_mem3),
     
     .en_wr(RAM2_en_wr),
     .wr_ptr1(RAM2_wr_ptr1),
     .wr_ptr2(RAM2_wr_ptr2),

     .en_rd(RAM2_en_rd),
     .rd_ptr(RAM2_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle2),
     
     .start_next_stage(),

     .done_o()
 );



       TWIDLE_14_bit_STAGE2  TWIDLE2(
      .rd_ptr_angle(rd_ptr_angle2),
      .cos_data(cos_data2),
      .sin_data(sin_data2)
 );

    RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(14))
    RADIX2   (

    .sin_data(sin_data2),
    .cos_data(cos_data2),

    .Re_i1(RD_Re_i1),
    .Im_i1(RD_Im_i1),
    .Re_i2(RD_Re_i2),
    .Im_i2(RD_Im_i2),
    .en(en_add2),

    .Re_o1(RAM3_Re_i1),
    .Im_o1(RAM3_Im_i1),
    .Re_o2(RAM3_Re_i2),
    .Im_o2(RAM3_Im_i2)  

    );
   
    RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM3 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM3_en_wr),
     .wr_ptr1(RAM3_ptr_wr1), 
     .wr_ptr2(RAM3_ptr_wr2), 

     .Re_i1(RAM3_Re_i1),
     .Im_i1(RAM3_Im_i1),
     .Re_i2(RAM3_Re_i2),
     .Im_i2(RAM3_Im_i2),
    
     .rd_ptr(RAM3_rd_ptr),
     .en_rd (RAM3_en_rd),
     
     .Re_o1(RD3_Re_i1),
     .Im_o1(RD3_Im_i1),
     .Re_o2(RD3_Re_i2),
     .Im_o2(RD3_Im_i2),
     .en_add(en_add3)

 );

  TWIDLE_14_bit_STAGE3 TWIDLE3_1(
      .rd_ptr_angle(rd_ptr_angle3),
      .cos_data(cos_data3),
      .sin_data(sin_data3)
 );

   TWIDLE_14_bit_STAGE3_2 TWIDLE3_2(
      .rd_ptr_angle(rd_ptr_angle3),
      .cos_data(cos_data3_2),
      .sin_data(sin_data3_2)
 );

   modify_RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(14))
    MODIFY_RADIX   (

    .sin_data(sin_data3),
    .cos_data(cos_data3),
    .sin_data2(sin_data3_2),
    .cos_data2(cos_data3_2),

    .Re_i1(RD3_Re_i1),
    .Im_i1(RD3_Im_i1),
    .Re_i2(RD3_Re_i2),
    .Im_i2(RD3_Im_i2),
    .en(en_add3),

    .Re_o1(Real_o1),
    .Im_o1(Imag_o1),
    .Re_o2(Real_o2),
    .Im_o2(Imag_o2 )  
    );

    CONTROL3 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL3(
     .clk(clk),
     .rst_n(rst_n),

     .start_stage(),

     .adr_ptr1(CT3_adr_ptr1),
     .adr_ptr2(CT3_adr_ptr2),
     .en_back_mem(en_back_mem3),

     .adr_ptr1_o(wr_ptr_o1),
     .adr_ptr2_o(wr_ptr_o2),
     .en_back_mem_o(en_o),

     .en_rd(RAM3_en_rd),
     .rd_ptr(RAM3_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle3),

     .en_wr(RAM3_en_wr),
     .wr_ptr1(RAM3_ptr_wr1),
     .wr_ptr2(RAM3_ptr_wr2),
     
     .start_next_stage(),

     .done_o(done_o)
 );  
   
endmodule