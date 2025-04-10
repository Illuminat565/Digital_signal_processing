module  RAM2 #(parameter bit_width=29, N = 16, SIZE = 4)(
    input clk,rst_n,

    input                 en_wr,
    input        [SIZE:0] wr_ptr,
    input signed [bit_width-1:0]  Re_i,
    input signed [bit_width-1:0]  Im_i,

    
    input [SIZE:0] rd_ptr,
    input          en_rd,
    
    output  signed [bit_width-1:0]  Re_o1,
    output  signed [bit_width-1:0]  Im_o1,
    output  signed [bit_width-1:0]  Re_o2,
    output  signed [bit_width-1:0]  Im_o2,

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    
    output reg  en_o,
    output      done_o
    
 );
    wire  signed [bit_width-1:0]  Re_o1_temp;
    wire  signed [bit_width-1:0]  Im_o1_temp;

    reg signed [bit_width-1:0]   mem_Re  [N-1:0];
    reg signed [bit_width-1:0]   mem_Im  [N-1:0];
    
    reg [1:0]    point;
    reg [SIZE:0] count;
     
    assign Re_o1_temp  =  (point==1)?   Re_o:Re_o1_temp;
    assign Im_o1_temp  =  (point==1)?   Im_o:Im_o1_temp;
    assign Re_o1       =  (point==2)?   Re_o1_temp:Re_o1;
    assign Im_o1       =  (point==2)?   Im_o1_temp:Im_o1;
    assign Re_o2       =  (point==2)?   Re_o:Re_o2;
    assign Im_o2       =  (point==2)?   Im_o:Im_o2;
    assign done_o      =  (point==2)?   1'b1:1'b0;

    //------------------------handle read from MEM----------------------------
        always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_o      <= 0;
            point     <= 0;
            count      <= 0;
        end else begin
            if (en_rd) begin
                Re_o <= mem_Re[rd_ptr];
                Im_o <= mem_Im[rd_ptr];
                point    <= point+1'd1;
                en_o     <= 1'b1;  
             end else if (en_wr) begin
                mem_Re[wr_ptr] <= Re_i;
                mem_Im[wr_ptr] <= Im_i;      
                count            <= count + 1'b1;
             end else  begin
                point   <= 0;
                en_o    <= 0;
                count      <= 0;
             end
        end
    end



endmodule