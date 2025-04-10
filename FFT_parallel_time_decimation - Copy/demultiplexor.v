module demultiplexor #(
    parameter bit_width = 16
) (
    input                               clk,
    input                               rst_n,
    input       signed [bit_width-1:0]  Re_i,
    input       signed [bit_width-1:0]  Im_i,
    input       signed [13:0]           cos_data,
    input       signed [13:0]           sin_data,
    input                               in_valid,

    output reg  signed [bit_width-1:0]  Re_o1,
    output reg  signed [bit_width-1:0]  Im_o1,
    output reg  signed [bit_width-1:0]  Re_o2,
    output reg  signed [bit_width-1:0]  Im_o2,
    output reg  signed [13:0]           o_cos_data,
    output reg  signed [13:0]           o_sin_data,

    output reg                          out_valid
);
    reg [1:0] state;
    reg  signed [bit_width-1:0]  Re_o1_temp;
    reg  signed [bit_width-1:0]  Im_o1_temp;


    localparam 
          FIRST_OUT = 2'b01,
          SEC_OUT   = 2'b10;
 
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                state          <= FIRST_OUT;
                out_valid         <= 1'b0;
            end else begin
                case (state)
                  FIRST_OUT  : begin
                    if (in_valid) begin
                        state      <= SEC_OUT;
                        Re_o1_temp      <= Re_i;
                        Im_o1_temp      <= Im_i;
                    end 
                        out_valid  <= 1'b0;
                    end
                  SEC_OUT: begin
                        Re_o2       <= Re_i;
                        Im_o2       <= Im_i;
                        Re_o1       <= Re_o1_temp;
                        Im_o1       <= Im_o1_temp;
                        o_cos_data  <= cos_data;
                        o_sin_data  <= sin_data;
                        out_valid   <= 1'b1;
                        state       <= FIRST_OUT;
                  end
                    default: state     <= FIRST_OUT;
                endcase
            end
        end


endmodule