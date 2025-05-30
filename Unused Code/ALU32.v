
`timescale 1ns / 100ps

module ALU32 (result, carry_out, a, b, op);

output [31:0] result;
output carry_out;

input [31:0] a;
input [31:0] b;
input [1:0] op;

wire [30:0] carry_wires;

// op_add = 2'd0, op_and = 2'd1, op_not = 2'd2;

one_bit_ALU alu[31:0] (
    .result (result),
    .c_out ({carry_out, carry_wires}),
    .c_in ({carry_wires, 1'b0}),
    .a (a),
    .b (b),
    .op (op)
);

endmodule