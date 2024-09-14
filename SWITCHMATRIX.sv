module matriz_comutacao_2x2 (
    input logic [1:0] in1, in2,
    input logic control1, control2,
    output logic [1:0] out1, out2
);

    assign out1 = (control1) ? in2 : in1;
    assign out2 = (control2) ? in2 : in1;

endmodule
