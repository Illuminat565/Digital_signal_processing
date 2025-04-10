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
module INVERT_ADDR2 #(parameter bit_width    = 32, 
                               N            = 16, 
                               SIZE         = 4,
                               t_1_bit      = 16'd5207,
                               t_half_1_bit = 16'd2603) (
    input clk,
    input rst_n,

    input data_in,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,
    output reg        [SIZE:0]         invert_addr,
    output reg                         start_flag,
    output reg                         en_o
);
   reg signed [bit_width-1:0] data_mem [1:0];

   reg [SIZE-1:0] rd_ptr_temp;
    
   wire    [7:0] signal; 
   wire    en_invert;
   wire    negative_signed = (signal[7] == 1'b0);
   integer i;
    
   reg [SIZE+1 : 0] wr_ptr; 
   reg [SIZE   : 0] rd_ptr;
  //----------------------------------------------------------------
    reg [4:0] cur_state;
    reg [4:0] next_state;

    //--------------------------------------------------------------
    localparam 
         IDLE  = 5'b00001,
         WRITE = 5'b00010,
         READ  = 5'b00100,
         WAIT  = 5'b01000,
         DONE  = 5'b10000;


//---------------------------------------------------
uart_rx2 #(.t_1_bit(t_1_bit),
           .t_half_1_bit(t_half_1_bit))
UART_RX2 (.clk(clk),
          .rst_n(rst_n),
          .rx_i(data_in),

          .data_o(signal),
          .rx_done_o(en_invert)
);

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
                    if (en_invert == 1'b1) next_state = WRITE;
                    else next_state = IDLE; 
            WRITE:  if (wr_ptr == 2'd2) next_state = READ; //fedgfkjosegio
                    else next_state = WAIT; 
            READ :   next_state = WAIT;
            WAIT :  if (rd_ptr == N) next_state = DONE;
                    else if (en_invert == 1'b1) next_state = WRITE;
                    else next_state = WAIT;
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
                READ: 
                    read_task;
                WAIT:
                    wait_task;
                DONE:
                    done_task;
                default: ilde_task;
            endcase
        end
    end
    //-----------------------reset_task---------------------------------
  task reset_task;
      begin
      rd_ptr        <= 0;
      wr_ptr        <= 0;
      rd_ptr_temp   <= 0; 
      en_o          <= 0;
      start_flag    <= 0;
      invert_addr   <= 0;
      end
 endtask

//----------------------idle task--------------------------------------
 task ilde_task;
      begin
      rd_ptr        <= 0;
      wr_ptr        <= 0;
      rd_ptr_temp   <= 0; 
      en_o          <= 0;
      start_flag    <= 0;
      invert_addr   <= 0; 
      end
 endtask

//----------------------wrire task--------------------------------------

task write_task;
                begin
                    if (negative_signed)
                         data_mem [wr_ptr] <= {20'b0000_0000_0000_0000_0000,signal,6'd0};
                    else data_mem [wr_ptr] <= {20'b1111_1111_1111_1111_1111,signal,6'd0};

                    wr_ptr <= wr_ptr + 1'd1; 
                end 
                    
endtask
//----------------------read task--------------------------------------
task read_task;
      begin
        en_o        <= 1'b1;
        Re_o        <= data_mem [0];
        Im_o        <= data_mem [1];
        rd_ptr      <= rd_ptr +1'd1;
        wr_ptr  <= 1'b0;
       
        invert_addr <= rd_ptr_temp;
      end
endtask
//---------------------wait_task---------------------------------------
task wait_task;
    begin
        en_o    <= 1'b0;
        for ( i= 0;i<SIZE;i=i+1 ) begin
            rd_ptr_temp[i] <= rd_ptr[SIZE-i-1];
        end
    end
endtask
// -----------------------done_task-----------------------------------
task done_task;
      begin
      en_o        <= 1'b0;
      rd_ptr      <= 1'b0;
      start_flag  <= 1'b1;
      end
endtask

endmodule