module  RAM #(parameter bit_width=29, N = 16, SIZE = 4)(
    input clk,rst_n,
    
    input                load_data,
    input        [SIZE:0]invert_adr,
    input signed [bit_width-1:0] Re_i1,
    input signed [bit_width-1:0] Im_i1,

    input                 en_wr,
    input        [SIZE:0] wr_ptr,
    input signed [bit_width-1:0]  Re_i2,
    input signed [bit_width-1:0]  Im_i2,

    
    input [SIZE:0] rd_ptr,
    input          en_rd_1,
    input          en_rd_2,
    
    output reg    signed [bit_width-1:0]  Re_o1,
    output reg    signed [bit_width-1:0]  Im_o1,
    output reg    signed [bit_width-1:0]  Re_o2,
    output reg    signed [bit_width-1:0]  Im_o2,

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    
    output reg en_o
 );

    reg  signed [bit_width-1:0]    x_real_i;
    reg  signed [bit_width-1:0]    y_real_i;
    reg         [SIZE:0]           index_wr ;


    reg signed [bit_width-1:0]   mem_Re  [N-1:0];
    reg signed [bit_width-1:0]   mem_Im  [N-1:0];
    
    reg en_o_1, en_o_2;
    reg en_wr_mem;
 
    //--------------------handle choose out put------------------------------
        always @(posedge clk) begin
                if (en_o_1) begin
                Re_o1       <= Re_o;
                Im_o1       <= Im_o;
                end
        end

        always @(*) begin
                if (en_o_2) begin
                    Re_o2 <= Re_o;
                    Im_o2 <= Im_o;
                end
        end
    //------------------------handle enable output----------------------------
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                en_o_1      <= 0;
                en_o_2      <= 0;
            end else begin
                en_o_1      <= en_rd_1;  
                en_o_2      <= en_rd_2;
            end
        end
    //------------------------handle read write from MEM----------------------------
        always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Re_o      <= 0;
            Im_o      <= 0;
            en_o     <= 0;
        end else begin
             if (en_rd_1 || en_rd_2) begin
                  Re_o     <= mem_Re[rd_ptr];
                  Im_o     <= mem_Im[rd_ptr];
                  en_o     <= 1'b1;
             end else  en_o     <= 0;
             if (en_wr_mem) begin
                  mem_Re[index_wr] <= x_real_i;
                  mem_Im[index_wr] <= y_real_i;    
            end
        end
        end
    //------------------------handle load initial data to MEM--------------------------
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
            en_wr_mem <= 1'b0;
            end else if (load_data) begin
                x_real_i  <= Re_i1;
                y_real_i  <= Im_i1;
                index_wr  <= invert_adr; 
                en_wr_mem <= 1'b1;
            end else if (en_wr) begin
                x_real_i  <= Re_i2;
                y_real_i  <= Im_i2;
                index_wr  <= wr_ptr; 
                en_wr_mem <= 1'b1;
            end else en_wr_mem <= 1'b0;
        end

endmodule