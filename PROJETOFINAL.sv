module pulse_width_counter (
    input logic clk, rst, pulse_in,
    input logic read_time, // Sinal para ler o tempo da última rodada
    output logic ready, done_tick,
    output logic [19:0] count, // contador de ciclos
    output logic [31:0] time_ms, // tempo atual em milissegundos
    output logic [31:0] last_time_ms // tempo da última rodada em milissegundos
);

// Tipos de estado para FSM
typedef enum {idle, counting, done} state_type;

state_type state_reg, state_next;

logic [31:0] count_reg, count_next;
logic [31:0] time_ms_reg, time_ms_next;
logic [31:0] last_time_ms_reg, last_time_ms_next; // Armazena o tempo da última rodada

// Constante para converter ciclos de clock em milissegundos
  parameter logic [31:0] MS_PER_CLOCK = 50000; // 50000 ciclos por milissegundo (a 50MHz)

logic pulse_in_prev; // Para detectar borda
logic edge_detected;

// FSM registers
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        state_reg <= idle;
        count_reg <= 0;
        time_ms_reg <= 0;
        last_time_ms_reg <= 0;
        pulse_in_prev <= 0;
    end else begin
        state_reg <= state_next;
        count_reg <= count_next;
        time_ms_reg <= time_ms_next;
        last_time_ms_reg <= last_time_ms_next;
        pulse_in_prev <= pulse_in; // Atualiza o valor anterior de pulse_in
    end
end

// Detecta borda de subida e descida
assign edge_detected = (pulse_in && !pulse_in_prev); // Detecta borda de subida

// Next state logic
always_comb begin
    // Inicializa os sinais
    state_next = state_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    count_next = count_reg;
    time_ms_next = time_ms_reg;
    last_time_ms_next = last_time_ms_reg; // Mantém o valor atual

    case (state_reg)
        idle: begin
            ready = 1'b1;
            if (edge_detected) begin // Detecta borda de subida
                count_next = 0; // Reseta o contador
                state_next = counting;
            end
        end

        counting: begin
            if (!pulse_in) begin // Detecta borda de descida
                state_next = done;
            end else begin
                count_next = count_reg + 1; // Incrementa o contador
            end
        end

        done: begin
            done_tick = 1'b1;
            time_ms_next = count_reg * MS_PER_CLOCK; // Converte ciclos em milissegundos
            if (read_time) begin
                last_time_ms_next = time_ms_next; // Armazena o tempo da última contagem
            end
            state_next = idle; // Volta para idle após a contagem
        end

        default: state_next = idle;
    endcase
end

// Atribui as saídas
assign time_ms = time_ms_reg; // Tempo atual em milissegundos
assign count = count_reg; // Contador de ciclos
assign last_time_ms = last_time_ms_reg; // Tempo da última rodada em milissegundos

endmodule
