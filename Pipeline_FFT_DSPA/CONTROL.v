module  CONTROL #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,

    input                              flag_start_FFT,
    input                              en_out_data,

    input      signed [bit_width-1:0]  Re_1,
    input      signed [bit_width-1:0]  Im_1,
    input      signed [bit_width-1:0]  Re_2,
    input      signed [bit_width-1:0]  Im_2,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,
    output reg        [SIZE       :0]  wr_ptr,

    output reg                         en_wr,
    output                             en_modify,

    output reg       [SIZE:0]          rd_ptr,
    output reg       [10  :0]          rd_ptr_angle, 
    
    output reg                         en_rd,         
    output reg                         finish_FFT,
    output reg                         done_o 
 );
    reg  [SIZE:0] b,i,k;
    reg  [SIZE:0] O_data_ptr_delay;
    reg  [SIZE:0] wr_ptr_delay;
    reg  [SIZE:0] wr_ptr_delay2;
    reg  [3:0]    stage_FFT_delay;
    reg  [3:0]    stage_FFT_delay2;
    reg  [3:0]    stage_FFT;
    reg  [10:0]   tw_ptr_delay1;
    reg  [10:0]   tw_ptr_delay2;
    reg           en_back_mem;

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
    localparam
         WRITE1       = 2'b01,
         WRITE2       = 2'b10;

 //-----------Writing back to memmory is delayed 2 clk with read_clk ----------------------------------        

 always @(posedge clk ) begin
    if (!rst_n) begin
        rd_ptr_angle        <= 0;
        tw_ptr_delay2       <= 0;
        wr_ptr_delay        <= 0;
        wr_ptr_delay2       <= 0;
        stage_FFT_delay     <= 1;
        stage_FFT_delay2    <= 1; 
    end else begin
        tw_ptr_delay2       <= tw_ptr_delay1;
        rd_ptr_angle        <= tw_ptr_delay2;
        stage_FFT_delay     <= stage_FFT;
        stage_FFT_delay2    <= stage_FFT_delay;
        wr_ptr_delay        <= rd_ptr;
        wr_ptr_delay2       <= wr_ptr_delay;     
    end
 end
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
                        en_rd                    <= 0 ; 
                        en_back_mem              <= 0;
                        finish_FFT               <= 0;
                        stage_FFT                <= 1;
                        O_data_ptr_delay         <= 0;
                        rd_ptr                   <= 0;
                        delay                    <= 0;
                        tw_ptr_delay1            <= 0;     
                        done_o                   <= 0;           
        end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        b                    <= 0;
                        i                    <= 0;    
                        k                    <= 0;
                        en_rd                <= 0 ; 
                        en_back_mem          <= 0;
                        finish_FFT           <= 0;
                        stage_FFT            <= 1;
                        O_data_ptr_delay     <= 0;
                        rd_ptr               <= 0;
                        delay                <= 0;
                        tw_ptr_delay1        <= 0;
                        done_o               <= 0; 
                      end
endtask

//-------------------------handle read point for the first input-------------------------------
task read_task;
                   begin
                            rd_ptr             <= (i<<(stage_FFT-1'b1))+k;
                            tw_ptr_delay1      <= k<<(10-stage_FFT);  // 10 PHU THUOC SO LUONG DU LIEU TINH CORDIC 
                            en_rd              <= 1'b1 ;  
                            delay              <= 1'b1;
                            en_back_mem        <= delay;
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
                        en_rd                       <= 1'b1 ; 
                        O_data_ptr_delay            <= O_data_ptr_delay + 1'b1;       
                        rd_ptr                      <= O_data_ptr_delay;   
                        en_back_mem                 <= 0;  
                        finish_FFT                  <= 1'b0;    
                        
                    end
endtask
//--------------------------wait task-----------------------------
task wait_task;
                   begin
                        en_rd                       <= 0; 
                    end
endtask

//-------------------------done task-------------------------------

task done_task;
                   begin
                        en_rd                   <= 0; 
                        O_data_ptr_delay        <= 0;  
                        rd_ptr                  <= 0;  
                        done_o                  <= 1;
                    end
endtask

//------------------------handle to write back to MEM----------------------------
                    always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        en_wr     <= 1'b0;      
                        state     <= WRITE1;
                        wr_ptr    <= 0;

                    end else begin
                                    
                    case (state)
                            WRITE1: begin    
                                if ((en_back_mem )) begin
                                    en_wr        <= 1'b1;   
                                    state        <= WRITE2;
                                    Re_o         <= Re_1; 
                                    Im_o         <= Im_1; 
                                    wr_ptr       <= wr_ptr_delay2;
                                end else begin 
                                    en_wr        <= 1'b0;
                                    state        <= WRITE1;
                                end
                            end
                            WRITE2: begin      
                                    state        <= WRITE1;
                                    Re_o         <= Re_2; 
                                    Im_o         <= Im_2; 
                                    wr_ptr       <= wr_ptr_delay2;
                            end
                        default:    begin
                                    state        <= WRITE1;
                                    en_wr        <= 1'b0;    
                            end 
                    endcase
                    end
                    end

endmodule 
