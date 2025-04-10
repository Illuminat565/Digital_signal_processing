       module multiply #(parameter bit_width=32) (
            input   signed [15:0]  sin_data,
            input   signed [15:0]  cos_data,
            input   signed [bit_width-1:0] xin,
            input   signed [bit_width-1:0] yin,

            output  signed [bit_width-1:0] x_out,
            output  signed [bit_width-1:0] y_out
       );

        assign x_out  = (xin*cos_data - yin*sin_data)>>>14 ;
        assign y_out  = (yin*cos_data + xin*sin_data)>>>14 ;
       
       endmodule
