// One-bit ALU Unit for TMR testing

`timescale 1ns / 100ps

module one_bit_ALU (result, c_out, c_in, a, b, op);

output result;
output c_out;

input c_in, a, b;
input [1:0] op;

wire add_wire, and_wire, not_wire, c_out_wire;

localparam op_add = 2'd0, op_and = 2'd1, op_not = 2'd2;

assign {c_out_wire, add_wire} = a + b + c_in;
assign and_wire = a & b;
assign not_wire = ~a;

assign result = (op == 0) ? add_wire : 
                (op == 1) ? and_wire :
                (op == 2) ? not_wire : 2'bz;

assign c_out = (op == 0) ? c_out_wire : 1'bz;

endmodule