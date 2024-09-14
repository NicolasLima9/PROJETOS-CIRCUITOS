module clock_counter(
    input logic clk, rst, start,
    input logic[4:0] i, // valor de ciclos para contar
    output logic ready, done_tick,
    output logic[19:0] count, // contador de ciclos
    output logic[31:0] time_ms // tempo em milissegundos
);

typedef enum {idle, counting, done} state_type;

state_type state_reg, state_next;

logic [31:0] count_reg, count_next;
logic [31:0] time_ms_reg, time_ms_next;
logic [31:0] total_cycles;
logic [4:0] n_reg, n_next; // Registra o valor de 'i'

// Constante para converter o número de ciclos em milissegundos
parameter logic [31:0] CYCLES_PER_MS = 50_000; // 50.000 ciclos por milissegundo a 50 MHz

// FSM registers
always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        state_reg <= idle;
        count_reg <= 0;
        time_ms_reg <= 0;
        n_reg <= 0;
    end else begin
        state_reg <= state_next;
        count_reg <= count_next;
        time_ms_reg <= time_ms_next;
        n_reg <= n_next;
    end
end

// Next state logic
always_comb begin
    // Inicializa os sinais
    state_next = state_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    count_next = count_reg;
    time_ms_next = time_ms_reg;
    n_next = n_reg;

    case (state_reg)
        idle: begin
            ready = 1'b1;
            if (start) begin
                count_next = 0;
                time_ms_next = 0;
                n_next = i; // Inicializa o valor de 'i'
                state_next = counting;
            end
        end

        counting: begin
            if (n_reg == 0) begin
                state_next = done;
            end else begin
                count_next = count_reg + 1; // Incrementa os ciclos de clock
                n_next = n_reg - 1;
                // Calcula o tempo em milissegundos baseado nos ciclos de clock
                time_ms_next = count_reg / CYCLES_PER_MS; 
            end
        end

        done: begin
            done_tick = 1'b1;
            state_next = idle;
        end

        default: state_next = idle;
    endcase
end

// Atribui as saídas
assign time_ms = time_ms_reg;
assign count = count_reg;

endmodule
