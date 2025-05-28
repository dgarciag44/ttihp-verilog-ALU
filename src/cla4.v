`timescale 1ns / 1ps

module cla4 (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout,
    output       P,    // Propagate de bloque
    output       G     // Generate de bloque
);
    wire [3:0] p, g;
    wire [4:0] c;

    assign p = A ^ B;
    assign g = A & B;
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign Sum  = p ^ c[3:0];
    assign Cout = c[4];

    assign P = &p;  // Group propagate (todos propagan)
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule
