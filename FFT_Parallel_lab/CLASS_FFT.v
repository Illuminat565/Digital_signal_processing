
module CLASS_FFT
  #(parameter word_length_tw = 14,               // Length of twiddle factor (sin/cos values)
    stagger                  = 0,  
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
    input                            en_out,     // Output enable

    output   signed  [bit_width-1:0] Re_o,       // Real output data after FFT processing
    output   signed  [bit_width-1:0] Im_o,       // Imaginary output data after FFT processing
    output                           en_o,       // Output enable flag
    output                           finish_FFT, // FFT finish signal
    output                           done_o      // Operation completion signal
);

    // Internal signals for storing temporary FFT data
    wire  signed [bit_width-1:0] Re_temp1, Im_temp1, Re_temp2, Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3, Im_temp3, Re_temp4, Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5, Im_temp5, Re_temp6, Im_temp6;

    // Control signals for managing the data flow and processing stages
    wire en_o_temp, en_wr, en_rd, en_add, en_modify;
    wire out_valid, en_radix, en_mul;

    // Address pointers for memory read and write
    wire [10:0] rd_ptr_angle;   // Angle address pointer for twiddle factors
    wire [SIZE-1:0] wr_ptr [SIZE+1:1];  // Read and write pointer signals
    wire [SIZE-1:0] rd_ptr [SIZE:1];

    // Output signals from the demultiplexer for splitting data streams
    wire signed [bit_width-1:0] Re_demul, Im_demul;

    // Twiddle factor data (sine and cosine values)
    wire signed [word_length_tw-1:0] sin_data2, cos_data2;
    wire signed [word_length_tw-1:0] sin_data_radix, cos_data_radix;
    wire signed [word_length_tw-1:0] sin_data, cos_data;
    //-----------------------------------------------------
    wire [SIZE+1:1] start_next_stage;
    wire [SIZE+1:1] en_wr_temp;
    wire  [bit_width-1:0] Re_o_temp[SIZE+1:1];
    wire  [bit_width-1:0] Im_o_temp[SIZE+1:1];

    //----------------------------------------------------------------------
    first_state  #(
        .word_length_tw(word_length_tw),
        .t_1_bit(t_1_bit),
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) first_state_ins (
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_flag),
        .load_data(load_data),
        .Re_i(Re_i),
        .Im_i(Im_i),
        .invert_addr(invert_addr),

        .Re_o(Re_o_temp[2]),
        .Im_o(Im_o_temp[2]),
        .en_wr(en_wr_temp[2]),
        .wr_ptr(wr_ptr[2]),
        .start_next_stage(start_next_stage[2])
    );

//------------------------------------------------------------------------
genvar i;
generate
    for (i = 2 ; i < SIZE ; i = i+1 ) begin: processor

    inter_state  #(
        .stage_FFT(i),
        .stagger(stagger),
        .word_length_tw(word_length_tw),
        .t_1_bit(t_1_bit),
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) inter_state_ins (
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_next_stage[i]),
        .load_data(en_wr_temp[i]),
        .Re_i(Re_o_temp[i]),
        .Im_i(Im_o_temp[i]),
        .invert_addr(wr_ptr[i]),

        .Re_o(Re_o_temp[i+1]),
        .Im_o(Im_o_temp[i+1]),
        .en_wr(en_wr_temp[i+1]),
        .wr_ptr(wr_ptr[i+1]),
        .start_next_stage(start_next_stage[i+1]));

    end
    
    
endgenerate
//------------------------------------------------------------
     class_final_state  #(
        .stage_FFT(SIZE),
        .stagger(stagger),
        .word_length_tw(word_length_tw),
        .t_1_bit(t_1_bit),
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) final_state_ins (
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_next_stage[SIZE]),
        .load_data(en_wr_temp[SIZE]),
        .Re_i(Re_o_temp[SIZE]),
        .Im_i(Im_o_temp[SIZE]),
        .invert_addr(wr_ptr[SIZE]),

        .Re_o(Re_o_temp[SIZE+1]),
        .Im_o(Im_o_temp[SIZE+1]),
        .en_wr(en_wr_temp[SIZE+1]),
        .wr_ptr(wr_ptr[SIZE+1]),
        .start_next_stage(start_next_stage[SIZE+1]));

//--------------------------------------------------------------
     out_state  #(
        .stage_FFT(SIZE),
        .word_length_tw(word_length_tw),
        .t_1_bit(t_1_bit),
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) out_state_ins (
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_next_stage[SIZE+1]),
        .load_data(en_wr_temp[SIZE+1]),
        .Re_i(Re_o_temp[SIZE+1]),
        .Im_i(Im_o_temp[SIZE+1]),
        .invert_addr(wr_ptr[SIZE+1]),
        .en_out(en_out),

        .Re_o(Re_o),
        .Im_o(Im_o),

        .en_o(en_o),
        .done_o(done_o));

endmodule

