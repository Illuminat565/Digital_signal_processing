module  out_addres_generator #(parameter  t_1_bit = 5207, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    input                              start_stage,
    input                              en_out,
    
    output reg                         en_rd,
    output reg [SIZE-1:0]              rd_ptr,

    output reg                         done_o
 );
localparam IDLE   = 3'b001,
           READ_1 = 3'b010,
           READ_2 = 3'b011,
           DONE   = 3'b100,
           WAIT_1 = 3'b101,
           WAIT_2 = 3'b110;

reg [2:0]    cur_state,next_state;


 // 1st always blocks, sequentail state transition
     always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state <= IDLE;
        end else begin
            cur_state <= next_state;
        end
     end
    

 // 2st always block, combination condition judgement
    always @(*) begin
        case (cur_state)
				IDLE:    if (start_stage)               next_state = READ_1;
                         else                           next_state = IDLE;

				READ_1:                                 next_state = WAIT_1;

                WAIT_1:  if (rd_ptr == N-1)             next_state = DONE;     
                         else if (en_out)               next_state = READ_2; 
                         else                           next_state = WAIT_1; 

                READ_2:                                 next_state = WAIT_1;

                DONE:                                   next_state = IDLE;

            default:                                    next_state = IDLE;
        endcase
    end

    // 3st always block, the sequential FSM output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_o               <= 0;
            en_rd                <= 1'b0;
            rd_ptr               <= 0;
        end else begin
            case (next_state)
                IDLE:begin 
                        done_o               <= 0;
                        en_rd                <= 1'b0;
                        rd_ptr               <= 0;
                    end
                READ_1:begin
                        en_rd              <= 1'b1;
                        rd_ptr             <= 0; 
                    end
                WAIT_1:  begin
                         en_rd             <= 1'b0;
                         end 
                READ_2:  begin
                         en_rd              <= 1'b1;
                         rd_ptr             <= rd_ptr + 1'b1; 
                         end     
                DONE: begin  
                        done_o             <= 1'b1;
                        en_rd              <= 1'b0;
                     end    
                default:begin 
                        done_o               <= 0;
                        en_rd                <= 1'b0;
                    end
            endcase
        end
    end
endmodule