module multiplexor #(
    parameter bit_width = 16,SIZE=8
) (
    input                               clk,
    input                               rst_n,
    input              [SIZE-1:     0]  rd_ptr,   
    input       signed [bit_width-1:0]  Re_i_1,
    input       signed [bit_width-1:0]  Im_i_1,
    input       signed [bit_width-1:0]  Re_i_2,
    input       signed [bit_width-1:0]  Im_i_2,
    input                               in_valid,
    
    output reg         [SIZE-1:     0]  wr_ptr, 
    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    output reg                          out_valid
);
    reg [1:0] state;
    wire [SIZE-1:     0]  wr_ptr_temp; 

    localparam 
          WRITE1 = 2'b01,
          WRITE2 = 2'b10;
    
     shift_register # ( .width (SIZE), .depth (3)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(rd_ptr),
         .out_data(wr_ptr_temp)
); 
 
                    always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin     
                        state     <= WRITE1;
                        out_valid     <= 0;
                    end else begin         
                    case (state)
                            WRITE1: begin    
                                if ((in_valid)) begin
                                    state        <= WRITE2;
                                    Re_o         <= Re_i_1; 
                                    Im_o         <= Im_i_1; 
                                    wr_ptr       <= wr_ptr_temp;
                                    out_valid        <= 1'b1;
                                end else out_valid   <= 1'b0;
                            end
                            WRITE2: begin      
                                    state        <= WRITE1;
                                    Re_o         <= Re_i_2; 
                                    Im_o         <= Im_i_2; 
                                    wr_ptr       <= wr_ptr_temp;
                            end
                        default:   
                                    state        <= WRITE1; 
                    endcase
                    end
                    end

    
endmodule