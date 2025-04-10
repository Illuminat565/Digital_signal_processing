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
    input clk,
    input rst_n,

    input data_in,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,
    output reg        [SIZE:0] invert_addr,

    output reg en_o
);
   reg signed [bit_width-1:0] mem_Re [N-1:0];
   reg signed [bit_width-1:0] mem_Im [N-1:0];

   reg [SIZE-1:0] rd_ptr_temp;
    
   wire [7:0] signal; 
   wire en_invert;
   integer i;
   //wire [bit_width-25:0] add_0 = 0;
   //wire [bit_width-25:0] add_1 = ~0;
    
   reg [SIZE+1:0] wr_ptr; 
   reg [SIZE:0] rd_ptr;
  //----------------------------------------------------------------
    reg [3:0] cur_state;
    reg [3:0] next_state;

    //--------------------------------------------------------------
    localparam 
         IDLE  = 4'b0001,
         WRITE = 4'b0010,
         READ  = 4'b0100,
         EMPTY  = 4'b1000;


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
            WRITE:  if (wr_ptr == (N<<1)) next_state = READ; //fedgfkjosegio
                    else next_state = WRITE; 
            READ :  if (rd_ptr==(N+1)) next_state = EMPTY;
                    else next_state = READ;
            EMPTY :  next_state = IDLE;
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
                EMPTY:
                    empty_task;
                default: ilde_task;
            endcase
        end
    end
    //-----------------------reset_task---------------------------------
  task reset_task;
      begin
      rd_ptr        <= 1;
      wr_ptr        <=0;
      Re_o   <=0;
      Im_o  <=0;
      rd_ptr_temp   <=0; 
      en_o          <=0;
      end
 endtask

//----------------------idle task--------------------------------------
 task ilde_task;
      begin
      rd_ptr        <= 1;
      wr_ptr        <=0;
      Re_o   <=0;
      Im_o  <=0;
      rd_ptr_temp   <=0; 
      en_o          <=0;
      end
 endtask

//----------------------wrire task--------------------------------------

task write_task;
      begin
      if (en_invert == 1'b1) begin
        if (wr_ptr < N) begin
                    if (signal[7] == 1'b0)
                         mem_Re [wr_ptr] <= {20'b0000_0000_0000_0000_0000,signal,6'd0};
                    else mem_Re [wr_ptr] <= {20'b1111_1111_1111_1111_1111,signal,6'd0};
                end else begin
                    if (signal[7] == 1'b0)
                         mem_Im [wr_ptr-N] <= {20'b0000_0000_0000_0000_0000,signal,6'd0};
                    else mem_Im [wr_ptr-N] <= {20'b1111_1111_1111_1111_1111,signal,6'd0};
                end
                wr_ptr <= wr_ptr + 1'd1;
        end
      end
endtask
//----------------------read task--------------------------------------
task read_task;
      begin
      en_o        <= 1'b1;
      Re_o        <= mem_Re [rd_ptr_temp];
      Im_o        <= mem_Im [rd_ptr_temp];
      rd_ptr      <= rd_ptr +1'd1;
      invert_addr <= rd_ptr - 1'b1;

      for ( i= 0;i<SIZE;i=i+1 ) begin
        rd_ptr_temp[i] <= rd_ptr[SIZE-i-1];
      end
      end
endtask
// -----------------------done_task-----------------------------------
task empty_task;
      begin
      en_o    <= 1'b0;
      end
endtask

endmodule