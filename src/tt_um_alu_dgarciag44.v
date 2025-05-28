`timescale 1ns / 1ps

module tt_um_alu_dgarciag44 (
    input  [7:0]  ui_in,
    output [7:0]  uo_out,
    input  [7:0]  uio_in,
    output [7:0]  uio_out,
    output [7:0]  uio_oe,
    input         ena,
    input         clk,
    input         rst_n
);

    wire reset = ~rst_n;

    wire data_in   = ui_in[0];
    wire sel_ab    = ui_in[1];
    wire save_bit  = ui_in[2];
    wire [2:0] alu_op = ui_in[5:3];
    wire show_flags = ui_in[7];
    wire show_shift = ui_in[6];

    reg [7:0] A = 8'd0;
    reg [7:0] B = 8'd0;

    // Carga de datos bit a bit
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 8'd0;
            B <= 8'd0;
        end else if (save_bit) begin
            if (sel_ab == 1'b0)
                A <= {A[6:0], data_in};  // shift-in a A
            else
                B <= {B[6:0], data_in};  // shift-in a B
        end
    end

    wire [7:0] alu_result;
    wire [3:0] flags;

    alu_core alu_inst (
        .A(A),
        .B(B),
        .op(alu_op),
        .shift_amount(ui_in[7:6]),
        .result(alu_result),
        .flags(flags)
    );

    assign uo_out = show_flags ? {4'b0, flags} :
                    show_shift ? (alu_op[0] ? (A >> ui_in[7:6]) : (A << ui_in[7:6])) :
                    alu_result;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
