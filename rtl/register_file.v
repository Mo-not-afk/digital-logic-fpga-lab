// Small register file with asynchronous reads and synchronous writes; register zero is constant.
module register_file #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire                    clk,
    input  wire                    reset_n,
    input  wire                    write_enable,
    input  wire [ADDR_WIDTH-1:0]   write_address,
    input  wire [DATA_WIDTH-1:0]   write_data,
    input  wire [ADDR_WIDTH-1:0]   read_address_a,
    input  wire [ADDR_WIDTH-1:0]   read_address_b,
    output wire [DATA_WIDTH-1:0]   read_data_a,
    output wire [DATA_WIDTH-1:0]   read_data_b
);
    localparam DEPTH = (1 << ADDR_WIDTH);
    reg [DATA_WIDTH-1:0] registers [0:DEPTH-1];
    integer index;

    always @(posedge clk) begin
        if (!reset_n) begin
            for (index = 0; index < DEPTH; index = index + 1)
                registers[index] <= {DATA_WIDTH{1'b0}};
        end else if (write_enable && (write_address != {ADDR_WIDTH{1'b0}})) begin
            registers[write_address] <= write_data;
        end
    end

    assign read_data_a = (read_address_a == {ADDR_WIDTH{1'b0}})
                       ? {DATA_WIDTH{1'b0}} : registers[read_address_a];
    assign read_data_b = (read_address_b == {ADDR_WIDTH{1'b0}})
                       ? {DATA_WIDTH{1'b0}} : registers[read_address_b];
endmodule
