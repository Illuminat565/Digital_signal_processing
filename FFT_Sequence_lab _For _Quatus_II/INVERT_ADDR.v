 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : INVERT_ADDR
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    : 
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
module INVERT_ADDR #(parameter bit_width    = 32, 
                               N            = 16, 
                               SIZE         = 4,
                               t_1_bit      = 16'd5207,
                               t_half_1_bit = 16'd2603) (
    input                              clk,
    input                              rst_n,

    input             [7:          0]  signal, 
    input                              en_invert,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,
    output reg        [SIZE-1:0]       invert_addr,
    output                             start_flag,
    output reg                         en_o
);
   reg signed [bit_width-1:0] data_mem [1:0];
   reg        [SIZE-1:     0] rd_ptr_temp;
   reg        [bit_width-17 :0] extend_bit_width; 
   integer i;
   integer j;
   reg [SIZE-1   : 0] rd_ptr;
   reg [SIZE-1   : 0] shift_rd_ptr;

    reg signed [bit_width-1:0]  Re_o_temp;
    reg signed [bit_width-1:0]  Im_o_temp;
    reg invert;
  //----------------------------------------------------------------
    reg [5:0] cur_state;
    reg [5:0] next_state;

    //--------------------------------------------------------------
    localparam 
         IDLE    = 6'b000001,
         WRITE_1 = 6'b000010,
         WRITE_2 = 6'b000100,
         READ    = 6'b001000,
         WAIT    = 6'b010000,
         DONE    = 6'b100000;
   
   
assign   start_flag  = (shift_rd_ptr == N-1);

//---------------------------------------------------

 always @(*) begin
   for (j=0; j < bit_width-16 ; j = j+1) begin
        extend_bit_width [j] = signal[7];
    end
 end 

//--------------------------------------------------


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
                     if (en_invert) next_state = WRITE_1;
                     else next_state = IDLE; 

            WRITE_1: if (en_invert) next_state = WRITE_2; //fedgfkjosegio
                     else next_state = WRITE_1; 
            WRITE_2: next_state = READ;
            READ :   next_state = DONE;
            DONE :   next_state = IDLE;
            default: 
                 next_state = IDLE;
        endcase
    end

    // 3st always block, the sequential FSM output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reset_task;
        end else begin
            case (next_state)
                IDLE:
                    ilde_task;
                WRITE_1:
                    write_1_task;
                WRITE_2:
                    write_2_task;
                READ: 
                    read_task;
                DONE:
                    done_task;
                default: ilde_task;
            endcase
        end
    end
    //-----------------------reset_task---------------------------------
  task reset_task;
      begin
      en_o          <= 0;
      invert      <= 0;
      end
 endtask

//----------------------idle task--------------------------------------
 task ilde_task;
      begin
      en_o          <= 0;
      invert      <= 0;
      end
 endtask

//----------------------wrire task 1--------------------------------------

task write_1_task;
                begin
                    Re_o_temp   <=  {extend_bit_width,signal,8'd0}; 
                end 
                    
endtask
//----------------------wrire task 2--------------------------------------

task write_2_task;
                begin
                    Im_o_temp   <=  {extend_bit_width,signal,8'd0}; 
                    invert      <=  1;
                    
                end 
                    
endtask
//----------------------read task--------------------------------------
task read_task;
      begin
        invert      <= 0;
        en_o        <= 1'b1;
        Re_o        <= Re_o_temp;
        Im_o        <= Im_o_temp;
      end
endtask
// -----------------------done_task-----------------------------------
task done_task;
      begin
      
      en_o        <= 1'b0;
      end
endtask

always @(*) begin
    for ( i= 0;i<SIZE;i=i+1 ) begin
            invert_addr[i] <= shift_rd_ptr [SIZE-i-1];
    end
end


always @(posedge clk ) begin
    if (!rst_n) begin
        rd_ptr <= 0; 
    end
    if (invert) begin
        rd_ptr        <= rd_ptr +1'd1;
        shift_rd_ptr  <= rd_ptr;
    end else if (shift_rd_ptr == N-1) begin
        shift_rd_ptr  <= 0;
    end
end

endmodule