
module MODIFY_RADIX2
	#(parameter bit_width=16, bit_width_tw_factor = 8)
    (
    input                                          clk,
    input                                          rst_n,
 
    input                                          en_modify,
 
    input       signed [bit_width_tw_factor-1: 0]  sin_data,
    input       signed [bit_width_tw_factor-1: 0]  cos_data,

    input       signed [bit_width_tw_factor-1: 0]  sin_data2,
    input       signed [bit_width_tw_factor-1: 0]  cos_data2,

	input       signed [bit_width-1:0]  Re_i1,
	input       signed [bit_width-1:0]  Im_i1,
    input       signed [bit_width-1:0]  Re_i2,
	input       signed [bit_width-1:0]  Im_i2,
    input                               en,

	output reg  signed [bit_width-1:0]  Re_o1,
	output reg  signed [bit_width-1:0]  Im_o1,
    output reg  signed [bit_width-1:0]  Re_o2,
	output reg  signed [bit_width-1:0]  Im_o2,
    output reg                          out_valid 
   );

    reg signed [bit_width+bit_width_tw_factor: 0] Re_temp1, Im_temp1;
    reg signed [bit_width+bit_width_tw_factor: 0] Re_temp2, Im_temp2;
    
    reg signed [bit_width-1: 0] Re_temp3, Im_temp3;   

     reg signed [bit_width-1:0]  Re_o1_temp;
	 reg signed [bit_width-1:0]  Im_o1_temp;
     reg signed [bit_width-1:0]  Re_o2_temp;
	 reg signed [bit_width-1:0]  Im_o2_temp;
     reg valid_input;

   always @(*) 
    if (en) begin
                Re_temp1  = (Re_i2*cos_data  - Im_i2*sin_data)>>>(bit_width_tw_factor-2);
                Im_temp1  = (Im_i2*cos_data  + Re_i2*sin_data)>>>(bit_width_tw_factor-2);
                    
                Re_temp3  = Re_temp1[bit_width-1:0];
                Im_temp3  = Im_temp1[bit_width-1:0];
 
                Re_temp2  = (Re_temp3*cos_data2 - Im_temp3*sin_data2)>>>(bit_width_tw_factor-2);
                Im_temp2  = (Im_temp3*cos_data2 + Re_temp3*sin_data2)>>>(bit_width_tw_factor-2);
                

                Re_o1     = Re_i1 + Re_temp3;
                Im_o1     = Im_i1 + Im_temp3;
                
             if (en_modify) begin
                Re_o2   =  Re_i1 + Re_temp2[bit_width-1:0];
                Im_o2   =  Im_i1 + Im_temp2[bit_width-1:0]; 
             end  else begin
                Re_o2   =  Re_i1 - Re_temp1[bit_width-1:0];
                Im_o2   =  Im_i1 - Im_temp1[bit_width-1:0];
             end  
            
            out_valid   <= 1'b1;
              
    end else out_valid <= 1'b0;
    
/*
     shift_register # ( .width (bit_width), .depth (2)) shift_register1(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(Re_i1),
         .out_data(Re_o1_temp)
   );

   shift_register # ( .width (bit_width), .depth (2)) shift_register2(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(Im_i1),
         .out_data(Im_o1_temp)
   );
    
    shift_register # ( .width (bit_width), .depth (1)) shift_register3(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(Re_temp1),
         .out_data(Re_o2_temp)
   );

   shift_register # ( .width (bit_width), .depth (1)) shift_register4(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(Im_temp1),
         .out_data(Im_o2_temp)
   );

   shift_register # ( .width (1), .depth (3)) shift_register5(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(en),
         .out_data(out_valid)
   );

    multiply #(.bit_width(bit_width), .bit_width_tw_factor(bit_width_tw_factor))multiply1 (
            .clk(clk),
            .sin_data(sin_data),
            .cos_data(cos_data),          
            .xin(Re_i2),
            .yin(Im_i2),

            .x_out(Re_temp1),
            .y_out(Im_temp1)
       ); 

       multiply #(.bit_width(bit_width), .bit_width_tw_factor(bit_width_tw_factor))multiply2 (
            .clk(clk),
            .sin_data(sin_data2),
            .cos_data(cos_data2),          
            .xin(Re_temp1),
            .yin(Im_temp1),

            .x_out(Re_temp2),
            .y_out(Im_temp2)
       ); 

       
 modifying_adder #(. bit_width(bit_width))modifying_adder(
    .clk(clk),
    .en_modify(en_modify),
    .xin1(Re_o1_temp),
    .yin1(Im_o1_temp),
	.xin2(Re_temp2),
	.yin2(Im_temp2),
    .xin3(Re_o2_temp),
	.yin3(Im_o2_temp),

    .xout1(Re_o1),
	.yout1(Im_o1),
    .xout2(Re_o2),
	.yout2(Im_o2)

   ); 
*/

  endmodule