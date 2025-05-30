
`define ERR_RATE 5

`timescale 1ns / 100ps

module TMR_tb ();

    integer i = 0, j = 0;
    integer seed = 31415;
    integer c_err, t2_err, t3_err;      // Error flags for ALUs. 
    // Note that CTRL and T1 share err flag. More on this in the report.

    integer ctrl_err_count = 0, tmr_err_count = 0;

    // Shared inputs across all ALUs
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;

    // Reference results that are unaffected by SEUs
    wire [31:0] ref_result;
    wire ref_c_out;

    // Reference ALU 
    ALU32 ref_ALU (
        .result (ref_result),
        .carry_out (ref_c_out),
        .a (a),
        .b (b),
        .op (op)
    );

    // Control results for ALU that has no TMR and is affected by SEUs
    wire [31:0] ctrl_result;
    wire ctrl_c_out;

    // Control ALU
    ALU32 ctrl_ALU (
        .result (ctrl_result),
        .carry_out (ctrl_c_out),
        .a (a),
        .b (b),
        .op (op)
    );

    // TMR results for ALUs that vote on results and are affected by SEUs
    wire [31:0] tmr1_result; wire tmr1_c_out;
    wire [31:0] tmr2_result; wire tmr2_c_out;
    wire [31:0] tmr3_result; wire tmr3_c_out;

    // Triplex ALUs
    ALU32 tmr_ALU_1 (tmr1_result, tmr1_c_out, a, b, op);
    ALU32 tmr_ALU_2 (tmr2_result, tmr2_c_out, a, b, op);
    ALU32 tmr_ALU_3 (tmr3_result, tmr3_c_out, a, b, op);


    // SEU block: Trigger SEU against control and TMR ALUs every nanosecond.
    // Note that this will almost always flip way more than 1 bit. For the 
    // purposes of this test and this circuit, wrong is wrong and this does not 
    // invalidate results. 

    reg [31:0] ctrl_r_reg; reg ctrl_c_reg;
    reg [31:0] t1_r_reg;   reg t1_c_reg;
    reg [31:0] t2_r_reg;   reg t2_c_reg;
    reg [31:0] t3_r_reg;   reg t3_c_reg;



    always #1 begin

        

        c_err <= $urandom(seed) % 100;
        t2_err <= $urandom(seed) % 100;
        t3_err <= $urandom(seed) % 100;

        if (c_err < `ERR_RATE) begin
            
        end

        if (t2_err < `ERR_RATE) begin
        end

        if (t3_err < `ERR_RATE) begin
        end
    end

    // Test Vectors
    initial begin
        
    #100 $finish;

    end
endmodule