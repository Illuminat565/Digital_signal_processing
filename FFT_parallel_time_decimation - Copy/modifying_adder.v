
module modifying_adder
	#(parameter bit_width=16)(
    input   clk,
    input   en_modify,
    input   signed [bit_width-1:0] xin1,
    input   signed [bit_width-1:0] yin1,
	input   signed [bit_width-1:0] xin2,
	input   signed [bit_width-1:0] yin2,
    input   signed [bit_width-1:0] xin3,
	input   signed [bit_width-1:0] yin3,

    output reg signed [bit_width-1:0]  xout1,
	output reg signed [bit_width-1:0]  yout1,
    output reg signed [bit_width-1:0]  xout2,
	output reg signed [bit_width-1:0]  yout2

   );    


   always @(posedge clk) begin
     begin
         begin
                xout1      <= xin1 + xin3 ;
                yout1      <= yin1 + yin3 ;

            if (en_modify) begin
                xout2      <= xin1 + xin2;
                yout2      <= yin1 + yin2; 
            end  else begin
                xout2      <= xin1 - xin3 ;
                yout2      <= yin1 - yin3 ;
            end
        end 
    end
   end
   


endmodule