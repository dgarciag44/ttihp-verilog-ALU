module tt_um_alu_dgarciag44 (
    input  [7:0]  ui_in,     // Dedicated inputs
    output [7:0]  uo_out,    // Dedicated outputs
    input  [7:0]  uio_in,    // Bidirectional (unused)
    output [7:0]  uio_out,   // Bidirectional (unused)
    output [7:0]  uio_oe,    // Bidirectional enable (unused)
    input         ena,       // Enable (unused)
    input         clk,       // Clock
    input         rst_n      // Active-low reset
);

    // Convertimos reset a activo alto
    wire reset = ~rst_n;

    // Entradas organizadas
    wire data_in    = ui_in[0];
    wire sel_ab     = ui_in[1];    // 0 → A, 1 → B
    wire load_bit   = ui_in[2];    // Confirmar/cargar bit
    wire [2:0] alu_op = ui_in[5:3]; // Operación ALU
    wire shift_mode = ui_in[6];
    wire show_flags = ui_in[7];

    // Registros A y B de 8 bits
    reg [7:0] A = 8'b0;
    reg [7:0] B = 8'b0;

    // Flags
    reg Zero, Negative, Carry, Overflow;

    // Resultado
    reg [7:0] Result;

    // Cargar bits en A o B
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 8'b0;
            B <= 8'b0;
        end else if (load_bit) begin
            if (sel_ab == 1'b0)
                A <= {A[6:0], data_in};  // Shift-in en A
            else
                B <= {B[6:0], data_in};  // Shift-in en B
        end
    end

    // ALU principal
    always @(*) begin
        case (alu_op)
            3'b000: {Carry, Result} = A + B;                   // Suma
            3'b001: {Carry, Result} = A - B;                   // Resta
            3'b010: Result = A & B;                           // AND
            3'b011: Result = A | B;                           // OR
            3'b100: Result = shift_mode ? (A >> 1) : (A << 1); // Shift
            3'b101: Result = shift_mode ? (B >> 1) : (B << 1); // Shift B
            default: Result = 8'b0;
        endcase

        // Flags
        Zero     = (Result == 8'b0);
        Negative = Result[7];
        Overflow = (alu_op == 3'b000 || alu_op == 3'b001) ? 
                   ((A[7] == B[7]) && (Result[7] != A[7])) : 1'b0;
    end

    // Salida final
    assign uo_out = show_flags ? {4'b0, Overflow, Carry, Negative, Zero} : Result;

    // Pines bidireccionales no usados
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
