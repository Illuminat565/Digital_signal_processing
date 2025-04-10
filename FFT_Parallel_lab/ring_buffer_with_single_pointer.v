module ring_buffer_with_single_pointer
# (
    parameter width = 256, depth = 10
)
(
    input                clk,
    input                rst_n,

    input                in_valid,
    input  [width - 1:0] in_data,

    output               out_valid,
    output [width - 1:0] out_data
);

    //------------------------------------------------------------------------

    localparam pointer_width = $clog2 (depth);
    localparam [pointer_width - 1:0] max_ptr =  depth - 1;
	 
    reg [pointer_width - 1:0] ptr;

    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
             ptr <= 0;
        else if (ptr == max_ptr)
             ptr <= 0;
		  else ptr <= ptr + 1'b1;

    //------------------------------------------------------------------------

    reg [depth - 1:0] valid;
    reg [width - 1:0] data [0: depth - 1];

    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            valid <= 0;
        else
            valid [ptr] <= in_valid;

    always @ (posedge clk)
        if (in_valid)
            data [ptr] <= in_data;

    assign out_valid = valid [ptr];
    assign out_data  = data  [ptr];


endmodule