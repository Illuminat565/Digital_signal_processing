
    module final_state 
       #(parameter 
    stage_FFT=2,
    word_length_tw = 14,                         // Length of twiddle factor (sin/cos values)
    stagger = 15,                                // Percentage of stagger 
    t_1_bit = 5207,                              // Bit time for UART communication
    bit_width = 24, N = 16, SIZE = 4)            // FFT parameters: data width, size, and address width
(
    input                            clk,        // Clock input
    input                            rst_n,      // Reset (active low)
    input                            start_flag, // Start flag for FFT
    input                            load_data,  // Data load flag
    input    signed  [bit_width-1:0] Re_i,       // Real input data for FFT
    input    signed  [bit_width-1:0] Im_i,       // Imaginary input data for FFT
    input            [SIZE-1     :0] invert_addr,// Address for memory inversion
  
    output   signed  [bit_width-1:0] Re_o,       // Real output data after FFT processing
    output   signed  [bit_width-1:0] Im_o,  
    output                           en_wr,    
    output           [SIZE-1:     0] wr_ptr,     // Imaginary output data after FFT processing
   
    output                           start_next_stage
    
);
    
    // Internal signals for storing temporary FFT data
    wire  signed [bit_width-1:0] Re_temp1, Im_temp1, Re_temp2, Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3, Im_temp3, Re_temp4, Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5, Im_temp5, Re_temp6, Im_temp6;

    wire  signed [bit_width-1:0] Re_o_temp, Im_o_temp;

    // Control signals for managing the data flow and processing stages
    wire en_o_temp, en_rd, en_add, en_modify;
    wire out_valid, in_demux_valid, en_mul;

    // Address pointers for memory read and write
    wire [stage_FFT-2:0] rd_ptr_angle;   // Angle address pointer for twiddle factors
    wire [SIZE-1:0] rd_ptr; // Read and write pointer signals

    // Output signals from the demultiplexer for splitting data streams
    wire signed [bit_width-1:0] Re_demul, Im_demul;

    // Twiddle factor data (sine and cosine values)
    wire signed [word_length_tw-1:0] sin_data2, cos_data2;
    wire signed [word_length_tw-1:0] sin_data_radix, cos_data_radix;
    wire signed [word_length_tw-1:0] sin_data, cos_data;


    //----------------------------------------------------------------------
    // Multiplier Generator Module: This module generates multiplier values
    // based on the sine and cosine twiddle factors, to be used in FFT calculation.
    add_multiplier_generator #(.word_length_tw(word_length_tw), .STAGGER(stagger)) multiplier_gen_inst (
        .sin_data2(sin_data2),
        .cos_data2(cos_data2)
    );

    //----------------------------------------------------------------------
    // Control Module: This module handles the control signals for FFT operation,
    // such as starting, enabling output, and managing read/write pointers.
    final_addres_generator #( 
    .stage_FFT(stage_FFT),
    .N(N),
    .SIZE(SIZE))
    final_addres_generator_ins(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_flag),
     
    .en_rd(en_rd),  
    .rd_ptr(rd_ptr),
    .rd_ptr_angle(rd_ptr_angle), 
    .start_next_stage(start_next_stage)
 );

    //----------------------------------------------------------------------
    // Shift Register Module: This module shifts the read pointer to the write
    // pointer in the FFT process for proper memory access.
    
    shift_register #(.width(SIZE), .depth(4)) shift_reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(rd_ptr),
        .out_data(wr_ptr)
    );  

    //----------------------------------------------------------------------
    // RAM Module: The memory block used to store FFT data, both input and 
    // intermediate results, as well as handle read/write operations during FFT.

    RAM #( .bit_width(bit_width), .N(N), .SIZE(SIZE)) ram_data_store (
        .clk(clk),
        .rst_n(rst_n),

        .en_wr(load_data),
        .wr_ptr(invert_addr),
        .Re_i(Re_i),
        .Im_i(Im_i),

        .rd_ptr(rd_ptr),
        .en_rd(en_rd),

        .Re_o(Re_o_temp),
        .Im_o(Im_o_temp),
        .o_valid(in_demux_valid)
    );

    //----------------------------------------------------------------------
    // Twiddle Factor Generator: This module generates sine and cosine values 
    // for the twiddle factors used in FFT calculations based on the angle.
    tw_factor_generator #(.SIZE(SIZE), 
                          .stage_FFT(stage_FFT), 
                          .word_length_tw(word_length_tw), 
                          .stagger(stagger)) 
    tw_factor_gen_inst (
        .clk(clk),
        .en_rd(en_rd),
        .rd_ptr_angle(rd_ptr_angle),
        .cos_data(cos_data),
        .sin_data(sin_data)
    );

    //----------------------------------------------------------------------
    // Demultiplexer Module: This module splits the input data into multiple
    // output streams to be processed in parallel during FFT.
    demultiplexor #(.bit_width(bit_width), .word_length_tw(word_length_tw)) demux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Re_i(Re_o_temp),
        .Im_i(Im_o_temp),
        .cos_data(cos_data),
        .sin_data(sin_data),
        .in_valid(in_demux_valid),
        .Re_o1(Re_temp2),
        .Im_o1(Im_temp2),
        .Re_o2(Re_temp4),
        .Im_o2(Im_temp4),
        .o_cos_data(cos_data_radix),
        .o_sin_data(sin_data_radix),
        .out_valid(en_add)
    );

    //----------------------------------------------------------------------
    // Radix Modification: This section modifies the FFT data in the case of
    // a radix-2 FFT 
    MODIFY_RADIX2 #(.bit_width(bit_width), 
                    .word_length_tw(word_length_tw)) 
    modify_radix2_inst (

        .sin_data(sin_data_radix),
        .cos_data(cos_data_radix),
        .sin_data2(sin_data2),
        .cos_data2(cos_data2),
        .Re_i1(Re_temp2),
        .Im_i1(Im_temp2),
        .Re_i2(Re_temp4),
        .Im_i2(Im_temp4),
        .en(en_add),
        .Re_o1(Re_temp3),
        .Im_o1(Im_temp3),
        .Re_o2(Re_temp5),
        .Im_o2(Im_temp5),
        .out_valid(en_mul)
    );
    //----------------------------------------------------------------------
    // Multiplexer Module: This module selects the correct intermediate result 
    // to output after all FFT modifications and processing are done.
    multiplexor #(.bit_width(bit_width)) mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Re_i_1(Re_temp3),
        .Im_i_1(Im_temp3),
        .Re_i_2(Re_temp5),
        .Im_i_2(Im_temp5),
        .in_valid(en_mul),
        .Re_o(Re_o),
        .Im_o(Im_o),
        .out_valid(en_wr)
    );
endmodule