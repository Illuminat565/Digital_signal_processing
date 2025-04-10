
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

module MODIFY_FFT #(parameter bit_width=29, N = 16, SIZE = 4, bit_width_tw =14) 
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

    
    wire    signed [bit_width-1:0] RD1_Re_i1;
    wire    signed [bit_width-1:0] RD1_Im_i1;
    wire    signed [bit_width-1:0] RD1_Re_i2;
    wire    signed [bit_width-1:0] RD1_Im_i2;

    wire    signed [bit_width-1:0] RD2_Re_i1;
    wire    signed [bit_width-1:0] RD2_Im_i1;
    wire    signed [bit_width-1:0] RD2_Re_i2;
    wire    signed [bit_width-1:0] RD2_Im_i2;

    wire    signed [bit_width-1:0] RD3_Re_i1;
    wire    signed [bit_width-1:0] RD3_Im_i1;
    wire    signed [bit_width-1:0] RD3_Re_i2;
    wire    signed [bit_width-1:0] RD3_Im_i2;

    wire    signed [bit_width-1:0] RD4_Re_i1;
    wire    signed [bit_width-1:0] RD4_Im_i1;
    wire    signed [bit_width-1:0] RD4_Re_i2;
    wire    signed [bit_width-1:0] RD4_Im_i2;

    wire    signed [bit_width-1:0] RD5_Re_i1;
    wire    signed [bit_width-1:0] RD5_Im_i1;
    wire    signed [bit_width-1:0] RD5_Re_i2;
    wire    signed [bit_width-1:0] RD5_Im_i2;

    wire    signed [bit_width-1:0] RD6_Re_i1;
    wire    signed [bit_width-1:0] RD6_Im_i1;
    wire    signed [bit_width-1:0] RD6_Re_i2;
    wire    signed [bit_width-1:0] RD6_Im_i2;

    wire    signed [bit_width-1:0] RD7_Re_i1;
    wire    signed [bit_width-1:0] RD7_Im_i1;
    wire    signed [bit_width-1:0] RD7_Re_i2;
    wire    signed [bit_width-1:0] RD7_Im_i2;

    wire    signed [bit_width-1:0] RD8_Re_i1;
    wire    signed [bit_width-1:0] RD8_Im_i1;
    wire    signed [bit_width-1:0] RD8_Re_i2;
    wire    signed [bit_width-1:0] RD8_Im_i2;
//--------------------------------------------------------

    wire    signed [bit_width-1:0] RAM1_re_i;
    wire    signed [bit_width-1:0] RAM1_im_i;

    wire    signed [bit_width-1:0] RAM2_Re_i1;
    wire    signed [bit_width-1:0] RAM2_Im_i1;
    wire    signed [bit_width-1:0] RAM2_Re_i2;
    wire    signed [bit_width-1:0] RAM2_Im_i2;

    wire    signed [bit_width-1:0] RAM3_Re_i1;
    wire    signed [bit_width-1:0] RAM3_Im_i1;
    wire    signed [bit_width-1:0] RAM3_Re_i2;
    wire    signed [bit_width-1:0] RAM3_Im_i2;

    wire    signed [bit_width-1:0] RAM4_Re_i1;
    wire    signed [bit_width-1:0] RAM4_Im_i1;
    wire    signed [bit_width-1:0] RAM4_Re_i2;
    wire    signed [bit_width-1:0] RAM4_Im_i2;

    wire    signed [bit_width-1:0] RAM5_Re_i1;
    wire    signed [bit_width-1:0] RAM5_Im_i1;
    wire    signed [bit_width-1:0] RAM5_Re_i2;
    wire    signed [bit_width-1:0] RAM5_Im_i2;

    wire    signed [bit_width-1:0] RAM6_Re_i1;
    wire    signed [bit_width-1:0] RAM6_Im_i1;
    wire    signed [bit_width-1:0] RAM6_Re_i2;
    wire    signed [bit_width-1:0] RAM6_Im_i2;

    wire    signed [bit_width-1:0] RAM7_Re_i1;
    wire    signed [bit_width-1:0] RAM7_Im_i1;
    wire    signed [bit_width-1:0] RAM7_Re_i2;
    wire    signed [bit_width-1:0] RAM7_Im_i2;

    wire    signed [bit_width-1:0] RAM8_Re_i1;
    wire    signed [bit_width-1:0] RAM8_Im_i1;
    wire    signed [bit_width-1:0] RAM8_Re_i2;
    wire    signed [bit_width-1:0] RAM8_Im_i2;
