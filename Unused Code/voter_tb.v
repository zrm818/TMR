
`timescale 1ns / 1ns

module voter_tb();

reg a, b, c;
wire out;

voter voter_1 (
    .a (a),
    .b (b),
    .c (c),
    .out (out)
);

initial begin
    $monitor("| %b | %b | %b |  %b  |", a, b, c, out);
    $monitoroff;
end

initial begin
    $vcdpluson;

    $display("| a | b | c | out |");
    $display("|---|---|---|-----|");
    $monitoron;
    
    #5 a = 1'b0; b = 1'b0; c = 1'b0;
    #5 a = 1'b0; b = 1'b0; c = 1'b1;
    #5 a = 1'b0; b = 1'b1; c = 1'b0;
    #5 a = 1'b0; b = 1'b1; c = 1'b1;
    #5 a = 1'b1; b = 1'b0; c = 1'b0;
    #5 a = 1'b1; b = 1'b0; c = 1'b1;
    #5 a = 1'b1; b = 1'b1; c = 1'b0;
    #5 a = 1'b1; b = 1'b1; c = 1'b1;

    #5 $finish;
end

endmodule