module CLASS_FFT 
#(parameter word_length_tw = 14,     // Width of the numbers in bits for trigonometric factors
            bit_width=24,            // Bit width for the real and imaginary numbers
            N = 16,                  // Number of FFT points (size of FFT)
            SIZE = 4,                // Size for address and pointers
            t_1_bit = 5207)          // Bit time for UART communication
(
    input                           clk,             // Clock signal
    input                           rst_n,           // Active-low reset signal
    input                           start_flag,      // Flag to start FFT operation
    input                           load_data,       // Flag to load data into RAM
    input    signed  [bit_width-1:0] Re_i,           // Real input data
    input    signed  [bit_width-1:0] Im_i,           // Imaginary input data
    input            [SIZE-1:0]      invert_addr,    // Inversion address (for addressing RAM)
    input                            en_out,         // Enable signal for the output
    output   signed  [bit_width-1:0] Re_o,           // Real output data
    output   signed  [bit_width-1:0] Im_o,           // Imaginary output data
    output                           en_o,           // Enable signal for output
    output                           finish_FFT,     // Flag indicating FFT process is finished
    output                           done_o          // Flag indicating the operation is complete
);

    // Temporary wire signals for intermediate results (real and imaginary parts)
    wire  signed [bit_width-1:0] Re_temp1;
    wire  signed [bit_width-1:0] Im_temp1;
    wire  signed [bit_width-1:0] Re_temp2;
    wire  signed [bit_width-1:0] Im_temp2;
    wire  signed [bit_width-1:0] Re_temp3;
    wire  signed [bit_width-1:0] Im_temp3;
    wire  signed [bit_width-1:0] Re_temp4;
    wire  signed [bit_width-1:0] Im_temp4;
    wire  signed [bit_width-1:0] Re_temp5;
    wire  signed [bit_width-1:0] Im_temp5;
    wire  signed [bit_width-1:0] Re_temp6;
    wire  signed [bit_width-1:0] Im_temp6;
    wire                         en_o_temp;         // Temporary enable signal for output

    wire         [10:0]          rd_ptr_angle;       // Read pointer for angle data
    wire                         en_wr;              // Enable write signal
    wire                         en_rd;              // Enable read signal
    wire         [SIZE:0]        wr_ptr;             // Write pointer
    wire         [SIZE:0]        rd_ptr;             // Read pointer
    wire                         en_add;             // Enable signal for addition operation
    wire signed  [bit_width-1:0]  Re_demul;          // Demultiplexed real part
    wire signed  [bit_width-1:0]  Im_demul;          // Demultiplexed imaginary part

    wire  signed [word_length_tw-1:0] sin_data_radix; // Sine data for radix operation
    wire  signed [word_length_tw-1:0] cos_data_radix; // Cosine data for radix operation
    wire  signed [word_length_tw-1:0] sin_data;       // General sine data
    wire  signed [word_length_tw-1:0] cos_data;       // General cosine data
    wire                              out_valid;      // Output valid signal for FFT
    wire                              en_radix;       // Enable signal for radix operation
    wire                              en_mul;         // Enable signal for multiplication operation

//--------------------------------------------------------------------------    

    // Control module for managing FFT operations (main control unit)
    CLASS_CONTROL #(.t_1_bit(t_1_bit),
                    .bit_width(bit_width), 
                    .N(N),
                    .SIZE(SIZE)) 
    CONTROL(
        .clk(clk),
        .rst_n(rst_n),
        .flag_start_FFT(start_flag),
        .en_out(en_out),
        .rd_ptr(rd_ptr),
        .rd_ptr_angle(rd_ptr_angle),
        .en_rd (en_rd),
        .finish_FFT(finish_FFT),
        .out_valid(out_valid),
        .done_o(done_o)
    );

    // Shift register to handle pointer shifts for read/write addresses
    shift_register #(.width(SIZE+1), .depth(5)) shift_register_inst(
        .clk(clk),
        .rst_n(rst_n), 
        .in_data(rd_ptr),
        .out_data(wr_ptr)
    );

    // RAM block to store input data and provide it for further operations
    RAM #( .bit_width(bit_width), .N(N), .SIZE(SIZE)) RAM_inst(
        .clk(clk),
        .rst_n(rst_n),
        .load_data(load_data),
        .invert_adr(invert_addr),
        .Re_i1(Re_i),
        .Im_i1(Im_i),
        .en_wr(en_wr),
        .Re_i2(Re_temp1),
        .Im_i2(Im_temp1),
        .out_valid(out_valid),
        .wr_ptr(wr_ptr),
        .rd_ptr(rd_ptr),
        .en_rd(en_rd),
        .Re_o(Re_o),
        .Im_o(Im_o),
        .en_radix(en_radix),
        .out_valid_data(en_o)
    );

    // Twiddle factor generator for FFT computation
    class_tw_factor_generator #(
        .word_length_tw(word_length_tw) 
    ) tw_factor_generator_inst (
        .clk(clk),
        .en_rd(en_rd),
        .rd_ptr_angle(rd_ptr_angle),
        .cos_data(cos_data),
        .sin_data(sin_data)
    );

    // Demultiplexer for separating real and imaginary parts for radix operation
    demultiplexor #(.bit_width(bit_width), .word_length_tw(word_length_tw)) demux_inst(
        .clk(clk),
        .rst_n(rst_n),
        .Re_i(Re_o),
        .Im_i(Im_o),
        .cos_data(cos_data),
        .sin_data(sin_data),
        .in_valid(en_radix),
        .Re_o1(Re_temp2),
        .Im_o1(Im_temp2),
        .Re_o2(Re_temp4),
        .Im_o2(Im_temp4),
        .o_cos_data(cos_data_radix),
        .o_sin_data(sin_data_radix),
        .out_valid(en_add)
    );

    // Radix-2 operation for FFT computation (stage of the FFT)
    RADIX #( .bit_width(bit_width), .word_length_tw(word_length_tw)) RADIX_inst(
        .sin_data(sin_data_radix),
        .cos_data(cos_data_radix),
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

    // Multiplexer to select between the two outputs from the radix stage
    multiplexor #(.bit_width(bit_width)) mux_inst(
        .clk(clk),
        .rst_n(rst_n),
        .Re_i_1(Re_temp3),
        .Im_i_1(Im_temp3),
        .Re_i_2(Re_temp5),
        .Im_i_2(Im_temp5),
        .in_valid(en_mul),
        .Re_o(Re_temp1),
        .Im_o(Im_temp1),
        .out_valid(en_wr)
    );
  
endmodule