//--------------------------------------------------------


    wire           [SIZE - 2:  0] rd_ptr_angle1;
    wire           [SIZE - 4:  0] rd_ptr_angle2;
    wire           [SIZE - 3:  0] rd_ptr_angle3;
    wire           [SIZE - 2:  0] rd_ptr_angle4;
    wire           [SIZE - 6:  0] rd_ptr_angle5;
    wire           [SIZE - 7:  0] rd_ptr_angle6;
    wire           [SIZE - 8:  0] rd_ptr_angle7;
    wire           [SIZE - 2:  0] rd_ptr_angle8;
//--------------------------------------------------------
    wire                          RAM1_en_rd;
    wire                          RAM2_en_rd;
    wire                          RAM3_en_rd;
    wire                          RAM4_en_rd;
    wire                          RAM5_en_rd;
    wire                          RAM6_en_rd;
    wire                          RAM7_en_rd;
    wire                          RAM8_en_rd;
//--------------------------------------------------------
    wire           [SIZE-1:    0] RAM1_rd_ptr;
    wire           [SIZE-1:    0] RAM2_rd_ptr;
    wire           [SIZE-1:    0] RAM3_rd_ptr;
    wire           [SIZE-1:    0] RAM4_rd_ptr;
    wire           [SIZE-1:    0] RAM5_rd_ptr;
    wire           [SIZE-1:    0] RAM6_rd_ptr;
    wire           [SIZE-1:    0] RAM7_rd_ptr;
    wire           [SIZE-1:    0] RAM8_rd_ptr;
//--------------------------------------------------------
    wire           [SIZE-1:    0] RAM1_wr_ptr;

    wire           [SIZE-1:    0] RAM2_wr_ptr1;
    wire           [SIZE-1:    0] RAM2_wr_ptr2;

    wire           [SIZE-1:    0] RAM3_wr_ptr1;
    wire           [SIZE-1:    0] RAM3_wr_ptr2;

    wire           [SIZE-1:    0] RAM4_wr_ptr1;
    wire           [SIZE-1:    0] RAM4_wr_ptr2;

    wire           [SIZE-1:    0] RAM5_wr_ptr1;
    wire           [SIZE-1:    0] RAM5_wr_ptr2;

    wire           [SIZE-1:    0] RAM6_wr_ptr1;
    wire           [SIZE-1:    0] RAM6_wr_ptr2;

    wire           [SIZE-1:    0] RAM7_wr_ptr1;
    wire           [SIZE-1:    0] RAM7_wr_ptr2;

    wire           [SIZE-1:    0] RAM8_wr_ptr1;
    wire           [SIZE-1:    0] RAM8_wr_ptr2;
//--------------------------------------------------------
    wire           [SIZE-1:    0] CT2_adr_ptr1;
    wire           [SIZE-1:    0] CT2_adr_ptr2;

    wire           [SIZE-1:    0] CT3_adr_ptr1;
    wire           [SIZE-1:    0] CT3_adr_ptr2;

    wire           [SIZE-1:    0] CT4_adr_ptr1;
    wire           [SIZE-1:    0] CT4_adr_ptr2;

    wire           [SIZE-1:    0] CT5_adr_ptr1;
    wire           [SIZE-1:    0] CT5_adr_ptr2;

    wire           [SIZE-1:    0] CT6_adr_ptr1;
    wire           [SIZE-1:    0] CT6_adr_ptr2;

    wire           [SIZE-1:    0] CT7_adr_ptr1;
    wire           [SIZE-1:    0] CT7_adr_ptr2;

    wire           [SIZE-1:    0] CT8_adr_ptr1;
    wire           [SIZE-1:    0] CT8_adr_ptr2;
