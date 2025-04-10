
module  test_real  (

 );
real v,pi,xi;

localparam  N = 16,
            bit_length = 14;

reg signed [13:0]  cos [N-1:0];
reg signed [13:0]  sin [N-1:0];
integer  k;


initial begin
    v  = 0.2;
    pi = 3.14159265;
    
for (k = 0; k <= N-1 ; k = k+1 ) begin

    xi      =  -pi*(1-v)*k/N;  

    cos[k]  =  $rtoi($cos(xi)*$pow(2,bit_length-2)) ;

    sin[k]  =  $rtoi($sin(xi)*$pow(2,bit_length-2)) ;
    
end
    
end
endmodule


