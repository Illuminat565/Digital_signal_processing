module  new_adress_genarator #(parameter  N = 16, SIZE = 4)(
    input                              clk,rst_n,

    input                              flag_start_FFT,
    input            [3:0]             stage_FFT,

    output                             initial_state,
    output                             next_state_FFT,
    output reg       [SIZE-1:0]        rd_ptr,
    output reg       [10  :0]          rd_ptr_angle, 

    output reg                         en_rd,         
    output reg                         done_o 
 );
 //----------------------------------------------------------------------
    reg       [SIZE-1:0] k;
    reg       [SIZE-1:0] i;
    reg       [SIZE:0] b;
    reg       [SIZE-1:0]   rd_ptr_1, rd_ptr_2;
    reg [6:0] cur_state;
    reg [6:0] next_state;

    wire [SIZE:0] element_number = 1<<(stage_FFT-1);
    wire [SIZE-1:0]       flag_1 = (k == element_number);
    assign next_state_FFT = (b==N); 
 //--------------------------------------------------------------
    localparam 
         IDLE         = 7'b000_0001,
         READ         = 7'b000_0010,
         READ1        = 7'b000_0100,
         DONE         = 7'b100_0000;

//---------------------------------------------------------------------
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
				IDLE:       if (flag_start_FFT)         next_state = READ;
                            else                        next_state = IDLE;
                READ:       if (stage_FFT == SIZE+1)   next_state = DONE;                        
                            else                        next_state = READ1;
                READ1:                                  next_state = READ;    
                DONE:                                   next_state = IDLE;
            default:                                    next_state = IDLE;
        endcase
    end

    // 3st always block, the sequential FSM output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reset_task;
        end else begin
            case (next_state)
                IDLE:
                    idle_task;
				READ:
                    read_task;
                READ1:
                    read_task1;
                DONE:
                    done_task;
                default:
                    idle_task;
            endcase
        end
    end
//---------------reset_task-----------------------------------------
task reset_task;
        begin
                        b                        <= 0;
                        k                        <= 0;
                        i                        <= 0;   
                        en_rd                    <= 0; 
                        done_o                   <= 0;      
        end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        b                    <= 0;
                        i                    <= 0;    
                        k                    <= 0;
                        en_rd                <= 0;
                        done_o               <= 0; 
                      end
endtask

//-------------------------handle read point for the first input-stage-1-------------------------------
task read_task;
                   begin
                            en_rd              <= 1'b1 ;  
                            k                  <= k + 1'b1; 
                            b                  <= b+2'd2;       
                    end 
endtask
//-------------------------handle read point for the second input-------------------------------
task read_task1;
                   begin            
                           
                            if (next_state_FFT) begin            
                                b             <= 0;
                                k             <= 0;
                                i             <= 0;  
                            end else if (flag_1) begin    
                                k             <= 0; 
                                i             <= i+2'd2;                     
                            end 

                    end
endtask
task done_task;
                  begin
                        b                    <= 0;
                        i                    <= 0;    
                        k                    <= 0;
                        en_rd                <= 0;
                        done_o               <= 1; 
                  end
endtask

always @(posedge clk ) begin
    if(next_state == READ) begin
        rd_ptr_1           <= (i<<(stage_FFT-1)) + k;
        rd_ptr_2           <= ((i+1)<<(stage_FFT-1)) + k;
        rd_ptr_angle       <= (k << (10-stage_FFT));  
    end
end

always @(*) begin
    case (next_state)
        READ  : rd_ptr = rd_ptr_2;
        READ1 : rd_ptr = rd_ptr_1;
        default: rd_ptr = 0;
    endcase
end
assign initial_state = (next_state == IDLE);

endmodule 