//--------------------------------------------------------

    wire                           en_back_mem2;
    wire                           en_back_mem3;
    wire                           en_back_mem4;
    wire                           en_back_mem5;
    wire                           en_back_mem6;
    wire                           en_back_mem7;
    wire                           en_back_mem8;
//--------------------------------------------------------
	wire                           en_add;
    wire                           en_add2;
	wire                           en_add3;
	wire                           en_add4;
	wire                           en_add5;
    wire                           en_add6;
	wire                           en_add7;
	wire                           en_add8;
//--------------------------------------------------------
    wire    signed [bit_width_tw-1: 0]  sin_data;
    wire    signed [bit_width_tw-1: 0]  cos_data;
    wire    signed [bit_width_tw-1: 0]  sin_data2;
    wire    signed [bit_width_tw-1: 0]  cos_data2;
    wire    signed [bit_width_tw-1: 0]  sin_data3;
    wire    signed [bit_width_tw-1: 0]  cos_data3;
    wire    signed [bit_width_tw-1: 0]  sin_data4;
    wire    signed [bit_width_tw-1: 0]  cos_data4;
    wire    signed [bit_width_tw-1: 0]  sin_data5;
    wire    signed [bit_width_tw-1: 0]  cos_data5;
    wire    signed [bit_width_tw-1: 0]  sin_data6;
    wire    signed [bit_width_tw-1: 0]  cos_data6;
    wire    signed [bit_width_tw-1: 0]  sin_data7;
    wire    signed [bit_width_tw-1: 0]  cos_data7;
    wire    signed [bit_width_tw-1: 0]  sin_data8_1;
    wire    signed [bit_width_tw-1: 0]  cos_data8_1;
    wire    signed [bit_width_tw-1: 0]  sin_data8_2;
    wire    signed [bit_width_tw-1: 0]  cos_data8_2;
    wire    signed [bit_width_tw-1: 0]  sin_data8;
    wire    signed [bit_width_tw-1: 0]  cos_data8;
    
//--------------------------------------------------------
    wire                          RAM1_en_wr;
    wire                          RAM2_en_wr;
    wire                          RAM3_en_wr;
    wire                          RAM4_en_wr;
    wire                          RAM5_en_wr;
    wire                          RAM6_en_wr;
    wire                          RAM7_en_wr;
    wire                          RAM8_en_wr;

//--------------------------------------------------------
    wire                           en_tw1;
    wire                           en_tw2;
    wire                           en_tw3;
    wire                           en_tw4;
    wire                           en_tw5;
    wire                           en_tw6;
    wire                           en_tw7;
    wire                           en_tw8;


//--------------------------------------------------------------------------
  wire signed [13:0] sin_data4_2  =  14'b11011010011000;
  wire signed [13:0] cos_data4_2  =  14'b11001100001110;    
