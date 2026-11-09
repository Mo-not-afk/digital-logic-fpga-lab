`timescale 1ns/1ps
module tb_alu;
    reg [7:0] a, b;
    reg [2:0] operation;
    wire [7:0] result;
    wire carry, overflow, zero;

    alu #(.WIDTH(8)) dut(a, b, operation, result, carry, overflow, zero);

    task verify;
        input [7:0] operand_a, operand_b, expected;
        input [2:0] op;
        input expected_carry, expected_overflow;
        begin
            a = operand_a;
            b = operand_b;
            operation = op;
            #1;
            if (result !== expected || carry !== expected_carry || overflow !== expected_overflow
                || zero !== (expected == 8'b0))
                $fatal(1, "ALU op=%b a=%h b=%h got=%h carry=%b overflow=%b zero=%b",
                       op, operand_a, operand_b, result, carry, overflow, zero);
        end
    endtask

    initial begin
        $dumpfile("build/tb_alu.vcd");
        $dumpvars(0, tb_alu);
        verify(8'h03, 8'h04, 8'h07, 3'b000, 0, 0);
        verify(8'hff, 8'h01, 8'h00, 3'b000, 1, 0);
        verify(8'h7f, 8'h01, 8'h80, 3'b000, 0, 1);
        verify(8'h09, 8'h04, 8'h05, 3'b001, 1, 0);
        verify(8'h03, 8'h04, 8'hff, 3'b001, 0, 0);
        verify(8'h0f, 8'h33, 8'h03, 3'b010, 0, 0);
        verify(8'h0f, 8'h30, 8'h3f, 3'b011, 0, 0);
        verify(8'h55, 8'h0f, 8'h5a, 3'b100, 0, 0);
        verify(8'hff, 8'h01, 8'h01, 3'b101, 0, 0); // signed -1 < +1
        verify(8'h00, 8'h00, 8'h00, 3'b001, 1, 0);
        $display("PASS: ALU operations, carry, overflow, signed compare, and zero flag");
        $finish;
    end
endmodule
