`timescale 1ns / 1ps

module alu_core (
    input        clk,
    input        reset,
    input        load_bit,      // ui[0]
    input        sel_AB,        // ui[1] (0=A, 1=B)
    input  [2:0] op,            // ui[5:3]
    input        confirm,       // ui[2]
    input        show_flags,    // ui[6]
    input        shift_ctrl,    // ui[7]
    input        bit_in,        // dato serial
    output [7:0] result_out,
    output [3:0] flags_out
);
    reg [7:0] A, B;
    reg [2:0] shift_amt;
    reg [7:0] result;
    reg       zero, negative, carry, overflow;

    wire [7:0] sum_out;
    wire       carry_out;

    // CLA sumador
    cla8 cla_unit (
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Sum(sum_out),
        .Cout(carry_out)
    );

    // Carga de datos serial
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 8'd0;
            B <= 8'd0;
        end else if (confirm) begin
            if (!sel_AB)
                A <= {A[6:0], bit_in};  // carga serial en A
            else
                B <= {B[6:0], bit_in};  // carga serial en B
        end
    end

    // Operación principal
    always @(*) begin
        case (op)
            3'b000: {carry, result} = {carry_out, sum_out};     // Suma
            3'b001: {carry, result} = A - B;                   // Resta
            3'b010: result = A & B;                            // AND
            3'b011: result = A | B;                            // OR
            3'b100: result = A << shift_amt;                   // Shift left
            3'b101: result = A >> shift_amt;                   // Shift right
            default: result = 8'd0;
        endcase

        zero     = (result == 8'd0);
        negative = result[7];
        overflow = (op == 3'b000 || op == 3'b001) ? (A[7] == B[7]) && (result[7] != A[7]) : 1'b0;
    end

    // Salidas
    assign result_out = (show_flags) ? {4'b0, zero, negative, carry, overflow} : result;
    assign flags_out  = {zero, negative, carry, overflow};
endmodule
