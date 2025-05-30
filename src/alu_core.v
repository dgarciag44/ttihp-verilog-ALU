module alu_core (
    input [7:0] A, B,
    input [2:0] op,
    output reg [7:0] R,
    output Zero, Negative, Carry, Overflow
);
    wire [7:0] sum, sub;
    wire cout_sum, cout_sub;

    cla8 adder (A, B, 0, sum, cout_sum);
    cla8 subtracter (A, ~B, 1, sub, cout_sub);

    always @(*) begin
        case (op)
            3'b000: R = sum;
            3'b001: R = sub;
            3'b010: R = A & B;
            3'b011: R = A | B;
            3'b100: R = A << 1;
            3'b101: R = A >> 1;
            default: R = 8'b0;
        endcase
    end

    assign Zero = (R == 0);
    assign Negative = R[7];
    assign Carry = (op == 3'b000) ? cout_sum : ((op == 3'b001) ? cout_sub : 0);
    assign Overflow = (op == 3'b000) ? (A[7] & B[7] & ~R[7]) | (~A[7] & ~B[7] & R[7]) : 0;
endmodule
