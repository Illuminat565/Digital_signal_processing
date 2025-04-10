module tw_factor_generator
       #(parameter SIZE = 10, 
                   stage_FFT = 2,
                   word_length_tw = 8, 
                   stagger = 20) 
(
        input                       clk,
        input                       en_rd, 
        input  [stage_FFT-2:     0] rd_ptr_angle,

        output [word_length_tw-1:0] cos_data,
        output [word_length_tw-1:0] sin_data
);

generate
    if (stage_FFT == SIZE) begin
    if ( stagger == 0) begin

        TWIDLE_14_bit #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        TWIDLE_14_bit_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    end
    else if ( stagger == 5) begin

        M_TWIDLE_0_05_v #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        M_TWIDLE_0_05_v_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if ( stagger == 10) begin

        M_TWIDLE_0_10_v #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        M_TWIDLE_0_10_v_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if ( stagger == 15) begin

        M_TWIDLE_0_15_v #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        M_TWIDLE_0_15_v_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if ( stagger == 20) begin

        M_TWIDLE_14_bit #(.stage_FFT(stage_FFT), .SIZE(SIZE),.word_length_tw(word_length_tw))
        M_TWIDLE_14_bit_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if ( stagger == 25) begin

        M_TWIDLE_0_25_v #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        M_TWIDLE_0_25_v_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
        
    end 
    else if (stage_FFT == 2) begin

        tw_factor_for_sec #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_sec_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );

    end
    else if (stage_FFT == 3) begin

        tw_factor_for_3th #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_3th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle), 

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (stage_FFT == 4) begin

        tw_factor_for_4th #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_4th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (stage_FFT == 5) begin

        tw_factor_for_5th #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_5th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (stage_FFT == 6) begin

        tw_factor_for_6th #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_6th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (stage_FFT == 7) begin

        tw_factor_for_7th #(.stage_FFT(stage_FFT), .SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_7th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (stage_FFT == 8) begin

        tw_factor_for_8th #(.stage_FFT(stage_FFT), .SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_8th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
    else if (stage_FFT == 9) begin

        tw_factor_for_9th #( .stage_FFT(stage_FFT),.SIZE(SIZE),.word_length_tw(word_length_tw))
        tw_factor_for_9th_ins(
        .clk(clk),
        .en_rd(en_rd), 
        .rd_ptr_angle(rd_ptr_angle),
         

        .cos_data(cos_data),
        .sin_data(sin_data)
    );
    
    end
   
endgenerate

endmodule