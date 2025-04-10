

module RADIX
	#(parameter bit_width=16, word_length_tw = 8)
    (
 
 
    input       signed [word_length_tw-1: 0]  sin_data,
    input       signed [word_length_tw-1: 0]  cos_data,


	input       signed [bit_width-1:0]  Re_i1,
	input       signed [bit_width-1:0]  Im_i1,
    input       signed [bit_width-1:0]  Re_i2,
	input       signed [bit_width-1:0]  Im_i2,
    input                               en,

	output      signed [bit_width-1:0]  Re_o1,
	output      signed [bit_width-1:0]  Im_o1,
    output      signed [bit_width-1:0]  Re_o2,
	output      signed [bit_width-1:0]  Im_o2,
    output                              out_valid
   );

    wire signed [bit_width + word_length_tw:0] Re_temp2, Im_temp2;

    multiply #(.bit_width(bit_width), 
               .word_length_tw(word_length_tw))
    multiply_inst (
            .sin_data(sin_data),
            .cos_data(cos_data),          
            .Re_i(Re_i2),
            .Im_i(Im_i2),

            .Re_o(Re_temp2),
            .Im_o(Im_temp2)
       ); 
//--------------------------------------------------------------------


adder #(.bit_width(bit_width),
        .word_length_tw(word_length_tw)) 
adder_inst(
    .en(en),
    .Re_i1(Re_i1),
    .Im_i1(Im_i1),
	.Re_i2(Re_temp2[bit_width-1:0]),
	.Im_i2(Im_temp2[bit_width-1:0]),

    .Re_o1(Re_o1),
	.Im_o1(Im_o1),
    .Re_o2(Re_o2),
	.Im_o2(Im_o2),
    .out_valid(out_valid)
   ); 

endmodule
