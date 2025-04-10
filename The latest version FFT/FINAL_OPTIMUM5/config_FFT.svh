
`ifdef MODIFY_FFT
     `define modifying_twidle_factor
     `define MODIFYING_ADDER
     `define Additional_Multiplier
`else 
     `define class_twidle_factor
     `define ADDER
`endif 
    