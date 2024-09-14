module somador_serial(
    input clk,
    input reset,
    input a,
    input b,
    output reg s,
    output reg cout
);

    reg carry;

    always @(posedge clk) begin
        if (reset) begin
            carry <= 1'b0;
            s <= 1'b0;
            cout <= 1'b0;
        end else begin
            // Somador completo:
            {s, cout} <= a + b + carry;
            carry <= cout;
        end
    end

endmodule
