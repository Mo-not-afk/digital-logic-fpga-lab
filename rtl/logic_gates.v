// Basic combinational gates kept explicit for truth-table exercises.
module logic_gates (
    input  wire a,
    input  wire b,
    output wire and_y,
    output wire or_y,
    output wire xor_y,
    output wire nand_y,
    output wire nor_y,
    output wire xnor_y
);
    assign and_y  = a & b;
    assign or_y   = a | b;
    assign xor_y  = a ^ b;
    assign nand_y = ~(a & b);
    assign nor_y  = ~(a | b);
    assign xnor_y = ~(a ^ b);
endmodule

module mux4 (
    input  wire [3:0] data,
    input  wire [1:0] select,
    output reg        y
);
    always @* begin
        case (select)
            2'b00: y = data[0];
            2'b01: y = data[1];
            2'b10: y = data[2];
            2'b11: y = data[3];
            default: y = 1'b0;
        endcase
    end
endmodule

module decoder3to8 (
    input  wire [2:0] address,
    input  wire       enable,
    output reg  [7:0] one_hot
);
    always @* begin
        one_hot = 8'b0;
        if (enable)
            one_hot[address] = 1'b1;
    end
endmodule
