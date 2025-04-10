module  RAM #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    
    input                              load_data,
    input              [SIZE:       0] invert_adr,
    input       signed [bit_width-1:0] Re_i1,
    input       signed [bit_width-1:0] Im_i1,

    input                               en_wr,
    input              [SIZE:       0]  wr_ptr,
    input       signed [bit_width-1:0]  Re_i2,
    input       signed [bit_width-1:0]  Im_i2,

    
    input              [SIZE:       0]  rd_ptr,
    input                               en_rd, 
    input                               finish_FFT,
    input                               done_all, 
    
    output reg  signed [bit_width-1:0]  Re_o1,
    output reg  signed [bit_width-1:0]  Im_o1,
    output reg  signed [bit_width-1:0]  Re_o2,
    output reg  signed [bit_width-1:0]  Im_o2,
    output reg                          en_add,       

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    
    output reg                          en_o
 );

    reg  signed [bit_width-1:0]   x_real_i;
    reg  signed [bit_width-1:0]   y_real_i;
    reg         [SIZE:       0]   index_wr ;


    reg  signed  [bit_width-1:0]  mem_Re  [N-1:0];
    reg  signed  [bit_width-1:0]  mem_Im  [N-1:0];

    reg  signed  [bit_width-1:0]  Re_o_temp;
    reg  signed  [bit_width-1:0]  Im_o_temp;

    reg  signed  [bit_width-1:0]  Re_o1_temp;
    reg  signed  [bit_width-1:0]  Im_o1_temp;
    
    reg                           en_o_temp;
    
    reg  en_o_1, en_o_2;
    reg  en_wr_mem;
    
    reg [1:0] state;
    reg [1:0] state2;

  //  assign en_add = en_o_2;

    localparam 
          FIRST_OUT = 2'b01,
          SEC_OUT   = 2'b10;
    localparam
          PROCESS   = 2'b01,
          FINISH    = 2'b10;  
    //--------------------handle choose out put------------------------------  
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                state          <= FIRST_OUT;
                en_o_1         <= 1'b0;  
                en_o_2         <= 1'b0;
            end else begin
                case (state)
                  FIRST_OUT  : begin
                    if (en_rd) begin
                        en_o_1         <= 1'b1;  
                        en_o_2         <= 1'b0;
                        state          <= SEC_OUT;
                    end 
                    end
                  SEC_OUT: begin
                        en_o_2         <= 1'b1;
                        en_o_1         <= 1'b0;
                        state     <= FIRST_OUT;
                  end
                    default: state     <= FIRST_OUT;
                endcase
            end
        end
        always @(posedge clk) begin
                if (en_o_1) begin
                Re_o1_temp       <= Re_o_temp;
                Im_o1_temp       <= Im_o_temp;
                end
        end 
       always @(*) begin
                if (en_o_2) begin
                    Re_o2  <= Re_o_temp;
                    Im_o2  <= Im_o_temp;
                    Re_o1  <= Re_o1_temp;
                    Im_o1  <= Im_o1_temp;
                    en_add <= 1'b1;
                end else en_add <= 1'b0;
        end  
    //--------------------handle out put------------------------------  
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                state2   <=   PROCESS;
                en_o    <= 0; 
            end else begin
                case (state2)
                  PROCESS  : begin
                    if (finish_FFT) state2   <= FINISH;   
                    en_o    <= 0;   
                    end
                  FINISH: begin
                        Re_o      <= Re_o_temp;
                        Im_o      <= Im_o_temp;
                        en_o      <= en_o_temp;
                    if (done_all) 
                        state2     <= PROCESS;
                  end
                    default: state2     <= PROCESS;
                endcase
            end
        end
    //------------------------handle read write from MEM----------------------------
        always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Re_o_temp      <= 0;
            Im_o_temp      <= 0;
            en_o_temp      <= 0;
        end else begin
             if (en_rd) begin
                  Re_o_temp             <= mem_Re[rd_ptr];
                  Im_o_temp             <= mem_Im[rd_ptr];
                  en_o_temp             <= 1'b1;
             end else  en_o_temp        <= 0;
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