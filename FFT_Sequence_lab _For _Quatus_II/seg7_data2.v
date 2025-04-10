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

module  seg7_data2 #(parameter bit_width = 34, N=32, SIZE = 5) (
    input                          clk,
    input                          rst_n,
    
    input      [3:0]               key,

    input                          en_FFT,
    input                          finish_FFT,
    input                          done_all,
    
    input signed [bit_width -1: 0] Re_in,
    input signed [bit_width -1: 0] Im_in,
    input                          en_comp,
	 
    output reg [        7:0]       HEX0,  // HEX[7] aka dp are not connected to FPGA at DE1 board
    output reg [        7:0]       HEX1,
    output reg [        7:0]       HEX2,
    output reg [        7:0]       HEX3,
    output reg [3:0]               led    
);
    
//////////////////////////////////////////////////////////////////////////////////
reg  signed [26:0] data_out;

 wire signed [7:0] re_o_temp = Re_in [bit_width-1:bit_width-8];
 wire signed [7:0] im_o_temp = Im_in [bit_width-1:bit_width-8];


 reg [1:0] cur_state;
 reg [1:0] next_state;

 reg         [3:0]   data       [3:0];
 reg signed  [3:0]   chanel     [3:0]; 
 reg signed  [3:0]   max_chanel [3:0]; 
 reg         [3:0]   data_seg   [3:0]; 

 reg signed  [16:0]  A,Amax;
 reg         [1 :0]  state;
 reg         [18:0]  count2;
 reg         [2:0 ]  state_seg;

 localparam          IDLE          = 2'b01,
                     DATA_PROC     = 2'b10;
 localparam 
                     DEFINE_CHANEL = 2'b11;
 localparam          
                     RESET         = 3'b001,
                     TIME          = 3'b010,
                     MAX_CHANEL    = 3'b100;


//----------------------------------------------------------------------
/*always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state     <= IDLE;     
        A         <= 0;
        chanel[0] <= -1;
        chanel[1] <= 0;
        chanel[2] <= 0;
        chanel[3] <= 0;
    end else 
       case (state)   
        IDLE:  
            if (en_FFT) begin
                A         <= 0;
                chanel[0] <= -1;
                chanel[1] <= 0;
                chanel[2] <= 0;
                chanel[3] <= 0;
                state     <= DEFINE_CHANEL;
            end
        DEFINE_CHANEL:  
            begin
                if (done_all) state     <= IDLE;
                else if (en_comp) begin

                        A  <=  re_o_temp*re_o_temp + im_o_temp*im_o_temp;

                        chanel [0] <= chanel [0] + 4'd1; // the first bit
                        if (chanel [0] == 4'd9) begin
                          chanel [0] <= 4'd0;
                          chanel [1] <= chanel [1] + 4'd1;          // the second bit
                                if (chanel [1] == 4'd9) begin
                                chanel [1] <= 4'd0;
                                chanel [2] <= chanel [2] +4'd1;          // the third bit
                                    if (chanel [2] == 4'd9) begin
                                    chanel [2] <= 4'd0;
                                    chanel [3] <= chanel [3] + 4'd1;          // the fourth bit
                                        if (chanel [3] == 4'd9) begin
                                        chanel [3] <= 4'd0;
                                       end
                                end
                          end
                        end 
                end
            end
            default:  state  <=  IDLE;
        endcase     
    end   
    


 always @(posedge clk or negedge rst_n) begin
    if (!rst_n)          begin
        Amax          <= 0;
        max_chanel[0] <= 0;
        max_chanel[1] <= 0;
        max_chanel[2] <= 0;
        max_chanel[3] <= 0;
                
    end else if (en_FFT) begin 
        Amax          <= 0;
        max_chanel[0] <= 0;
        max_chanel[1] <= 0;
        max_chanel[2] <= 0;
        max_chanel[3] <= 0;

    end else if(A>Amax)  begin 
        Amax          <= A;
        max_chanel[0] <= chanel[0];
        max_chanel[1] <= chanel[1];
        max_chanel[2] <= chanel[2];
        max_chanel[3] <= chanel[3];
    end
 end  */

//------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_seg <= RESET;
    end else 

    case ({key[1], key[0]}) 

        2'b11 : state_seg   <=  TIME;
        2'b01 : state_seg   <=  MAX_CHANEL;
        2'b00 : state_seg   <=  RESET;

        default: state_seg <= state_seg;
    endcase
