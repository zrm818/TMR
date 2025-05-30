// Test bench designed to familiarize myself with Verilog's $random function.
// This module has nothing to do with the TMR and can be safely deleted.

`timescale 1ns/1ns

module rand_test();

integer i = 0, j = 0, x = 0, seed = 112358, err_count = 0;
integer vects = 100;
integer trials = 10;

initial begin

    for (j = 0; j < trials; j=j+1) begin    // Run 10 trials

        for (i = 0; i < vects; i=i+1) begin // 100 test vectors in each trial
            x = $urandom(seed) % 100;
            if (x < 1) err_count = err_count + 1;   // 5% Error rate
        end

        $display("Results of trial %d: %d Failure Rate.", j+1, err_count);
        err_count = 0;

    end

    $finish;

end

endmodule