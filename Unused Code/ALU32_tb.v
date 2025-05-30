
`timescale 1ns / 100ps

module ALU32_tb ();

    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;

    wire [31:0] result;
    wire carry_out;

    ALU32 uut (
        .result (result),
        .carry_out (carry_out),
        .a (a),
        .b (b),
        .op (op)
    );

    initial begin
        $monitor("\t| %h | %h | %d  | %h  |   %b   |", 
                        a, b, op, result, carry_out);
        $monitoroff;
    end

initial begin
    $display("\n\t_________________Addition Test__________________");
    $display("\t| A[31:0]  | A[31:0]  | OP | RES[31:0] | C_OUT |");
    $display("\t|----------|----------|----|-----------|-------|");
    $monitoron;
    #5 op = 2'b00;
       a = 32'h0000_0000; b = 32'h0000_0000;
    #5 a = 32'h0000_1234; b = 32'h0000_2222;
    #5 a = 32'h1111_1111; b = 32'h1111_1111;
    #5 a = 32'hFFFF_FFFF; b = 32'h0000_0001;
    #5 a = 32'hFFFF_FFFF; b = 32'hFFFF_FFFF;
    #5 a = 32'h8765_5678; b = 32'h1212_1212;

    #5;
    $display("\n\t___________________AND Test_____________________");
    $display("\t| A[31:0]  | A[31:0]  | OP | RES[31:0] | C_OUT |");
    $display("\t|----------|----------|----|-----------|-------|");
    #5 op = 2'b01;
       a = 32'h0000_0000; b = 32'h0000_0000;
    #5 a = 32'h0000_1234; b = 32'h0000_2222;
    #5 a = 32'h1111_1111; b = 32'h3333_7777;
    #5 a = 32'hFFFF_FFFF; b = 32'h0000_0001;
    #5 a = 32'hFFFF_FFFF; b = 32'hFFFF_FFFF;
    #5 a = 32'h8765_5678; b = 32'h1212_1212;

    #5;
    $display("\n\t__________________NOT A Test____________________");
    $display("\t| A[31:0]  | A[31:0]  | OP | RES[31:0] | C_OUT |");
    $display("\t|----------|----------|----|-----------|-------|");
    #5 op = 2'b10; b =32'h0000_0000;
       a = 32'h0000_0000;
    #5 a = 32'h0000_1234;
    #5 a = 32'h1111_1111;
    #5 a = 32'hFFFF_FFFF;
    #5 a = 32'hFFFF_FFFF;
    #5 a = 32'h8765_5678;

    #5 $display("\n\t|-----------------END OF TEST------------------|\n\n");
    $finish;
end

endmodule