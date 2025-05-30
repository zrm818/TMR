// Simulation Environment demonstrating TMR over multiple tests
// Current trials: 100  |  Current vectors per trial: 1000

`define ERR_RATE 1      // Error rate (in percent, current resolution = 0.1)

module TMR();

// Verilog random number generator seed to conform to or violate stability.
// Change seed to generate new values, keep it the same to reproduce results.
integer seed; integer seeds[0:9]; integer seed_count = 10;

// Establish loop counters, dice roll outcomes, and one-bit error flags
integer i = 0, j = 0, k = 0;
real x, y, z;
reg x_err, y_err, z_err;

// Error counters and average error percentages
integer err_count = 0;
integer tmr_err_count = 0;
real avg_err = 0;
real avg_tmr_err = 0;

// Number of test vectors and number of trials to perform
integer vects = 1000;
integer trials = 100;

initial begin

    seeds[0] = 0; seeds[1] = 10; seeds[2] = 200; seeds[3] = 3000; 
    seeds[4] = 31415; seeds[5] = 27182; seeds[6] = 112358; 
    seeds[7] = 628318; seeds[8] = 2; seeds[9] = 42;

for (k = 0; k < seed_count; k=k+1) begin

    seed = seeds[k];

    $display("\n\tTEST %0d (SEED: %0d): ", k+1, seed);

    for (i = 0; i < trials; i=i+1) begin

        err_count = 0; tmr_err_count = 0;

        for (j = 0; j < vects; j=j+1) begin

            // Life is all about chance. Roll dice for each module
            x = $urandom(seed) % 1000;
            y = $urandom(seed) % 1000;
            z = $urandom(seed) % 1000;

            // See if the dice rolled above create SEU error
            if (x/10 < `ERR_RATE) begin
                x_err = 1;
            end if (y/10 < `ERR_RATE) begin
                y_err = 1;
            end if (z/10 < `ERR_RATE) begin
                z_err = 1;
            end

            // First unit is also used as the non-triplex case.
            // More info on this can be found in the report.
            if (x_err) begin
                err_count = err_count + 1;
            end

            // This is a voter. 
            // If more than 1 unit is wrong, voter will be wrong
            if (x_err + y_err + z_err > 1) begin
                tmr_err_count = tmr_err_count + 1;
            end

            // Reset error flags
            x_err = 0; y_err = 0; z_err = 0;

        end

        // Rolling sum of errors to be used later in average calculation
        avg_err = avg_err + err_count;
        avg_tmr_err = avg_tmr_err + tmr_err_count;

        // Print the first error counts 
        if (i == 1) begin
            $display("-------------------------------------------------------");
            $display("Error count for 1 sample trial (1000 test vectors):");
            $display("  Errors without TMR: %0d,          Errors with TMR: %0d", 
                err_count, tmr_err_count);
        end
    end

    // Compute average error percentages
    avg_err = avg_err / (trials*vects) * 100;
    avg_tmr_err = avg_tmr_err / (trials*vects) * 100;

    // Display Averages and Improvement from TMR
    $display("-------------------------------------------------------");
    $display("Average error across %0d trials (%%):     ", trials);
    $display("  Error without TMR: %0.4f%%,   Error with TMR: %0.4f%%", 
        avg_err, avg_tmr_err);
    $display("-------------------------------------------------------");
    $display("Accuracy improvement using TMR:                  %0.1fx", 
        avg_err/avg_tmr_err);   // Potentially UNDEFINED (div by 0)
    $display("-------------------------------------------------------\n"); 

end

$finish;

end

endmodule