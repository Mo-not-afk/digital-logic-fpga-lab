`timescale 1ns/1ps
module tb_sequence_detector;
    reg clk = 0;
    reg reset_n = 0;
    reg serial_in = 0;
    wire detected;

    sequence_detector_1011 dut(clk, reset_n, serial_in, detected);
    always #5 clk = ~clk;

    task send_bit;
        input bit_value, expected_pulse;
        begin
            @(negedge clk);
            serial_in = bit_value;
            #1;
            if (detected !== expected_pulse)
                $fatal(1, "FSM pulse mismatch for input bit %b", bit_value);
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("build/tb_sequence_detector.vcd");
        $dumpvars(0, tb_sequence_detector);
        @(posedge clk); #1;
        @(negedge clk); reset_n = 1;
        send_bit(1, 0);
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(1, 1); // 1011 detected
        send_bit(0, 0);
        send_bit(1, 0);
        send_bit(1, 1); // overlapping 1011 detected
        $display("PASS: overlapping Mealy sequence detector for 1011");
        $finish;
    end
endmodule
