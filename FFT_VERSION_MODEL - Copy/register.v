 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : register
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    :
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------
module register #(parameter bit_width=32, N=16, SIZE = 4) (
    input clk,rst_n,

    input signed [8:0] real_in_data,
    input signed [8:0] image_in_data,

    input en_register,

    output reg signed [bit_width-1:0] real_o_data,
    output reg signed [bit_width-1:0] image_o_data,
    output reg        [SIZE:0] inx_point,

    output reg full_o,
    output reg en_o,
    output reg empty_o
);
   reg signed [bit_width-1:0] mem_x [N-1:0];
   reg signed [bit_width-1:0] mem_y [N-1:0];
    
   integer i;

   reg [10:0] count;
   reg [SIZE:0]  wr_ptr,rd_ptr;
   reg [SIZE-1:0] rd_ptr_temp;
  //----------------------------------------------------------------
    reg [4:0] cur_state;
    reg [4:0] next_state;

    //--------------------------------------------------------------
    localparam 
         IDLE  = 5'b0_0001,
         WRITE = 5'b0_0010,
         COUNT = 5'b0_0100,
         FULL  = 5'b0_1100,
         READ  = 5'b0_1000,
         DONE  = 5'b1_0000;

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
                    if (en_register) next_state = WRITE;
                    else next_state = IDLE;
            WRITE : if (wr_ptr==N)  next_state = FULL; 
                    else next_state = COUNT;        
            COUNT:  if (count == 1000) next_state = WRITE;
                    else next_state = COUNT;
            FULL:   next_state = READ;
            READ :  if (rd_ptr==(N+1)) next_state = DONE;
                    else next_state = READ; 
            DONE :  next_state = IDLE;
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
                WRITE:
                    write_task;
                COUNT:
                    count_task;
                FULL:
                    full_task;
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
      count <= 0;
      wr_ptr <= 4'd0;
      en_o = 1'b0;
      rd_ptr <= 1;
      rd_ptr_temp <=0; 
      full_o <= 1'b0;
      empty_o <= 1'b0;
      end
 endtask

//----------------------idle task--------------------------------------
 task ilde_task;
      begin
      count <= 0;
      wr_ptr <= 4'd0;
      en_o <= 1'b0;
      rd_ptr <= 1;
      rd_ptr_temp <=0; 
      full_o <= 1'b0;
      empty_o <= 1'b0;
      end
 endtask
//------------------------write_task-----------------------------------

task write_task;
    begin
        if (real_in_data >= 0)

          mem_x [wr_ptr] <= {19'd0,real_in_data,4'd0};

        else mem_x [wr_ptr] <= {19'b111_1111_1111_1111_1111,real_in_data,4'd0};

        if (image_in_data >= 0)

          mem_y [wr_ptr] <= {19'd0,image_in_data,4'd0};

        else mem_y [wr_ptr] <= {19'b111_1111_1111_1111_1111,image_in_data,4'd0};   

             wr_ptr  <= wr_ptr +1'd1;
             count <= 0;
    end
endtask
//----------------------count_task--------------------------------------
task count_task;
     count <= count + 1'd1;
endtask
//----------------------read task--------------------------------------
task full_task;
      begin
      full_o <= 1'b1;
      end
endtask
//----------------------read_task--------------------------------------
task read_task;
      begin
      full_o <= 1'b0;
      en_o = 1'b1;
      real_o_data  <= mem_x [rd_ptr_temp];
      image_o_data <= mem_y [rd_ptr_temp];
      rd_ptr       <= rd_ptr +1'd1;
      inx_point    <= rd_ptr - 1'b1;

      for ( i= 0;i<SIZE;i=i+1 ) begin
        rd_ptr_temp[i] <= rd_ptr[SIZE-i-1];
      end
      end
endtask
// -----------------------done_task-----------------------------------
task done_task;
      begin
      empty_o <= 1'b1;
      en_o   <= 1'b0;
      end
endtask
endmodule