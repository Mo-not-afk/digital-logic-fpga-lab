// Overlapping Mealy detector for serial bit pattern 1011.
module sequence_detector_1011 (
    input  wire clk,
    input  wire reset_n,
    input  wire serial_in,
    output wire detected
);
    localparam [1:0] IDLE = 2'b00, GOT_1 = 2'b01, GOT_10 = 2'b10, GOT_101 = 2'b11;
    reg [1:0] state;
    reg [1:0] next_state;

    assign detected = (state == GOT_101) && serial_in;

    always @* begin
        next_state = IDLE;
        case (state)
            IDLE:    next_state = serial_in ? GOT_1 : IDLE;
            GOT_1:   next_state = serial_in ? GOT_1 : GOT_10;
            GOT_10:  next_state = serial_in ? GOT_101 : IDLE;
            GOT_101: next_state = serial_in ? GOT_1 : GOT_10;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end
endmodule
