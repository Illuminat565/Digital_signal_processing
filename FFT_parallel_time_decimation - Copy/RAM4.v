module  RAM4 #(parameter bit_width=29, N = 16, SIZE = 4)(
    input                              clk,rst_n,
    
    input                              load_data,
    input              [SIZE-1:     0] invert_adr,
    input       signed [bit_width-1:0] Re_i,
    input       signed [bit_width-1:0] Im_i,

    
    input              [SIZE-1:       0]  rd_ptr,
    input                                 en_rd, 

    input              [2:0]              rd_angle_ptr,      

    output reg  signed [bit_width-1:0]  Re_o,
    output reg  signed [bit_width-1:0]  Im_o,
    output reg                          en_radix,
    output  reg signed [13:0]           cos_data,
    output  reg signed [13:0]           sin_data
 );
    reg signed [13:0]  cos  [7:0];
    reg signed [13:0]  sin  [7:0];

    reg  signed  [bit_width-1:0]  mem_Re  [N-1:0];
    reg  signed  [bit_width-1:0]  mem_Im  [N-1:0];

    reg signed [13:0]           cos_temp;
    reg signed [13:0]           sin_temp;

 

     //------------------------handle read read from MEM----------------------------
        always @(posedge clk) begin
         begin
             if (en_rd) begin
                  Re_o             <= mem_Re[rd_ptr];
                  Im_o             <= mem_Im[rd_ptr];
             end
        end
        end
   //--------------------------handle wirte read from MEM----------------------------
        always @(posedge clk) begin
         begin
           if (load_data)   begin
                  mem_Re[invert_adr] <= Re_i;
                  mem_Im[invert_adr] <= Im_i;    
            end
        end
        end

    //--------------------------------handle reaf tw factor------------------------------
     always @(posedge clk) begin 
             if (en_rd ) begin
                  cos_data         <= cos   [rd_angle_ptr];
                  sin_data         <= sin   [rd_angle_ptr];
                  en_radix         <= 1'b1;
             end else en_radix     <= 1'b0;
        end

//-------------------------ROM----------------------------------------------------------
initial begin
   sin[0]  =  14'b00000000000000;     //0pi/256
   cos[0]  =  14'b01000000000000;     //0pi/256
   sin[1]  =  14'b11100111100001;     //32pi/256
   cos[1]  =  14'b00111011001000;     //32pi/256
   sin[2]  =  14'b11010010110000;     //64pi/256
   cos[2]  =  14'b00101101010000;     //64pi/256
   sin[3]  =  14'b11000100111000;     //96pi/256
   cos[3]  =  14'b00011000011111;     //96pi/256
   sin[4]  =  14'b11000000000000;     //128pi/256
   cos[4]  =  14'b00000000000000;     //128pi/256
   sin[5]  =  14'b11000100111000;     //160pi/256
   cos[5]  =  14'b11100111100001;     //160pi/256
   sin[6]  =  14'b11010010110000;     //192pi/256
   cos[6]  =  14'b11010010110000;     //192pi/256
   sin[7]  =  14'b11100111100001;     //224pi/256
   cos[7]  =  14'b11000100111000;     //224pi/256
end

endmodule