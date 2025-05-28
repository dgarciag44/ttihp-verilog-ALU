`timescale 1ns / 1ps

module cla8 (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);
    wire [1:0] P, G;
    wire [2:0] C;

    assign C[0] = Cin;

    cla4 cla_lower (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(C[0]),
        .Sum(Sum[3:0]),
        .Cout(),
        .P(P[0]),
        .G(G[0])
    );

    cla4 cla_upper (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[1]),
        .Sum(Sum[7:4]),
        .Cout(),
        .P(P[1]),
        .G(G[1])
    );

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);

    assign Cout = C[2];
endmodule
