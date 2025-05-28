`timescale 1ns / 1ps

module mealy (
    input  wire        BT,
    input  wire        clk,
    input  wire        reset,
    input  wire [1:0]  temp,
    output reg  [2:0]  E
);

    typedef enum reg [1:0] {S0, S1, S2} estado_t;
    estado_t state, nextstate;

    always @(*) begin
        if (BT)
            nextstate = S2;
        else if (temp == 2'b00)
            nextstate = S0;
        else
            nextstate = S1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= nextstate;
    end

    always @(*) begin
        case (state)
            S0: E = 3'b000;
            S1: E = {1'b0, temp};
            S2: E = {1'b1, 2'b00};
            default: E = 3'b000;
        endcase
    end

endmodule
