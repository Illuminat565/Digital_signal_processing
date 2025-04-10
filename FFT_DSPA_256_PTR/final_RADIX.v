

module final_RADIX
	#(parameter bit_width            =  16,
                bit_width_tw_factor  =  16 )
    (
    input       signed [bit_width_tw_factor - 1:0] sin_data,
    input       signed [bit_width_tw_factor - 1:0] cos_data,

	input       signed [bit_width-1:0]  Re_i1,
	input       signed [bit_width-1:0]  Im_i1,
    input       signed [bit_width-1:0]  Re_i2,
	input       signed [bit_width-1:0]  Im_i2,
    input                               en,

	output  reg signed [bit_width-1:0]  Re_o1,
	output  reg signed [bit_width-1:0]  Im_o1,
    output  reg signed [bit_width-1:0]  Re_o2,
	output  reg signed [bit_width-1:0]  Im_o2 
   );

   always @(*) begin
     begin
        if (en) begin
            Re_o1  = Re_i1 + Re_i2 ;
            Im_o1  = Im_i1 + Im_i2 ;

            Re_o2  =  Re_i1 - Re_i2;
            Im_o2  =  Im_i1 - Im_i2;  
        end 
    end
   end  
endmodule