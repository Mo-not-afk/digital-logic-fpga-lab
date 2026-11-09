`timescale 1ns/1ps
module tb_combinational;
    reg a, b;
    wire and_y, or_y, xor_y, nand_y, nor_y, xnor_y;
    reg [3:0] mux_data;
    reg [1:0] mux_select;
    wire mux_y;
    reg [2:0] decoder_address;
    reg decoder_enable;
    wire [7:0] one_hot;
    integer left_bit, right_bit;

    logic_gates gates(a, b, and_y, or_y, xor_y, nand_y, nor_y, xnor_y);
    mux4 mux(mux_data, mux_select, mux_y);
    decoder3to8 decoder(decoder_address, decoder_enable, one_hot);

    initial begin
        $dumpfile("build/tb_combinational.vcd");
        $dumpvars(0, tb_combinational);
        mux_data = 4'b1010;
        for (left_bit = 0; left_bit < 2; left_bit = left_bit + 1) begin
            for (right_bit = 0; right_bit < 2; right_bit = right_bit + 1) begin
                a = left_bit[0];
                b = right_bit[0];
                #1;
                if (and_y !== (a & b) || or_y !== (a | b) || xor_y !== (a ^ b)
                    || nand_y !== ~(a & b) || nor_y !== ~(a | b) || xnor_y !== ~(a ^ b))
                    $fatal(1, "gate truth-table mismatch for a=%b b=%b", a, b);
            end
        end
        for (left_bit = 0; left_bit < 4; left_bit = left_bit + 1) begin
            mux_select = left_bit[1:0];
            #1;
            if (mux_y !== mux_data[mux_select]) $fatal(1, "mux mismatch at select=%0d", mux_select);
        end
        decoder_enable = 1'b1;
        for (left_bit = 0; left_bit < 8; left_bit = left_bit + 1) begin
            decoder_address = left_bit[2:0];
            #1;
            if (one_hot !== (8'b1 << left_bit)) $fatal(1, "decoder mismatch at address=%0d", left_bit);
        end
        decoder_enable = 1'b0;
        #1;
        if (one_hot !== 8'b0) $fatal(1, "disabled decoder must clear every output");
        $display("PASS: gates, 4:1 mux, and 3:8 decoder");
        $finish;
    end
endmodule
