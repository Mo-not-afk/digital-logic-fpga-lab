// Synchronous active-low reset counter with enable and programmable terminal count.
module counter #(
    parameter WIDTH = 8,
    parameter MAX_COUNT = 255
) (
    input  wire             clk,
    input  wire             reset_n,
    input  wire             enable,
    output reg  [WIDTH-1:0] count
);
    always @(posedge clk) begin
        if (!reset_n)
            count <= {WIDTH{1'b0}};
        else if (enable) begin
            if (count == MAX_COUNT)
                count <= {WIDTH{1'b0}};
            else
                count <= count + {{(WIDTH-1){1'b0}}, 1'b1};
        end
    end
endmodule
