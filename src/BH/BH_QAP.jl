using Random, Printf, Distributions

using Random
using Printf

Random.seed!(146543)

function costo(permutacion, D, F)
    n = length(permutacion)
    costo_total = 0
    for i in 1:n
        for j in 1:n
            costo_total += F[i, j] * D[permutacion[i], permutacion[j]]
        end
    end
    return costo_total
end


function move_towards_black_hole(star, black_hole)
    n = length(star)
    
    diff_positions = findall(x -> star[x] != black_hole[x], 1:n)
    if length(diff_positions) > 1

        pos1, pos2 = sample(diff_positions, 2, replace=false)
        star[pos1], star[pos2] = star[pos2], star[pos1]
    end
    return star
end

function optimizacion_black_hole(D, F; num_stars=20, R=0.1, iteraciones=100)
    n = size(D, 1)
    P = [randperm(n) for _ in 1:num_stars]  
    mejor_costo_global = Inf
    mejor_permutacion_global = []

    for iter in 1:iteraciones

        for i in 1:num_stars
            permutacion = P[i]
            costo_actual = costo(permutacion, D, F)

            if costo_actual < mejor_costo_global
                mejor_costo_global = costo_actual
                mejor_permutacion_global = permutacion
            end
        end


        for j in 1:num_stars
            if P[j] != mejor_permutacion_global
                
                P[j] = move_towards_black_hole(P[j], mejor_permutacion_global)
            end

            if rand() < R 
                P[j] = randperm(n)  
            end
        end

        @printf("Iteración %d: Mejor costo: %f\n", iter, mejor_costo_global)
    end

    return mejor_permutacion_global, mejor_costo_global
end

function fitness_black_hole(parametros, D, F)
   
    num_stars = round(Int, parametros[1]) 
    R = parametros[2]
    _, mejor_costo = optimizacion_black_hole(D, F; num_stars=num_stars, R=R, iteraciones=100)
    return mejor_costo
end

function evolucion_diferencial_black_hole(D, F; tam_poblacion=25, max_iteraciones=25, escala_F=0.5, CR=0.75)
    rangos_parametros = [
        (25, 50),  
        (0.01, 1000.0)  
    ]
    
    poblacion = []
    for _ in 1:tam_poblacion
        individuo = [
            rand(Float64) * (rangos_parametros[j][2] - rangos_parametros[j][1]) + rangos_parametros[j][1] for j in 1:length(rangos_parametros)
        ]
        push!(poblacion, individuo)
    end

    fitness = [fitness_black_hole(p, D, F) for p in poblacion]
    
    mejor_idx = argmin(fitness)
    mejores_parametros = poblacion[mejor_idx]
    mejor_costo = fitness[mejor_idx]

    for iter in 1:max_iteraciones
        for i in 1:tam_poblacion
            idxs = sample(1:tam_poblacion, 3, replace=false)
            a, b, c = poblacion[idxs[1]], poblacion[idxs[2]], poblacion[idxs[3]]
            
            vector_prueba = copy(a)
            for j in 1:length(rangos_parametros)
                if rand() < CR
                    vector_prueba[j] = b[j] + escala_F * (c[j] - b[j])
                    vector_prueba[j] = clamp(vector_prueba[j], rangos_parametros[j][1], rangos_parametros[j][2])
                end
            end

            fitness_prueba = fitness_black_hole(vector_prueba, D, F)
            if fitness_prueba < fitness[i]
                poblacion[i] = vector_prueba
                fitness[i] = fitness_prueba
            end

            if fitness_prueba < mejor_costo
                mejores_parametros = vector_prueba
                mejor_costo = fitness_prueba
            end
        end
        @printf("Iteración DE %d: Mejor costo Black Hole: %f\n", iter, mejor_costo)
    end

    return mejores_parametros, mejor_costo
end


