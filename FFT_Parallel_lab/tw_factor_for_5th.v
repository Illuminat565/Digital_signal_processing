module  tw_factor_for_5th #(parameter stage_FFT = 2, SIZE =10, word_length_tw = 14) (
    input            clk,
    input            en_rd, 
    input   [stage_FFT-2:0]   rd_ptr_angle,

    output reg  signed [word_length_tw-1:0]   cos_data,
    output reg  signed [word_length_tw-1:0]   sin_data
 );

reg signed [word_length_tw-1:0]  cos  [15:0];
reg signed [word_length_tw-1:0]  sin  [15:0];


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
   sin[1]  =  14'b11110011100001;     //16pi/256
   cos[1]  =  14'b00111110110001;     //16pi/256
   sin[2]  =  14'b11100111100001;     //32pi/256
   cos[2]  =  14'b00111011001000;     //32pi/256
   sin[3]  =  14'b11011100011100;     //48pi/256
   cos[3]  =  14'b00110101001101;     //48pi/256
   sin[4]  =  14'b11010010110000;     //64pi/256
   cos[4]  =  14'b00101101010000;     //64pi/256
   sin[5]  =  14'b11001010110010;     //80pi/256
   cos[5]  =  14'b00100011100011;     //80pi/256
   sin[6]  =  14'b11000100111000;     //96pi/256
   cos[6]  =  14'b00011000011111;     //96pi/256
   sin[7]  =  14'b11000001001111;     //112pi/256
   cos[7]  =  14'b00001100011111;     //112pi/256
   sin[8]  =  14'b11000000000000;     //128pi/256
   cos[8]  =  14'b00000000000000;     //128pi/256
   sin[9]  =  14'b11000001001111;     //144pi/256
   cos[9]  =  14'b11110011100001;     //144pi/256
   sin[10]  =  14'b11000100111000;     //160pi/256
   cos[10]  =  14'b11100111100001;     //160pi/256
   sin[11]  =  14'b11001010110010;     //176pi/256
   cos[11]  =  14'b11011100011100;     //176pi/256
   sin[12]  =  14'b11010010110000;     //192pi/256
   cos[12]  =  14'b11010010110000;     //192pi/256
   sin[13]  =  14'b11011100011100;     //208pi/256
   cos[13]  =  14'b11001010110010;     //208pi/256
   sin[14]  =  14'b11100111100001;     //224pi/256
   cos[14]  =  14'b11000100111000;     //224pi/256
   sin[15]  =  14'b11110011100001;     //240pi/256
   cos[15]  =  14'b11000001001111;     //240pi/256
end
endmodule