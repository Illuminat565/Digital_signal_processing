module  TWIDLE_14_bit_STAGE2  (
    input   [1:0]   rd_ptr_angle,

    output  signed [13:0]   cos_data,
    output  signed [13:0]   sin_data
 );

wire signed [13:0]  cos  [1:0];
wire signed [13:0]  sin  [1:0];

assign cos_data =    cos [rd_ptr_angle];
assign sin_data =    sin [rd_ptr_angle];

  assign sin[0]  =  14'b00000000000000;     //0pi/8
  assign cos[0]  =  14'b01000000000000;     //0pi/8
  assign sin[1]  =  14'b11000000000000;     //4pi/8
  assign cos[1]  =  14'b00000000000000;     //4pi/8

endmodule