
module modifying_adder
	#(parameter bit_width=16, SIZE = 4)(
    input   en_modify,
    
    input   signed [bit_width-1:0] xin1,
    input   signed [bit_width-1:0] yin1,
	input   signed [bit_width-1:0] xin2,
	input   signed [bit_width-1:0] yin2,
    input   signed [bit_width-1:0] xin3,
	input   signed [bit_width-1:0] yin3,
    input   en,

    output reg signed [bit_width-1:0]  xout1,
	output reg signed [bit_width-1:0]  yout1,
    output reg signed [bit_width-1:0]  xout2,
	output reg signed [bit_width-1:0]  yout2
    
   );  

   always @(*) begin
     begin
        if (en) begin
            xout1 = xin1 + xin2 ;
            yout1 = yin1 + yin2 ;
            if (en_modify) begin
                xout2 =  xin1 + xin3;
                yout2 =  yin1 + yin3; 
            end  else begin
                xout2 = xin1 - xin2 ;
                yout2 = yin1 - yin2 ;
            end
        end else begin
            xout1 = xout1;
            xout1 = xout1;
            xout2 = xout2;
            yout2 = yout2;
        end
    end
   end
   
 // assign xout1 = en ?  xin1 + xin2 : xout1;
 // assign yout1 = en ?  yin1 + yin2 : yout1;
 // assign xout2 = (stage_FFT == SIZE && en)? xin1 + xin3  : en?  xin1-xin2  :xout2;
 // assign yout2 = (stage_FFT == SIZE && en)? yin1 + yin3  : en?  yin1-yin2  :yout2;
  
//  assign xout2 = (en_modify && en)? xin1 + xin3  : en ? xin1-xin2 : xout2 ;
//  assign yout2 = (en_modify && en)? yin1 + yin3  : en ? yin1-yin2 : yout2 ; 

 // assign xout2 =  en ? ((stage_FFT == SIZE )? xin1 + xin3 : xin1-xin2) : xout2 ;
 // assign yout2 =  en ? ((stage_FFT == SIZE )? yin1 + yin3 : yin1-yin2) : yout2 ; 

endmodule