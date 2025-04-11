
module MODIFY_RADIX2
	#(parameter bit_width=16, word_length_tw = 8)
    (
    input                                          clk,
    input                                          rst_n,
 
    input                                          en_modify,
 
    input       signed [word_length_tw-1: 0]  sin_data,
    input       signed [word_length_tw-1: 0]  cos_data,

    input       signed [word_length_tw-1: 0]  sin_data2,
    input       signed [word_length_tw-1: 0]  cos_data2,
    
    input       signed [word_length_tw-1: 0]  sin_data3,
    input       signed [word_length_tw-1: 0]  cos_data3,


	input       signed [bit_width-1:0]  Re_i1,
	input       signed [bit_width-1:0]  Im_i1,
    input       signed [bit_width-1:0]  Re_i2,
	input       signed [bit_width-1:0]  Im_i2,
    input                               en,

	output  reg signed [bit_width-1:0]  Re_o1,
	output  reg  signed [bit_width-1:0]  Im_o1,
    output  reg signed [bit_width-1:0]  Re_o2,
	output  reg signed [bit_width-1:0]  Im_o2,
    output  reg                         out_valid 
   );

    wire signed [bit_width-1: 0] Re_temp1, Im_temp1;
    wire signed [bit_width-1: 0] Re_temp2, Im_temp2;
    
    wire signed [bit_width-1: 0] Re_temp3, Im_temp3; 
    wire signed [bit_width-1: 0] Re_temp4, Im_temp4;   

    wire valid_input;


    sub_M_RADIX2 #( .bit_width(bit_width), .word_length_tw(word_length_tw)) 
    modify_radix2_inst (
        .clk(clk),
        .rst_n(rst_n),

        .sin_data(sin_data2),
        .cos_data(cos_data2),
        .sin_data2(sin_data3),
        .cos_data2(cos_data3),

        .Re_i1(Re_i1),
        .Im_i1(Im_i1),
        .Re_i2(Re_i2),
        .Im_i2(Im_i2),

        .Re_o1(Re_temp1),
        .Im_o1(Im_temp1),
        .Re_o2(Re_temp2),
        .Im_o2(Im_temp2)
    );

        RADIX2 #( .bit_width(bit_width), .word_length_tw(word_length_tw)) 
        radix2_inst (
        .clk(clk),
        .rst_n(rst_n),
        
        .sin_data(sin_data),
        .cos_data(cos_data),

        .Re_i1(Re_i1),
        .Im_i1(Im_i1),
        .Re_i2(Re_i2),
        .Im_i2(Im_i2),

        .Re_o1(Re_temp3),
        .Im_o1(Im_temp3),
        .Re_o2(Re_temp4),
        .Im_o2(Im_temp4)
    );
    
   always @(*) begin
     begin
        if (en) begin 
           if(en_modify) begin
            	Re_o1 = Re_temp1;
                Im_o1 = Im_temp1;
                Re_o2 = Re_temp2;
                Im_o2 = Im_temp2;
           end else begin
                Re_o1 = Re_temp3;
                Im_o1 = Im_temp3;
                Re_o2 = Re_temp4;
                Im_o2 = Im_temp4;
           end
           out_valid =1'b1;
        end  else out_valid =1'b0;
    end
   end  

  endmodule