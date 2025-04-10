 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : top_module
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    :
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
`define SIMULATION

module top_module #(
    parameter    word_length_tw = 14,  // Length of twiddle factor (sin/cos values)
                 stagger        = 20,  // Percentage of stagger 
                 N=256,               // Number of samples (FFT size)
			     bit_width = 24        // Data bit width
) (     
    input         clk,             // Clock input
    input         rst_n,           // Reset (active low)
    input         data_in,         // UART input data
    input   [3:0] key,             // Input keys for control (e.g., buttons)
    output        tx_o,            // UART transmit output
 //   output  [3:0] dig,             // 7-segment display digit
 //   output  [3:0] led,             // LEDs to indicate status
    output  [7:0] seg              // 7-segment display segments
);

    // Calculate SIZE based on N for address width
    localparam SIZE = $clog2(N);

    // Define different bit widths for simulation vs. real operation
    `ifdef SIMULATION
        localparam t_1_bit = 4'd9,
                   t_half_1_bit = 4'd4;
    `else    
        localparam t_1_bit = 16'd5207,   // Transmission bit time for real operation
                   t_half_1_bit = 16'd2603; // Half of transmission bit time
    `endif

    // Internal wires for complex number storage, FFT process control, and UART communication
    wire signed [bit_width-1:0] Re_o;      // Real output of FFT
    wire signed [bit_width-1:0] Im_o;      // Imaginary output of FFT
    wire signed [bit_width-1:0] Re_i;      // Real input to FFT
    wire signed [bit_width-1:0] Im_i;      // Imaginary input to FFT 
    wire [SIZE-1:0] invert_addr;           // Inverted address for data access
    wire load_data;                        // Load data flag for FFT processing
    wire finish_FFT;                       // FFT completion flag
    wire tx_done_o, en_tx;                 // UART transmit done and enable
  //  wire clk = CLK;                        // Clock signal
  //  wire rst_n = RST_N;                    // Reset signal
    wire start_flag;                       // Start flag for FFT processing
    wire en_out;                           // Output enable signal for FFT result
    wire [7:0] data_i_uart;                // Data to be sent via UART
    wire en_proc_data;                     // Data processing enable
    wire done_o;                           // Data processing completion flag
    wire [7:0] signal;                     // Data signal for FFT processing
    wire en_invert;                        // Enable signal for address inversion

    //------------------------------------------------------------------
    // UART RX module: Receives data and signals when a complete frame is received
    uart_rx #(.t_1_bit(t_1_bit), .t_half_1_bit(t_half_1_bit)) UART_RX (
        .clk(clk),
        .rst_n(rst_n),
        .rx_i(data_in),
        .data_o(signal),
        .rx_done_o(en_invert)
    );

    //------------------------------------------------------------------
    // Invert Address Module: Handles the inversion of address for FFT data
    INVERT_ADDR  #(
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE),
        .t_1_bit(t_1_bit),
        .t_half_1_bit(t_half_1_bit)
    ) INVERT_ADDR (
        .clk(clk),
        .rst_n(rst_n),
        .en_invert(en_invert),
        .signal(signal),
        .Re_o(Re_i),
        .Im_o(Im_i),
        .invert_addr(invert_addr),
        .en_o(load_data),
        .start_flag(start_flag)
    );

    //------------------------------------------------------------------
    // FFT Module: Performs the main FFT computation based on input data
    generate
    if (stagger == 0) begin
        
    CLASS_FFT  #(
        .word_length_tw(word_length_tw),
        .stagger(stagger),
        .t_1_bit(t_1_bit),
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) CLASS_FFT (
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_flag),
        .load_data(load_data),
        .Re_i(Re_i),
        .Im_i(Im_i),
        .invert_addr(invert_addr),
        .en_out(en_out),
        .Re_o(Re_o),
        .Im_o(Im_o),
        .en_o(en_proc_data),
        .finish_FFT(finish_FFT),
        .done_o(done_o)
    );
    end else begin
    MODIFY_FFT  #(
        .word_length_tw(word_length_tw),
        .stagger(stagger),
        .t_1_bit(t_1_bit),
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) MODIFY_FFT (
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_flag),
        .load_data(load_data),
        .Re_i(Re_i),
        .Im_i(Im_i),
        .invert_addr(invert_addr),
        .en_out(en_out),
        .Re_o(Re_o),
        .Im_o(Im_o),
        .en_o(en_proc_data),
        .finish_FFT(finish_FFT),
        .done_o(done_o)
    );
    end

    endgenerate

    //------------------------------------------------------------------
    // Output Data Processing Module: Processes the FFT output before sending to UART
    PROCESS_O_DATA #(
        .t_1_bit(t_1_bit),
        .bit_width(bit_width)
    ) PROCESS_O_DATA (
        .clk(clk),
        .rst_n(rst_n),
        .en_wr(en_proc_data),
        .en_rd(tx_done_o),
        .data_re_i(Re_o),
        .data_im_i(Im_o),
        .data_out(data_i_uart),
        .en_o(en_tx),
        .done_o(en_out)
    );

    //------------------------------------------------------------------
    // UART TX Module: Sends the processed data over UART
    uart_tx #(
        .t_1_bit(t_1_bit)
    ) UART_TX (
        .clk(clk),
        .rst_n(rst_n),
        .en_i(en_tx),
        .data_i(data_i_uart),
        .tx_o(tx_o),
        .tx_done_o(tx_done_o)
    );

    //------------------------------------------------------------------
  /*  // 7-Segment Display Data Module: Manages the output to the 7-segment display
    seg7_data2  #(
        .bit_width(bit_width),
        .N(N),
        .SIZE(SIZE)
    ) SEG7_DATA2 (
        .clk(clk),
        .rst_n(rst_n),
        .key(key),
        .en_FFT(start_flag),
        .finish_FFT(finish_FFT),
        .done_all(done_o),
        .Re_in(Re_o),
        .Im_in(Im_o),
        .en_comp(en_proc_data),
        .led(led),
        .dig(dig),
        .seg(seg)
    );*/

endmodule
