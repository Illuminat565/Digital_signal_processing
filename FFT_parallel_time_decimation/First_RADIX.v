module First_RADIX
	#(parameter bit_width=16)
    (

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

   always @(*) begin
     begin
        if (en) begin

                Re_o1     = Re_i1 + Re_i2;
                Im_o1     = Im_i1 + Im_i2;

                Re_o2   =  Re_i1 - Re_i2;
                Im_o2   =  Im_i1 - Im_i2;
                
                out_valid = 1;
        end else out_valid =0 ;
    end
   end  

endmodule
