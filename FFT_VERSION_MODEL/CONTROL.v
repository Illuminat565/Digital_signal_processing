module  CONTROL #(parameter bit_width=29, N = 16, SIZE = 4)(
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


    reg  [SIZE-1:0] i1;
    reg  [SIZE-1:0] i2;
    reg  [SIZE-1:0] i3;
    reg  [SIZE-1:0] i4;
    reg  [SIZE-1:0] i5;
    reg  [SIZE-1:0] i6;
    reg  [SIZE-1:0] i7;
    reg  [SIZE-1:0] i8;

    reg        k1;
    reg        k2;
    reg  [1:0] k3;
    reg  [2:0] k4;
    reg  [3:0] k5;
    reg  [4:0] k6;
    reg  [5:0] k7;
    reg  [6:0] k8;

    reg start_modify; 

    reg  [SIZE:0] O_data_ptr_delay;
    reg  [SIZE:0] wr_ptr_delay8; 
    reg  [3:0]    stage_FFT_delay;
    wire  [3:0]   stage_FFT_delay2;
    wire          next_stage_FFT = (rd_ptr == N-1);

 //----------------------------------------------------------------------
    reg [4:0] cur_state;
    reg [4:0] next_state;
    reg [1:0] state;
    reg       delay;

    
 //--------------------------------------------------------------
    localparam 
         IDLE         = 5'b0_0001,
         STAGE_1_R_1  = 5'b0_0010,
         STAGE_1_R_2  = 5'b0_0011,
         STAGE_2_R_1  = 5'b0_0100,
         STAGE_2_R_2  = 5'b0_0101,
         STAGE_3_R_1  = 5'b0_0110,
         STAGE_3_R_2  = 5'b0_0111,
         STAGE_4_R_1  = 5'b0_1000,
         STAGE_4_R_2  = 5'b0_1001,
         STAGE_5_R_1  = 5'b0_1010,
         STAGE_5_R_2  = 5'b0_1011,
         STAGE_6_R_1  = 5'b0_1100,
         STAGE_6_R_2  = 5'b0_1101,
         STAGE_7_R_1  = 5'b0_1110,
         STAGE_7_R_2  = 5'b0_1111,
         STAGE_8_R_1  = 5'b1_0000,
         STAGE_8_R_2  = 5'b1_0001,
         READ_DONE    = 5'b1_0010,
         WAIT         = 5'b1_0011,
         OUT_DATA     = 5'b1_0100,
         DONE         = 5'b1_0101;

 //-----------Writing back to memmory is delayed 2 clk with read_clk ----------------------------------        

     shift_register # ( .width (1), .depth (3)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(start_modify),
         .out_data(en_modify)
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
				IDLE:       if (flag_start_FFT)         next_state = STAGE_1_R_1;
                            else                        next_state = IDLE;

                STAGE_1_R_1:                            next_state = STAGE_1_R_2; 
                STAGE_1_R_2: if (next_stage_FFT)        next_state = STAGE_2_R_1;
                             else                       next_state = STAGE_1_R_1;                           

                STAGE_2_R_1:                            next_state = STAGE_2_R_2; 
                STAGE_2_R_2: if (next_stage_FFT)        next_state = STAGE_3_R_1;
                             else                       next_state = STAGE_2_R_1;  

                STAGE_3_R_1:                            next_state = STAGE_3_R_2; 
                STAGE_3_R_2: if (next_stage_FFT)        next_state = STAGE_4_R_1;
                             else                       next_state = STAGE_3_R_1;  

                STAGE_4_R_1:                            next_state = STAGE_4_R_2; 
                STAGE_4_R_2: if (next_stage_FFT)        next_state = STAGE_5_R_1;
                             else                       next_state = STAGE_4_R_1;  

                STAGE_5_R_1:                            next_state = STAGE_5_R_2; 
                STAGE_5_R_2: if (next_stage_FFT)        next_state = STAGE_6_R_1;
                             else                       next_state = STAGE_5_R_1;  

                STAGE_6_R_1:                            next_state = STAGE_6_R_2; 
                STAGE_6_R_2: if (next_stage_FFT)        next_state = STAGE_7_R_1;
                             else                       next_state = STAGE_6_R_1;  

                STAGE_7_R_1:                            next_state = STAGE_7_R_2; 
                STAGE_7_R_2: if (next_stage_FFT)        next_state = STAGE_8_R_1;
                             else                       next_state = STAGE_7_R_1;  

                STAGE_8_R_1:                            next_state = STAGE_8_R_2; 
                STAGE_8_R_2: if (next_stage_FFT)        next_state = READ_DONE;
                             else                       next_state = STAGE_8_R_1;  

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
				STAGE_1_R_1:
                    read_task11;
                STAGE_1_R_2:
                    read_task12;
				STAGE_2_R_1:
                    read_task21;
                STAGE_2_R_2:
                    read_task22;
				STAGE_3_R_1:
                    read_task31;
                STAGE_3_R_2:
                    read_task32;
				STAGE_4_R_1:
                    read_task41;
                STAGE_4_R_2:
                    read_task42;
				STAGE_5_R_1:
                    read_task51;
                STAGE_5_R_2:
                    read_task52;
				STAGE_6_R_1:
                    read_task61;
                STAGE_6_R_2:
                    read_task62;
				STAGE_7_R_1:
                    read_task71;
                STAGE_7_R_2:
                    read_task72;
				STAGE_8_R_1:
                    read_task81;
                STAGE_8_R_2:
                    read_task82;
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
                        k1                        <= 0;
                        i1                        <= 0;   
                        k2                        <= 0;
                        i2                        <= 0;
                        k3                        <= 0;
                        i3                        <= 0;
                        k4                        <= 0;
                        i4                        <= 0;
                        k5                        <= 0;
                        i5                        <= 0;
                        k6                        <= 0;
                        i6                        <= 0;
                        k7                        <= 0;
                        i7                        <= 0;
                        k8                        <= 0;
                        i8                        <= 0;
                        start_modify             <= 1'b0;
                        en_rd                    <= 0; 
                        out_valid                <= 1'b0; 
                        finish_FFT               <= 0;
                        O_data_ptr_delay         <= 0;
                        rd_ptr                   <= 0;
                        rd_ptr_angle             <= 0;     
                        done_o                   <= 0;           
        end
