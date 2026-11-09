`timescale 1ns/1ps
module tb_counter;
    reg clk = 0;
    reg reset_n = 0;
    reg enable = 0;
    wire [3:0] count;
    integer tick;

    counter #(.WIDTH(4), .MAX_COUNT(5)) dut(clk, reset_n, enable, count);
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/tb_counter.vcd");
        $dumpvars(0, tb_counter);
        @(posedge clk); #1;
        if (count !== 0) $fatal(1, "synchronous reset failed");
        @(negedge clk); reset_n = 1; enable = 1;
        for (tick = 1; tick <= 6; tick = tick + 1) begin
            @(posedge clk); #1;
            if (count !== (tick % 6)) $fatal(1, "counter mismatch at tick %0d: %0d", tick, count);
        end
        @(negedge clk); enable = 0;
        @(posedge clk); #1;
        if (count !== 0) $fatal(1, "disabled counter changed unexpectedly");
        $display("PASS: synchronous reset, enable, and modulo-6 counter");
        $finish;
    end
endmodule
