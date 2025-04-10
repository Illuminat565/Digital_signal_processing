
module  TWIDLE_14_bit_STAGE2  #(parameter N = 256, SIZE = 8, bit_width_tw = 14) (
    input                               clk,
    input          [SIZE        -4:0]   rd_ptr_angle,
    input                               en, 

    output  reg signed [bit_width_tw-1:0]   cos_data,
    output  reg signed [bit_width_tw-1:0]   sin_data
 );

reg signed [bit_width_tw-1:0]  cos  [N/8-1:0];
reg signed [bit_width_tw-1:0]  sin  [N/8-1:0];

//localparam  coefficient =  $clog2(256/N);

//wire [6:0] rd_ptr = rd_ptr_angle << coefficient;

always @(posedge clk) begin
  if (en) begin
    cos_data <= cos [rd_ptr_angle];
    sin_data <= sin [rd_ptr_angle];
  end
end


initial begin
   sin[0]  =  14'b00000000000000;     //0pi/16
   cos[0]  =  14'b01000000000000;     //0pi/16
   sin[1]  =  14'b11000000000000;     //8pi/16
   cos[1]  =  14'b00000000000000;     //8pi/16
end

endmodule