endtask
//-------------------------idle task-------------------------------

task idle_task;
                     begin
                        k1                        <= 0;
                        i1                        <= 0;   
                        k2                        <= 0;
                        i2                        <= 0;
                        k3                        <= 0;
                        i3                        <= 0;
                        k4                        <= 0;
                        i4                        <= 0;
                        k5                        <= 0;
                        i5                        <= 0;
                        k6                        <= 0;
                        i6                        <= 0;
                        k7                        <= 0;
                        i7                        <= 0;
                        k8                        <= 0;
                        i8                        <= 0;
                        start_modify              <= 1'b0;
                        en_rd                <= 0;
                        out_valid            <= 1'b0;  
                        finish_FFT           <= 0;
                        O_data_ptr_delay     <= 0;
                        rd_ptr               <= 0;
                        delay                <= 0;
                        rd_ptr_angle        <= 0;
                        done_o               <= 0; 
                      end
endtask

//-------------------------handle read point for the first input-stage-1-------------------------------
task read_task11;
                   begin
                            rd_ptr             <= i1;
                            rd_ptr_angle       <= 0;  
                            en_rd              <= 1'b1 ;      
                    end 
endtask
//-------------------------handle read point for the second input-------------------------------
task read_task12;
                   begin            
                            rd_ptr             <= rd_ptr + 1;
                            i1                 <= i1+2'd2;
                    end
endtask


