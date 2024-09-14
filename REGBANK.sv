module banco_registradores (
    input logic clock,
    input logic reset,
    input logic [1:0] add_rd0,
    input logic [1:0] add_rd1,
    input logic wr_en,
    input logic [1:0] add_wr,
    input logic [7:0] wr_data,
    output logic [7:0] rd0,
    output logic [7:0] rd1
);

    logic [7:0] registrador [3:0];

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            registrador[0] <= 8'b0;
            registrador[1] <= 8'b0;
            registrador[2] <= 8'b0;
            registrador[3] <= 8'b0;
        end else begin
            if (wr_en) begin
                registrador[add_wr] <= wr_data;
            end
        end
    end

    assign rd0 = registrador[add_rd0];
    assign rd1 = registrador[add_rd1];

endmodule
