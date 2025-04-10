

module RADIX
	#(parameter bit_width=16, bit_width_tw_factor = 8)
    (
 
    input       signed [bit_width_tw_factor-1: 0]  sin_data,
    input       signed [bit_width_tw_factor-1: 0]  cos_data,

	input       signed [bit_width-1:0]  Re_i1,
	input       signed [bit_width-1:0]  Im_i1,
    input       signed [bit_width-1:0]  Re_i2,
	input       signed [bit_width-1:0]  Im_i2,
    input                               en,

	output  reg signed [bit_width-1:0]  Re_o1,
	output  reg signed [bit_width-1:0]  Im_o1,
    output  reg signed [bit_width-1:0]  Re_o2,
	output  reg signed [bit_width-1:0]  Im_o2,
    output  reg                         out_valid
   );

    reg signed [bit_width + bit_width_tw_factor:0] Re_temp1, Im_temp1;


   always @(*) begin
     begin
        if (en) begin
                Re_temp1  = (Re_i2*cos_data  - Im_i2*sin_data)>>>(bit_width_tw_factor-2);
                Im_temp1  = (Im_i2*cos_data  + Re_i2*sin_data)>>>(bit_width_tw_factor-2);

                Re_o1     = Re_i1 + Re_temp1[bit_width-1:0];
                Im_o1     = Im_i1 + Im_temp1[bit_width-1:0];

                Re_o2   =  Re_i1 - Re_temp1[bit_width-1:0];
                Im_o2   =  Im_i1 - Im_temp1[bit_width-1:0];
                
                out_valid = 1;
        end else out_valid =0 ;
    end
   end  

endmodule
