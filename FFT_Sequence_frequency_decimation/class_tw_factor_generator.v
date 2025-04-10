module class_tw_factor_generator #(parameter word_length_tw = 8) (
        input                       clk,
        input                       en_rd, 
        input  [10:              0] rd_ptr_angle,

        output [word_length_tw-1:0] cos_data,
        output [word_length_tw-1:0] sin_data
);

generate
    if (word_length_tw == 6) begin

        TWIDLE_6_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_6_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );

    end
    else if (word_length_tw == 7) begin

        TWIDLE_7_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_7_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 8) begin

        TWIDLE_8_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_8_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 9) begin

        TWIDLE_9_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_9_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 10) begin

        TWIDLE_10_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_10_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 11) begin

        TWIDLE_11_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_11_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 12) begin

        TWIDLE_12_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_12_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 13) begin

        TWIDLE_13_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_13_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 14) begin

        TWIDLE_14_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_14_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 15) begin

        TWIDLE_15_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_15_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (word_length_tw == 16) begin

        TWIDLE_16_bit #( .SIZE(10),.word_length_tw(word_length_tw))
        TWIDLE_16_bit(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
        

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end

endgenerate

endmodule