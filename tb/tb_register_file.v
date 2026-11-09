`timescale 1ns/1ps
module tb_register_file;
    reg clk = 0;
    reg reset_n = 0;
    reg write_enable = 0;
    reg [2:0] write_address = 0;
    reg [7:0] write_data = 0;
    reg [2:0] read_address_a = 0, read_address_b = 0;
    wire [7:0] read_data_a, read_data_b;

    register_file #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut(
        clk, reset_n, write_enable, write_address, write_data,
        read_address_a, read_address_b, read_data_a, read_data_b
    );
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/tb_register_file.vcd");
        $dumpvars(0, tb_register_file);
        @(posedge clk); #1;
        if (read_data_a !== 0) $fatal(1, "register zero must read as zero after reset");
        @(negedge clk); reset_n = 1; write_enable = 1; write_address = 1; write_data = 8'hA5;
        @(posedge clk); #1;
        @(negedge clk); write_address = 2; write_data = 8'h3C;
        @(posedge clk); #1;
        @(negedge clk); write_enable = 0; read_address_a = 1; read_address_b = 2;
        #1;
        if (read_data_a !== 8'hA5 || read_data_b !== 8'h3C)
            $fatal(1, "asynchronous dual read mismatch");
        @(negedge clk); write_enable = 1; write_address = 0; write_data = 8'hFF;
        @(posedge clk); #1;
        if (read_data_a !== 8'hA5) $fatal(1, "write to constant-zero register altered other registers");
        @(negedge clk); write_enable = 0; read_address_a = 0; #1;
        if (read_data_a !== 0) $fatal(1, "register zero must remain constant");
        $display("PASS: synchronous reset/write and asynchronous dual read register file");
        $finish;
    end
endmodule
