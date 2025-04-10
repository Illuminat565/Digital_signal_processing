module  tw_factor_for_3th #(parameter stage_FFT = 2, SIZE =10, word_length_tw = 14) (
    input            clk,
    input            en_rd, 
    input   [stage_FFT-2:0]   rd_ptr_angle,

    output reg  signed [word_length_tw-1:0]   cos_data,
    output reg  signed [word_length_tw-1:0]   sin_data
 );

reg signed [word_length_tw-1:0]  cos  [3:0];
reg signed [word_length_tw-1:0]  sin  [3:0];


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
   sin[1]  =  14'b11010010110000;     //64pi/256
   cos[1]  =  14'b00101101010000;     //64pi/256
   sin[2]  =  14'b11000000000000;     //128pi/256
   cos[2]  =  14'b00000000000000;     //128pi/256
   sin[3]  =  14'b11010010110000;     //192pi/256
   cos[3]  =  14'b11010010110000;     //192pi/256
end
endmodule