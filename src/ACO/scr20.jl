F =[
    0   180  120    0    0    0    0    0    0  104  112    0    0  120    0    0    0    0    0    0;
    180    0   96 2445   78    0 1395    0  120  135    0    0    0    0    0    0    0    0  690    0;
    120   96    0    0    0  221    0    0  315  390    0    0    0 1305    0    0    0    0 1365    0;
      0 2445    0    0  108  570  750    0  234    0    0  140    0    0    0    0    0  150 1575    0;
      0   78    0  108    0    0  225  135    0  156    0    0    0    0  135    0    0    0    0    0;
      0    0  221  570    0    0  615    0    0    0    0   45    0    0    0    0    0  105    0    0;
      0 1395    0  750  225  615    0 2400    0  187    0    0    0   96    0    0    0  165    0  375;
      0    0    0    0  135    0 2400    0    0    0    0    0   60    0    0    0    0    0  750 3345;
      0  120  315  234    0    0    0    0    0    0    0    0    0  750    0    0  750    0    0    0;
    104  135  390    0  156    0  187    0    0    0   36 1200    0 1860  192    0    0    0  525    0;
    112    0    0    0    0    0    0    0    0   36    0  225    0  300   96 2250    0    0    0    0;
      0    0    0  140    0   45    0    0    0 1200  225    0    0    0  165    0 1500    0  840    0;
      0    0    0    0    0    0    0   60    0    0    0    0    0  800  104  600    0    0    0    0;
    120    0 1305    0    0    0   96    0  750 1860  300    0  800    0  975    0    0   90    0    0;
      0    0    0    0  135    0    0    0    0  192   96  165  104  975    0    0  525    0    0    0;
      0    0    0    0    0    0    0    0    0    0 2250    0  600    0    0    0 1200    0    0    0;
      0    0    0    0    0    0    0    0  750    0    0 1500    0    0  525 1200    0    0  750    0;
      0    0    0  150    0  105  165    0    0    0    0    0    0   90    0    0    0    0  465    0;
      0  690 1365 1575    0    0    0  750    0  525    0  840    0    0    0    0  750  465    0    0;
      0    0    0    0    0    0  375 3345    0    0    0    0    0    0    0    0    0    0    0    0
]


# Define matrix D
D = [
    0  1  2  3  1  2  3  4  2  3  4  5  3  4  5  6  4  5  6  7;
    1  0  1  2  2  1  2  3  3  2  3  4  4  3  4  5  5  4  5  6;
    2  1  0  1  3  2  1  2  4  3  2  3  5  4  3  4  6  5  4  5;
    3  2  1  0  4  3  2  1  5  4  3  2  6  5  4  3  7  6  5  4;
    1  2  3  4  0  1  2  3  1  2  3  4  2  3  4  5  3  4  5  6;
    2  1  2  3  1  0  1  2  2  1  2  3  3  2  3  4  4  3  4  5;
    3  2  1  2  2  1  0  1  3  2  1  2  4  3  2  3  5  4  3  4;
    4  3  2  1  3  2  1  0  4  3  2  1  5  4  3  2  6  5  4  3;
    2  3  4  5  1  2  3  4  0  1  2  3  1  2  3  4  2  3  4  5;
    3  2  3  4  2  1  2  3  1  0  1  2  2  1  2  3  3  2  3  4;
    4  3  2  3  3  2  1  2  2  1  0  1  3  2  1  2  4  3  2  3;
    5  4  3  2  4  3  2  1  3  2  1  0  4  3  2  1  5  4  3  2;
    3  4  5  6  2  3  4  5  1  2  3  4  0  1  2  3  1  2  3  4;
    4  3  4  5  3  2  3  4  2  1  2  3  1  0  1  2  2  1  2  3;
    5  4  3  4  4  3  2  3  3  2  1  2  2  1  0  1  3  2  1  2;
    6  5  4  3  5  4  3  2  4  3  2  1  3  2  1  0  4  3  2  1;
    4  5  6  7  3  4  5  6  2  3  4  5  1  2  3  4  0  1  2  3;
    5  4  5  6  4  3  4  5  3  2  3  4  2  1  2  3  1  0  1  2;
    6  5  4  5  5  4  3  4  4  3  2  3  3  2  1  2  2  1  0  1;
    7  6  5  4  6  5  4  3  5  4  3  2  4  3  2  1  3  2  1  0
]

include("ACO_QAP.jl")
current_file = @__FILE__
vecindarios = ["2-opt" , "2-swap"]
for vecindario in vecindarios
    if vecindario == "2-opt"
        best_params, best_cost = evolucion_diferencial_ACO(D, F)
    else 
        best_params, best_cost = evolucion_diferencial_ACO(D, F, usar_intercambio = true)
    end
    open("resultados.txt", "a") do io
        @printf(io, "Metodo: %s\n", "ACO")
        @printf(io, "Problema: %s\n", current_file)
        @printf(io, "Parametros del ACO: alpha=%f, beta=%f, rho=%f, Q=%f\n", 
            best_params[1], best_params[2], best_params[3], best_params[4])
        @printf(io, "Mejor fitness: %f\n", best_cost)
        @printf(io, "Vecindario: %s\n", vecindario)
    end
end
