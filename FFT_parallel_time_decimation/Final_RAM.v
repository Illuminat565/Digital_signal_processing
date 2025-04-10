module  Final_RAM #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    
    input                              load_data,
    input              [SIZE-1:     0] invert_adr,
    input       signed [bit_width-1:0] Re_i,
    input       signed [bit_width-1:0] Im_i,
    
    input              [SIZE-1:    0]  rd_ptr,
    input                              en_rd, 

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,

    output reg                          valid_o
 );

    reg  signed  [bit_width-1:0]  mem_Re  [N-1:0];
    reg  signed  [bit_width-1:0]  mem_Im  [N-1:0];


//------------------------handle read write from MEM----------------------------
        always @(posedge clk) begin
         begin
             if (en_rd) begin
                  Re_o             <= mem_Re[rd_ptr];
                  Im_o             <= mem_Im[rd_ptr];
                  valid_o          <= 1'b1;
             end else valid_o      <= 1'b0; 
        end
        end

   //--------------------------handle wirte read from MEM----------------------------
        always @(posedge clk) begin
         begin
           if (load_data)   begin
                  mem_Re[invert_adr] <= Re_i;
                  mem_Im[invert_adr] <= Im_i;    
            end
        end
        end


endmodule