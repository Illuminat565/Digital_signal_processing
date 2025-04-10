module  CONTROL1 #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    
    input                              data_detect,
    input                              en_new_count,

    input                              en_wr_in,
    input  signed    [bit_width-1  :0] Re_i,
    input  signed    [bit_width-1  :0] Im_i,

    output reg       [SIZE     -1  :0] adr_ptr1,
    output reg       [SIZE     -1  :0] adr_ptr2,
    output reg                         en_back_mem,

    output reg                         en_rd,
    output reg       [SIZE     -1  :0] rd_ptr,
    output reg       [SIZE     -2  :0] rd_ptr_angle, 
    output reg                         en_rd_angle,

    output reg                         en_wr_o,
    output reg       [SIZE     -1  :0] wr_ptr,

    output reg signed [bit_width-1  :0] Re_o,
    output reg signed [bit_width-1  :0] Im_o,

    output reg                         done_o 
 );

    reg  [SIZE-1:0] i;
    reg  [SIZE-2:0] k;
    reg  [SIZE-1:0] wr_ptr_temp;
    reg             start_fft;
    reg             count;
    reg             count_temp;      
 //   reg  [SIZE-1:0] adr_ptr1, adr_ptr2;
//    wire          flag_1    = (k == 1<<(stage_FFT-1));
//    wire          flag_1    = (k == 1<<(SIZE - stage_FFT));
 //-------------------------------------------------------------------------------
 //----------------------------------------------------------------------
    reg [3:0] cur_state;
    reg [6:0] next_state;
    reg [3:0] initial_state;

    
 //--------------------------------------------------------------
    localparam 
         IDLE         = 4'b0001,
         READ         = 4'b0010,
         READ1        = 4'b0100,
         DONE_stage1  = 4'b1000;
    localparam
         WRITE_TO_MEM = 4'b0010,
         WAIT         = 4'b0100;

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
				IDLE:       if (start_fft)              next_state = READ;
                            else                        next_state = IDLE;
                READ:       next_state = READ1;

                READ1:      if (rd_ptr == N-1)          next_state = DONE_stage1;
                            else                        next_state = READ;     
                DONE_stage1:                            next_state = IDLE; 
				
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
                DONE_stage1:
                    done_task;
                default:
                    idle_task;
            endcase
        end
    end
//---------------reset_task-----------------------------------------
task reset_task;
                    begin
                        i                        <= 0;   
                        en_rd                    <= 0; 
                        en_back_mem              <= 0;
                        rd_ptr                   <= 0;
                        done_o                   <= 0;   
                    //    k                        <= 0;        
                    end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        i                    <= 0;    
                        en_rd                <= 0; 
                        rd_ptr               <= 0;
                        adr_ptr1             <= 0;
                        adr_ptr2             <= 0;
                        en_back_mem          <= 0;
                        done_o               <= 0; 
                      //  k                    <= 0;
                      end
endtask

//-------------------------handle read point for the first input------------
task read_task;
                    begin
                        rd_ptr           <=    (i << (SIZE - 4));
                        adr_ptr1         <=    (i << (SIZE - 4));
                    //    k                <=    k+1;
                    //    k                <=    0;
                        en_rd            <=    1'b1;  

                    end 
endtask
//-------------------------handle read point for the second input-----------
task read_task1;
                   begin            

                        rd_ptr           <=    adr_ptr1+  1;
                        adr_ptr2         <=    rd_ptr     +  1;
                        en_rd            <=    1'b1;
                        en_back_mem      <=    1'b1; 

                     //   if (k == 0)  
                        i   <= i+2'd2;                        

                    end
endtask

//-------------------------done task-------------------------------

task done_task;
                   begin
                        en_back_mem             <= 1'b0; 
                        en_rd                   <= 0; 
                        rd_ptr                  <= 0;  
                        done_o                  <= 1;
                    end
endtask

//------------------------handle read angle data------------------------------------

                    always @(posedge clk) begin
                        if (!rst_n) begin
                        count           <= 0;  
                        count_temp      <= 0; 
                        rd_ptr_angle    <= 0;
                        en_rd_angle     <= 0;
                        end else if (en_rd) begin
                            count      <= count +1'b1;
                            count_temp <= count;
                            if (count_temp == 1) rd_ptr_angle  <= rd_ptr_angle + 1'b1;
                            en_rd_angle   <= 1'b1;
                        end else begin 
                            en_rd_angle   <= 0;
                            count         <= 0;  
                            rd_ptr_angle  <= 0;
                            count_temp    <= 0;
                        end
                    end

//------------------------handle to write to next RAM----------------------------
                    always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        en_wr_o       <= 0;      
                        wr_ptr        <= 0;
                        wr_ptr_temp   <= 0;
                        initial_state <= IDLE;
                        start_fft     <= 1'b0;
                    end else begin    
                        case (initial_state)
                            IDLE : begin
                                start_fft    <= 1'b0;
                                en_wr_o      <= 0;   
                                wr_ptr       <= 0;
                                wr_ptr_temp  <= 0;
                                if (data_detect) initial_state <= WRITE_TO_MEM;
                                else             initial_state <= IDLE;
                            end 
                            WRITE_TO_MEM: begin
                                if ((en_wr_in )) begin
                                en_wr_o      <= 1'b1;   

                                 for (k = 0  ; k <= SIZE - 1  ; k = k+1 ) begin
                                    wr_ptr[k] <= wr_ptr_temp [SIZE-1-k];
                                 end

                           //     wr_ptr       <= wr_ptr_temp;
                                Re_o         <= Re_i;
                                Im_o         <= Im_i;
                                wr_ptr_temp  <= wr_ptr_temp + 1'b1;
                                end else begin 
                                en_wr_o      <= 1'b0;
                                if (wr_ptr == N-1) begin 
                                initial_state <= WAIT;
                                start_fft     <= 1'b1;
                                end else initial_state <= WRITE_TO_MEM;
                                end 
                            end
                            WAIT: 
                            begin
                                if (en_new_count)  initial_state <= IDLE;
                                else             initial_state <= WAIT;  
                                start_fft     <= 1'b0;
                            end
                            default: begin
                                en_wr_o      <= 0;   
                                wr_ptr       <= 0;
                                wr_ptr_temp  <= 0;
                                start_fft    <= 1'b0;
                            end
                        endcase
                    end 
                    end
endmodule 
