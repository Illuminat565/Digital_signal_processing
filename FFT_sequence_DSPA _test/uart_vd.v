`timescale 1ns/1ps
`define clk_period 20

module uart_vd (
    output reg signed tx_o
);

reg [7:0] tx_data,tx_data1,tx_data2,tx_data3,tx_data4,tx_data5,tx_data6,tx_data7,tx_data8,tx_data9,tx_data10,tx_data11,tx_data12,tx_data13,tx_data14,tx_data15;
reg [7:0] tx_data16,tx_data17,tx_data18,tx_data19,tx_data20,tx_data21,tx_data22,tx_data23,tx_data24,tx_data25,tx_data26,tx_data27,tx_data28,tx_data29,tx_data30,tx_data31;
//-------------------------------------------------
initial begin
    tx_o = 1;
    tx_data   = 8'd0;
    tx_data1  = 8'd0;
    tx_data2  = 8'd1;
    tx_data3  = 8'd1;
    tx_data4  = 8'd2;
    tx_data5  = 8'd2;
    tx_data6  = 8'd3;
    tx_data7  = 8'd3;
    tx_data8  = 8'd4;
    tx_data9  = 8'd4;
    tx_data10 = 8'd5;
    tx_data11 = 8'd5;
    tx_data12 = 8'd6;
    tx_data13 = 8'd6;
    tx_data14 = 8'd7;
    tx_data15 = 8'd7;

    tx_data16  = 8'd8;
    tx_data17  = 8'd8;
    tx_data18  = 8'd9;
    tx_data19  = 8'd9;
    tx_data20  = 8'd10;
    tx_data21  = 8'd10;
    tx_data22  = 8'd11;
    tx_data23  = 8'd11;
    tx_data24  = 8'd12;
    tx_data25  = 8'd12;
    tx_data26 = 8'd13;
    tx_data27 = 8'd13;
    tx_data28 = 8'd14;
    tx_data29 = 8'd14;
    tx_data30 = 8'd15;
    tx_data31 = 8'd15;

    #(`clk_period*10);
    tx_task;
end
//------------------------------------------------
task tx_task;
    begin
        tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

        tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data1[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data1[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data1[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data1[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data1[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data1[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data1[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data1[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);
        
                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data2[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data2[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data2[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data2[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data2[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data2[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data2[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data2[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data3[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data3[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data3[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data3[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data3[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data3[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data3[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data3[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data4[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data4[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data4[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data4[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data4[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data4[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data4[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data4[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data5[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data5[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data5[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data5[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data5[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data5[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data5[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data5[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data6[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data6[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data6[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data6[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data6[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data6[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data6[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data6[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

         tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data7[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data7[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data7[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data7[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data7[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data7[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data7[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data7[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);
        
            tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data8[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data8[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data8[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data8[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data8[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data8[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data8[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data8[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

        tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data9[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data9[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data9[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data9[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data9[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data9[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data9[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data9[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);
        
                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data10[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data10[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data10[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data10[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data10[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data10[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data10[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data10[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data11[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data11[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data11[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data11[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data11[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data11[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data11[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data11[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data12[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data12[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data12[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data12[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data12[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data12[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data12[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data12[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data13[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data13[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data13[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data13[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data13[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data13[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data13[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data13[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data14[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data14[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data14[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data14[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data14[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data14[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data14[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data14[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

         tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data15[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data15[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data15[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data15[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data15[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data15[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data15[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data15[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

               tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data16[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data16[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data16[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data16[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data16[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data16[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data16[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data16[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

        tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data17[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data17[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data17[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data17[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data17[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data17[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data17[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data17[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);
        
                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data18[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data18[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data18[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data18[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data18[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data18[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data18[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data18[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data19[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data19[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data19[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data19[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data19[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data19[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data19[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data19[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data20[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data20[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data20[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data20[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data20[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data20[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data20[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data20[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data21[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data21[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data21[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data21[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data21[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data21[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data21[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data21[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data22[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data22[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data22[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data22[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data22[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data22[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data22[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data22[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

         tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data23[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data23[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data23[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data23[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data23[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data23[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data23[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data23[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

               tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data24[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data24[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data24[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data24[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data24[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data24[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data24[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data24[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

        tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data25[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data25[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data25[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data25[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data25[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data25[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data25[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data25[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);
        
                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data26[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data26[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data26[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data26[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data26[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data26[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data26[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data26[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data27[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data27[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data27[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data27[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data27[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data27[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data27[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data27[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data28[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data28[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data28[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data28[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data28[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data28[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data28[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data28[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data29[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data29[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data29[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data29[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data29[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data29[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data29[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data29[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

                tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data30[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data30[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data30[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data30[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data30[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data30[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data30[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data30[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);

         tx_o = 0;
        #(`clk_period*10);       // start bit

        tx_o = tx_data31[0];       // bit 0
        #(`clk_period*10); 

        tx_o = tx_data31[1];       // bit 2
        #(`clk_period*10);

        tx_o = tx_data31[2];       // bit 3
        #(`clk_period*10);

        tx_o = tx_data31[3];       // bit 4
        #(`clk_period*10);

        tx_o = tx_data31[4];       // bit 5
        #(`clk_period*10);

        tx_o = tx_data31[5];       // bit 6
        #(`clk_period*10);

        tx_o = tx_data31[6];       // bit 7
        #(`clk_period*10);

        tx_o = tx_data31[7];       // bit 8
        #(`clk_period*10);

        tx_o = 1;                // stop bit
        #(`clk_period*10);
        
        tx_o = 1;

    end
endtask




endmodule