module  MODIFY_CONTROL #(parameter t_1_bit = 5207, bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,

    input                              flag_start_FFT,
    input                              en_out, 

    output reg       [SIZE:0]          rd_ptr,
    output reg       [10  :0]          rd_ptr_angle, 

    output                             en_modify,
    output                             en_modify_tw,

    output                             finish_FFT,   
    
    output                             en_rd,         
    output                             out_valid, 
    output                             done_o 
 );
    
    

    wire start_modify; 

    reg  [SIZE:0] O_data_ptr_delay;
    reg  [SIZE:0] wr_ptr_delay8; 
    reg  [3:0]    stage_FFT_delay;
    wire  [3:0]   stage_FFT_delay2;


     wire       [SIZE-1:0]          rd_ptr_temp [SIZE:0];
     wire       [10    :0]          rd_ptr_angle_temp [SIZE:0]; 
 //----------------------------------------------------------------------
    reg [4:0] cur_state;
    reg [4:0] next_state;
    reg [3:0] state;
    
    reg [3:0]  stage_FFT;

    wire start_read_stage;

    wire [SIZE:0] start_next_stage;
    
    wire [SIZE:0] en_rd_temp;

    wire out_valid_temp;

    assign  finish_FFT    = start_read_stage;
    assign  en_modify_tw  = start_modify;
    assign  out_valid     = en_rd_temp[SIZE]; 

    integer k;
    genvar  i;

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
     
    .en_rd(en_rd_temp[0]),  
    .rd_ptr(rd_ptr_temp[0]),
    .rd_ptr_angle(rd_ptr_angle_temp[0]), 
    .start_next_stage(start_next_stage[2])
 );
//----------------------------------------------------------------------------------------
generate 
begin
		for (i = 2; i < SIZE; i = i + 1) begin : gen_address_generator 
        addres_generator #( .stage_FFT(i),.N(N), .SIZE(SIZE)) u0
           (.clk(clk),
            .rst_n(rst_n), 
            .start_stage(start_next_stage[i]),
            
            .rd_ptr(rd_ptr_temp[i-1]),
            .en_rd(en_rd_temp[i-1]),
            .rd_ptr_angle(rd_ptr_angle_temp[i-1]), 
            .start_next_stage(start_next_stage[i+1]));
		end
end
	endgenerate
//--------------------------------Final state-------------------------------------------------
    
    final_addres_generator #(  .stage_FFT(SIZE),.N(N), .SIZE(SIZE))addres_final_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_next_stage[SIZE]),
    
    .start_modify(start_modify),
    .rd_ptr(rd_ptr_temp[SIZE-1]),
    .en_rd(en_rd_temp[SIZE-1]),
    .rd_ptr_angle(rd_ptr_angle_temp[SIZE-1]), 
    .start_next_stage(start_read_stage)
 );
 //-----------------------------OUTPUT data
    out_addres_generator #(  .t_1_bit(t_1_bit),.N(N), .SIZE(SIZE))out_addres_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_read_stage),
    .en_out(en_out),
    
    .rd_ptr(rd_ptr_temp[SIZE]),
    .en_rd(en_rd_temp[SIZE]),
    .done_o(done_o)
 );

assign en_rd =(en_rd_temp[SIZE-1:0] != 0);

always @(*) begin
    for (k = 0 ; k <= SIZE ; k=k+1 ) begin
      if (en_rd_temp[k]) begin
        rd_ptr        <= rd_ptr_temp[k];
        rd_ptr_angle  <= rd_ptr_angle_temp[k];
      end
    end
end



endmodule 