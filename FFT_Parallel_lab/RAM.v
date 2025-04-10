module  RAM #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    
    input                               en_wr,
    input              [SIZE-1:     0]  wr_ptr,  
    input       signed [bit_width-1:0]  Re_i,
    input       signed [bit_width-1:0]  Im_i,

    
    input              [SIZE-1:       0]  rd_ptr,
    input                                 en_rd, 

   

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    output reg                          o_valid
 );



    reg  signed  [bit_width-1:0]  mem_Re  [N-1:0];
    reg  signed  [bit_width-1:0]  mem_Im  [N-1:0];
	 


    //------------------------handle read write from MEM----------------------------
        always @(posedge clk) begin
         begin
             if (en_rd) begin
                  Re_o             <= mem_Re[rd_ptr];
                  Im_o             <= mem_Im[rd_ptr];
             end

             if (en_wr) begin
                  mem_Re[wr_ptr] <= Re_i;
                  mem_Im[wr_ptr] <= Im_i;    
            end

            o_valid              <= en_rd;
        end
        end

endmodule