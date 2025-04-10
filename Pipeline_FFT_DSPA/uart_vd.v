`timescale 1ns/1ps
`define clk_period 20

module uart_vd #(parameter N = 256) (
    output reg signed tx_o
);
integer i,j,k;

reg [7:0] tx_data [2*N-1 :0];
//-------------------------------------------------
initial begin
    tx_o = 1;
    tx_data[0] = 0;
    tx_data[1] = 0;

    for (k=2 ; k <= 2*N-1  ; k = k+2) begin
           tx_data [k]   =  tx_data [k-1] +1;
           tx_data [k+1] =  tx_data [k] ;
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