end

always @(*) begin
   case (state_seg)
        RESET: begin
            data_seg [0]  <=   0;
            data_seg [1]  <=   0;
            data_seg [2]  <=   0;
            data_seg [3]  <=   0;
            led      [0]  <=   0;
            led      [1]  <=   0;
            led      [2]  <=   0;
            led      [3]  <=   0;            
        end
        TIME: begin
            
            data_seg [0]  <=   data[0] ;
            data_seg [1]  <=   data[1] ;
            data_seg [2]  <=   data[2] ;
            data_seg [3]  <=   data[3] ;
            led      [0]  <=   0;
            led      [1]  <=   1;
            led      [2]  <=   1;
            led      [3]  <=   1;  
        end
        MAX_CHANEL: begin
            data_seg [0]  <=   max_chanel[0] ;
            data_seg [1]  <=   max_chanel[1] ;
            data_seg [2]  <=   max_chanel[2] ;
            data_seg [3]  <=   max_chanel[3] ;
            led      [0]  <=   1;
            led      [1]  <=   0;  
            led      [2]  <=   1;
            led      [3]  <=   1; 
        end
        default: begin
            data_seg [0]  <= 0;
            data_seg [1]  <= 0;
            data_seg [2]  <= 0;
            data_seg [3]  <= 0;
            led      [0]  <= 0;
            led      [1]  <= 0;
            led      [2]  <= 0;
            led      [3]  <= 0;            
        end
    endcase
end

//-------------------------------------------------------------------------


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
        IDLE :     if (en_FFT)      next_state = DATA_PROC;
                   else             next_state = IDLE;
        DATA_PROC: if (finish_FFT)  next_state = IDLE;
                   else             next_state = DATA_PROC;                
        default:   next_state = IDLE;
    endcase
end

