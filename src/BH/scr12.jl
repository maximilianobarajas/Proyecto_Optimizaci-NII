F = [
    0  180  120    0    0    0    0    0    0  104  112    0;
  180    0   96 2445   78    0 1395    0  120  135    0    0;
  120   96    0    0    0  221    0    0  315  390    0    0;
    0 2445    0    0  108  570  750    0  234    0    0  140;
    0   78    0  108    0    0  225  135    0  156    0    0;
    0    0  221  570    0    0  615    0    0    0    0   45;
    0 1395    0  750  225  615    0 2400    0  187    0    0;
    0    0    0    0  135    0 2400    0    0    0    0    0;
    0  120  315  234    0    0    0    0    0    0    0    0;
  104  135  390    0  156    0  187    0    0    0   36 1200;
  112    0    0    0    0    0    0    0    0   36    0  225;
    0    0    0  140    0   45    0    0    0 1200  225    0
]
D = [
    0 1 2 3 1 2 3 4 2 3 4 5;
    1 0 1 2 2 1 2 3 3 2 3 4;
    2 1 0 1 3 2 1 2 4 3 2 3;
    3 2 1 0 4 3 2 1 5 4 3 2;
    1 2 3 4 0 1 2 3 1 2 3 4;
    2 1 2 3 1 0 1 2 2 1 2 3;
    3 2 1 2 2 1 0 1 3 2 1 2;
    4 3 2 1 3 2 1 0 4 3 2 1;
    2 3 4 5 1 2 3 4 0 1 2 3;
    3 2 3 4 2 1 2 3 1 0 1 2;
    4 3 2 3 3 2 1 2 2 1 0 1;
    5 4 3 2 4 3 2 1 3 2 1 0
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
