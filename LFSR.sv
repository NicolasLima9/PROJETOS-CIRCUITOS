module LFSR_32bit(
    input clk, rst,
    output reg [31:0] op
);

    always @(posedge clk) begin
        if (rst)
            op <= 32'h12345678; // Valor inicial aleatório
        else
            op <= {op[30:0], ^({op[31], op[22], op[2], op[1], op[0]})};
    end
