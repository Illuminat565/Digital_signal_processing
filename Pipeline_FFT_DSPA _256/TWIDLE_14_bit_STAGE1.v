module  TWIDLE_14_bit_STAGE1  #(parameter N = 256, SIZE = 8, bit_width_tw = 14) (
    input                               clk,
    input                               en, 

    output reg signed [bit_width_tw-1:0]   cos_data,
    output reg signed [bit_width_tw-1:0]   sin_data
 );


//localparam  coefficient =  $clog2(256/N);

//wire [6:0] rd_ptr = rd_ptr_angle << coefficient;

always @(posedge clk) begin
  if (en) begin
    cos_data <=  14'b01000000000000;     //0pi/256
    sin_data <=  14'b00000000000000;     //0pi/256
  end
end

endmodule