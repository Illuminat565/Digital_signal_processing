module  CONTROL7 #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,

    input           [SIZE-1       :0] adr_ptr1,
    input           [SIZE-1       :0] adr_ptr2,   
    input                             en_back_mem,         

    output reg      [SIZE-1       :0] adr_ptr1_o,
    output reg      [SIZE-1       :0] adr_ptr2_o,   
    output reg                        en_back_mem_o, 

    output reg                         en_rd,
    output reg       [SIZE-1:0]        rd_ptr,
    output reg       [SIZE-8:0]        rd_ptr_angle, 
    output reg                         en_rd_angle,

    output reg                         en_wr,
    output reg       [SIZE-1       :0] wr_ptr1,
    output reg       [SIZE-1       :0] wr_ptr2,
    
    output reg                         done_o 
 );
    reg  [SIZE-1:0] i;
  //  reg             en_back_mem;   
  // wire          flag_1    = (k >= 1<<(stage_FFT-1));
    reg  [SIZE-8:0] k,k_delay,k_delay2,k_delay3;
    reg  [SIZE-1:0] b;

    reg  [SIZE-1:0] rd_ptr_delay;

 //-------------------------------------------------------------------------------
 //----------------------------------------------------------------------
    reg [6:0] cur_state;
    reg [6:0] next_state;
    reg [1:0] state;
    
 //--------------------------------------------------------------
    localparam 
         IDLE         = 7'b000_0001,
         READ         = 7'b000_0010,
         READ1        = 7'b000_0100,
         DONE_stage1  = 7'b100_0000;
    localparam
         WRITE1       = 2'b01,
         WRITE2         = 2'b10;

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
				IDLE:       if (wr_ptr2 == N/2+1)            next_state = READ;
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
                        en_back_mem_o            <= 0;
                        rd_ptr                   <= 0; 
                        adr_ptr1_o               <= 0;
                        done_o                   <= 0;   
                        k                        <= 0;        
                    end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        i                    <= 0;    
                        en_rd                <= 0 ; 
                        rd_ptr               <= 0;
                        adr_ptr2_o           <= 0;
                        en_back_mem_o        <= 0;
                        done_o               <= 0; 
                        k                    <= 0;
                      end
endtask

//-------------------------handle read point for the first input------------
task read_task;
                    begin
                        rd_ptr           <=    (i << (SIZE - 7))+k;
                        adr_ptr1_o       <=    (i << (SIZE - 7))+k;
                        k                <=    k+1;
                        en_rd            <=    1'b1;  
                        
                    end 
endtask
//-------------------------handle read point for the second input-----------
task read_task1;
                   begin            

                        rd_ptr           <=    adr_ptr1_o +   (1<<(SIZE-7));
                        adr_ptr2_o       <=    rd_ptr     +   (1<<(SIZE-7));
                        en_rd            <=    1'b1;
                        en_back_mem_o    <=    1'b1; 

                        if (k == 0)  i   <= i+2'd2;                     

                        
                    end
endtask

//-------------------------done task-------------------------------

task done_task;
                   begin
                        en_rd                   <= 0; 
                        rd_ptr                  <= 0;  
                        done_o                  <= 1;
                    end
endtask

//---------------------------------------------------------------------------
always @(posedge clk) begin
    k_delay        <= k;
    k_delay2       <= k_delay;
    rd_ptr_angle   <= k_delay2;
    en_rd_angle    <= en_rd;
end

//------------------------handle to write to next RAM----------------------------
                    always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        en_wr     <= 1'b0;      
                        wr_ptr1   <= 0;
                        wr_ptr2   <= 0;
                        state     <= WRITE1;
                    end else begin
                        case (state)
                            WRITE1: begin    
                                if ((en_back_mem )) begin
                                    en_wr        <= 1'b1;  
                                    wr_ptr1      <= adr_ptr1;
                                    state        <= WRITE2;
                                end else begin 
                                    en_wr        <= 1'b0;
                                end
                            end
                            WRITE2:  begin 
                                   state        <= WRITE1;
                                   wr_ptr2      <= adr_ptr2;
                                   en_wr        <= 1'b0;
                            end
                            default: state     <= WRITE1;
                        endcase                    
                            end 

                    end

endmodule 