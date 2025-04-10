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

    input                              data_in,
    
    output                             data_detect,

    output reg signed [bit_width-1:0]  Re_o,
    output reg signed [bit_width-1:0]  Im_o,

    output reg                         en_o
);


    
   wire       [7:          0]    signal; 
   wire                          data_detect_temp;

   wire       [9:          0] extend_bit_width = {signal[7],signal[7],signal[7],signal[7],signal[7],signal[7],signal[7],signal[7],signal[7],signal[7]};

   reg signed [bit_width-1:0]    Re_o_temp ;
   reg signed [bit_width-1:0]    Im_o_temp ; 
 
   reg        [SIZE:       0]    wr_ptr;
   

   assign data_detect = data_detect_temp;
  //----------------------------------------------------------------
    reg [3:0] cur_state;
    reg [3:0] next_state;

    //--------------------------------------------------------------
    localparam 
         IDLE   = 4'b0001,
         WRITE1 = 4'b0010,
         WRITE2 = 4'b0100,
         READ   = 4'b1000;


//---------------------------------------------------
uart_rx #(.t_1_bit(t_1_bit),
           .t_half_1_bit(t_half_1_bit))
UART_RX (.clk(clk),
          .rst_n(rst_n),
          .rx_i(data_in),

          .data_o(signal),
          .rx_done_o(data_detect_temp)
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
                    if (data_detect_temp) next_state = WRITE1;
                    else           next_state = IDLE; 

            WRITE1: if (data_detect_temp) next_state = WRITE2;
                    else           next_state = WRITE1;

            WRITE2:                next_state = READ;

            READ :                 next_state = IDLE;
            default:               next_state = IDLE;
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
                WRITE1:
                    write_task1;
                WRITE2:
                    write_task2;
                READ: 
                    read_task;
                default: ilde_task;
            endcase
        end
    end
    //-----------------------reset_task---------------------------------
  task reset_task;
      begin
        Re_o_temp         <= 0;
        Im_o_temp         <= 0;
        en_o              <= 0;
      end
 endtask

//----------------------idle task--------------------------------------
 task ilde_task;
      begin 
        Re_o_temp         <= 0;
        Im_o_temp         <= 0;
        en_o              <= 0;
      end
 endtask

//----------------------wrire task--------------------------------------
task write_task1;
        begin
            Re_o_temp  <= {extend_bit_width,signal,6'd0}; 
        end 
                    
endtask
//----------------------wrire task--------------------------------------
task write_task2;
        begin
            Im_o_temp  <= {extend_bit_width,signal,6'd0};
        end 
endtask
//----------------------read task--------------------------------------
task read_task;
      begin
        en_o          <=  1'b1;
        Re_o          <=  Re_o_temp;
        Im_o          <=  Im_o_temp;  
      end
endtask

endmodule