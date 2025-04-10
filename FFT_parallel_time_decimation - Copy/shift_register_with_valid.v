

module shift_register_with_valid
# (
    parameter width = 256,  depth = 10
)
(
    input                clk,
    input                rst,

    input                in_valid,
    input  [width - 1:0] in_data,

    output               out_valid,
    output [width - 1:0] out_data
);

    reg [depth - 1:0] valid;
    reg [width - 1:0] data [0: depth - 1];
    integer i;

    always @ (posedge clk or posedge rst)
        if (rst)
            valid <= 1'b0;
        else
            valid <= { valid [depth - 1- 1:0], in_valid };

    always @ (posedge clk)
    begin
        data [0] <= in_data;

        for (i = 1; i < depth; i =i+1) begin
            data [i] <= data [i - 1];
        end
    end

    assign out_valid = valid [depth - 1];
    assign out_data  = data [depth - 1];



endmodule