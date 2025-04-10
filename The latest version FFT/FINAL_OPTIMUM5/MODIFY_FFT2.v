module MODIFY_FFT2 #(parameter bit_width=29, N = 16, SIZE = 4) 
(
    input clk,rst_n,
    
    input  load_data,
    input signed [bit_width-1:0] Re_i,
    input signed [bit_width-1:0] Im_i,
    input        [SIZE:0]invert_addr,
    
    output  signed [bit_width-1:0] Re_o ,
    output  signed [bit_width-1:0] Im_o, 
    output  [25:0] count,
    output  flag_start_FFT,
    output  en_o,
    output  done_o
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
    wire                en_o_temp; 

    wire  [10:0] rd_ptr_angle;
    wire  en_wr;
    wire  en_rd;
    wire  [3:0] stage_FFT;
    wire  [3:0] stage_FFT_temp;
    wire  [SIZE:0] wr_ptr;
    wire  [SIZE:0] rd_ptr;
    wire  done_bf;
    wire signed [15:0]  sin_data;
    wire signed [15:0]  cos_data;
	 wire en_back;
     wire delay;
   
   assign Re_o = (stage_FFT_temp == SIZE + 1'b1 )? Re_temp6 : 0;
   assign Im_o = (stage_FFT_temp == SIZE + 1'b1 )? Im_temp6 : 0;
   assign en_o = (stage_FFT_temp == SIZE + 1'b1 )? en_o_temp : 1'b0;

//--------------------------------------------------------------------------
    

    CONTROL #( .bit_width(bit_width), .N(N),.SIZE(SIZE)) CONTROL(
     .clk(clk),
     .rst_n(rst_n),

     .flag_start_FFT(flag_start_FFT),

     .Re_1(Re_temp3),
     .Im_1(Im_temp3),
     .Re_2(Re_temp5),
     .Im_2(Im_temp5),

     .back_mem(en_back), 

     .Re_o(Re_temp1),
     .Im_o(Im_temp1),
     .wr_ptr(wr_ptr),
     .en_wr(en_wr),

     .stage_FFT(stage_FFT),
     .stage_FFT_temp(stage_FFT_temp),

     .rd_ptr(rd_ptr),
     .rd_ptr_angle(rd_ptr_angle),
     .delay(delay),
     
     .count(count),
     .en_o(en_rd),
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
     
    
     .rd_ptr(rd_ptr),
     .en_rd(en_rd),

     .Re_o1(Re_temp2),
     .Im_o1(Im_temp2),
     .Re_o2(Re_temp4),
     .Im_o2(Im_temp4),

     .Re_o(Re_temp6),
     .Im_o(Im_temp6),
     
     .flag_start_FFT(flag_start_FFT),
     .en_o(en_o_temp),
     .done_o(en_back)
 );

  `ifdef modifying_twidle_factor
      ROM_TWIDLE #(.SIZE(SIZE)) ROM_TWIDLE (
          .stage_FFT(stage_FFT_temp),
          .rd_ptr_angle(rd_ptr_angle),

          .cos_data(cos_data),
          .sin_data(sin_data)
    );
 `endif 

 `ifdef class_twidle_factor
       CLASS_TWIDLE_ROM ROM_TWIDLE (
          .rd_ptr_angle(rd_ptr_angle),

          .cos_data(cos_data),
          .sin_data(sin_data)
    );
 `endif 

   RADIX2  #( .bit_width(bit_width),.SIZE(SIZE)) RADIX2   (

   .stage_FFT(stage_FFT_temp),

   .sin_data(sin_data),
   .cos_data(cos_data),

   .Re_i1(Re_temp2),
   .Im_i1(Im_temp2),
   .Re_i2(Re_temp4),
   .Im_i2(Im_temp4),
   .en(en_back),
   .delay(delay),

   .Re_o1(Re_temp3),
   .Im_o1(Im_temp3),
   .Re_o2(Re_temp5),
   .Im_o2(Im_temp5)  
   );

endmodule