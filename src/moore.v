`timescale 1ns / 1ps

module moore (
    input  wire [2:0] E,
    input  wire       clk,
    input  wire       reset,
    input  wire [1:0] select,
    output reg  [1:0] K
);

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 3'b000;
        else
            state <= E;
    end

    always @(*) begin
        case (state)
            3'b000: K = 2'b00;
            default: begin
                if (state[2] == 1'b1)
                    K = select;
                else
                    K = state[1:0];
            end
        endcase
    end

endmodule
