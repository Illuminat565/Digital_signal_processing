
`define MODIFY_FFT

`include "config_FFT.svh"

module MODIFY_FFT2 #(parameter bit_width=29, N = 16, SIZE = 4) 
(
    input  clk,rst_n,
    input  start_flag,
    input  load_data,
    input  en_out_data,
    input signed [bit_width-1:0] Re_i,
    input signed [bit_width-1:0] Im_i,
    input        [SIZE:0]invert_addr,
    
    output  signed [bit_width-1:0] Re_o ,
    output  signed [bit_width-1:0] Im_o, 

    output  en_o,
    output  finish_FFT
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

    wire signed [bit_width-1:0] Re_temp6;
    wire signed [bit_width-1:0] Im_temp6;
    wire                        en_o_temp; 

    wire  [10:0] rd_ptr_angle;
    wire  en_wr;
    wire  en_rd_1;
    wire  en_rd_2;
    wire  en_o_data;
    wire  [SIZE:0] wr_ptr;
    wire  [SIZE:0] rd_ptr;
    wire  done_bf;
    wire signed [15:0]  sin_data;
    wire signed [15:0]  cos_data;
	wire en_add;
    wire en_modify;
   
   assign Re_o = en_o_data? Re_temp6 : 0;
   assign Im_o = en_o_data? Im_temp6 : 0;
   assign en_o = en_o_data? en_o_temp: 1'b0;

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
     .en_add(en_add),

     .rd_ptr(rd_ptr),
     .rd_ptr_angle(rd_ptr_angle),
     
     .en_o_1(en_rd_1),
     .en_o_2(en_rd_2),
     .en_o_data(en_o_data),
     .finish_FFT(finish_FFT)
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
     .en_rd_1(en_rd_1),
     .en_rd_2(en_rd_2),

     .Re_o1(Re_temp2),
     .Im_o1(Im_temp2),
     .Re_o2(Re_temp4),
     .Im_o2(Im_temp4),

     .Re_o(Re_temp6),
     .Im_o(Im_temp6),
     
     .en_o(en_o_temp)
 );

  `ifdef modifying_twidle_factor
      ROM_TWIDLE #(.SIZE(SIZE)) MODIFYING_ROM_TWIDLE (
          .en_modify(en_modify),
          .rd_ptr_angle(rd_ptr_angle),

          .cos_data(cos_data),
          .sin_data(sin_data)
    );
 `endif 

 `ifdef class_twidle_factor
       CLASS_TWIDLE_ROM CLASS_ROM_TWIDLE (
          .rd_ptr_angle(rd_ptr_angle),

          .cos_data(cos_data),
          .sin_data(sin_data)
    );
 `endif 

   RADIX2  #( .bit_width(bit_width),.SIZE(SIZE)) RADIX2   (

   .en_modify(en_modify),

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

endmodule