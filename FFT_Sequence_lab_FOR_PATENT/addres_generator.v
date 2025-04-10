module  addres_generator #(parameter stage_FFT = 2, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    input                              start_stage,
    
    output reg                         en_rd,           
    output reg [SIZE-1:0]              rd_ptr,
    output reg [10    :0]              rd_ptr_angle, 
    output                             start_next_stage
 );

localparam IDLE   = 3'b001,
           READ_1 = 3'b010,
           READ_2 = 3'b011,
           DONE   = 3'b100;

reg [2:0]    cur_state,next_state;

reg [SIZE-1:0] i;
reg [stage_FFT-2:0] k;
assign start_next_stage = (rd_ptr == N-1);

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
				IDLE:       if (start_stage)            next_state = READ_1;
                            else                        next_state = IDLE;
				READ_1:                                 next_state = READ_2;
                READ_2:     if (rd_ptr == N-1)          next_state = DONE;
                            else                        next_state = READ_1;
                DONE:                                   next_state = IDLE;
            default:                                    next_state = IDLE;
        endcase
    end

    // 3st always block, the sequential FSM output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
        //    start_next_stage     <= 0;
            i                    <= 0;
            k                    <= 0; 
            en_rd                <= 1'b0;
            rd_ptr               <= 0;
            rd_ptr_angle         <= 0;
        end else begin
            case (next_state)
                IDLE:begin 
         //               start_next_stage     <= 0;
                        k                    <= 0; 
                        i                    <= 0;  
                        en_rd                <= 1'b0;
                        rd_ptr               <= 0;
                        rd_ptr_angle         <= 0;
                    end
                READ_1:begin
                        rd_ptr             <= (i<<(stage_FFT-1))+k;
                        en_rd              <= 1'b1;
                        rd_ptr_angle       <= k << (10-stage_FFT);   
                        k                  <= k +1'd1;
                    end
                READ_2:  begin
                        rd_ptr             <= rd_ptr + (1 << (stage_FFT-1));
                        if (k==0)       i  <= i+2'd2;     
                   end
                DONE: begin  
         //               start_next_stage   <= 1'b1;
                        en_rd              <= 1'b0;
                        rd_ptr               <= 0;
                     end    
                default:begin 
         //               start_next_stage     <= 0;
                        i                    <= 0;
                        en_rd                <= 1'b0;
                        k                    <= 0;
                    end
            endcase
        end
    end

endmodule