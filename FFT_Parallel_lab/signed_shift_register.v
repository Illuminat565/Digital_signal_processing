module signed_shift_register
# (
    parameter width = 256, depth = 10
)
(
    input                clk,
    input                rst_n,

    input signed [width - 1:0] in_data,

    output signed [width - 1:0] out_data

);

    reg signed [width - 1:0] data [0: depth - 1];
    integer i;

    always @(posedge clk)
    begin
        data [0] <= in_data;

        for ( i = 1; i < depth; i = i+1)
            data [i] <= data [i - 1];
    end

    assign out_data  = data  [depth - 1];

endmodule