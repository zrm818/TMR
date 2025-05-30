
`timescale 1ns / 1ns

module voter(out, a, b, c);

parameter WIDTH = 1;

input  [WIDTH-1:0] a;
input  [WIDTH-1:0] b;
input  [WIDTH-1:0] c;
output [WIDTH-1:0] out;
wire   [WIDTH-1:0] a_b;
wire   [WIDTH-1:0] a_c;
wire   [WIDTH-1:0] b_c;

assign a_b = ~(a & b);
assign a_c = ~(a & c);
assign b_c = ~(b & c);

assign out = ~(a_b & a_c & b_c);


endmodule