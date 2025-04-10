module uart_tx #(parameter t_1_bit = 16'd5207)  (
    input clk, 
    input rst_n,
    input en_i,
    input [7:0] data_i,
    output  reg tx_o,
    output  reg tx_done_o
);
//----------------------------------------------------------------
localparam s_idle   = 8'b0000_0001,
           s_start1 = 8'b0000_1000,
           s_start2 = 8'b0001_0000,
           s_wr     = 8'b0010_0000,
           s_stop   = 8'b0100_0000,
           s_done   = 8'b1000_0000;
/*
`ifdef SIMULATION
//This is for simulation
 localparam t_1_bit =9; // from 0 to 9, it is 10;
 `else 
 // localparagram BPS_CNT = CLK_FREQUENCE/BAUD_RATE-1,  (50_000_000/9600)-1=5207;
 localparam t_1_bit = 16'd5207;
 `endif
*/

reg       en_cnt;
reg[15:0] cnt;
reg[7:0]  state;
reg[7:0]  data_r;
reg[3:0]  tx_bits;
    
//--------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <=16'd0;
    end else  if ((en_cnt == 0)||(cnt == t_1_bit))
        cnt <=16'd0;
        else  cnt <= cnt + 16'd1;
end

//------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s_idle;
        tx_o  <= 1'b0;
        data_r <= 8'b0;
        en_cnt <= 1'b0;
        tx_bits <= 4'd0;
        tx_done_o <= 1'b0;
    end else begin
        case (state)
            s_idle:
                  begin
                    tx_bits   <= 4'd0;
                    tx_done_o <= 1'b0;
                    tx_o      <= 1'b0;
                    
                    if (en_i) begin
                        state  <= s_start1;
                        data_r <= data_i;
                        en_cnt <= 1'b1;
                    end else begin
                        en_cnt <= 1'b0;
                        state  <= s_idle;
                    end
                  end
            s_start1: 
                  if(cnt == t_1_bit) begin
                    state <= s_start2;
                  end else begin
                    tx_o <= 1'b1;
                    state <= s_start1;
                  end
            s_start2: 
                  if(cnt == t_1_bit) begin
                    state <= s_wr;
                  end else begin
                    tx_o <= 1'b0;
                    state <= s_start2;
                  end
            s_wr:
                 if (cnt == t_1_bit) begin
                    if (tx_bits == 4'd7) begin
                        state <= s_stop;
                    end else begin
                        tx_bits <= tx_bits + 4'd1;
                        state <= s_wr;
                    end
                 end else begin
                    tx_o <= data_r [tx_bits];
                    state <= s_wr;
                 end  
            s_stop:
                     if (cnt == t_1_bit) begin
                        state <= s_done;
                     end else 
                     begin
                        tx_o <= 1'b1;
                        state <= s_stop;
                     end   
            s_done:
                    if (cnt == t_1_bit)  begin
                        en_cnt     <= 1'b0;
                        tx_done_o  <= 1'b1;
                        state      <= s_idle;
                        tx_o       <= 1'b0;
                    end
            default: state <= s_idle;
        endcase
    end
    end


endmodule