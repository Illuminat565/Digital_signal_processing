module  CONTROL2 #(parameter t_1_bit = 5207, bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,

    input                              flag_start_FFT,
    output                             en_modify,
    input                              en_out, 

    output reg       [SIZE:0]          rd_ptr,
    output reg       [10  :0]          rd_ptr_angle, 
    
    output                              en_rd,         
    output                              out_valid, 
    output                              done_o 
 );

    wire start_modify; 

    reg  [SIZE:0] O_data_ptr_delay;
    reg  [SIZE:0] wr_ptr_delay8; 
    reg  [3:0]    stage_FFT_delay;
    wire  [3:0]   stage_FFT_delay2;

     wire       [SIZE-1:0]          rd_ptr1;
     wire       [10    :0]          rd_ptr_angle1; 
     wire       [SIZE-1:0]          rd_ptr2;
     wire       [10    :0]          rd_ptr_angle2; 
     wire       [SIZE-1:0]          rd_ptr3;
     wire       [10    :0]          rd_ptr_angle3; 
     wire       [SIZE-1:0]          rd_ptr4;
     wire       [10    :0]          rd_ptr_angle4; 
     wire       [SIZE-1:0]          rd_ptr5;
     wire       [10    :0]          rd_ptr_angle5; 
     wire       [SIZE-1:0]          rd_ptr6;
     wire       [10    :0]          rd_ptr_angle6; 
     wire       [SIZE-1:0]          rd_ptr7;
     wire       [10    :0]          rd_ptr_angle7; 
     wire       [SIZE-1:0]          rd_ptr8;
     wire       [10    :0]          rd_ptr_angle8; 
     wire        [SIZE-1:0]          rd_ptr9;
 //----------------------------------------------------------------------
    reg [4:0] cur_state;
    reg [4:0] next_state;
    reg [3:0] state;
    
    reg [3:0]  stage_FFT;
    wire start_sec_stage;
    wire start_3th_stage;
    wire start_4th_stage;
    wire start_5th_stage;
    wire start_6th_stage;
    wire start_7th_stage;
    wire start_final_stage;
    wire start_read_stage;

    wire en_rd1;
    wire en_rd2;
    wire en_rd3;
    wire en_rd4;
    wire en_rd5;
    wire en_rd6;
    wire en_rd7;
    wire en_rd8;

    wire out_valid_temp;

 //----------------------------------------------------------------------
 localparam s_stage1 = 4'd1,
            s_stage2 = 4'd2,
            s_stage3 = 4'd3,
            s_stage4 = 4'd4,
            s_stage5 = 4'd5,
            s_stage6 = 4'd6,
            s_stage7 = 4'd7,
            s_stage8 = 4'd8,
            s_stage9 = 4'd9,
            s_done   = 4'd10;


 //--------------------------------------------------------------
    localparam 
         IDLE         = 5'b0_0001,
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

//---------------------------FIrst state-----------------------------------------------------
   addres_1st_generator #(  .N(N), .SIZE(SIZE))addres_1st_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(flag_start_FFT),
     
    .en_rd(en_rd1),  
    .rd_ptr(rd_ptr1),
    .rd_ptr_angle(rd_ptr_angle1), 
    .start_next_stage(start_sec_stage)
 );

    addres_generator #(  .stage_FFT(2),.N(N), .SIZE(SIZE))addres_sec_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_sec_stage),
    
    .rd_ptr(rd_ptr2),
    .en_rd(en_rd2),
    .rd_ptr_angle(rd_ptr_angle2), 
    .start_next_stage(start_3th_stage)
 );

     addres_generator #(  .stage_FFT(3),.N(N), .SIZE(SIZE))addres_3th_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_3th_stage),
    
    .rd_ptr(rd_ptr3),
    .en_rd(en_rd3),
    .rd_ptr_angle(rd_ptr_angle3), 
    .start_next_stage(start_4th_stage)
 );

     addres_generator #(  .stage_FFT(4),.N(N), .SIZE(SIZE))addres_4th_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_4th_stage),
    
    .rd_ptr(rd_ptr4),
    .en_rd(en_rd4),
    .rd_ptr_angle(rd_ptr_angle4), 
    .start_next_stage(start_5th_stage)
 );

     addres_generator #(  .stage_FFT(5),.N(N), .SIZE(SIZE))addres_5th_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_5th_stage),
    
    .rd_ptr(rd_ptr5),
    .en_rd(en_rd5),
    .rd_ptr_angle(rd_ptr_angle5), 
    .start_next_stage(start_6th_stage)
 );

     addres_generator #(  .stage_FFT(6),.N(N), .SIZE(SIZE))addres_6th_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_6th_stage),
    
    .rd_ptr(rd_ptr6),
    .en_rd(en_rd6),
    .rd_ptr_angle(rd_ptr_angle6), 
    .start_next_stage(start_7th_stage)
 );
    addres_generator #(  .stage_FFT(7),.N(N), .SIZE(SIZE))addres_7th_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_7th_stage),
    
    .rd_ptr(rd_ptr7),
    .en_rd(en_rd7),
    .rd_ptr_angle(rd_ptr_angle7), 
    .start_next_stage(start_final_stage)
 );
    final_addres_generator #(  .stage_FFT(8),.N(N), .SIZE(SIZE))addres_final_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_final_stage),
    
    .start_modify(start_modify),
    .rd_ptr(rd_ptr8),
    .en_rd(en_rd8),
    .rd_ptr_angle(rd_ptr_angle8), 
    .start_next_stage(start_read_stage)
 );
    out_addres_generator #(  .t_1_bit(t_1_bit),.N(N), .SIZE(SIZE))out_addres_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_read_stage),
    .en_out(en_out),
    
    .rd_ptr(rd_ptr9),
    .en_rd(out_valid),
    .done_o(done_o)
 );
