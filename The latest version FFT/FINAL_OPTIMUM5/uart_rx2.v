module uart_rx2 #(parameter bit_width = 8, N = 32, SIZE = 5)(
    input clk,
    input rst_n,
    input rx_i,
    output reg [bit_width-1:0] data_o,
    output reg rx_done_o
);
//------------------------------------------------
localparam s_idle  = 5'b00001,
           s_start = 5'b00010,
           s_rd    = 5'b00100,
           s_stop  = 5'b01000,
           s_done  = 5'b10000;

reg [bit_width-1:0] data_temp;

//localparagram BPS_CNT = CLK_FREQUENCE/BAUD_RATE-1,  (50_000_000/9600)-1=5207;
localparam t_1_bit = 16'd5207;   //16'd5207
localparam t_half_1_bit = 16'd2603;  //16'd2603
//This is for simulation
//localparam t_1_bit = 9;         //from 0 to 9, it is 10;
//localparam t_half_1_bit = 4;    //from 0 to 4, it is 5;
//--------------------------------------------------
reg en_cnt;
reg[15:0] cnt;
reg[4:0]  state;
reg[bit_width-1:0]  rx_bits;
integer i;

//--------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)  cnt <= 16'd0;
    else if ((en_cnt == 0) || (cnt == t_1_bit))
                 cnt <= 16'd0;
    else cnt <= cnt + 16'd1;
end

//---------------------------------------------------
reg rx_0, rx_1, rx_2, rx_3;

//---------------------------------------------------
always @(posedge clk or negedge rst_n)    
      if (!rst_n) begin
        rx_0 <= 1'b0;
        rx_1 <= 1'b0;
        rx_2 <= 1'b0;
        rx_3 <= 1'b0;
      end else begin
        rx_3 <= rx_i;
        rx_2 <= rx_3;
        rx_1 <= rx_2;
        rx_0 <= rx_1;
      end    
//----------------------------------------------------
wire start_flag;
assign start_flag = rx_0 & rx_1 & (~rx_2) & (~rx_3); //detect the negedge;

//----------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state     <= s_idle;
        en_cnt    <= 1'b0;
        data_o    <= 8'd0;
        rx_bits   <= 8'd0;
        rx_done_o <= 1'b0;
    end else begin
        case (state)
            s_idle:
                  begin
                    rx_bits   <= 8'b0;
                    rx_done_o <= 1'b0;

                    if (start_flag) begin   // detect the negedge
                        en_cnt <= 1'b1;
                        state  <= s_start;
                    end else begin
                      en_cnt <= 1'b0;
                      state  <= s_idle;
                    end
                  end 
            s_start: 
                  if (cnt == t_half_1_bit) 
                  if (rx_i == 1'b0)
                     state <= s_rd;     //this is the valid start signal
                  else 
                     state <= s_idle;   //this is the invalid start signal
            s_rd:
                if (rx_bits == 8'd8)  state <= s_done; 
                else if (cnt == t_half_1_bit) begin
                    data_temp [rx_bits] <= rx_i;
                    rx_bits          <= rx_bits + 8'd1;
                    state            <= s_rd;  
                end
            s_done:
                    begin
                        en_cnt    <= 1'b0;
                        rx_done_o <= 1'b1;
                        data_o    <= data_temp;
                        state     <= s_idle;                
                    end
            default: state <= s_idle;
        endcase
    end
end


endmodule