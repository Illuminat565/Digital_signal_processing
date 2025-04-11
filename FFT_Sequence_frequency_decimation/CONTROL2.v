module  MODIFY_CONTROL #(parameter t_1_bit = 5207, bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,

 //   input                              flag_start_FFT,
    input                              en_out, 
    input                              en_invert,      

    output reg       [SIZE-1:0]          rd_ptr,
    output           [SIZE-1:0]        invert_adr, 
    output           [10  :0]          rd_ptr_angle, 
    output           [10  :0]          rd_ptr_angle_final, 
    
    output          [SIZE-1:0]           wr_ptr,
    output                             en_modify,
    output                             en_modify_tw,

    output                             finish_FFT,   
    
    output                             load_data,
    output                             en_rd,         
    output                             out_valid, 
    output                             done_o 
 );
    
    

    wire start_modify; 

    wire initial_state;

  
 //----------------------------------------------------------------------
    reg [4:0] cur_state;
    reg [4:0] next_state;
    reg [3:0] state;
    
    reg [3:0]  stage_FFT;

    wire start_read_stage;
    wire next_state_FFT;
    
    wire [1  :0]  en_rd_temp;
    wire [SIZE-1:0]  rd_ptr_temp [1:0];

    wire out_valid_temp;

    assign  finish_FFT    = start_read_stage;
    assign  out_valid     = en_rd_temp[1]; 

    integer k;
    genvar  i;

 //-----------Writing back to memmory is delayed 2 clk with read_clk ----------------------------------        

     shift_register # ( .width (1), .depth (3)) shift_register(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(start_modify),
         .out_data(en_modify)
  );
     shift_register # ( .width (1), .depth (2)) shift_register2(
         .clk(clk),
         .rst_n(rst_n), 
         .in_data(start_modify),
         .out_data(en_modify_tw)
  );
  //----------------------------------------------------------------
    new_adress_genarator #( .N(N), .SIZE(SIZE))
    new_adress_genarator_inst
    (
      .clk(clk),
      .rst_n(rst_n), 
      .flag_start_FFT(flag_start_FFT),
      .stage_FFT(stage_FFT),
      .initial_state(initial_state),
      .next_state_FFT(next_state_FFT),
      
      .en_rd(en_rd_temp[0]),  
      .rd_ptr(rd_ptr_temp[0]),
      .rd_ptr_angle(rd_ptr_angle), 
      .rd_ptr_angle_final(rd_ptr_angle_final), 
      .done_o(start_read_stage)
 );
 //-----------------------------OUTPUT data
    out_addres_generator #(  .t_1_bit(t_1_bit),.N(N), .SIZE(SIZE))out_addres_generator(
    .clk(clk),
    .rst_n(rst_n), 
    .start_stage(start_read_stage),
    .en_out(en_out),
    
    .rd_ptr(rd_ptr_temp[1]),
    .en_rd(en_rd_temp[1]),
    .done_o(done_o)
 );

//-----------------------------------------------------------

always @(posedge clk ) begin
    if (initial_state) begin
        stage_FFT <= 1;
    end else if (next_state_FFT) begin              
        stage_FFT <= stage_FFT +1'b1;
end
end

assign start_modify = (stage_FFT == SIZE);
assign en_rd = |en_rd_temp[0];
//-------------------------------------------------------------

always @(*) begin
   case (en_rd_temp)
      2'b001: rd_ptr = rd_ptr_temp[0];
      2'b010: rd_ptr = rd_ptr_temp[1];
      default: rd_ptr = 0; 
   endcase
end

//---------------------------------------revert_adress--------------
INVERT  #(.N(N), .SIZE(SIZE)) 
invert_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en_invert(en_invert),

    .invert_addr(invert_adr),
    .en_o(load_data)
);

assign   flag_start_FFT  = (invert_adr == N-1);
//------------------------------------------------------
    //----------------------------------------------------------------------  
    // Сдвиговый регистр: обеспечивает сдвиг указателя чтения в указатель записи  
    // в процессе выполнения FFT.  
    shift_register #(.width(SIZE), .depth(4)) shift_reg_inst (
        .clk(clk),
        .rst_n(rst_n),
        .in_data(rd_ptr),
        .out_data(wr_ptr)
    );

endmodule 