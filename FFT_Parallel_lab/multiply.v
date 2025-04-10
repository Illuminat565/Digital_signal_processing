       module multiply #(parameter bit_width=32, word_length_tw = 16) (
            input   signed [word_length_tw-1:0]          sin_data,
            input   signed [word_length_tw-1:0]          cos_data,          
            input   signed [bit_width-1     :0]          Re_i,
            input   signed [bit_width-1     :0]          Im_i,

            output  reg signed [bit_width + word_length_tw:0] Re_o,
            output  reg signed [bit_width + word_length_tw:0] Im_o
       );

        always @(*) begin
           begin
              Re_o   <= (Re_i*cos_data - Im_i*sin_data)>>>(word_length_tw-2);
              Im_o   <= (Im_i*cos_data + Re_i*sin_data)>>>(word_length_tw-2);
          end
        end

       endmodule
