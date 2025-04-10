module p2d
#(
  parameter WIDTH = 16
)
(
  input  wire [WIDTH-1:0] x,
  output wire [WIDTH-1:0] y
);
  assign y =x[WIDTH-1]? {x[WIDTH-1],(~x[WIDTH-2:0]) + 1}: x;
endmodule


module d2p
#(
  parameter WIDTH = 16
)
(
  input  wire [WIDTH-1:0] x,
  output wire [WIDTH-1:0] y
);
  assign y =x[WIDTH-1]? {x[WIDTH-1],~(x[WIDTH-2:0]-1)}: x;
endmodule

module mult #(
	parameter Q = 9,
	parameter N = 16
	)
	(
	 input			[N-1:0]	mul1,
	 input			[N-1:0]	mul2,
	 output			[N-1:0]	result
	 );
	 
	reg [2*N-1:0]	r_result;											
	reg [N-1:0]		RetVal;
	wire [N-1:0] a,b;
	
	d2p d2p1 (.x(mul1), .y(a));
	d2p d2p2 (.x(mul2), .y(b));
	p2d p2d1 (.x(RetVal), .y(result));
	
	always @(a, b)	
	begin						
		 r_result = a[N-2:0] * b[N-2:0];	 
		 RetVal[N-1] = a[N-1] ^ b[N-1];	
		 RetVal[N-2:0] = r_result[N-2+Q:Q];	
    	end
endmodule	

module mult_tb;
	reg [15:0] a,b;
	wire [15:0] res;
	mult m1(.mul1(a), .mul2(b), .result(res));
initial begin
	a = 16'b0000010100000000; //2,5
	b = 16'b0000110010000000; //6,25 
	#10;
	a = 16'b0000010100000000; //2,5
	b = 16'b1111111000000000; //-0,999 
	#10;
end
endmodule