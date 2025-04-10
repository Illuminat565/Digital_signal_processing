module  RAM #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    
    input                              load_data,
    input              [SIZE-1:     0] invert_adr,
    input       signed [bit_width-1:0] Re_i1,
    input       signed [bit_width-1:0] Im_i1,

    input                               en_wr,
    input       signed [bit_width-1:0]  Re_i2,
    input       signed [bit_width-1:0]  Im_i2,

    
    input              [SIZE-1:     0]  rd_ptr,
    input                               en_rd, 
    input                               out_valid,
    input              [SIZE-1:     0]  wr_ptr,
   

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    output reg                          en_radix,

    output reg                          out_valid_data
 );
    reg  signed [bit_width-1:0]   x_real_i;
    reg  signed [bit_width-1:0]   y_real_i;
    reg         [SIZE-1:     0]   index_wr ;


    reg  signed  [bit_width-1:0]  mem_Re  [N-1:0];
    reg  signed  [bit_width-1:0]  mem_Im  [N-1:0];
	 
    reg  en_wr_mem;

 
  /*  //-------------------------write point------------------------------------------
    shift_register # ( .width (SIZE+1), .depth (5)) shift_register3(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(rd_ptr),
         .out_data(wr_ptr)
);*/
    


    //------------------------handle read write from MEM----------------------------
        always @(posedge clk) begin
         begin
             if (en_rd || out_valid) begin
                  Re_o             <= mem_Re[rd_ptr];
                  Im_o             <= mem_Im[rd_ptr];
             end

             if (en_wr_mem) begin
                  mem_Re[index_wr] <= x_real_i;
                  mem_Im[index_wr] <= y_real_i;    
            end

        end
        end

        always @(posedge clk) begin
         begin
             if (en_rd )    en_radix <= 1'b1;
             else           en_radix <= 1'b0;
             
             if (out_valid )    out_valid_data <= 1'b1;
             else               out_valid_data <= 1'b0;
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