//----------------------------------stage 1-------------------------    

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
     .en_back_mem(en_back_mem2),

     .en_rd(RAM1_en_rd),
     .rd_ptr(RAM1_rd_ptr),
     .rd_ptr_angle(),
     .en_rd_angle(en_tw1),

     .en_wr_o(RAM1_en_wr),
     .wr_ptr(RAM1_wr_ptr),

     .Re_o(RAM1_re_i),
     .Im_o(RAM1_im_i), 
     
     .done_o()
 );
    
    RAM  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM1 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM1_en_wr),
     .wr_ptr(RAM1_wr_ptr), 

     .Re_i(RAM1_re_i),
     .Im_i(RAM1_im_i),

    
     .rd_ptr (RAM1_rd_ptr),
     .en_rd (RAM1_en_rd),
     
     .Re_o1(RD1_Re_i1),
     .Im_o1(RD1_Im_i1),
     .Re_o2(RD1_Re_i2),
     .Im_o2(RD1_Im_i2),
     .en_add(en_add)
 );
   
    TWIDLE_14_bit_STAGE1 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
     TWIDLE1 (
      .clk(clk),
      .en(en_tw1),
      .cos_data(cos_data),
      .sin_data(sin_data));

    RADIX  #( .bit_width(bit_width),
              .bit_width_tw_factor(14))
    RADIX   (

    .sin_data(sin_data),
    .cos_data(cos_data),

    .Re_i1(RD1_Re_i1),
    .Im_i1(RD1_Im_i1),
    .Re_i2(RD1_Re_i2),
    .Im_i2(RD1_Im_i2),
    .en(en_add),

    .Re_o1(RAM2_Re_i1),
    .Im_o1(RAM2_Im_i1),
    .Re_o2(RAM2_Re_i2),
    .Im_o2(RAM2_Im_i2) 
    );
//-------------------------stage 2----------------------------------

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
     
     .Re_o1(RD2_Re_i1),
     .Im_o1(RD2_Im_i1),
     .Re_o2(RD2_Re_i2),
     .Im_o2(RD2_Im_i2),
     .en_add(en_add2)
 );  


     CONTROL2 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL2(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT2_adr_ptr1),
     .adr_ptr2(CT2_adr_ptr2),
     .en_back_mem(en_back_mem2),

     .adr_ptr1_o(CT3_adr_ptr1),
     .adr_ptr2_o(CT3_adr_ptr2),
     .en_back_mem_o(en_back_mem3),
     
     .en_wr(RAM2_en_wr),
     .wr_ptr1(RAM2_wr_ptr1),
     .wr_ptr2(RAM2_wr_ptr2),

     .en_rd(RAM2_en_rd),
     .rd_ptr(RAM2_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle2),
     .en_rd_angle(en_tw2),

     .done_o()
 );



    TWIDLE_14_bit_STAGE2 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw)) 
       TWIDLE2(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle2),
      .en(en_tw2),
      .cos_data(cos_data2),
      .sin_data(sin_data2)
 );

    RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(14))
    RADIX2   (

    .sin_data(sin_data2),
    .cos_data(cos_data2),

    .Re_i1(RD2_Re_i1),
    .Im_i1(RD2_Im_i1),
    .Re_i2(RD2_Re_i2),
    .Im_i2(RD2_Im_i2),
    .en(en_add2),

    .Re_o1(RAM3_Re_i1),
    .Im_o1(RAM3_Im_i1),
    .Re_o2(RAM3_Re_i2),
    .Im_o2(RAM3_Im_i2)  
 );

//---------------------------stage 3-------------------------------  
    RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM3 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM3_en_wr),
     .wr_ptr1(RAM3_wr_ptr1), 
     .wr_ptr2(RAM3_wr_ptr2), 

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

  TWIDLE_14_bit_STAGE3 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
  TWIDLE3(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle3),
      .en(en_tw3),
      .cos_data(cos_data3),
      .sin_data(sin_data3)
 );


   RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(14))
    RADIX3   (

    .sin_data(sin_data3),
    .cos_data(cos_data3),

    .Re_i1(RD3_Re_i1),
    .Im_i1(RD3_Im_i1),
    .Re_i2(RD3_Re_i2),
    .Im_i2(RD3_Im_i2),
    .en(en_add3),

    .Re_o1(RAM4_Re_i1),
    .Im_o1(RAM4_Im_i1),
    .Re_o2(RAM4_Re_i2),
    .Im_o2(RAM4_Im_i2 )  
    );

    CONTROL3 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL3(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT3_adr_ptr1),
     .adr_ptr2(CT3_adr_ptr2),
     .en_back_mem(en_back_mem3),

     .adr_ptr1_o(CT4_adr_ptr1),
     .adr_ptr2_o(CT4_adr_ptr2),
     .en_back_mem_o(en_back_mem4),

     .en_rd(RAM3_en_rd),
     .rd_ptr(RAM3_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle3),
     .en_rd_angle(en_tw3),

     .en_wr(RAM3_en_wr),
     .wr_ptr1(RAM3_wr_ptr1),
     .wr_ptr2(RAM3_wr_ptr2),

     .done_o()
 );  

