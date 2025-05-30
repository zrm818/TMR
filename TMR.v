/******************************************************************************
 ***                                                                        ***
 *** ECE 526 Final Project                      Zach Martin, Fall, 2024     ***
 ***                                                                        ***
 *** Triple Modular Redundancy                                              ***
 ***                                                                        ***
 ******************************************************************************
 *** Filename: TMR.v                 Created by Zach Martin, 12/01/2024     ***
 ***                                                                        ***
 *** Simulation demonstrating TMR vs Non-TMR accuracy with multiple tests   ***
 ***                                                                        ***
 ******************************************************************************/

`define ERR_RATE 1       // Error rate in percent, current max resolution = 0.1%
`define VECTS 1000       // Number of test vectors
`define TRIALS 10        // Number of trials to perform. NOTE: MUST HAVE SEEDS

`timescale 1ns / 1ns

module TMR();

// Determines how to view waveforms depending on current compiler
`ifdef __ICARUS__
    initial begin
        $dumpfile("tmr.vcd");
        $dumpvars(0, TMR);
    end
`elsif __VCS__
    initial begin
        $vcdpluson;
    end
`endif

// Verilog random number generator seed to conform to or violate stability.
// Change seeds in procedural block to generate new values.
integer seeds[0:9];
integer seed;

// Loop counters, dice roll outcomes, and one-bit error flags
integer i = 0, j = 0, k = 0;
real x, y, z;
reg x_err, y_err, z_err;

// Error counters and average error percentages
reg [$clog2(`VECTS)-1:0] err_count = 0;
reg [$clog2(`VECTS)-1:0] tmr_err_count = 0;
real avg_err = 0;
real avg_tmr_err = 0;


// ------------------------------ MAIN TEST BLOCK ------------------------------ 
initial begin

    // Define seeds. These can be any unique value to generate unique results
    seeds[0] = 0; 
    seeds[1] = 10; 
    seeds[2] = 200; 
    seeds[3] = 3000; 
    seeds[4] = 31415; 
    seeds[5] = 27182; 
    seeds[6] = 112358; 
    seeds[7] = 628318; 
    seeds[8] = 2; 
    seeds[9] = 42;

for (i = 0; i < `TRIALS; i=i+1) begin

    seed = seeds[i];    // Set seed for current trial

    $display("\n\tBatch %0d (seed: %0d): ", i+1, seed);

    for (j = 0; j < `TRIALS; j=j+1) begin

        err_count = 0; tmr_err_count = 0;   // Reset error counts for new trial

        for (k = 0; k < `VECTS; k=k+1) begin

            #1;

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

            #1;

            // First unit in TMR is also used as the non-triplex case.
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

        // Print the first trial's error counts 
        if (j == 1) begin
            $display("-------------------------------------------------------");
            $display("Errors in first trial (%0d vectors):", `VECTS);
            $display("  Errors without TMR: %0d,          Errors with TMR: %0d", 
                err_count, tmr_err_count);
        end
    end

    // Compute average error percentages for each trial
    avg_err = avg_err / (`TRIALS*`VECTS) * 100;
    avg_tmr_err = avg_tmr_err / (`TRIALS*`VECTS) * 100;

    // Display Averages and Improvement from TMR for each trial
    $display("-------------------------------------------------------");
    $display("Average error across %0d trials (%%):     ", `TRIALS);
    $display("  Error without TMR: %0.4f%%,   Error with TMR: %0.4f%%", 
        avg_err, avg_tmr_err);
    $display("-------------------------------------------------------");
    $display("Accuracy improvement using TMR:                  %0.1fx", 
        avg_err/avg_tmr_err);   // Potentially UNDEFINED (div by 0)
    $display("-------------------------------------------------------\n"); 

end     // End main for loop

$finish;    // Finish simulation

end     // End main test block

endmodule