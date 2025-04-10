module  CONTROL_norm #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,

    input                              flag_start_FFT,
    input                              en_out_data,
    output                             en_modify,

    output reg       [SIZE:0]          rd_ptr,
    output reg       [10  :0]          rd_ptr_angle, 
    
    output reg                         en_rd,         
    output reg                         finish_FFT,
    output reg                         out_valid, 
    output reg                         done_o 
 );
    reg  [SIZE:0] b,i,k;
    reg  [SIZE:0] O_data_ptr_delay;
    reg  [SIZE:0] wr_ptr_delay8; 
    reg  [3:0]    stage_FFT_delay;
    wire  [3:0]    stage_FFT_delay2;

    reg  [3:0]    stage_FFT;

    wire          flag_1    = (k >= 1<<(stage_FFT-1));
    assign        en_modify = (stage_FFT_delay2 >= SIZE)  ;
 //----------------------------------------------------------------------
    reg [6:0] cur_state;
    reg [6:0] next_state;
    reg [1:0] state;
    reg       delay;

    
 //--------------------------------------------------------------
    localparam 
         IDLE         = 7'b000_0001,
         READ         = 7'b000_0010,
         READ1        = 7'b000_0100,
         READ_DONE    = 7'b000_1000,
         WAIT         = 7'b001_0000,
         OUT_DATA     = 7'b010_0000,
         DONE         = 7'b100_0000;

 //-----------Writing back to memmory is delayed 2 clk with read_clk ----------------------------------        

     shift_register # ( .width (4), .depth (4)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(stage_FFT),
         .out_data(stage_FFT_delay2)
  );

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
                READ:       next_state = READ1;
                READ1:      if (stage_FFT == SIZE+1'b1) next_state = READ_DONE;
                            else                        next_state = READ;     
                READ_DONE:                              next_state = OUT_DATA; 
				OUT_DATA:                               next_state = WAIT;
                WAIT:       if (!en_out_data)           next_state = WAIT;
                            else if (rd_ptr == N)
                                                        next_state = DONE;
                            else                        next_state = OUT_DATA;
                            
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
                READ_DONE:
                    read_finish;
                OUT_DATA:
                    out_data_task;
                WAIT: 
                    wait_task;
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
                        out_valid                <= 1'b0; 
                        finish_FFT               <= 0;
                        stage_FFT                <= 1;
                        O_data_ptr_delay         <= 0;
                        rd_ptr                   <= 0;
                        rd_ptr_angle             <= 0;     
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
                        out_valid            <= 1'b0;  
                        finish_FFT           <= 0;
                        stage_FFT            <= 1;
                        O_data_ptr_delay     <= 0;
                        rd_ptr               <= 0;
                        delay                <= 0;
                        rd_ptr_angle        <= 0;
                        done_o               <= 0; 
                      end
endtask

//-------------------------handle read point for the first input-stage-1-------------------------------
task read_task;
                   begin
                            rd_ptr             <= (i<<(stage_FFT-1'b1))+k;

                            if (stage_FFT >= SIZE) rd_ptr_angle       <= (k << (8-stage_FFT))+ 128;  
                            else                   rd_ptr_angle       <= (k << (8-stage_FFT)) ;  

                            en_rd              <= 1'b1 ;  
                            k                  <= k + 1'b1; 
                            b                  <= b+2'd2;       
                    end 
endtask
//-------------------------handle read point for the second input-------------------------------
task read_task1;
                   begin            
                            rd_ptr           <= rd_ptr + (1<<(stage_FFT-1'b1));
                            if (b == N) begin 
                                stage_FFT     <= stage_FFT + 1'b1;
                                b             <= 0;
                                k             <= 0;
                                i             <= 0;  
                            end else if (flag_1) begin
                                k             <= 0;      
                                i             <= i+2'd2;                     
                            end 

                    end
endtask


//-------------------------finish reading-----------------------------------
task read_finish;
                    begin
                        rd_ptr       <= 0;
                        en_rd        <= 0 ; 
                        finish_FFT   <= 1'b1;  
                    end
endtask

//-------------------------read_task-------------------------------
task out_data_task;
                   begin
                        out_valid                   <= 1'b1 ; 
                        O_data_ptr_delay            <= O_data_ptr_delay + 1'b1;       
                        rd_ptr                      <= O_data_ptr_delay;   
                        finish_FFT                  <= 1'b0;     
                        
                    end
endtask
//--------------------------wait task-----------------------------
task wait_task;
                   begin
                        out_valid                   <= 1'b0 ; 
                    end
endtask

//-------------------------done task-------------------------------

task done_task;
                   begin
                        out_valid               <= 1'b0 ; 
                        O_data_ptr_delay        <= 0;  
                        rd_ptr                  <= 0;  
                        done_o                  <= 1;
                    end
endtask

endmodule 