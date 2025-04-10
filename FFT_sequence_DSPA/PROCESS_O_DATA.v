module PROCESS_O_DATA # (parameter bit_width = 28)(
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
//----------------state machin----------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= IDLE;
    end else cur_state <= next_state;
  end

//-------------combination logic---------------

always @(*) begin
    case (cur_state)
        IDLE: if (en_wr)  next_state     <=  WRITE;
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
            data_out_temp [0]  <= 0;
            data_out_temp [1]  <= 0;
            data_out_temp [2]  <= 0;
            data_out_temp [3]  <= 0;    
            rd_ptr             <= 0;
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
            done_o             <= 1'b0;  
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

       DONE:begin
            en_o               <= 1'b0;
            done_o             <= 1'b1;
       end
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