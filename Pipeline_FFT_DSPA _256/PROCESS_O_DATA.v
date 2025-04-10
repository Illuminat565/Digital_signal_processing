module PROCESS_O_DATA # (parameter bit_width = 28, N = 16, SIZE = 4)(
  input                        clk,
  input                        rst_n, 
  
  input                        finish_fft,
  input                        en_back_mem,
  input                        en_rd,

  input          [SIZE-1:     0]     adr_ptr1,
  input          [SIZE-1:     0]     adr_ptr2,

  input   signed [bit_width-1:0]     data_re_i1,
  input   signed [bit_width-1:0]     data_im_i1,
  input   signed [bit_width-1:0]     data_re_i2,
  input   signed [bit_width-1:0]     data_im_i2,
                
  output  reg [7:0] data_out,
  output  reg   en_o,
  output  reg   done_o);

  localparam 
          IDLE       = 8'b00000001,
          WRITE      = 8'b00000010,
          TAKE_DATA  = 8'b00000100,
          WAIT       = 8'b00001000,
          READ       = 8'b00010000,
          COUNT      = 8'b00100000,
          INVERT     = 8'b01000000,  
          DONE       = 8'b10000000;

  reg [7:0] cur_state;
  reg [7:0] next_state;
  reg [7:0] data_out_temp [3:0];
  reg [2:0] rd_ptr;

  wire en_wr_mem;

  reg  signed    [bit_width-1:0]     data_re_i;
  reg  signed    [bit_width-1:0]     data_im_i;
  reg  signed    [bit_width-1:0]     x_i;
  reg  signed    [bit_width-1:0]     y_i;

  reg            [SIZE-1:     0]     wr_ptr_mem;
  reg            [SIZE:       0]     rd_ptr_mem;

  reg  signed          [bit_width-1:0]     mem_Re [N-1:0];
  reg  signed          [bit_width-1:0]     mem_Im [N-1:0];
  //------------------------------------------------------------------------------------

      reg [1:0] state;
      reg en_wr,en_wr_temp;
      reg [SIZE-1:0] wr_ptr1, wr_ptr2;
      integer i;
      reg [SIZE-1:0] rd_mem;

     localparam
          FIRST_IN   = 2'b01,
          SECOND_IN  = 2'b10;   
     localparam
          WRITE1     = 2'b01,
          WRITE2     = 2'b10;   
     //------------------------handle load initial data to MEM--------------------------
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        en_wr     <= 1'b0;      
                        wr_ptr1   <= 0;
                        wr_ptr2   <= 0;
                        state     <= WRITE1;
                    end else begin
                        case (state)
                            WRITE1: begin    
                                if ((en_back_mem )) begin
                                    en_wr        <= 1'b1;  
                                    wr_ptr1      <= adr_ptr1;
                                    state        <= WRITE2;
                                end else begin 
                                    en_wr        <= 1'b0;
                                end
                            end
                            WRITE2:  begin 
                                   state        <= WRITE1;
                                   wr_ptr2      <= adr_ptr2;
                                   en_wr        <= 1'b0;
                            end
                            default: state     <= WRITE1;
                        endcase                    
                            end 
                    end
//--------------------------------------------------------------------
    always @(posedge clk) begin
        en_wr_temp <= en_wr;
    end

     always @(*) begin
        if (en_wr) begin
                x_i           <= data_re_i1;
                y_i           <= data_im_i1;
                wr_ptr_mem    <= wr_ptr1;
            end else begin
                x_i           <= data_re_i2;
                y_i           <= data_im_i2;
                wr_ptr_mem    <= wr_ptr2;
            end 
    end  
  
    assign en_wr_mem = (en_wr || en_wr_temp); 
//-------------------------------------------------------------------
always @(posedge clk ) begin
          if (en_wr_mem) begin
                  mem_Re[wr_ptr_mem]      <= x_i;
                  mem_Im[wr_ptr_mem]      <= y_i;   
          end
     
end

//----------------state machin----------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= IDLE;
    end else cur_state <= next_state;
  end

//-------------combination logic---------------

always @(*) begin
    case (cur_state)
        IDLE: if (finish_fft)  next_state <=  TAKE_DATA;
              else        next_state      <=  IDLE;
        TAKE_DATA: if (rd_ptr_mem == N)     
                          next_state     <=  DONE;
                    else  next_state     <=  WRITE;
        WRITE:            next_state     <=  READ;
        WAIT: if (!en_rd) next_state     <=  WAIT;
              else if (rd_ptr == 4) 
                          next_state     <=  COUNT; 
              else        next_state     <=  READ;            
        READ:             next_state     <=  WAIT;
        COUNT:            next_state     <=  INVERT; 
        INVERT:           next_state     <=  TAKE_DATA; 
        DONE:             next_state     <=  IDLE; 
        default:          next_state     <=  IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
            data_out_temp [0]  <= 0;
            data_out_temp [1]  <= 0;
            data_out_temp [2]  <= 0;
            data_out_temp [3]  <= 0;    
            rd_ptr_mem         <= 0;
            rd_ptr             <= 0;
            rd_mem             <= 0;
            en_o               <= 1'b0;
            done_o             <= 1'b0;       
    end else case (cur_state)
       IDLE : begin
            data_out_temp [0]  <= 0;
            data_out_temp [1]  <= 0;
            data_out_temp [2]  <= 0;
            data_out_temp [3]  <= 0; 
            rd_ptr             <= 0;
            en_o               <= 1'b0;
            rd_ptr_mem         <= 0;
            rd_mem             <= 0;
            done_o             <= 1'b0; 
       end

       TAKE_DATA: begin
             data_re_i         <= mem_Re[rd_mem];
             data_im_i         <= mem_Im[rd_mem];    
       end

       WRITE: begin
            data_out_temp [0]  <= data_re_i[15:8];
            data_out_temp [1]  <= data_im_i[15:8];
            data_out_temp [2]  <= data_re_i[23:16];
            data_out_temp [3]  <= data_im_i[23:16];
       end

       WAIT: begin
            en_o               <= 0;    
       end

       READ: begin
            en_o               <= 1;
            data_out           <= data_out_temp [rd_ptr];
            rd_ptr             <= rd_ptr + 1'b1;
       end

       COUNT:begin
            rd_ptr_mem         <= rd_ptr_mem + 1;
            rd_ptr             <= 0;
            en_o               <= 1'b0;
       end

       INVERT: begin
          //  for (i = 0  ; i <= SIZE - 1  ; i = i+1 ) begin
          //      rd_mem[i] = rd_ptr_mem [SIZE-1-i];
          
          rd_mem   <=   rd_ptr_mem;
       end

       DONE: done_o <= 1'b1;
        default: begin
            data_out_temp [0]  <= 0;
            data_out_temp [1]  <= 0;
            data_out_temp [2]  <= 0;
            data_out_temp [3]  <= 0; 
            rd_ptr             <= 0;
            en_o               <= 1'b0;
            done_o             <= 1'b0;
       end
    endcase
end
    
endmodule