// One bit ALU test bench

`timescale 1ns / 100ps

module one_bit_ALU_tb ();

    reg a, b;
    reg [1:0] op;
    reg c_in = 0;

    wire result, c_out;

    one_bit_ALU uut (
        .result (result),
        .c_out (c_out),
        .c_in (c_in),
        .a (a),
        .b (b),
        .op (op)
    );

    initial begin
        #1 $monitor("| %b | %b |   %b  | %b |    %b   |   %b   |",
                        a, b, c_in, op, result, c_out);
    end

initial begin

    $display("\n|-----One Bit Addition Test----------|");
    $display("| a | b | c_in | op | result | c_out |");
    $display("|---|---|------|----|--------|-------|");
    #5 c_in = 0; op = 0;
       a = 0; b = 0;
    #5 a = 0; b = 1;
    #5 a = 1; b = 0;
    #5 a = 1; b = 1;
    #5 c_in = 1;
       a = 0; b = 0;
    #5 a = 0; b = 1;
    #5 a = 1; b = 0;
    #5 a = 1; b = 1;

    #5;
    $display("\n|------One Bit AND Test--------------|");
    $display("| a | b | c_in | op | result | c_out |");
    $display("|---|---|------|----|--------|-------|");
    c_in = 0; op = 1;
       a = 0; b = 0;
    #5 a = 0; b = 1;
    #5 a = 1; b = 0;
    #5 a = 1; b = 1;

    #5;
    $display("\n|---------One Bit NOT Test-----------|");
    $display("| a | b | c_in | op | result | c_out |");
    $display("|---|---|------|----|--------|-------|");
    op = 2; b = 0;
       a = 0;
    #5 a = 1;
    #5 a = 0;
    #5 a = 1;

    #5;
    $display("\n|---------High Impedance Test--------|");
    $display("| a | b | c_in | op | result | c_out |");
    $display("|---|---|------|----|--------|-------|");
    op = 3; a = 0; b = 0;
    #5 a = 1; b = 0;
    #5 a = 0; b = 1;


    #5;
    $display("\n|-----------END OF TEST--------------|"); $finish;
end

endmodule