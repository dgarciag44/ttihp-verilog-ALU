module tt_um_alu_dgarciag44 (
    input  [7:0] ui_in,
    output [7:0] uo_out,
    input  [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input        ena,
    input        clk,
    input        rst_n
);
    reg [7:0] A, B;
    wire [7:0] R;
    wire Zero, Negative, Carry, Overflow;

    wire bit_in = ui_in[0];
    wire sel_AB = ui_in[1];
    wire confirm = ui_in[2];
    wire [2:0] op = ui_in[5:3];
    wire shift_mode = ui_in[6];
    wire show_flags = ui_in[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A <= 0;
            B <= 0;
        end else if (confirm) begin
            if (sel_AB == 0)
                A <= {A[6:0], bit_in};
            else
                B <= {B[6:0], bit_in};
        end
    end

    alu_core alu (
        .A(A),
        .B(B),
        .op(op),
        .R(R),
        .Zero(Zero),
        .Negative(Negative),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    assign uo_out = show_flags ? {4'b0, Overflow, Carry, Negative, Zero} :
                     (shift_mode ? (op[0] ? A >> 1 : A << 1) : R);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;
endmodule
