module add_multiplier_generator #(parameter word_length_tw = 8, STAGGER = 20) (
    output  [word_length_tw-1:0] sin_data2,
    output  [word_length_tw-1:0] cos_data2
);

generate
if (word_length_tw == 6 && STAGGER == 5) begin
    assign  sin_data2  =  6'b111101;
    assign  cos_data2  =  6'b110000;
end
else if (word_length_tw == 6 && STAGGER == 10) begin
    assign  sin_data2  =  6'b111011;
    assign  cos_data2  =  6'b110001;
end
else if (word_length_tw == 6 && STAGGER == 15) begin
    assign  sin_data2  =  6'b111001;
    assign  cos_data2  =  6'b110010;
end
else if (word_length_tw == 6 && STAGGER == 20) begin
    assign  sin_data2  =  6'b110111;
    assign  cos_data2  =  6'b110011;
end
else if (word_length_tw == 6 && STAGGER == 25) begin
    assign  sin_data2  =  6'b110101;
    assign  cos_data2  =  6'b110101;
end
else if (word_length_tw == 7 && STAGGER == 5) begin
    assign  sin_data2  =  7'b1111011;
    assign  cos_data2  =  7'b1100000;
end
else if (word_length_tw == 7 && STAGGER == 10) begin
    assign  sin_data2  =  7'b1110110;
    assign  cos_data2  =  7'b1100010;
end
else if (word_length_tw == 7 && STAGGER == 15) begin
    assign  sin_data2  =  7'b1110001;
    assign  cos_data2  =  7'b1100011;
end
else if (word_length_tw == 7 && STAGGER == 20) begin
    assign  sin_data2  =  7'b1101101;
    assign  cos_data2  =  7'b1100110;
end
else if (word_length_tw == 7 && STAGGER == 25) begin
    assign  sin_data2  =  7'b1101001;
    assign  cos_data2  =  7'b1101001;
end
else if (word_length_tw == 8 && STAGGER == 5) begin
    assign  sin_data2  =  8'b11110110;
    assign  cos_data2  =  8'b11000001;
end
else if (word_length_tw == 8 && STAGGER == 10) begin
    assign  sin_data2  =  8'b11101100;
    assign  cos_data2  =  8'b11000011;
end
else if (word_length_tw == 8 && STAGGER == 15) begin
    assign  sin_data2  =  8'b11100011;
    assign  cos_data2  =  8'b11000111;
end
else if (word_length_tw == 8 && STAGGER == 20) begin
    assign  sin_data2  =  8'b11011010;
    assign  cos_data2  =  8'b11001100;
end
else if (word_length_tw == 8 && STAGGER == 25) begin
    assign  sin_data2  =  8'b11010011;
    assign  cos_data2  =  8'b11010011;
end
else if (word_length_tw == 9 && STAGGER == 5) begin
    assign  sin_data2  =  9'b111101100;
    assign  cos_data2  =  9'b110000010;
end
else if (word_length_tw == 9 && STAGGER == 10) begin
    assign  sin_data2  =  9'b111011000;
    assign  cos_data2  =  9'b110000110;
end
else if (word_length_tw == 9 && STAGGER == 15) begin
    assign  sin_data2  =  9'b111000110;
    assign  cos_data2  =  9'b110001110;
end
else if (word_length_tw == 9 && STAGGER == 20) begin
    assign  sin_data2  =  9'b110110101;
    assign  cos_data2  =  9'b110011000;
end
else if (word_length_tw == 9 && STAGGER == 25) begin
    assign  sin_data2  =  9'b110100101;
    assign  cos_data2  =  9'b110100101;
end
else if (word_length_tw == 10 && STAGGER == 5) begin
    assign  sin_data2  =  10'b1111011000;
    assign  cos_data2  =  10'b1100000011;
end
else if (word_length_tw == 10 && STAGGER == 10) begin
    assign  sin_data2  =  10'b1110110001;
    assign  cos_data2  =  10'b1100001101;
end
else if (word_length_tw == 10 && STAGGER == 15) begin
    assign  sin_data2  =  10'b1110001100;
    assign  cos_data2  =  10'b1100011100;
end
else if (word_length_tw == 10 && STAGGER == 20) begin
    assign  sin_data2  =  10'b1101101010;
    assign  cos_data2  =  10'b1100110001;
end
else if (word_length_tw == 10 && STAGGER == 25) begin
    assign  sin_data2  =  10'b1101001011;
    assign  cos_data2  =  10'b1101001011;
end
else if (word_length_tw == 11 && STAGGER == 5) begin
    assign  sin_data2  =  11'b11110110000;
    assign  cos_data2  =  11'b11000000110;
end
else if (word_length_tw == 11 && STAGGER == 10) begin
    assign  sin_data2  =  11'b11101100010;
    assign  cos_data2  =  11'b11000011001;
end
else if (word_length_tw == 11 && STAGGER == 15) begin
    assign  sin_data2  =  11'b11100011000;
    assign  cos_data2  =  11'b11000111000;
