module  CONTROL2 #(parameter bit_width=29, N = 16, SIZE = 4)(
    input clk,rst_n,

    input flag_start_FFT,

    input signed [bit_width-1:0] Re_1,
    input signed [bit_width-1:0] Im_1,
    input signed [bit_width-1:0] Re_2,
    input signed [bit_width-1:0] Im_2,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,
    output reg        [SIZE:0] wr_ptr,

    output reg              en_wr,
    output                  en_modify,
    output reg              en_add,

    output      [SIZE:0] rd_ptr,
    output reg  [10:0]   rd_ptr_angle, 
    
    output reg en_o_1,
    output reg en_o_2,
    output reg en_o_data,
    output reg finish_FFT
 );
    reg  [SIZE:0] b,i,k;
    reg  [SIZE:0] rd_ptr1;
    reg  [SIZE:0] rd_ptr2;
    reg  [SIZE:0] Out_data_rd_ptr;
    reg  [SIZE:0] Out_data_rd_ptr_temp;
    reg  [SIZE:0] wr_ptr1;
    reg  [SIZE:0] wr_ptr2;
    reg  [3:0]    stage_FFT_temp;
    reg  [3:0]    stage_FFT;
    wire flag_1 = (k < 1<<(stage_FFT-1));
    wire flag_2 = (i < 1<<(SIZE+1'b1-stage_FFT));
    reg  [10:0]   rd_ptr_angle_temp1;
    reg  [10:0]   rd_ptr_angle_temp2;
    reg  back_mem;

    assign en_modify = (stage_FFT_temp >= SIZE)  ;
 //----------------------------------------------------------------------
    reg [8:0] cur_state;
    reg [8:0] next_state;
    reg [8:0] state;
    reg delay;
 //--------------------------------------------------------------
    localparam 
         IDLE     = 9'b0_0000_0001,
         READ     = 9'b0_0000_0010,
         READ1    = 9'b0_0000_0100,
         WRITE1   = 9'b0_0000_1000,
         WRITE2   = 9'b0_0001_0000,
         DELAY    = 9'b0_0100_0000,
         DELAY2   = 9'b0_1100_0000,
         READ2    = 9'b0_1000_0000,
         DONE     = 9'b1_0000_0000;

    assign rd_ptr  = (cur_state == READ)? rd_ptr1 : (cur_state == READ1)? rd_ptr2: Out_data_rd_ptr;
 //--------------------------------------------------------------------        

 always @(posedge clk ) begin
    if (!rst_n) begin
        rd_ptr_angle <=0;
        rd_ptr_angle_temp2    <=0;
    end else begin 
        rd_ptr_angle       <= rd_ptr_angle_temp2;
        rd_ptr_angle_temp2 <= rd_ptr_angle_temp1;
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
				IDLE:
                       if (flag_start_FFT) next_state = READ;
                       else next_state = IDLE;
                READ:   next_state = READ1;
                READ1:  if (stage_FFT == SIZE+1'b1) next_state = DELAY; 
                        else next_state = READ;     
                DELAY: next_state = DELAY2; 
                DELAY2: next_state = READ2;
				READ2: if (Out_data_rd_ptr == N-1 ) next_state = DONE;
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
                DELAY:
                    write_task;
                DELAY2:
                    write_task2;
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
                        b                        <= 0;
                        k                        <= 0;
                        i                        <= 0;   
                        en_o_1                   <= 0;
                        en_o_2                   <= 0;   
                        en_o_data                <= 0; 
                        back_mem                 <= 0;
                        finish_FFT               <= 0;
                        stage_FFT                <= 1;
                        Out_data_rd_ptr          <= 0;
                        Out_data_rd_ptr_temp     <= 0;
                        rd_ptr1                  <= 0;
                        rd_ptr2                  <= 0;
                        wr_ptr1                  <= 0;
                        wr_ptr2                  <= 0;
                        rd_ptr_angle_temp1       <= 0;
                        stage_FFT_temp           <= 1;
                        
        end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        b                    <= 0;
                        i                    <= 0;    
                        k                    <= 0;
                        en_o_1               <= 0;
                        en_o_2               <= 0; 
                        en_o_data            <= 0;
                        back_mem             <= 0;
                        finish_FFT           <= 0;
                        stage_FFT            <= 1;
                        Out_data_rd_ptr      <= 0;
                        Out_data_rd_ptr_temp <= 0;
                        rd_ptr1              <= 0;
                        rd_ptr2              <= 0;
                        wr_ptr1              <= 0;
                        wr_ptr2              <= 0;
                        rd_ptr_angle_temp1    <= 0;
                        stage_FFT_temp       <= 1;
                      end
endtask

//-------------------------read_task-------------------------------
task read_task;
                   begin
                            rd_ptr1            <= (i<<(stage_FFT-1'b1))+k;
                            wr_ptr2            <= rd_ptr2;
                            rd_ptr_angle_temp1  <= k<<(10-stage_FFT);  // 10 PHU THUOC SO LUONG DU LIEU TINH CORDIC 
                            en_o_1             <= 1'b1;  
                            en_o_2             <= 1'b0;    
                            delay              <= 1'b1;
                            back_mem           <= delay;
                            en_add             <= en_o_2 ;
                              
                            if (flag_1) begin       
                                    k          <= k + 1'b1; 
                                    b          <= b+2'd2; 
                            end             
                    end 
endtask
//-------------------------read_task-------------------------------
task read_task1;
                   begin            
                            rd_ptr2          <= rd_ptr1 + (11'd1<<(stage_FFT-1'b1));
                            wr_ptr1          <= rd_ptr1;
                            en_o_2           <= 1'b1;  
                            en_o_1           <= 1'b0; 
                            en_add           <= en_o_2 ;
      
                            stage_FFT_temp <= stage_FFT;

                            if (b == N) begin stage_FFT <= stage_FFT + 1'b1;
                                b            <=0;
                                k            <=0;
                                i            <=0;  
                            end else if (!flag_1) begin
                                k <=0;
                                if (flag_2)  i<=i+2'd2;
                                else         i<=0;     
                                              
                            end 

                    end
endtask
//-------------------------count state-----------------------------------
task write_task;
                    begin
                        en_o_1       <= 0;
                        en_o_2       <= 0;           
                        en_add       <= en_o_2;
                        wr_ptr1      <= rd_ptr1;
                        finish_FFT   <= 1'b1;  
                    end
endtask
//-------------------------count state-----------------------------------
task write_task2;
                    begin
                        wr_ptr2         <= rd_ptr2;
                        back_mem        <= 0;
                        en_add          <= en_o_2;
                        finish_FFT      <= 1'b0;
                    end
endtask

//-------------------------read_task-------------------------------
task read_task2;
                   begin
                        en_o_1                      <= 1'b1; 
                        en_o_data                   <= 1'b1;
                        Out_data_rd_ptr_temp        <= Out_data_rd_ptr_temp + 1'b1;       
                        Out_data_rd_ptr             <= Out_data_rd_ptr_temp;         
                        stage_FFT_temp              <= stage_FFT;   
                    end
endtask
//-------------------------done task-------------------------------

task done_task;
                   begin
                    en_o_1                  <= 0;
                    en_o_2                  <= 0;  
                    Out_data_rd_ptr         <= 0;   
                    Out_data_rd_ptr_temp    <=0;    
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
                                if ((back_mem )) begin
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