// Parameterized combinational ALU. Arithmetic flags are defined for add/sub only.
module alu #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [2:0]       operation,
    output reg  [WIDTH-1:0] result,
    output reg              carry,
    output reg              overflow,
    output wire             zero
);
    localparam MSB = WIDTH - 1;
    reg [WIDTH:0] extended;

    always @* begin
        result = {WIDTH{1'b0}};
        carry = 1'b0;
        overflow = 1'b0;
        extended = {(WIDTH+1){1'b0}};
        case (operation)
            3'b000: begin // ADD
                extended = {1'b0, a} + {1'b0, b};
                result = extended[WIDTH-1:0];
                carry = extended[WIDTH];
                overflow = (~(a[MSB] ^ b[MSB])) & (result[MSB] ^ a[MSB]);
            end
            3'b001: begin // SUB; carry means no borrow
                extended = {1'b0, a} - {1'b0, b};
                result = extended[WIDTH-1:0];
                carry = ~extended[WIDTH];
                overflow = (a[MSB] ^ b[MSB]) & (result[MSB] ^ a[MSB]);
            end
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ($signed(a) < $signed(b)) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
            default: result = {WIDTH{1'b0}};
        endcase
    end

    assign zero = (result == {WIDTH{1'b0}});
endmodule
