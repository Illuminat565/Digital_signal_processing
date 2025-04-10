module  CONTROL #(parameter bit_width=29, N = 16, SIZE = 4)(
    input clk,rst_n,

    input flag_start_FFT,

    input signed [bit_width-1:0] Re_1,
    input signed [bit_width-1:0] Im_1,
    input signed [bit_width-1:0] Re_2,
    input signed [bit_width-1:0] Im_2,

    input                back_mem,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,
    output reg        [SIZE:0] wr_ptr,
    output reg                 en_wr,

    output reg  [3:0]    stage_FFT,
    output reg  [3:0]    stage_FFT_temp,

    output      [SIZE:0] rd_ptr,
    output reg  [10:0]   rd_ptr_angle, 
    output reg delay,
    
    output reg  [25:0]   count,
    output reg en_o,
    output reg done_o
 );
    reg  [SIZE:0] b,i,k;
    reg  [SIZE:0] rd_ptr1;
    reg  [SIZE:0] rd_ptr2;
    reg  [SIZE:0] rd_ptr3;
    reg  [SIZE:0] wr_ptr1;
    reg  [SIZE:0] wr_ptr2;
    wire flag_1 = (k < 1<<(stage_FFT-1));
    wire flag_2 = (i < 1<<(SIZE+1'b1-stage_FFT));
    reg  [10:0]   rd_ptr_angle_temp;

 //----------------------------------------------------------------------
    reg [8:0] cur_state;
    reg [8:0] next_state;
    reg [8:0] state;
 //--------------------------------------------------------------
    localparam 
         IDLE     = 9'b0_0000_0001,
         READ     = 9'b0_0000_0010,
         READ1    = 9'b0_0000_0100,
         WRITE1   = 9'b0_0000_1000,
         WRITE2   = 9'b0_0001_0000,
         STAGE    = 9'b0_0010_0000,
         DELAY    = 9'b0_0100_0000,
         DELAY2   = 9'b0_1100_0000,
         READ2    = 9'b0_1000_0000,
         DONE     = 9'b1_0000_0000;

    assign rd_ptr  = (cur_state == READ)? rd_ptr1 : (cur_state == READ1)? rd_ptr2: rd_ptr3;
 //--------------------------------------------------------------------        

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
				IDLE:
                       if (flag_start_FFT) next_state = READ;
                       else next_state = IDLE;
                READ:   next_state = READ1;
                READ1:  if (stage_FFT == SIZE+1'b1) next_state = DELAY; 
                        else next_state = READ;     
                DELAY: next_state = DELAY2; 
                DELAY2: next_state = READ2;
				READ2: if (rd_ptr3 == N-1 ) next_state = DONE;
                       else next_state = READ2;
                DONE:  next_state = IDLE;
            default:   next_state = IDLE;
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
                STAGE:
                    count_stage;
                DELAY:
                    delay_task;
                DELAY2:
                    delay_task2;
                READ2:
                    read_task2;
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
                        b            <= 0;
                        k            <= 0;
                        i            <= 0;   
                        en_o         <= 0;
                        done_o       <= 0;
                        stage_FFT    <= 1'b1;
                        rd_ptr3      <=11'b111_1111_1111;
                        rd_ptr1      <= 0;
                        rd_ptr2      <= 0;
                        wr_ptr1      <= 0;
                        wr_ptr2      <= 0;
                        rd_ptr_angle_temp <=0;
                        stage_FFT_temp<=1;
                        delay <= 1'b0;
                        count <= 0;
                        
        end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        b            <= 0;
                        i            <= 0;    
                        k            <= 0;
                        en_o         <= 0;
                        done_o       <= 0;
                        stage_FFT    <= 1;
                        rd_ptr3      <=11'b111_1111_1111;
                        stage_FFT_temp<=1;
                        delay <= 1'b0;
                        count <= 0;
                      end
endtask

//-------------------------read_task-------------------------------
task read_task;
                   begin
                            rd_ptr1       <= (i<<(stage_FFT-1'b1))+k;
                            rd_ptr_angle_temp  <= k<<(10-stage_FFT);  // 10 PHU THUOC SO LUONG DU LIEU TINH CORDIC 
                            en_o           <= 1'b1;      

                            if (flag_1) begin       
                                    k <= k + 1'b1; 
                                    b <= b+2'd2; 
                            end   

                             wr_ptr2     <= rd_ptr2;  
                             count <= count + 1'b1;
                             

                            
                    end
endtask
//-------------------------read_task-------------------------------
task read_task1;
                   begin
                            rd_ptr_angle   <= rd_ptr_angle_temp;
                            rd_ptr2        <= rd_ptr1 + (11'd1<<(stage_FFT-1'b1));
                            wr_ptr1        <= rd_ptr1;
                            count <= count + 1'b1;
      
                            stage_FFT_temp <= stage_FFT;

                            if (b == N) begin stage_FFT <= stage_FFT + 1'b1;
                                b         <=0;
                                k         <=0;
                                i         <=0;  
                            end else if (!flag_1) begin
                                k <=0;
                                if (flag_2) i<=i+2'd2;
                                else i<=0;     
                                              
                            end 

                    end
endtask
//-------------------------count state-----------------------------------
task count_stage;
                    begin
                        stage_FFT <= stage_FFT + 1'b1;
                        rd_ptr3   <= 11'b111_1111_1111;
                        en_o      <= 0;
                        b         <=0;
                        k         <=0;
                        i         <=0;  
                    end
endtask
//-------------------------count state-----------------------------------
task delay_task;
                    begin
                        en_o    <= 1'b0; 
                        delay   <= 1'b1;
                        wr_ptr1 <= rd_ptr1;
                        count <= count + 1'b1;
                    end
endtask
//-------------------------count state-----------------------------------
task delay_task2;
                    begin
                        delay   <= 1'b1;
                        wr_ptr2 <= rd_ptr2;
                        count <= count + 1'b1;
                    end
endtask

//-------------------------read_task-------------------------------
task read_task2;
                   begin
                        en_o         <= 1'b1; 
                        rd_ptr3      <= rd_ptr3 + 1'b1;  
                        delay   <= 1'b0;      
                        done_o <= 1'b1;    
                        stage_FFT_temp <= stage_FFT;   
                    end
endtask
//-------------------------done task-------------------------------

task done_task;
                   begin
                    en_o    <= 0;
                    done_o  <= 1'b1;   
                    rd_ptr3 <= 11'b111_1111_1111;       
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
                     if ((back_mem && stage_FFT_temp <= SIZE)||delay) begin
                        en_wr    <=  1'b1;   
                        state    <= WRITE2;
                        Re_o     <= Re_1; 
                        Im_o     <= Im_1; 
                        wr_ptr   <= wr_ptr1;
                     end else begin 
                        en_wr    <= 1'b0;
                        state    <= WRITE1;
                     end
                end
                WRITE2: begin      
                        state    <= WRITE1;
                        Re_o     <= Re_2; 
                        Im_o     <= Im_2; 
                        wr_ptr   <= wr_ptr2;
                end
            default:    begin
                        state    <= WRITE1;
                        en_wr    <= 1'b0;    
                end 
           endcase
        end
    end

endmodule 
