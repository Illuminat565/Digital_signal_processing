module  adder
	#(parameter bit_width=16) (
    
    input   signed [bit_width-1:0] xin1,
    input   signed [bit_width-1:0] yin1,
	input   signed [bit_width-1:0] xin2,
	input   signed [bit_width-1:0] yin2,

    input   en,
    input   delay,

    output  signed [bit_width-1:0]  xout1,
	output  signed [bit_width-1:0]  yout1,
    output  signed [bit_width-1:0]  xout2,
	output  signed [bit_width-1:0]  yout2
    
   );
   
  assign xout1 = (en || delay)?  xin1 + xin2 : xout1;
  assign yout1 = (en || delay)?  yin1 + yin2 : yout1;

  
  assign xout2 =  (en || delay)? xin1-xin2 : xout2 ;
  assign yout2 =  (en || delay)? yin1-yin2 : yout2 ; 

endmodule