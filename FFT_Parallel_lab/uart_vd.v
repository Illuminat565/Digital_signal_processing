`timescale 1ns/1ps
`define clk_period 20

module uart_vd #(parameter N = 256, k = 10, norm = 8, v = 0.2) (
        output reg signed tx_o
 );

            real pi = 3.141592653589793;


            reg signed [7:0] tx_data_real [N-1 :0];
            reg signed [7:0] tx_data_imag [N-1 :0];

            integer i,j,n;

            reg signed [7:0] tx_data [2*N-1 :0];
            //-------------------------------------------------
            initial begin
                tx_o = 1;

                for (n = 0 ; n < N ; n = n+2 ) begin
                    tx_data_real[n] = $rtoi($cos(2*pi*k*n/N)*$pow(2,norm-1));
                end

                for (n = 1 ; n < N ; n = n+2 ) begin
                    tx_data_real[n] = $rtoi($cos(2*pi*k*(n-v)/N)*$pow(2,norm-1));
                end

                for (n = 0 ; n < N ; n = n+2 ) begin
                    tx_data_imag[n] = $rtoi($sin(2*pi*k*n/N)*$pow(2,norm-1));
                end

                for (n = 1 ; n < N ; n = n+2 ) begin
                    tx_data_imag[n] = $rtoi($sin(2*pi*k*(n-v)/N)*$pow(2,norm-1));
                end

                for (n = 0 ; n < 2*N ; n=n+2) begin
                    tx_data [n] = tx_data_real[n/2];
                end
                
                for (n = 1 ; n < 2*N ; n=n+2) begin
                    tx_data [n] = tx_data_imag[n/2];
                end

                #(`clk_period*10);
                tx_task;
            end
            //------------------------------------------------
            task tx_task;
            begin
                    tx_o = 0;
                    #(`clk_period*10);       // start bit

                for (j=0; j <= 2*N-1 ; j = j+1) begin

                    for ( i = 0; i < 8 ; i = i+1 ) begin
                            tx_o = tx_data[j][i];       // bit 0
                            #(`clk_period*10);  
                    end
                            tx_o = 1;                // stop bit
                            #(`clk_period*10);

                            tx_o = 0;
                            #(`clk_period*10);       // start bit
                end

            end
            endtask


    endmodule