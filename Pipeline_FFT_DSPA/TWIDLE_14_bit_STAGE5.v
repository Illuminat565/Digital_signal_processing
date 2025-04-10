module  TWIDLE_14_bit_STAGE5  #(parameter N = 256, SIZE = 8, bit_width_tw = 14) (
    input                               clk,
    input          [SIZE        -6:0]   rd_ptr_angle,
    input                               en, 

    output reg signed [bit_width_tw-1:0]   cos_data,
    output reg signed [bit_width_tw-1:0]   sin_data
 );

reg signed [bit_width_tw-1:0]  cos  [N/32-1:0];
reg signed [bit_width_tw-1:0]  sin  [N/32-1:0];

localparam  coefficient =  $clog2(256/N);

wire [6:0] rd_ptr = rd_ptr_angle << coefficient;

always @(posedge clk) begin
  if (en) begin
    cos_data <= cos [rd_ptr];
    sin_data <= sin [rd_ptr];
  end
end


initial begin
   sin[0]  =  14'b00000000000000;     //0pi/256
   cos[0]  =  14'b01000000000000;     //0pi/256
   sin[1]  =  14'b11100111100001;     //32pi/256
   cos[1]  =  14'b00111011001000;     //32pi/256
   sin[2]  =  14'b11010010110000;     //64pi/256
   cos[2]  =  14'b00101101010000;     //64pi/256
   sin[3]  =  14'b11000100111000;     //96pi/256
   cos[3]  =  14'b00011000011111;     //96pi/256
   sin[4]  =  14'b11000000000000;     //128pi/256
   cos[4]  =  14'b00000000000000;     //128pi/256
   sin[5]  =  14'b11000100111000;     //160pi/256
   cos[5]  =  14'b11100111100001;     //160pi/256
   sin[6]  =  14'b11010010110000;     //192pi/256
   cos[6]  =  14'b11010010110000;     //192pi/256
   sin[7]  =  14'b11100111100001;     //224pi/256
   cos[7]  =  14'b11000100111000;     //224pi/256
end
endmodule