//---------stage 4--------------------------------------------------

    RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM4 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM4_en_wr),
     .wr_ptr1(RAM4_wr_ptr1), 
     .wr_ptr2(RAM4_wr_ptr2), 

     .Re_i1(RAM4_Re_i1),
     .Im_i1(RAM4_Im_i1),
     .Re_i2(RAM4_Re_i2),
     .Im_i2(RAM4_Im_i2),
    
     .rd_ptr(RAM4_rd_ptr),
     .en_rd (RAM4_en_rd),
     
     .Re_o1(RD4_Re_i1),
     .Im_o1(RD4_Im_i1),
     .Re_o2(RD4_Re_i2),
     .Im_o2(RD4_Im_i2),
     .en_add(en_add4)

 );

  TWIDLE_14_bit_STAGE4 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
  TWIDLE4(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle4),
      .en(en_tw4),
      .cos_data(cos_data4),
      .sin_data(sin_data4)
 );


   modify_RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(bit_width_tw))
    RADIX4   (

    .sin_data(sin_data4),
    .cos_data(cos_data4),
    .sin_data2(sin_data4_2),
    .cos_data2(cos_data4_2),

    .Re_i1(RD4_Re_i1),
    .Im_i1(RD4_Im_i1),
    .Re_i2(RD4_Re_i2),
    .Im_i2(RD4_Im_i2),
    .en(en_add4),


    .Re_o1(Real_o1),
    .Im_o1(Imag_o1),
    .Re_o2(Real_o2),
    .Im_o2(Imag_o2 )   
    );

    CONTROL4 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL4(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT4_adr_ptr1),
     .adr_ptr2(CT4_adr_ptr2),
     .en_back_mem(en_back_mem4),

     .adr_ptr1_o(wr_ptr_o1),
     .adr_ptr2_o(wr_ptr_o2),
     .en_back_mem_o(en_o),

     .en_rd(RAM4_en_rd),
     .rd_ptr(RAM4_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle4),
     .en_rd_angle(en_tw4),

     .en_wr(RAM4_en_wr),
     .wr_ptr1(RAM4_wr_ptr1),
     .wr_ptr2(RAM4_wr_ptr2),

     .done_o(done_o)
 );  

