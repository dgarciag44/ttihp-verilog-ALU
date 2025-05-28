`timescale 1ns / 1ps

module tt_um_alu_dgarciag44 (
    input  [7:0]  ui_in,     // Entradas
    output [7:0]  uo_out,    // Salidas
    input  [7:0]  uio_in,    // Bidireccionales (entrada)
    output [7:0]  uio_out,   // Bidireccionales (salida)
    output [7:0]  uio_oe,    // Bidireccionales (habilitar)
    input         ena,       // Enable general (no usado)
    input         clk,       // Clock global
    input         rst_n      // Reset activo bajo
);

    // Convertimos reset a activo alto
    wire reset = ~rst_n;

    // Mapear entradas:
    wire bit_in       = ui_in[0];         // bit de dato serial
    wire sel_AB       = ui_in[1];         // seleccionar A o B
    wire confirm      = ui_in[2];         // confirmar/cargar
    wire [2:0] op     = ui_in[5:3];       // operación ALU
    wire show_flags   = ui_in[6];         // mostrar flags
    wire shift_ctrl   = ui_in[7];         // cantidad de desplazamiento (manual)

    // Salidas internas
    wire [7:0] result_out;
    wire [3:0] flags_out;

    // Instancia de la ALU
    alu_core alu_inst (
        .clk(clk),
        .reset(reset),
        .load_bit(bit_in),
        .sel_AB(sel_AB),
        .op(op),
        .confirm(confirm),
        .show_flags(show_flags),
        .shift_ctrl(shift_ctrl),
        .bit_in(bit_in),
        .result_out(result_out),
        .flags_out(flags_out)
    );

    // Salidas al chip
    assign uo_out = result_out;

    // Pines bidireccionales no usados
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
