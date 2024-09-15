module tb_pulse_width_counter;
  logic clk, rst, pulse_in, read_time;
  logic ready, done_tick;
  logic [19:0] count;
  logic [31:0] time_ms, last_time_ms;

  // Parâmetros para o número de testes
  parameter NUM_TESTS = 5;
  int pulse_durations[NUM_TESTS]; // Array de durações dos pulsos

  // Instancia o DUT (Dispositivo Sob Teste)
  pulse_width_counter uut (
    .clk(clk),
    .rst(rst),
    .pulse_in(pulse_in),
    .read_time(read_time),
    .ready(ready),
    .done_tick(done_tick),
    .count(count),
    .time_ms(time_ms),
    .last_time_ms(last_time_ms)
  );

  // Gera o clock
  always #10 clk = ~clk;

  // Inicializa os sinais e reseta o sistema
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_pulse_width_counter);

    // Atribui valores ao pulse_durations
    pulse_durations[0] = 100_000;
    pulse_durations[1] = 200_000;
    pulse_durations[2] = 50_000;
    pulse_durations[3] = 150_000;
    pulse_durations[4] = 250_000;

    clk = 0;
    rst = 1;
    pulse_in = 0;
    read_time = 0;
    #40;
    rst = 0;

    // Loop para realizar múltiplos testes
    for (int i = 0; i < NUM_TESTS; i++) begin
      $display("Iniciando Teste %0d com duração de %0d ciclos de clock", i + 1, pulse_durations[i]);

      // Inicia o pulso
      pulse_in = 1;

      // Aguarda pelo tempo de pulso especificado
      repeat (pulse_durations[i] / 10) begin
        #10;
      end

      pulse_in = 0; // Finaliza o pulso
      #20;

      // Espera até que a FSM indique que a contagem está completa
      wait(done_tick);

      // Lê o tempo da contagem atual
      read_time = 1;
      #20;
      read_time = 0;

      // Exibe os resultados do teste
      $display("Teste %0d - Contador de ciclos: %0d, Tempo em ms: %0d, Último tempo registrado: %0d",
                i + 1, count, time_ms, last_time_ms);

      // Aguarda antes de iniciar o próximo teste
      #100;
    end

    $finish; // Finaliza a simulação
  end
endmodule
