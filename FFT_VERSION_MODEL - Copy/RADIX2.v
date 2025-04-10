
`define MODIFY_FFT

`include "config_FFT.svh"

module RADIX2
	#(parameter bit_width=16, SIZE = 4)
    (
 
    input                  en_modify,
 
    input   signed [15:0]  sin_data,
    input   signed [15:0]  cos_data,

	input   signed [bit_width-1:0] Re_i1,
	input   signed [bit_width-1:0] Im_i1,
    input   signed [bit_width-1:0] Re_i2,
	input   signed [bit_width-1:0] Im_i2,
    input   en,

	output  signed [bit_width-1:0]  Re_o1,
	output  signed [bit_width-1:0]  Im_o1,
    output  signed [bit_width-1:0]  Re_o2,
	output  signed [bit_width-1:0]  Im_o2
   );

   wire signed [bit_width-1:0] Re_temp1, Im_temp1;
   wire signed [bit_width-1:0] Re_temp2, Im_temp2;

   wire signed [15:0]  sin_data2;
   wire signed [15:0]  cos_data2;
   
   assign sin_data2 = 16'b1101_1010_0110_0010; 
   assign cos_data2 = 16'b1100_1100_0011_1001; 

  //    assign sin_data2 = 16'b0000_0000_0000_0000;     //0pi/512
  //    assign cos_data2 = 16'b0100_0000_0000_0000;     //0pi/512
   
 


 `ifdef MODIFYING_ADDER
    modifying_adder #(.bit_width(bit_width), .SIZE(SIZE)) MODIFYING_ADDER_BLOCK(
        .en_modify(en_modify),
    
        .xin1(Re_i1),
        .yin1(Im_i1),
	    .xin2(Re_temp1),
	    .yin2(Im_temp1),
        .xin3(Re_temp2),
	    .yin3(Im_temp2),
        .en(en),

        .xout1(Re_o1),
	    .yout1(Im_o1),
        .xout2(Re_o2),
        .yout2(Im_o2)
   );
   `else
    adder #(.bit_width(bit_width)) CLASS_ADDER_BLOCK(

        .xin1(Re_i1),
        .yin1(Im_i1),
	    .xin2(Re_temp1),
	    .yin2(Im_temp1),

        .en(en),

        .xout1(Re_o1),
	    .yout1(Im_o1),
        .xout2(Re_o2),
        .yout2(Im_o2)
   );
   `endif
       

        multiply #(.bit_width(bit_width)) MULTIPLY1(
                .sin_data(sin_data),
                .cos_data(cos_data),
                .xin(Re_i2),
                .yin(Im_i2),

                .x_out(Re_temp1),
                .y_out(Im_temp1)
        );

    `ifdef Additional_Multiplier
       multiply #(.bit_width(bit_width)) MULTIPLY2(
            .sin_data(sin_data2),
            .cos_data(cos_data2),
            .xin(Re_temp1),
            .yin(Im_temp1),

            .x_out(Re_temp2),
            .y_out(Im_temp2)
       );
    `endif 


endmodule