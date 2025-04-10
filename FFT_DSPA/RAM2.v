module  RAM2 #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                               clk,rst_n,
    
    input                               en_wr,
    input              [SIZE-1:     0]  wr_ptr1,
    input              [SIZE-1:     0]  wr_ptr2,

    input       signed [bit_width-1:0]  Re_i1,
    input       signed [bit_width-1:0]  Im_i1,
    input       signed [bit_width-1:0]  Re_i2,
    input       signed [bit_width-1:0]  Im_i2,

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

    reg  signed  [bit_width-1:0]  Re_i;
    reg  signed  [bit_width-1:0]  Im_i;
    
    reg [1:0] state_rd;

    reg en_o1, en_o2;
    reg en_wr1, en_wr2;
    wire en_wr_mem;
    reg en_wr_temp;

    reg [SIZE-1:0] wr_ptr;
    
    reg [1:0] state_wr;

    localparam
              WRITE1 = 2'b01,
              WRITE2 = 2'b10;


    localparam 
          FIRST_OUT  = 2'b01,
          SEC_OUT    = 2'b10;
    //-----------------------------------------------------------------------
  /*  always @(posedge clk or rst_n ) begin
        if (!rst_n) begin
           state_wr  <=  WRITE1;  
           en_wr_mem <=  0;

        end else 
        case (state_wr)
            WRITE1: if (en_wr) begin
                Re_i      <= Re_i1;
                Im_i      <= Im_i1;
                wr_ptr    <= wr_ptr1;
                en_wr_mem <= 1'b1;
                state_wr  <= WRITE2;
            end else  en_wr_mem <= 1'b0;
            WRITE2: begin
                Re_i      <= Re_i2;
                Im_i      <= Im_i2;
                wr_ptr    <= wr_ptr2;
                state_wr  <= WRITE1;
            end
            default: en_wr_mem <= 1'b0;
        endcase
        
    end*/
    always @(posedge clk) begin
        en_wr_temp <= en_wr;
    end

     always @(*) begin
        if (en_wr) begin
                Re_i      <= Re_i1;
                Im_i      <= Im_i1;
                wr_ptr    <= wr_ptr1;
            end else begin
                Re_i      <= Re_i2;
                Im_i      <= Im_i2;
                wr_ptr    <= wr_ptr2;
            end 
    end  
  
    assign en_wr_mem = (en_wr || en_wr_temp); 

    //--------------------handle choose out put------------------------------  
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                state_rd   <=  FIRST_OUT;
            end else begin
                case (state_rd)
                  FIRST_OUT: begin
                    if (en_rd) begin
                        state_rd       <= SEC_OUT;
                        en_o1          <= 1'b1;
                        en_o2          <= 1'b0;
                    end else begin
                        en_o1          <= 1'b0;
                        en_o2          <= 1'b0;
                    end
                    end
                  SEC_OUT:   begin
                        state_rd       <= FIRST_OUT;
                        en_o2          <= 1'b1;
                        en_o1          <= 1'b0;
                  end    
                    default: state_rd     <= FIRST_OUT;
                endcase
            end
        end
//----------------------------------------------------------------------------------

        always @(posedge clk) begin
                if (en_o1) begin
                Re_o1_temp       <= Re_o_temp;
                Im_o1_temp       <= Im_o_temp;
                end
        end 
       always @(*) begin
                if (en_o2) begin
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

             if (en_wr_mem) begin
                  mem_Re[wr_ptr]      <= Re_i;
                  mem_Im[wr_ptr]      <= Im_i;    
            end
        end
        end

endmodule