//--------------------------stage 5------------------------------------

 /*   RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM5 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM5_en_wr),
     .wr_ptr1(RAM5_wr_ptr1), 
     .wr_ptr2(RAM5_wr_ptr2), 

     .Re_i1(RAM5_Re_i1),
     .Im_i1(RAM5_Im_i1),
     .Re_i2(RAM5_Re_i2),
     .Im_i2(RAM5_Im_i2),
    
     .rd_ptr(RAM5_rd_ptr),
     .en_rd (RAM5_en_rd),
     
     .Re_o1(RD5_Re_i1),
     .Im_o1(RD5_Im_i1),
     .Re_o2(RD5_Re_i2),
     .Im_o2(RD5_Im_i2),
     .en_add(en_add5)

 );

  TWIDLE_14_bit_STAGE5 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
  TWIDLE5(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle5),
      .en(en_tw5),
      .cos_data(cos_data5),
      .sin_data(sin_data5)
 );


    RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(bit_width_tw))
    RADIX5   (

    .sin_data(sin_data5),
    .cos_data(cos_data5),

    .Re_i1(RD5_Re_i1),
    .Im_i1(RD5_Im_i1),
    .Re_i2(RD5_Re_i2),
    .Im_i2(RD5_Im_i2),
    .en(en_add5),

    .Re_o1(RAM6_Re_i1),
    .Im_o1(RAM6_Im_i1),
    .Re_o2(RAM6_Re_i2),
    .Im_o2(RAM6_Im_i2 )  
    );

    CONTROL5 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL5(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT5_adr_ptr1),
     .adr_ptr2(CT5_adr_ptr2),
     .en_back_mem(en_back_mem5),

     .adr_ptr1_o(CT6_adr_ptr1),
     .adr_ptr2_o(CT6_adr_ptr2),
     .en_back_mem_o(en_back_mem6),

     .en_rd(RAM5_en_rd),
     .rd_ptr(RAM5_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle5),
     .en_rd_angle(en_tw5),

     .en_wr(RAM5_en_wr),
     .wr_ptr1(RAM5_wr_ptr1),
     .wr_ptr2(RAM5_wr_ptr2),

     .done_o()
 );  
//--------------------------stage 6------------------------------------

    RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM6 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM6_en_wr),
     .wr_ptr1(RAM6_wr_ptr1), 
     .wr_ptr2(RAM6_wr_ptr2), 

     .Re_i1(RAM6_Re_i1),
     .Im_i1(RAM6_Im_i1),
     .Re_i2(RAM6_Re_i2),
     .Im_i2(RAM6_Im_i2),
    
     .rd_ptr(RAM6_rd_ptr),
     .en_rd (RAM6_en_rd),
     
     .Re_o1(RD6_Re_i1),
     .Im_o1(RD6_Im_i1),
     .Re_o2(RD6_Re_i2),
     .Im_o2(RD6_Im_i2),
     .en_add(en_add6)

 );

  TWIDLE_14_bit_STAGE6 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
  TWIDLE6(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle6),
      .en(en_tw6),
      .cos_data(cos_data6),
      .sin_data(sin_data6)
 );


    RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(bit_width_tw))
    RADIX6   (

    .sin_data(sin_data6),
    .cos_data(cos_data6),

    .Re_i1(RD6_Re_i1),
    .Im_i1(RD6_Im_i1),
    .Re_i2(RD6_Re_i2),
    .Im_i2(RD6_Im_i2),
    .en(en_add6),

    .Re_o1(RAM7_Re_i1),
    .Im_o1(RAM7_Im_i1),
    .Re_o2(RAM7_Re_i2),
    .Im_o2(RAM7_Im_i2 )  
    );

    CONTROL6 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL6(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT6_adr_ptr1),
     .adr_ptr2(CT6_adr_ptr2),
     .en_back_mem(en_back_mem6),

     .adr_ptr1_o(CT7_adr_ptr1),
     .adr_ptr2_o(CT7_adr_ptr2),
     .en_back_mem_o(en_back_mem7),

     .en_rd(RAM6_en_rd),
     .rd_ptr(RAM6_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle6),
     .en_rd_angle(en_tw6),

     .en_wr(RAM6_en_wr),
     .wr_ptr1(RAM6_wr_ptr1),
     .wr_ptr2(RAM6_wr_ptr2),

     .done_o()
 ); 
//--------------------------stage 7------------------------------------

    RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM7 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM7_en_wr),
     .wr_ptr1(RAM7_wr_ptr1), 
     .wr_ptr2(RAM7_wr_ptr2), 

     .Re_i1(RAM7_Re_i1),
     .Im_i1(RAM7_Im_i1),
     .Re_i2(RAM7_Re_i2),
     .Im_i2(RAM7_Im_i2),
    
     .rd_ptr(RAM7_rd_ptr),
     .en_rd (RAM7_en_rd),
     
     .Re_o1(RD7_Re_i1),
     .Im_o1(RD7_Im_i1),
     .Re_o2(RD7_Re_i2),
     .Im_o2(RD7_Im_i2),
     .en_add(en_add7)

 );

  TWIDLE_14_bit_STAGE7 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
  TWIDLE7(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle7),
      .en(en_tw7),
      .cos_data(cos_data7),
      .sin_data(sin_data7)
 );


    RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(bit_width_tw))
    RADIX7   (

    .sin_data(sin_data7),
    .cos_data(cos_data7),

    .Re_i1(RD7_Re_i1),
    .Im_i1(RD7_Im_i1),
    .Re_i2(RD7_Re_i2),
    .Im_i2(RD7_Im_i2),
    .en(en_add7),

    .Re_o1(RAM8_Re_i1),
    .Im_o1(RAM8_Im_i1),
    .Re_o2(RAM8_Re_i2),
    .Im_o2(RAM8_Im_i2 )  
    );

    CONTROL7 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL7(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT7_adr_ptr1),
     .adr_ptr2(CT7_adr_ptr2),
     .en_back_mem(en_back_mem7),

     .adr_ptr1_o(CT8_adr_ptr1),
     .adr_ptr2_o(CT8_adr_ptr2),
     .en_back_mem_o(en_back_mem8),

     .en_rd(RAM7_en_rd),
     .rd_ptr(RAM7_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle7),
     .en_rd_angle(en_tw7),

     .en_wr(RAM7_en_wr),
     .wr_ptr1(RAM7_wr_ptr1),
     .wr_ptr2(RAM7_wr_ptr2),

     .done_o()
 ); 
//--------------------------stage 8------------------------------------

    RAM2  #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) RAM8 (
     .clk(clk),
     .rst_n(rst_n),

     .en_wr(RAM8_en_wr),
     .wr_ptr1(RAM8_wr_ptr1), 
     .wr_ptr2(RAM8_wr_ptr2), 

     .Re_i1(RAM8_Re_i1),
     .Im_i1(RAM8_Im_i1),
     .Re_i2(RAM8_Re_i2),
     .Im_i2(RAM8_Im_i2),
    
     .rd_ptr(RAM8_rd_ptr),
     .en_rd (RAM8_en_rd),
     
     .Re_o1(RD8_Re_i1),
     .Im_o1(RD8_Im_i1),
     .Re_o2(RD8_Re_i2),
     .Im_o2(RD8_Im_i2),
     .en_add(en_add8)

 );

  TWIDLE_14_bit_STAGE8_1 #(.N(N),.SIZE(SIZE), .bit_width_tw(bit_width_tw))
  TWIDLE8(
      .clk(clk),
      .rd_ptr_angle(rd_ptr_angle8),
      .en(en_tw8),
      .cos_data(cos_data8),
      .sin_data(sin_data8)
 );


    final_RADIX  #( .bit_width(bit_width),
                        .bit_width_tw_factor(bit_width_tw))
    RADIX8   (

    .sin_data(sin_data8),
    .cos_data(cos_data8),

    .Re_i1(RD8_Re_i1),
    .Im_i1(RD8_Im_i1),
    .Re_i2(RD8_Re_i2),
    .Im_i2(RD8_Im_i2),
    .en(en_add8),

    .Re_o1(Real_o1),
    .Im_o1(Imag_o1),
    .Re_o2(Real_o2),
    .Im_o2(Imag_o2 )  
    );

    CONTROL8 #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL8(
     .clk(clk),
     .rst_n(rst_n),

     .adr_ptr1(CT8_adr_ptr1),
     .adr_ptr2(CT8_adr_ptr2),
     .en_back_mem(en_back_mem8),

     .adr_ptr1_o(wr_ptr_o1),
     .adr_ptr2_o(wr_ptr_o2),
     .en_back_mem_o(en_o),

     .en_rd(RAM8_en_rd),
     .rd_ptr(RAM8_rd_ptr),
     .rd_ptr_angle(rd_ptr_angle8),
     .en_rd_angle(en_tw8),

     .en_wr(RAM8_en_wr),
     .wr_ptr1(RAM8_wr_ptr1),
     .wr_ptr2(RAM8_wr_ptr2),

     .done_o(done_o)
 );   */  
endmodule