//-------------------------handle read point for the first input-stage-2-------------------------------
task read_task21;
                   begin
                            rd_ptr             <= (i2<<1)+k2;
                            rd_ptr_angle       <= k2 << 6;  
                            k2                 <= k2 + 1'b1;      
                    end 
endtask
//-------------------------handle read point for the second input ------------------------------
task read_task22;
                   begin            
                            rd_ptr            <= rd_ptr + 2;
                           if (k2 == 0)  i2   <= i2+2'd2;
                    end
endtask


//-------------------------handle read point for the first input -stage-3--------------------------------
task read_task31;
                   begin
                            rd_ptr             <= (i3<<2)+k3;
                            rd_ptr_angle       <= k3 << 5 ;  
                            k3                 <= k3 + 1'b1;     
                    end 
endtask
//-------------------------handle read point for the second input-------------------------------
task read_task32;
                   begin            
                            rd_ptr             <= rd_ptr + 4;
                            if (k3 == 0)  i3   <= i3+2'd2;
                    end
endtask

//-------------------------handle read point for the first input -stage-4--------------------------------
task read_task41;
                   begin
                            rd_ptr             <= (i4<<3)+k4;
                            rd_ptr_angle       <= k4 << 4;  
                            k4                 <= k4 + 1'b1;    
                    end 
endtask
//-------------------------handle read point for the second input --------------------------------
task read_task42;
                   begin            
                            rd_ptr             <= rd_ptr + 8;
                            if (k4 == 0)  i4   <= i4+2'd2;

                    end
endtask


//-------------------------handle read point for the first input -stage-5--------------------------------
task read_task51;
                   begin
                            rd_ptr             <= (i5<<4)+k5;
                            rd_ptr_angle       <= (k5 << 3) ;  
                            k5                 <= k5 + 1'b1;   
                    end 
endtask
//-------------------------handle read point for the second input -------------------------------
task read_task52;
                   begin            
                            rd_ptr             <= rd_ptr + 16;
                            if (k5 == 0)  i5   <= i5+2'd2;

                    end
endtask

//-------------------------handle read point for the first input -stage-6--------------------------------
task read_task61;
                   begin
                            rd_ptr             <= (i6<<5)+k6;
                            rd_ptr_angle       <= k6 << 2 ;  
                            k6                 <= k6 + 1'b1;      
                    end 
endtask
//-------------------------handle read point for the second input -------------------------------
task read_task62;
                   begin            
                            rd_ptr             <= rd_ptr + 32;
                            if (k6 == 0)  i6   <= i6+2'd2;

                    end
endtask

//-------------------------handle read point for the first input -stage-7--------------------------------
task read_task71;
                   begin
                            rd_ptr             <= (i7<<6)+k7;
                            rd_ptr_angle       <= k7 << 1 ;  
                            k7                 <= k7 + 1'b1;    
                    end 
endtask
//-------------------------handle read point for the second input -------------------------------
task read_task72;
                   begin            
                            rd_ptr             <= rd_ptr + 64;
                            if (k7 == 0)  i7   <= i7+2'd2;

                    end
endtask
//-------------------------handle read point for the first input -stage-8--------------------------------
task read_task81;
                   begin
                            rd_ptr             <= (i8<<7)+k8;
                            rd_ptr_angle       <= k8 + 128;  
                            k8                 <= k8 + 1'b1;    
                            start_modify       <= 1'b1;
                    end 
endtask
//-------------------------handle read point for the second input -------------------------------
task read_task82;
                   begin            
                            rd_ptr           <= rd_ptr + 128;
                            if (k8 == 0)     i8<= i8+2'd2;

                    end
endtask


//-------------------------finish reading-----------------------------------
task read_finish;
                    begin
                        rd_ptr       <= 0;
                        en_rd        <= 0 ; 
                        finish_FFT   <= 1'b1;  
                        start_modify <= 1'b0;
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
