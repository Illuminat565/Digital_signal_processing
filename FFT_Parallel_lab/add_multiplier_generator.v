module add_multiplier_generator #(parameter word_length_tw = 8, STAGGER = 20) (
    output  [word_length_tw-1:0] sin_data2,
    output  [word_length_tw-1:0] cos_data2
);

generate
   
    if (word_length_tw == 14 && STAGGER == 5) begin
        
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
    else if (word_length_tw == 14  && STAGGER == 20) begin
        
       assign  sin_data2  =  14'b11011010011000;
       assign  cos_data2  =  14'b11001100001110; 
        
    end
    else if (word_length_tw == 14  && STAGGER == 25) begin
        
       assign  sin_data2  =  14'b11010010110000;
       assign  cos_data2  =  14'b11010010110000;
        
    end
endgenerate

endmodule