`timescale 1ns / 1ps

module tt_um_fsm_dgarciag44 (
    input  [7:0]  ui_in,     // Dedicated inputs
    output [7:0]  uo_out,    // Dedicated outputs
    input  [7:0]  uio_in,    // Bidirectional (input)
    output [7:0]  uio_out,   // Bidirectional (output)
    output [7:0]  uio_oe,    // Bidirectional (enable)
    input         ena,       // Enable signal (unused)
    input         clk,       // Clock
    input         rst_n      // Active-low reset
);

    // Convert reset to active-high
    wire reset = ~rst_n;

    // Assign signals from ui_in
    wire BT          = ui_in[0];
    wire [1:0] temp  = ui_in[3:2];
    wire [1:0] select= ui_in[5:4];

    wire [2:0] E;
    wire [1:0] K;

    // Instantiate Mealy
    mealy u_mealy (
        .BT(BT),
        .clk(clk),
        .reset(reset),
        .temp(temp),
        .E(E)
    );

    // Instantiate Moore
    moore u_moore (
        .E(E),
        .clk(clk),
        .reset(reset),
        .select(select),
        .K(K)
    );

    // Map outputs to Tiny Tapeout pins
    assign uo_out[1:0] = K;
    assign uo_out[7:2] = 6'b0;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
