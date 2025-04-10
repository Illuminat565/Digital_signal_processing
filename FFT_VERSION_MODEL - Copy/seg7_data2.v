///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.24.01
// Design Name    : seg7_data
// Module name    : seg7_data
// Project_name   : FPGA seg7_data
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    :
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------

module seg7_data2  (
    input clk,
    input rst_n,
    
    input en_FFT,
    input finish_FFT,

    output reg [3:0] dig,
    output reg [7:0] seg
);
    
//////////////////////////////////////////////////////////////////////////////////

reg signed [10:0] data_out;

reg [15:0] count;
reg [15:0] cnt;
reg flag_1sec;

 reg [2:0]cur_state;
 reg [2:0]next_state;

 reg [3:0] data [3:0];

 localparam IDLE      = 3'b001,
            COUNT     = 3'b111,
            DATA_PROC = 3'b010,
            DISPLAY   = 3'b100;

 localparam count_param = 26'd49_999_999; // for run on board

reg [18:0] count2;

//localparam count_param = 26'd200_000; // for simulation
///////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count2 <= 19'd0;
        dig    <= 4'b0000;
    end else begin
        case (count2)
                    19'd1000:  dig <= 4'b1110;
                    19'd2000:  dig <= 4'b1101;
                    19'd3000:  dig <= 4'b1011;
                    19'd4000:  dig <= 4'b0111;
        endcase    
         if  (count2 == 19'd5000)  count2 <= 19'd0;
         else                      count2 <= count2 + 1'd1;
        end   
    end

/////////////////////////////////////////////////////////////////////////////

// 1st always block, sequemtial state trasition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= IDLE;
    end else begin
        cur_state <= next_state;
    end
end

// 2st always block, combinational condition judgement
always @(*) begin
    case (cur_state)
        IDLE :     if (en_FFT)  next_state = COUNT;
                   else         next_state = IDLE;
        COUNT:     if (finish_FFT) next_state = DATA_PROC;      
                   else         next_state = COUNT;
        DATA_PROC: if (count == data_out) next_state = IDLE;
                   else next_state = DATA_PROC;                
        default:  begin
                   next_state = IDLE;
                  end
    endcase
end

// 3rd always block, the sequential FSM output
 always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data[0]     <= 4'd0;
        data[1]     <= 4'd0;
        data[2]     <= 4'd0;
        data[3]     <= 4'd0;
        data_out    <= 0;
        count       <= 0;
        cnt         <= 0;  
    end else begin
        case (cur_state)

            IDLE :  begin
                        count    <= 0;
                        data_out <=0;
                    end 

            COUNT: 
                  
               //    if (cnt  < 9)  cnt <= cnt + 1'b1;  
               //    else
                    begin
                        data_out <= data_out + 1'd1; 
                        cnt      <= 0;  
                    end
                   
            DATA_PROC:  begin
                        count <= count + 1'd1;

                        data [0] <= data [0] + 4'd1; // the first bit
                        if (data [0] == 4'd9) begin
                          data [0] <= 4'd0;
                          data [1] <= data [1] + 4'd1;          // the second bit
                                if (data [1] == 4'd9) begin
                                data [1] <= 4'd0;
                                data [2] <= data [2] +4'd1;          // the third bit
                                    if (data [2] == 4'd9) begin
                                    data [2] <= 4'd0;
                                    data [3] <= data [3] + 4'd1;          // the fourth bit

                                        if (data [3] == 4'd9) begin
                                        data [3] <= 4'd0;

                                       end
                                end
                          end
                        end
                        end
        endcase
    end
    
 end
 
        //--------------------------------------------------

        always @ (posedge clk or negedge rst_n)
        if (!rst_n) begin
            seg = 8'hc0;
        end else begin

            case (count2)
                18'd1000:   begin
                    case (data [0])
                4'h0 : seg = 8'hc0; //��ʾ"0"
                4'h1 : seg = 8'hf9; //��ʾ"1"
                4'h2 : seg = 8'ha4; //��ʾ"2"
                4'h3 : seg = 8'hb0; //��ʾ"3"
                4'h4 : seg = 8'h99; //��ʾ"4"
                4'h5 : seg = 8'h92; //��ʾ"5"
                4'h6 : seg = 8'h82; //��ʾ"6"
                4'h7 : seg = 8'hf8; //��ʾ"7"
                4'h8 : seg = 8'h80; //��ʾ"8"
                4'h9 : seg = 8'h90; //��ʾ"9"
                4'ha : seg = 8'h88; //��ʾ"a"
                4'hb : seg = 8'h83; //��ʾ"b"
                4'hc : seg = 8'hc6; //��ʾ"c"
                4'hd : seg = 8'ha1; //��ʾ"d"
                4'he : seg = 8'h86; //��ʾ"e"
                4'hf : seg = 8'h8e; //��ʾ"f"
                endcase
            end
               18'd2000: begin
                    case (data [1])
                4'h0 : seg = 8'hc0; //��ʾ"0"
                4'h1 : seg = 8'hf9; //��ʾ"1"
                4'h2 : seg = 8'ha4; //��ʾ"2"
                4'h3 : seg = 8'hb0; //��ʾ"3"
                4'h4 : seg = 8'h99; //��ʾ"4"
                4'h5 : seg = 8'h92; //��ʾ"5"
                4'h6 : seg = 8'h82; //��ʾ"6"
                4'h7 : seg = 8'hf8; //��ʾ"7"
                4'h8 : seg = 8'h80; //��ʾ"8"
                4'h9 : seg = 8'h90; //��ʾ"9"
                4'ha : seg = 8'h88; //��ʾ"a"
                4'hb : seg = 8'h83; //��ʾ"b"
                4'hc : seg = 8'hc6; //��ʾ"c"
                4'hd : seg = 8'ha1; //��ʾ"d"
                4'he : seg = 8'h86; //��ʾ"e"
                4'hf : seg = 8'h8e; //��ʾ"f"
                endcase
            end
            18'd3000: begin
                    case (data [2])
                4'h0 : seg = 8'hc0; //��ʾ"0"
                4'h1 : seg = 8'hf9; //��ʾ"1"
                4'h2 : seg = 8'ha4; //��ʾ"2"
                4'h3 : seg = 8'hb0; //��ʾ"3"
                4'h4 : seg = 8'h99; //��ʾ"4"
                4'h5 : seg = 8'h92; //��ʾ"5"
                4'h6 : seg = 8'h82; //��ʾ"6"
                4'h7 : seg = 8'hf8; //��ʾ"7"
                4'h8 : seg = 8'h80; //��ʾ"8"
                4'h9 : seg = 8'h90; //��ʾ"9"
                4'ha : seg = 8'h88; //��ʾ"a"
                4'hb : seg = 8'h83; //��ʾ"b"
                4'hc : seg = 8'hc6; //��ʾ"c"
                4'hd : seg = 8'ha1; //��ʾ"d"
                4'he : seg = 8'h86; //��ʾ"e"
                4'hf : seg = 8'h8e; //��ʾ"f"
                endcase
            end
            18'd4000: begin
                    case (data [3])
                4'h0 : seg = 8'hc0; //��ʾ"0"
                4'h1 : seg = 8'hf9; //��ʾ"1"
                4'h2 : seg = 8'ha4; //��ʾ"2"
                4'h3 : seg = 8'hb0; //��ʾ"3"
                4'h4 : seg = 8'h99; //��ʾ"4"
                4'h5 : seg = 8'h92; //��ʾ"5"
                4'h6 : seg = 8'h82; //��ʾ"6"
                4'h7 : seg = 8'hf8; //��ʾ"7"
                4'h8 : seg = 8'h80; //��ʾ"8"
                4'h9 : seg = 8'h90; //��ʾ"9"
                4'ha : seg = 8'h88; //��ʾ"a"
                4'hb : seg = 8'h83; //��ʾ"b"
                4'hc : seg = 8'hc6; //��ʾ"c"
                4'hd : seg = 8'ha1; //��ʾ"d"
                4'he : seg = 8'h86; //��ʾ"e"
                4'hf : seg = 8'hbf; //��ʾ"f"
                endcase
            end
            endcase

        end
        
     

endmodule