end
else if (word_length_tw == 11 && STAGGER == 20) begin
    assign  sin_data2  =  11'b11011010011;
    assign  cos_data2  =  11'b11001100010;
end
else if (word_length_tw == 11 && STAGGER == 25) begin
    assign  sin_data2  =  11'b11010010110;
    assign  cos_data2  =  11'b11010010110;
end
else if (word_length_tw == 12 && STAGGER == 5) begin
    assign  sin_data2  =  12'b111101100000;
    assign  cos_data2  =  12'b110000001101;
end
else if (word_length_tw == 12 && STAGGER == 10) begin
    assign  sin_data2  =  12'b111011000100;
    assign  cos_data2  =  12'b110000110010;
end
else if (word_length_tw == 12 && STAGGER == 15) begin
    assign  sin_data2  =  12'b111000101111;
    assign  cos_data2  =  12'b110001110000;
end
else if (word_length_tw == 12 && STAGGER == 20) begin
    assign  sin_data2  =  12'b110110100110;
    assign  cos_data2  =  12'b110011000100;
end
else if (word_length_tw == 12 && STAGGER == 25) begin
    assign  sin_data2  =  12'b110100101100;
    assign  cos_data2  =  12'b110100101100;
end
else if (word_length_tw == 13 && STAGGER == 5) begin
    assign  sin_data2  =  13'b1111011000000;
    assign  cos_data2  =  13'b1100000011001;
end
else if (word_length_tw == 13 && STAGGER == 10) begin
    assign  sin_data2  =  13'b1110110000111;
    assign  cos_data2  =  13'b1100001100100;
end
else if (word_length_tw == 13 && STAGGER == 15) begin
    assign  sin_data2  =  13'b1110001011110;
    assign  cos_data2  =  13'b1100011011111;
end
else if (word_length_tw == 13 && STAGGER == 20) begin
    assign  sin_data2  =  13'b1101101001100;
    assign  cos_data2  =  13'b1100110000111;
end
else if (word_length_tw == 13 && STAGGER == 25) begin
    assign  sin_data2  =  13'b1101001011000;
    assign  cos_data2  =  13'b1101001011000;
end
else if (word_length_tw == 14 && STAGGER == 5) begin
    assign  sin_data2  =  14'b11110101111111;
    assign  cos_data2  =  14'b11000000110010;
end
else if (word_length_tw == 14 && STAGGER == 10) begin
    assign  sin_data2  =  14'b11101100001110;
    assign  cos_data2  =  14'b11000011001000;
end
else if (word_length_tw == 14 && STAGGER == 15) begin
    assign  sin_data2  =  14'b11100010111100;
    assign  cos_data2  =  14'b11000110111110;
end
else if (word_length_tw == 14 && STAGGER == 20) begin
    assign  sin_data2  =  14'b11011010011000;
    assign  cos_data2  =  14'b11001100001110;
end
else if (word_length_tw == 14 && STAGGER == 25) begin
    assign  sin_data2  =  14'b11010010110000;
    assign  cos_data2  =  14'b11010010110000;
end
else if (word_length_tw == 15 && STAGGER == 5) begin
    assign  sin_data2  =  15'b111101011111110;
    assign  cos_data2  =  15'b110000001100101;
end
else if (word_length_tw == 15 && STAGGER == 10) begin
    assign  sin_data2  =  15'b111011000011101;
    assign  cos_data2  =  15'b110000110010001;
end
else if (word_length_tw == 15 && STAGGER == 15) begin
    assign  sin_data2  =  15'b111000101111001;
    assign  cos_data2  =  15'b110001101111101;
end
else if (word_length_tw == 15 && STAGGER == 20) begin
    assign  sin_data2  =  15'b110110100110001;
    assign  cos_data2  =  15'b110011000011101;
end
else if (word_length_tw == 15 && STAGGER == 25) begin
    assign  sin_data2  =  15'b110100101011111;
    assign  cos_data2  =  15'b110100101011111;
end
else if (word_length_tw == 16 && STAGGER == 5) begin
    assign  sin_data2  =  16'b1111010111111101;
    assign  cos_data2  =  16'b1100000011001010;
end
else if (word_length_tw == 16 && STAGGER == 10) begin
    assign  sin_data2  =  16'b1110110000111001;
    assign  cos_data2  =  16'b1100001100100010;
end
else if (word_length_tw == 16 && STAGGER == 15) begin
    assign  sin_data2  =  16'b1110001011110010;
    assign  cos_data2  =  16'b1100011011111010;
end
else if (word_length_tw == 16 && STAGGER == 20) begin
    assign  sin_data2  =  16'b1101101001100010;
    assign  cos_data2  =  16'b1100110000111001;
end
else if (word_length_tw == 16 && STAGGER == 25) begin
    assign  sin_data2  =  16'b1101001010111111;
    assign  cos_data2  =  16'b1101001010111111;
end

endgenerate

endmodule