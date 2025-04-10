module test #(parameter t_1_bit = 5207,
                   t_half_1_bit = 2603) 
 (
    input clk,
    input rst_n,

    input data_in,

    output reg [23:0] Re_o,
    output reg [23:0] Im_o,
    output reg        en_o
);
wire [7:0] signal;
reg [7:0] data_out_temp [3:0];
wire done_o;
reg [3:0] cur_state;
reg [3:0] next_state;
reg [2:0] wr_ptr;


  localparam 
          IDLE    = 4'b0001,
          WRITE   = 4'b0010,
          WAIT    = 4'b0011,
          COMBINE = 4'b0100;

uart_rx #(.t_1_bit(t_1_bit),
           .t_half_1_bit(t_half_1_bit))
UART_RX (.clk(clk),
          .rst_n(rst_n),
          .rx_i(data_in),

          .data_o(signal),
          .rx_done_o(done_o)
);

  
//----------------state machin----------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= IDLE;
    end else cur_state <= next_state;
  end

//-------------combination logic---------------

always @(*) begin
    case (cur_state)
        IDLE: if (done_o) next_state     <=  WRITE;
              else        next_state     <=  IDLE;
        WRITE:            next_state     <=  WAIT;
        WAIT: if (wr_ptr == 4)  
                          next_state     <=  COMBINE;
              else if (done_o)       
                          next_state     <=  WRITE;  
              else        next_state     <=  WAIT;          
        COMBINE:          next_state     <=  IDLE;
        default:          next_state     <=  IDLE;
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin 
            wr_ptr             <= 0;     
            en_o               <= 0;  
    end else case (cur_state)
       IDLE : begin
            wr_ptr             <= 0;
            en_o               <= 0; 
       end

       WRITE: begin
            data_out_temp [wr_ptr]  <= signal;
            wr_ptr                  <= wr_ptr +1;
       end

       WAIT: begin
            en_o               <= 0;    
       end

       COMBINE: begin
            Re_o              <= {data_out_temp [2],data_out_temp [0],8'd0};
            Im_o              <= {data_out_temp [3],data_out_temp [1],8'd0};
            en_o              <= 1;  
       end

        default: begin
           wr_ptr             <= 0;
           en_o               <= 0; 
       end
    endcase
end



    
endmodule