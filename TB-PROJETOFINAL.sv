module tb_clock_counter;
    // Sinais de teste
    logic clk, rst, start;
    logic [4:0] i;
    logic ready, done_tick;
    logic [19:0] count;
    logic [31:0] time_ms;
    
    // Instancia o módulo que você quer testar
    clock_counter uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i(i),
        .ready(ready),
        .done_tick(done_tick),
        .count(count),
        .time_ms(time_ms)
    );
    
    // Gera o clock (50 MHz = 20 ns de período)
    always #10 clk = ~clk;
    
    // Inicializa os sinais
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        i = 0;
        
        // Reseta por alguns ciclos
        #40;
        rst = 0;
        
        // Teste 1: Contar 50.000 ciclos (1 ms)
        i = 50000;
        start = 1;
        #20;
        start = 0;  // Desliga o start
        
        // Espera o sinal de done_tick
        wait(done_tick);
        
        // Verifica os resultados
        $display("Teste 1 - Count: %0d, Time (ms): %0d", count, time_ms);
        
        // Teste 2: Contar 100.000 ciclos (2 ms)
        #40;
        i = 100000;
        start = 1;
        #20;
        start = 0;
        
        // Espera o done_tick
        wait(done_tick);
        
        // Verifica os resultados
        $display("Teste 2 - Count: %0d, Time (ms): %0d", count, time_ms);
        
        $finish;
    end
endmodule
