module cla4 (
    input [3:0] A, B,
    input Cin,
    output [3:0] Sum,
    output Cout,
    output P, G
);
    wire [3:0] P_local, G_local;
    wire [4:0] C;

    assign P_local = A ^ B;
    assign G_local = A & B;

    assign C[0] = Cin;
    assign C[1] = G_local[0] | (P_local[0] & C[0]);
    assign C[2] = G_local[1] | (P_local[1] & C[1]);
    assign C[3] = G_local[2] | (P_local[2] & C[2]);
    assign C[4] = G_local[3] | (P_local[3] & C[3]);

    assign Sum = P_local ^ C[3:0];
    assign Cout = C[4];
    assign P = &P_local;
    assign G = |G_local;
endmodule
