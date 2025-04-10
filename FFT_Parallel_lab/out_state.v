    module out_state 
       #(parameter 
    stage_FFT=2,
    word_length_tw = 14,               // Length of twiddle factor (sin/cos values)
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
    input                            en_out,

    output   signed  [bit_width-1:0] Re_o,       // Real output data after FFT processing
    output   signed  [bit_width-1:0] Im_o,  

    output                           done_o,
    output                           en_o
    
);
    
    // Internal signals for storing temporary FFT data
    wire  signed [bit_width-1:0] Re_temp1, Im_temp1, Re_temp2, Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3, Im_temp3, Re_temp4, Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5, Im_temp5, Re_temp6, Im_temp6;

    wire  signed [bit_width-1:0] Re_o_temp, Im_o_temp;

    // Control signals for managing the data flow and processing stages
    wire en_o_temp, en_rd, en_add, en_modify;
    wire out_valid, en_radix, en_mul;

    // Address pointers for memory read and write
    wire [10:0] rd_ptr_angle;   // Angle address pointer for twiddle factors
    wire [SIZE-1:0] rd_ptr; // Read and write pointer signals

    // Output signals from the demultiplexer for splitting data streams
    wire signed [bit_width-1:0] Re_demul, Im_demul;

    // Twiddle factor data (sine and cosine values)
    wire signed [word_length_tw-1:0] sin_data2, cos_data2;
    wire signed [word_length_tw-1:0] sin_data_radix, cos_data_radix;
    wire signed [word_length_tw-1:0] sin_data, cos_data;

    //----------------------------------------------------------------------
    // Control Module: This module handles the control signals for FFT operation,
    // such as starting, enabling output, and managing read/write pointers.
 
out_addres_generator #(  .t_1_bit(t_1_bit),.N(N), .SIZE(SIZE))out_addres_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_flag),
    .en_out(en_out),
    
    .rd_ptr(rd_ptr),
    .en_rd(en_rd),
    .done_o(done_o)
 );

    //----------------------------------------------------------------------
    // Shift Register Module: This module shifts the read pointer to the write
    // pointer in the FFT process for proper memory access.

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

        .Re_o(Re_o),
        .Im_o(Im_o),
        .o_valid(en_o)
    );


endmodule