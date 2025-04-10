module PROCESS_O_DATA # (parameter t_1_bit = 16'd5207, bit_width = 28 )(
  input         clk,
  input         rst_n, 
  input         en_wr,
  input         en_rd,
  input    [bit_width-1:0]     data_re_i,
  input    [bit_width-1:0]     data_im_i,
                
  output  reg [7:0] data_out,
  output  reg   en_o,
  output  reg   done_o);

  localparam 
          IDLE    = 4'b0001,
          WRITE   = 4'b0010,
          WAIT    = 4'b0011,
          READ    = 4'b0100,
          DONE    = 4'b1000;

  reg [3:0] cur_state;
  reg [3:0] next_state;
  reg [7:0] data_out_temp [3:0];
  reg [2:0] rd_ptr;
  reg       start;
  reg    [bit_width-1:0]     Re_i_temp;
  reg    [bit_width-1:0]     Im_i_temp;
//-------------------------------------------
always @(posedge clk ) begin
     if(en_wr) begin
            start          <= 1'b1;
            Re_i_temp      <= data_re_i;
            Im_i_temp      <= data_im_i;
     end else start        <= 1'b0;
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
        IDLE: if (start)  next_state     <=  WRITE;
              else        next_state     <=  IDLE;
        WRITE:            next_state     <=  READ;
        WAIT: if (!en_rd) next_state     <=  WAIT;
              else if (rd_ptr == 4) 
                          next_state     <=  DONE; 
              else        next_state     <=  READ;            
        READ:             next_state     <=  WAIT;
        DONE:             next_state     <=  IDLE; 
        default:          next_state     <=  IDLE;
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin   
            rd_ptr             <= 0;
            en_o               <= 1'b0;
            done_o             <= 1'b0;       
    end else case (cur_state)
       IDLE : begin 
            rd_ptr             <= 0;
            en_o               <= 1'b0;
            done_o             <= 1'b0;  
       end

       WRITE: begin
            data_out_temp [0]  <= Re_i_temp[15:8];
            data_out_temp [1]  <= Im_i_temp[15:8];
            data_out_temp [2]  <= Re_i_temp[23:16];
            data_out_temp [3]  <= Im_i_temp[23:16];
       end

       WAIT: begin
            en_o               <= 0;    
       end

       READ: begin
            en_o               <= 1;
            data_out           <= data_out_temp [rd_ptr];
            rd_ptr             <= rd_ptr + 1'b1;
       end

       DONE:begin
            en_o               <= 1'b0;
            done_o             <= 1'b1;
       end
        default: begin 
            rd_ptr             <= 0;
            en_o               <= 1'b0;
            done_o             <= 1'b0;  
       end
    endcase
end
    
endmodule