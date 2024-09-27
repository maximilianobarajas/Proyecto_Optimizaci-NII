F = [
  0  1  2  2  3  4  4  5  3  5  6  7;
  1  0  1  1  2  3  3  4  2  4  5  6;
  2  1  0  2  1  2  2  3  1  3  4  5;
  2  1  2  0  1  2  2  3  3  3  4  5;
  3  2  1  1  0  1  1  2  2  2  3  4;
  4  3  2  2  1  0  2  3  3  1  2  3;
  4  3  2  2  1  2  0  1  3  1  2  3;
  5  4  3  3  2  3  1  0  4  2  1  2;
  3  2  1  3  2  3  3  4  0  4  5  6;
  5  4  3  3  2  1  1  2  4  0  1  2;
  6  5  4  4  3  2  2  1  5  1  0  1;
  7  6  5  5  4  3  3  2  6  2  1  0
]


D = [
  0  3  4  6  8  5  6  6  5  1  4  6;
  3  0  6  3  7  9  9  2  2  7  4  7;
  4  6  0  2  6  4  4  4  2  6  3  6;
  6  3  2  0  5  5  3  3  9  4  3  6;
  8  7  6  5  0  4  3  4  5  7  6  7;
  5  9  4  5  4  0  8  5  5  5  7  5;
  6  9  4  3  3  8  0  6  8  4  6  7;
  6  2  4  3  4  5  6  0  1  5  5  3;
  5  2  2  9  5  5  8  1  0  4  5  2;
  1  7  6  4  7  5  4  5  4  0  7  7;
  4  4  3  3  6  7  6  5  5  7  0  9;
  6  7  6  6  7  5  7  3  2  7  9  0
]
include("BH_QAP.jl")
current_file = @__FILE__
best_params, best_cost = evolucion_diferencial_black_hole(D, F)
open("resultados.txt", "a") do io
    @printf(io, "Metodo: %s\n", "BH")
    @printf(io, "Problema: %s\n", current_file)
    @printf(io, "Parametros del BH: N=%f, R=%f\n", 
        best_params[1], best_params[2])
    @printf(io, "Mejor fitness: %f\n", best_cost)
end