/*
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state  <= s_stage1;
    end else begin
        case (state)
            s_stage1:
                  begin
                    rd_ptr        <= rd_ptr1;
                    rd_ptr_angle  <= rd_ptr_angle1;
                    en_rd         <= en_rd1; 
                    done_o        <= 0;

                    if (start_sec_stage) state  <= s_stage2;
                    else                 state  <= s_stage1;
                  end
            s_stage2: 
                  begin
                    rd_ptr        <= rd_ptr2;
                    rd_ptr_angle  <= rd_ptr_angle2;
                    en_rd         <= en_rd2; 

                    if (start_3th_stage) state  <= s_stage3;
                    else                 state  <= s_stage2;
                  end
            s_stage3: 
                  begin
                    rd_ptr        <= rd_ptr3;
                    rd_ptr_angle  <= rd_ptr_angle3;
                    en_rd         <= en_rd3; 

                    if (start_4th_stage) state  <= s_stage4;
                    else                 state  <= s_stage3;
                  end
            s_stage4: 
                  begin
                    rd_ptr        <= rd_ptr4;
                    rd_ptr_angle  <= rd_ptr_angle4;
                    en_rd         <= en_rd4; 

                    if (start_5th_stage) state  <= s_stage5;
                    else                 state  <= s_stage4;
                  end
            s_stage5: 
                  begin
                    rd_ptr        <= rd_ptr5;
                    rd_ptr_angle  <= rd_ptr_angle5;
                    en_rd         <= en_rd5; 

                    if (start_6th_stage) state  <= s_stage6;
                    else                 state  <= s_stage5;
                  end
            s_stage6: 
                  begin
                    rd_ptr        <= rd_ptr6;
                    rd_ptr_angle  <= rd_ptr_angle6;
                    en_rd         <= en_rd6; 

                    if (start_7th_stage) state  <= s_stage7;
                    else                 state  <= s_stage6;
                  end
            s_stage7: 
                  begin
                    rd_ptr        <= rd_ptr7;
                    rd_ptr_angle  <= rd_ptr_angle7;
                    en_rd         <= en_rd7;


                    if (start_final_stage) state  <= s_stage8;
                    else                   state  <= s_stage7;
                  end    
            s_stage8: 
                  begin
                    rd_ptr        <= rd_ptr8;
                    rd_ptr_angle  <= rd_ptr_angle8;
                    en_rd         <= en_rd8;

                    if (start_read_stage) state  <= s_stage9;
                    else                  state  <= s_stage8;
                  end  
            s_stage9: 
                  begin
                    en_rd         <= 0;
                    rd_ptr        <= rd_ptr9;
                    out_valid     <= out_valid_temp;

                    if (done_o_temp) state  <= s_done;
                    else        state  <= s_stage9;
                  end   
            s_done: begin
                   done_o         <= 1;
                   state          <= s_stage1;
            end    
            default: state <= s_stage1;
        endcase
    end
    end
*/


assign en_rd =({en_rd1,en_rd2,en_rd3,en_rd4,en_rd5,en_rd6,en_rd7,en_rd8} != 0);

always @(*) begin
    if (en_rd1) begin
        rd_ptr        <= rd_ptr1;
        rd_ptr_angle  <= rd_ptr_angle1;
    end else if (en_rd2) begin
        rd_ptr        <= rd_ptr2;
        rd_ptr_angle  <= rd_ptr_angle2;
    end else if (en_rd3) begin
        rd_ptr        <= rd_ptr3;
        rd_ptr_angle  <= rd_ptr_angle3;
    end else if (en_rd4) begin
        rd_ptr        <= rd_ptr4;
        rd_ptr_angle  <= rd_ptr_angle4;
    end else if (en_rd5) begin
        rd_ptr        <= rd_ptr5;
        rd_ptr_angle  <= rd_ptr_angle5;
    end else if (en_rd6) begin
        rd_ptr        <= rd_ptr6;
        rd_ptr_angle  <= rd_ptr_angle6;
    end else if (en_rd7) begin
        rd_ptr        <= rd_ptr7;
        rd_ptr_angle  <= rd_ptr_angle7;
    end else if (en_rd8) begin
        rd_ptr        <= rd_ptr8;
        rd_ptr_angle  <= rd_ptr_angle8;
    end else if (out_valid)  begin 
        rd_ptr        <= rd_ptr9;
        rd_ptr_angle <= 0;
    end
end




endmodule 