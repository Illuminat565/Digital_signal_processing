//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);
  
 wire na,nb,anb,bna;
 mux m1 (.d0(1'b1),.d1(1'b0),.sel(a),.y(na));
 mux m2 (.d0(1'b1),.d1(1'b0),.sel(b),.y(nb));
 mux m3 (.d0(1'b0),.d1(a),.sel(nb),.y(anb));
 mux m4 (.d0(1'b0),.d1(b),.sel(na),.y(bna));
 mux m5 (.d0(anb),.d1(1'b1),.sel(bna),.y(o));
  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections


endmodule
