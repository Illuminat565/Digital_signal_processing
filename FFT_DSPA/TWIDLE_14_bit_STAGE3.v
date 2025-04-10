module  TWIDLE_14_bit_STAGE3  (
    input   [1:0]     rd_ptr_angle,
    output  signed [13:0]   cos_data,
    output  signed [13:0]   sin_data
 );

reg signed [13:0]  cos  [3:0];
reg signed [13:0]  sin  [3:0];

assign       cos_data =    cos [rd_ptr_angle];
assign       sin_data =    sin [rd_ptr_angle];

initial begin

   sin[0]  =  14'b00000000000000;     //0pi/8
   cos[0]  =  14'b01000000000000;     //0pi/8

   sin[1]  =  14'b00010011110001;     //0.1pi/8
   cos[1]  =  14'b00111100110111;     //0.1pi/8

   sin[2]  =  14'b00001010000000;     //0.05pi/8
   cos[2]  =  14'b00111111001101;     //0.05pi/8

   sin[3]  =  14'b00011101000011;     //0.15pi/8
   cos[3]  =  14'b00111001000001;     //0.15pi/8



end


endmodule