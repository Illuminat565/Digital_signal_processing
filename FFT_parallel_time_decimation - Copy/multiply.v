       module multiply #(parameter bit_width=32, bit_width_tw_factor = 16) (
            input                          clk,
            input   signed [bit_width_tw_factor-1:0]          sin_data,
            input   signed [bit_width_tw_factor-1:0]          cos_data,          
            input   signed [bit_width-1:0] xin,
            input   signed [bit_width-1:0] yin,

            output  signed [bit_width-1:0] x_out,
            output  signed [bit_width-1:0] y_out
       );
            reg signed [bit_width + bit_width_tw_factor:0] Re_temp, Im_temp;
            reg out_valid_temp;
            
            assign   x_out     = Re_temp[bit_width-1:0];
            assign   y_out     = Im_temp[bit_width-1:0];

        always @(posedge clk ) begin
           begin
              Re_temp   <= (xin*cos_data - yin*sin_data)>>>(bit_width_tw_factor-2);
              Im_temp   <= (yin*cos_data + xin*sin_data)>>>(bit_width_tw_factor-2);
          end
        end

       endmodule
