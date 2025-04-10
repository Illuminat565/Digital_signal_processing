
module  TWIDLE_14_bit_STAGE4  #(parameter N = 256, SIZE = 8, bit_width_tw = 14) (
    input                               clk,
    input          [SIZE        -2:0]   rd_ptr_angle,
    input                               en, 

    output reg signed [bit_width_tw-1:0]   cos_data,
    output reg signed [bit_width_tw-1:0]   sin_data
 );

reg signed [bit_width_tw-1:0]  cos  [N/2-1:0];
reg signed [bit_width_tw-1:0]  sin  [N/2-1:0];

//localparam  coefficient =  $clog2(256/N);

//wire [6:0] rd_ptr = rd_ptr_angle << coefficient;

always @(posedge clk) begin
  if (en) begin
    cos_data <= cos [rd_ptr_angle];
    sin_data <= sin [rd_ptr_angle];
  end
end


initial begin
   sin[0]  =  14'b00000000000000;     //0pi/8
   cos[0]  =  14'b01000000000000;     //0pi/8
   sin[1]  =  14'b11101100001110;     //1pi/8
   cos[1]  =  14'b00111100110111;     //1pi/8
   sin[2]  =  14'b11011010011000;     //2pi/8
   cos[2]  =  14'b00110011110001;     //2pi/8
   sin[3]  =  14'b11001100001110;     //3pi/8
   cos[3]  =  14'b00100101100111;     //3pi/8
   sin[4]  =  14'b11000011001000;     //4pi/8
   cos[4]  =  14'b00010011110001;     //4pi/8
   sin[5]  =  14'b11000000000000;     //5pi/8
   cos[5]  =  14'b00000000000000;     //5pi/8
   sin[6]  =  14'b11000011001000;     //6pi/8
   cos[6]  =  14'b11101100001110;     //6pi/8
   sin[7]  =  14'b11001100001110;     //7pi/8
   cos[7]  =  14'b11011010011000;     //7pi/8
end

endmodule