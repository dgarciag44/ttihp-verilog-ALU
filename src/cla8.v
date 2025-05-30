module cla8 (
    input [7:0] A, B,
    input Cin,
    output [7:0] Sum,
    output Cout
);
    wire P0, G0, P1, G1, C4;

    cla4 cla_low (
        .A(A[3:0]), .B(B[3:0]), .Cin(Cin),
        .Sum(Sum[3:0]), .Cout(), .P(P0), .G(G0)
    );

    cla4 cla_high (
        .A(A[7:4]), .B(B[7:4]), .Cin(C4),
        .Sum(Sum[7:4]), .Cout(), .P(P1), .G(G1)
    );

    assign C4 = G0 | (P0 & Cin);
    assign Cout = G1 | (P1 & C4);
endmodule