// 3rd always block, the sequential FSM output
 always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data[0]     <= 4'd0;
        data[1]     <= 4'd0;
        data[2]     <= 4'd0;
        data[3]     <= 4'd0;
    end else begin
        case (cur_state)

            IDLE :  begin
                    data[0]     <= data[0];
                    data[1]     <= data[1];
                    data[2]     <= data[2];
                    data[3]     <= data[3];
                    end 
       
            DATA_PROC:  begin
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
 
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h
    
	 //HEX = abcdefgh
 
        //--------------------------------------------------

        always @ (posedge clk or negedge rst_n)
        if (!rst_n) begin
            HEX0 = 8'h03;
				HEX1 = 8'h03;
				HEX2 = 8'h03;
				HEX3 = 8'h03;
        end else begin

            begin
                case (data_seg [0])
                4'h0 : HEX0 = 8'h03; //пїЅпїЅКѕ"0"
                4'h1 : HEX0 = 8'h9f; //пїЅпїЅКѕ"1"
                4'h2 : HEX0 = 8'h25; //пїЅпїЅКѕ"2"
                4'h3 : HEX0 = 8'h0d; //пїЅпїЅКѕ"3"
                4'h4 : HEX0 = 8'h99; //пїЅпїЅКѕ"4"
                4'h5 : HEX0 = 8'h49; //пїЅпїЅКѕ"5"
                4'h6 : HEX0 = 8'h41; //пїЅпїЅКѕ"6"
                4'h7 : HEX0 = 8'h1f; //пїЅпїЅКѕ"7"
                4'h8 : HEX0 = 8'h01; //пїЅпїЅКѕ"8"
                4'h9 : HEX0 = 8'h09; //пїЅпїЅКѕ"9"
                4'ha : HEX0 = 8'h11; //пїЅпїЅКѕ"a"
                4'hb : HEX0 = 8'hc1; //пїЅпїЅКѕ"b"
                4'hc : HEX0 = 8'h63; //пїЅпїЅКѕ"c"
                4'hd : HEX0 = 8'h85; //пїЅпїЅКѕ"d"
                4'he : HEX0 = 8'h61; //пїЅпїЅКѕ"e"
                4'hf : HEX0 = 8'h71; //пїЅпїЅКѕ"f"
                endcase
            end
            begin
                case (data_seg [1])
                4'h0 : HEX1 = 8'h03; //пїЅпїЅКѕ"0"
                4'h1 : HEX1 = 8'h9f; //пїЅпїЅКѕ"1"
                4'h2 : HEX1 = 8'h25; //пїЅпїЅКѕ"2"
                4'h3 : HEX1 = 8'h0d; //пїЅпїЅКѕ"3"
                4'h4 : HEX1 = 8'h99; //пїЅпїЅКѕ"4"
                4'h5 : HEX1 = 8'h49; //пїЅпїЅКѕ"5"
                4'h6 : HEX1 = 8'h41; //пїЅпїЅКѕ"6"
                4'h7 : HEX1 = 8'h1f; //пїЅпїЅКѕ"7"
                4'h8 : HEX1 = 8'h01; //пїЅпїЅКѕ"8"
                4'h9 : HEX1 = 8'h09; //пїЅпїЅКѕ"9"
                4'ha : HEX1 = 8'h11; //пїЅпїЅКѕ"a"
                4'hb : HEX1 = 8'hc1; //пїЅпїЅКѕ"b"
                4'hc : HEX1 = 8'h63; //пїЅпїЅКѕ"c"
                4'hd : HEX1 = 8'h85; //пїЅпїЅКѕ"d"
                4'he : HEX1 = 8'h61; //пїЅпїЅКѕ"e"
                4'hf : HEX1 = 8'h71; //пїЅпїЅКѕ"f"
                endcase
            end
            begin
                case (data_seg [2])
                4'h0 : HEX2 = 8'h03; //пїЅпїЅКѕ"0"
                4'h1 : HEX2 = 8'h9f; //пїЅпїЅКѕ"1"
                4'h2 : HEX2 = 8'h25; //пїЅпїЅКѕ"2"
                4'h3 : HEX2 = 8'h0d; //пїЅпїЅКѕ"3"
                4'h4 : HEX2 = 8'h99; //пїЅпїЅКѕ"4"
                4'h5 : HEX2 = 8'h49; //пїЅпїЅКѕ"5"
                4'h6 : HEX2 = 8'h41; //пїЅпїЅКѕ"6"
                4'h7 : HEX2 = 8'h1f; //пїЅпїЅКѕ"7"
                4'h8 : HEX2 = 8'h01; //пїЅпїЅКѕ"8"
                4'h9 : HEX2 = 8'h09; //пїЅпїЅКѕ"9"
                4'ha : HEX2 = 8'h11; //пїЅпїЅКѕ"a"
                4'hb : HEX2 = 8'hc1; //пїЅпїЅКѕ"b"
                4'hc : HEX2 = 8'h63; //пїЅпїЅКѕ"c"
                4'hd : HEX2 = 8'h85; //пїЅпїЅКѕ"d"
                4'he : HEX2 = 8'h61; //пїЅпїЅКѕ"e"
                4'hf : HEX2 = 8'h71; //пїЅпїЅКѕ"f"
                endcase
            end
            begin
                case (data_seg [3])
                4'h0 : HEX0 = 8'h03; //пїЅпїЅКѕ"0"
                4'h1 : HEX3 = 8'h9f; //пїЅпїЅКѕ"1"
                4'h2 : HEX3 = 8'h25; //пїЅпїЅКѕ"2"
                4'h3 : HEX3 = 8'h0d; //пїЅпїЅКѕ"3"
                4'h4 : HEX3 = 8'h99; //пїЅпїЅКѕ"4"
                4'h5 : HEX3 = 8'h49; //пїЅпїЅКѕ"5"
                4'h6 : HEX3 = 8'h41; //пїЅпїЅКѕ"6"
                4'h7 : HEX3 = 8'h1f; //пїЅпїЅКѕ"7"
                4'h8 : HEX3 = 8'h01; //пїЅпїЅКѕ"8"
                4'h9 : HEX3 = 8'h09; //пїЅпїЅКѕ"9"
                4'ha : HEX3 = 8'h11; //пїЅпїЅКѕ"a"
                4'hb : HEX3 = 8'hc1; //пїЅпїЅКѕ"b"
                4'hc : HEX3 = 8'h63; //пїЅпїЅКѕ"c"
                4'hd : HEX3 = 8'h85; //пїЅпїЅКѕ"d"
                4'he : HEX3 = 8'h61; //пїЅпїЅКѕ"e"
                4'hf : HEX3 = 8'h71; //пїЅпїЅКѕ"f"
                endcase
            end
        end
        
     

endmodule