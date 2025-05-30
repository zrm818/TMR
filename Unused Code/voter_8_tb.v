
`timescale 1ns / 1ns

`define WIDTH 8

module voter_tb();

reg  [`WIDTH-1:0] a;
reg  [`WIDTH-1:0] b;
reg  [`WIDTH-1:0] c;
wire [`WIDTH-1:0] out;

voter #(.WIDTH(`WIDTH)) voter_8 (
    .a (a),
    .b (b),
    .c (c),
    .out (out)
);

initial begin
    $monitor("| %h | %h | %h | %h  |", a, b, c, out);
    $monitoroff;
end

initial begin
    $vcdpluson;

    $display("| a  | b  | c  | out |");
    $display("|----|----|----|-----|");
    $monitoron;
    
    #5 a = 8'h00; b = 8'h00; c = 8'h00;     // Output 00
    #5 a = 8'h00; b = 8'h00; c = 8'hFF;     // Output 00
    #5 a = 8'hFF; b = 8'h00; c = 8'h00;     // Output 00

    #5 a = 8'h00; b = 8'hFF; c = 8'hFF;     // Output FF
    #5 a = 8'hFF; b = 8'hFF; c = 8'h00;     // Output FF
    #5 a = 8'hFF; b = 8'hFF; c = 8'hFF;     // Output FF

    #5 a = 8'h22; b = 8'h22; c = 8'h10;     // Output 22
    #5 a = 8'h77; b = 8'h66; c = 8'h22;     // Output 22 *RESULT OF BITWISE AND
    #5 a = 8'h55; b = 8'h44; c = 8'h00;     // Output 44 *RESULT OF BITWISE AND

    #5 a = 8'h11; b = 8'h22; c = 8'h44;     // Output 00 *RESULT OF BITWISE AND

    #5 $finish;
end

endmodule