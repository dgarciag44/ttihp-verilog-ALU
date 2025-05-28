`timescale 1ns / 1ps

module cla4 (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout
);

    wire [3:0] P, G;
    wire [4:0] C;

    assign P = A ^ B;      // Propagate
    assign G = A & B;      // Generate

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    assign S = P ^ C[3:0]; // Final sum
    assign Cout = C[4];    // Final carry out

endmodule
