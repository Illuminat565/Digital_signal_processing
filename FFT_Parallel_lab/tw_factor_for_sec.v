module  tw_factor_for_sec #(parameter stage_FFT = 2, SIZE =10, word_length_tw = 14) (
    input            clk,
    input            en_rd, 
    input   [stage_FFT-2:0]   rd_ptr_angle,

    output reg  signed [word_length_tw-1:0]   cos_data,
    output reg  signed [word_length_tw-1:0]   sin_data
 );


reg signed [word_length_tw-1:0]  cos  [1:0];
reg signed [word_length_tw-1:0]  sin  [1:0];


//--------------------------------handle read tw factor------------------------------
     always @(posedge clk) begin 
             if (en_rd  ) begin
                  cos_data           <= cos   [rd_ptr_angle];
                  sin_data           <= sin   [rd_ptr_angle];
             end 
        end

//--------------------------------handle read tw factor------------------------------

initial begin
   sin[0]  =  14'b00000000000000;     //0pi/256
   cos[0]  =  14'b01000000000000;     //0pi/256
   sin[1]  =  14'b11000000000000;     //128pi/256
   cos[1]  =  14'b00000000000000;     //128pi/256
end
endmodule