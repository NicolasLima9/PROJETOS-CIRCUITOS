module TB;
    reg clk, rst;
    wire [31:0] op;
    integer file_handle;

    LFSR_32bit lfsr1(clk, rst, op);

    initial begin
        // Abrindo o arquivo para escrita
        file_handle = $fopen("resultados.txt", "w");

        $monitor("op=%d", op); // Exibindo no console
        clk = 0; rst = 1;
        #5 rst = 0;
        #500;

        // Fechando o arquivo
        $fclose(file_handle);
        $finish;
    end

    always #2 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end

    // Gravando os resultados no arquivo a cada ciclo de clock
    always @(posedge clk) begin
        $fwrite(file_handle, "%d\n", op);
    end
endmodule
