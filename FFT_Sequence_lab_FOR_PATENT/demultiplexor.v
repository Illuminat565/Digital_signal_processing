module demultiplexor #(
    parameter bit_width = 16, word_length_tw = 14
) (
    input                               clk,
    input                               rst_n,
    input       signed [bit_width-1:0]  Re_i,
    input       signed [bit_width-1:0]  Im_i,
//    input       signed [word_length_tw-1:0]           cos_data,
//    input       signed [word_length_tw-1:0]           sin_data,
    input                               in_valid,

    output reg  signed [bit_width-1:0]  Re_o1,
    output reg  signed [bit_width-1:0]  Im_o1,
    output reg  signed [bit_width-1:0]  Re_o2,
    output reg  signed [bit_width-1:0]  Im_o2,
//    output reg  signed [word_length_tw-1:0]           o_cos_data,
//    output reg  signed [word_length_tw-1:0]           o_sin_data,

    output reg                          out_valid
);
/*
    reg [1:0] state;
    reg  signed [bit_width-1:0]  Re_o1_temp;
    reg  signed [bit_width-1:0]  Im_o1_temp;

    reg  signed [bit_width-1:0]  Re_i_temp;
    reg  signed [bit_width-1:0]  Im_i_temp;
    reg       signed [word_length_tw-1:0]           cos_data_temp;
    reg       signed [word_length_tw-1:0]           sin_data_temp;
    reg  start;


    always @(posedge clk ) begin
     if(in_valid) begin
            start          <= 1'b1;
            Re_i_temp      <= Re_i;
            Im_i_temp      <= Im_i;
   //         cos_data_temp     <= cos_data;
   //         sin_data_temp     <= sin_data;
     end else start        <= 1'b0;
end  
    

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
                    if (start) begin
                        state      <= SEC_OUT;
                        Re_o1_temp      <= Re_i_temp;
                        Im_o1_temp      <= Im_i_temp;
                    end 
                        out_valid  <= 1'b0;
                    end
                  SEC_OUT: begin
                        Re_o2       <= Re_i_temp;
                        Im_o2       <= Im_i_temp;
                        Re_o1       <= Re_o1_temp;
                        Im_o1       <= Im_o1_temp;
                //        o_cos_data  <= cos_data_temp;
                //        o_sin_data  <= sin_data_temp;
                        out_valid   <= 1'b1;
                        state       <= FIRST_OUT;
                  end
                    default: state     <= FIRST_OUT;
                endcase
            end
        end
*/
    reg selector; // Флаг, который чередует выходы
    reg  signed [bit_width-1:0]  Re_o1_temp;
    reg  signed [bit_width-1:0]  Im_o1_temp;
    wire en = in_valid & selector;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Re_o1_temp <= 0; 
            Im_o1_temp <= 0;
            selector       <= 1'b0;
            out_valid      <= 1'b0;
        end 
        else if (in_valid) begin
            if (selector == 1'b0) begin
                Re_o1_temp <= Re_i; // Чётные байты → parallel_out_0
                Im_o1_temp <= Im_i;
                out_valid <= 1'b0; 
            end else out_valid     <= 1'b1; // После второго байта данные готовы
            selector <= ~selector; // Переключение выходного сигнала
        end
    end

       always @(posedge clk ) begin
        if(en ) begin
          Re_o1         <= Re_o1_temp;
          Im_o1         <= Im_o1_temp;
          Re_o2         <= Re_i; 
          Im_o2         <= Im_i;
        end
    end

    /*
    shift_register # ( .width (bit_width), .depth (1)) shift_register1(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(Re_i),
         .out_data(Re_i_temp)
);

shift_register # ( .width (bit_width), .depth (1)) shift_register2(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(Im_i),
         .out_data(Im_i_temp)
);

shift_register # ( .width (bit_width), .depth (1)) shift_register3(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(cos_data),
         .out_data(cos_data_temp)
);

shift_register # ( .width (bit_width), .depth (1)) shift_register4(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(sin_data),
         .out_data(sin_data_temp)
);
//--------------------------------------------------------------

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
                    end 
                        out_valid  <= 1'b0;
                    end
                  SEC_OUT: begin
                        Re_o1       <= Re_i_temp;
                        Im_o1       <= Im_i_temp;
                        Re_o2       <= Re_i;
                        Im_o2       <= Im_i;
                        o_cos_data  <= cos_data_temp;
                        o_sin_data  <= sin_data_temp;
                        out_valid   <= 1'b1;
                        state       <= FIRST_OUT;
                  end
                    default: state     <= FIRST_OUT;
                endcase
            end
        end

    
endmodule*/
endmodule