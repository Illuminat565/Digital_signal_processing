 ///////////////////////////////////////////////////////////////////////////////////
// University     : Ryazan State Radio Engineering University 
// Engineer       : TRINH NGOC HIEU
// Create Date    : 2024.22.02
// Design Name    : 
// Module name    : data
// Project_name   : FPGA FFT
// Target Device  : 
// Tool versions  :
// Description    : 
//
// Revision       : V1.0
// Additional Comments    :
///////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------------


module data_FFT #(parameter bit_width = 9)(
    input clk,rst_n,

    output reg signed [bit_width-1:0] real_o_data,
    output reg signed [bit_width-1:0] image_o_data,
    output reg en_register

);
    reg [31:0] count;
    always @(posedge clk ) begin
       if (!rst_n) begin
        count <= 1'd0;
        real_o_data = 9'd0;
        image_o_data =  9'd0;
        en_register = 0;
       end else begin
        count <= count +1'd1;
        if (count >= 1000 & count <=1099) begin
            en_register <=1'b1;
    //        real_o_data <= 9'd128;
      //      image_o_data <= 9'd221;
            real_o_data <= 9'd1;
            image_o_data <= 9'd17;
        end else if (count >= 2000 & count <=2099)
        begin
      //        real_o_data <= -9'd79;
       //     image_o_data <= 9'd243;
          real_o_data <= 9'd2;
            image_o_data <= 9'd18;
        end else if (count >= 3000 & count <=3099)
        begin
      //      real_o_data <= -9'd233;
      //      image_o_data <= 9'd104;
           real_o_data <= 9'd3;
            image_o_data <= 9'd19;
        end else if (count >= 4000 & count <=4099)
        begin
    //       real_o_data <= -9'd233;
    //        image_o_data <= -9'd104;
            real_o_data <= 9'd4;
           image_o_data <= 9'd20;
        end else if (count >= 5000 & count <=5099)
        begin
    //        real_o_data <= -9'd79;
    //        image_o_data <= -9'd243;
          real_o_data <= 9'd5;
            image_o_data <= 9'd21;
        end else if (count >= 6000 & count <=6099)
        begin
   //        real_o_data <= 9'd127;
   //        image_o_data <= -9'd221;
            real_o_data <= 9'd6;
            image_o_data <= 9'd22;
        end else if (count >= 7000 & count <=7099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= -9'd53;
            real_o_data <= 9'd7;
            image_o_data <= 9'd23;
        end else if (count >= 8000 & count <=8099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= 9'd150;
             real_o_data <= 9'd8;
             image_o_data <= 9'd24;
        end else if (count >= 9000 & count <=9099)
        begin
    //        real_o_data <= 9'd27;
   //         image_o_data <= 9'd254;
            real_o_data <= 9'd9;
            image_o_data <= 9'd25;
        end else if (count >= 10000 & count <=10099)
        begin
    //        real_o_data <= -9'd171;
    //        image_o_data <= 9'd190;
             real_o_data <= 9'd10;
            image_o_data <= 9'd26;
        end else if (count >= 11000 & count <=11099)
        begin
    //        real_o_data <= -9'd255;
    //       image_o_data <= 9'd0;
            real_o_data <= 9'd11;
            image_o_data <= 9'd27;
        end else if (count >= 12000 & count <=12099)
        begin
    //        real_o_data <= -9'd171;
   //         image_o_data <= -9'd190;
             real_o_data <= 9'd12;
            image_o_data <= 9'd28;
        end else if (count >= 13000 & count <=13099)
        begin
    //        real_o_data <= 9'd27;
    //       image_o_data <= -9'd254;
            real_o_data <= 9'd13;
            image_o_data <= 9'd29;
        end else if (count >= 14000 & count <=14099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= -9'd150;
            real_o_data <= 9'd14;
            image_o_data <= 9'd30;
        end else if (count >= 15000 & count <=15099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= 9'd53;
            real_o_data <= 9'd15;
            image_o_data <= 9'd31;
        end else if (count >= 16000 & count <=16099)
        begin
   //         real_o_data <= 9'd127;
   //         image_o_data <= 9'd221;
         real_o_data <= 9'd16;
            image_o_data <=9'd32;
        end else if (count >= 17000 & count <=17099)
        begin
    //        real_o_data <= 9'd128;
      //      image_o_data <= 9'd221;
            real_o_data <= 9'd17;
            image_o_data <= 9'd33;
        end else if (count >= 18000 & count <=18099)
        begin
      //        real_o_data <= -9'd79;
       //     image_o_data <= 9'd243;
          real_o_data <= 9'd18;
            image_o_data <= 9'd34;
        end else if (count >= 19000 & count <=19099)
        begin
      //      real_o_data <= -9'd233;
      //      image_o_data <= 9'd104;
           real_o_data <= 9'd19;
            image_o_data <= 9'd35;
        end else if (count >= 20000 & count <=20099)
        begin
    //       real_o_data <= -9'd233;
    //        image_o_data <= -9'd104;
            real_o_data <= 9'd20;
           image_o_data <= 9'd36;
        end else if (count >= 21000 & count <=21099)
        begin
    //        real_o_data <= -9'd79;
    //        image_o_data <= -9'd243;
          real_o_data <= 9'd21;
            image_o_data <= 9'd37;
        end else if (count >= 22000 & count <=22099)
        begin
   //        real_o_data <= 9'd127;
   //        image_o_data <= -9'd221;
            real_o_data <= 9'd22;
            image_o_data <= 9'd38;
        end else if (count >= 23000 & count <=23099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= -9'd53;
            real_o_data <= 9'd23;
            image_o_data <= 9'd39;
        end else if (count >= 24000 & count <=24099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= 9'd150;
             real_o_data <= 9'd24;
             image_o_data <= 9'd40;
        end else if (count >= 25000 & count <=25099)
        begin
    //        real_o_data <= 9'd27;
   //         image_o_data <= 9'd254;
            real_o_data <= 9'd25;
            image_o_data <= 9'd41;
        end else if (count >= 26000 & count <=26099)
        begin
    //        real_o_data <= -9'd171;
    //        image_o_data <= 9'd190;
             real_o_data <= 9'd26;
            image_o_data <= 9'd42;
        end else if (count >= 27000 & count <=27099)
        begin
    //        real_o_data <= -9'd255;
    //       image_o_data <= 9'd0;
            real_o_data <= 9'd27;
            image_o_data <= 9'd43;
        end else if (count >= 28000 & count <=28099)
        begin
    //        real_o_data <= -9'd171;
   //         image_o_data <= -9'd190;
             real_o_data <= 9'd28;
            image_o_data <= 9'd44;
        end else if (count >= 29000 & count <=29099)
        begin
    //        real_o_data <= 9'd27;
    //       image_o_data <= -9'd254;
            real_o_data <= 9'd29;
            image_o_data <= 9'd45;
        end else if (count >= 30000 & count <=30099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= -9'd150;
            real_o_data <= 9'd30;
            image_o_data <= 9'd46;
        end else if (count >= 31000 & count <=31099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= 9'd53;
            real_o_data <= 9'd31;
            image_o_data <= 9'd47;
        end else if (count >= 32000 & count <=32099)
        begin
   //         real_o_data <= 9'd127;
   //         image_o_data <= 9'd221;
            real_o_data <= 9'd32;
            image_o_data <=9'd48;
        end else if (count >= 33000 & count <=33099)
        begin
    //        real_o_data <= 9'd128;
      //      image_o_data <= 9'd221;
            real_o_data <= 9'd1;
            image_o_data <= 9'd17;
        end else if (count >= 34000 & count <=34099)
        begin
      //        real_o_data <= -9'd79;
       //     image_o_data <= 9'd243;
          real_o_data <= 9'd2;
            image_o_data <= 9'd18;
        end else if (count >= 35000 & count <=35099)
        begin
      //      real_o_data <= -9'd233;
      //      image_o_data <= 9'd104;
           real_o_data <= 9'd3;
            image_o_data <= 9'd19;
        end else if (count >= 36000 & count <=36099)
        begin
    //       real_o_data <= -9'd233;
    //        image_o_data <= -9'd104;
            real_o_data <= 9'd4;
           image_o_data <= 9'd20;
        end else if (count >= 37000 & count <=37099)
        begin
    //        real_o_data <= -9'd79;
    //        image_o_data <= -9'd243;
          real_o_data <= 9'd5;
            image_o_data <= 9'd21;
        end else if (count >= 38000 & count <=38099)
        begin
   //        real_o_data <= 9'd127;
   //        image_o_data <= -9'd221;
            real_o_data <= 9'd6;
            image_o_data <= 9'd22;
        end else if (count >= 39000 & count <=39099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= -9'd53;
            real_o_data <= 9'd7;
            image_o_data <= 9'd23;
        end else if (count >= 40000 & count <=40099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= 9'd150;
             real_o_data <= 9'd8;
             image_o_data <= 9'd24;
        end else if (count >= 41000 & count <=41099)
        begin
    //        real_o_data <= 9'd27;
   //         image_o_data <= 9'd254;
            real_o_data <= 9'd9;
            image_o_data <= 9'd25;
        end else if (count >= 42000 & count <=42099)
        begin
    //        real_o_data <= -9'd171;
    //        image_o_data <= 9'd190;
             real_o_data <= 9'd10;
            image_o_data <= 9'd26;
        end else if (count >= 43000 & count <=43099)
        begin
    //        real_o_data <= -9'd255;
    //       image_o_data <= 9'd0;
            real_o_data <= 9'd11;
            image_o_data <= 9'd27;
        end else if (count >= 44000 & count <=44099)
        begin
    //        real_o_data <= -9'd171;
   //         image_o_data <= -9'd190;
             real_o_data <= 9'd12;
            image_o_data <= 9'd28;
        end else if (count >= 45000 & count <=45099)
        begin
    //        real_o_data <= 9'd27;
    //       image_o_data <= -9'd254;
            real_o_data <= 9'd13;
            image_o_data <= 9'd29;
        end else if (count >= 46000 & count <=46099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= -9'd150;
            real_o_data <= 9'd14;
            image_o_data <= 9'd30;
        end else if (count >= 47000 & count <=47099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= 9'd53;
            real_o_data <= 9'd15;
            image_o_data <= 9'd31;
        end else if (count >= 48000 & count <=48099)
        begin
   //         real_o_data <= 9'd127;
   //         image_o_data <= 9'd221;
         real_o_data <= 9'd16;
            image_o_data <=9'd32;
        end else if (count >= 49000 & count <=49099)
        begin
    //        real_o_data <= 9'd128;
      //      image_o_data <= 9'd221;
            real_o_data <= 9'd17;
            image_o_data <= 9'd33;
        end else if (count >= 50000 & count <=50099)
        begin
      //        real_o_data <= -9'd79;
       //     image_o_data <= 9'd243;
          real_o_data <= 9'd18;
            image_o_data <= 9'd34;
        end else if (count >= 51000 & count <=51099)
        begin
      //      real_o_data <= -9'd233;
      //      image_o_data <= 9'd104;
           real_o_data <= 9'd19;
            image_o_data <= 9'd35;
        end else if (count >= 52000 & count <=52099)
        begin
    //       real_o_data <= -9'd233;
    //        image_o_data <= -9'd104;
            real_o_data <= 9'd20;
           image_o_data <= 9'd36;
        end else if (count >= 53000 & count <=53099)
        begin
    //        real_o_data <= -9'd79;
    //        image_o_data <= -9'd243;
          real_o_data <= 9'd21;
            image_o_data <= 9'd37;
        end else if (count >= 54000 & count <=54099)
        begin
   //        real_o_data <= 9'd127;
   //        image_o_data <= -9'd221;
            real_o_data <= 9'd22;
            image_o_data <= 9'd38;
        end else if (count >= 55000 & count <=55099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= -9'd53;
            real_o_data <= 9'd23;
            image_o_data <= 9'd39;
        end else if (count >= 56000 & count <=56099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= 9'd150;
             real_o_data <= 9'd24;
             image_o_data <= 9'd40;
        end else if (count >= 57000 & count <=57099)
        begin
    //        real_o_data <= 9'd27;
   //         image_o_data <= 9'd254;
            real_o_data <= 9'd25;
            image_o_data <= 9'd41;
        end else if (count >= 58000 & count <=58099)
        begin
    //        real_o_data <= -9'd171;
    //        image_o_data <= 9'd190;
             real_o_data <= 9'd26;
            image_o_data <= 9'd42;
        end else if (count >= 59000 & count <=59099)
        begin
    //        real_o_data <= -9'd255;
    //       image_o_data <= 9'd0;
            real_o_data <= 9'd27;
            image_o_data <= 9'd43;
        end else if (count >= 60000 & count <=60099)
        begin
    //        real_o_data <= -9'd171;
   //         image_o_data <= -9'd190;
             real_o_data <= 9'd28;
            image_o_data <= 9'd44;
        end else if (count >= 61000 & count <=61099)
        begin
    //        real_o_data <= 9'd27;
    //       image_o_data <= -9'd254;
            real_o_data <= 9'd29;
            image_o_data <= 9'd45;
        end else if (count >= 62000 & count <=62099)
        begin
   //         real_o_data <= 9'd206;
   //         image_o_data <= -9'd150;
            real_o_data <= 9'd30;
            image_o_data <= 9'd46;
        end else if (count >= 63000 & count <=63099)
        begin
   //         real_o_data <= 9'd249;
   //         image_o_data <= 9'd53;
            real_o_data <= 9'd31;
            image_o_data <= 9'd47;
        end else if (count >= 64000 & count <=64099)
        begin
   //         real_o_data <= 9'd127;
   //         image_o_data <= 9'd221;
            real_o_data <= 9'd32;
            image_o_data <=9'd48;
        end
        else begin
            real_o_data = 9'd0;
            image_o_data =  9'd0;
             en_register <=1'b0;
        end
       end
  
    end

endmodule