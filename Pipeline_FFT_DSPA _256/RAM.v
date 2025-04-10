module  RAM #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                               clk,rst_n,
    
    input                               en_wr,
    input              [SIZE-1:     0]  wr_ptr,

    input       signed [bit_width-1:0]  Re_i,
    input       signed [bit_width-1:0]  Im_i,

    input              [SIZE-1:     0]  rd_ptr,
    input                               en_rd, 

    output reg  signed [bit_width-1:0]  Re_o1,
    output reg  signed [bit_width-1:0]  Im_o1,
    output reg  signed [bit_width-1:0]  Re_o2,
    output reg  signed [bit_width-1:0]  Im_o2,
    output reg                          en_add      

 );

    reg  signed  [bit_width-1:0]  mem_Re  [N-1:0];
    reg  signed  [bit_width-1:0]  mem_Im  [N-1:0];

    reg  signed  [bit_width-1:0]  Re_o_temp;
    reg  signed  [bit_width-1:0]  Im_o_temp;

    reg  signed  [bit_width-1:0]  Re_o1_temp;
    reg  signed  [bit_width-1:0]  Im_o1_temp;
    
    reg [1:0] state_rd;

    reg  en_o;

    localparam 
          FIRST_OUT  = 2'b01,
          SEC_OUT    = 2'b10;


  
    //--------------------handle choose out put------------------------------  
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                state_rd   <=  FIRST_OUT;
                en_o       <= 0;
            end else begin
                case (state_rd)
                  FIRST_OUT: begin
                  if (en_rd) state_rd      <= SEC_OUT;
                             en_o          <= 0;
                    end
                  SEC_OUT:   begin
                        state_rd      <= FIRST_OUT;
                        en_o          <= 1;
                        Re_o1_temp    <= Re_o_temp;
                        Im_o1_temp    <= Im_o_temp;
                  end    
                    default: state_rd     <= FIRST_OUT;
                endcase
            end
        end
//----------------------------------------------------------------------------------
       always @(*) begin
                if (en_o) begin
                    Re_o2  <= Re_o_temp;
                    Im_o2  <= Im_o_temp;
                    Re_o1  <= Re_o1_temp;
                    Im_o1  <= Im_o1_temp;
                    en_add <= 1'b1;
                end else en_add <= 1'b0;
        end  

    //------------------------handle read write from MEM----------------------------
        always @(posedge clk) begin
        begin
             if (en_rd) begin
                  Re_o_temp           <= mem_Re[rd_ptr];
                  Im_o_temp           <= mem_Im[rd_ptr];
             end

             if (en_wr) begin
                  mem_Re[wr_ptr]      <= Re_i;
                  mem_Im[wr_ptr]      <= Im_i;    
            end
        end
        end

endmodule