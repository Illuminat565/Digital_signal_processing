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
    input done_FFT,

    output reg [3:0] dig,
    output reg [7:0] seg
);
    
//////////////////////////////////////////////////////////////////////////////////

reg signed [15:0] data_out;

reg display;

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

reg [25:0] count2;
reg [25:0] count3;

//localparam count_param = 26'd200_000; // for simulation
///////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count2 <= 26'd0;
        dig <= 4'b0000;
    end else begin
        count2 <= count2 + 26'd1;
        case (count2)
                    26'd50_000:   dig <= 4'b1110;
                    26'd150_000:  dig <= 4'b1101;
                    26'd250_000:  dig <= 4'b1011;
                    26'd350_000:  dig <= 4'b0111;
        endcase     
         if (count2 == 26'd450_000)  count2 <= 26'd0;
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
        COUNT:     if (done_FFT) next_state = DATA_PROC;      
                   else         next_state = COUNT;
        DATA_PROC: if (display) next_state = DISPLAY;
                   else next_state = DATA_PROC;
         
        DISPLAY:   if (flag_1sec) next_state = COUNT;  
                   else next_state =DISPLAY;
                 
        default:  begin
                   next_state = IDLE;
                  end
    endcase
end

// 3rd always block, the sequential FSM output
 always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data[0] <= 4'd0;
        data[1] <= 4'd0;
        data[2] <= 4'd0;
        data[3] <= 4'd0;
        count3  <= 26'd0;
        flag_1sec <= 1'b0;
        data_out <=0;
        display <= 0;
        count <= 0;
        cnt   <= 0;  
    end else begin
        case (cur_state)
            IDLE :  begin
                        data[0] <= data[0];
                        data[1] <= data[1];
                        data[2] <= data[2];
                        data[3] <= data[3];
                        count <= 0;
                        display <= 0;
                        data_out <=0;
                    end 

            COUNT: 
                  
                   if (cnt  < 99)  cnt <= cnt + 1'b1;  
                   else begin
                        data_out <= data_out + 1'd1; 
                        cnt      <= 0;  
                   end
                   

            DATA_PROC:  begin
                if (count == data_out) display <= 1'b1;
                else begin
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
            end
            DISPLAY:
            if (count3 == count_param) begin
                count3 <= 26'd0;
                flag_1sec <= 1'b1;
                display <= 1'b0;
            end else begin 
                count3 <= count3 + 1'd1;
                flag_1sec <= 1'b0;
                count <= 0;
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
                26'd50_000:   begin
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
               26'd150_000: begin
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
            26'd250_000: begin
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
            26'd350_000: begin
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