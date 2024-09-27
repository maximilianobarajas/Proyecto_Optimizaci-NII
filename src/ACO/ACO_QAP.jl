using Random, Printf, Distributions


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

function busqueda_local_2opt(permutacion, D, F)
    n = length(permutacion)
    mejor_costo = costo(permutacion, D, F)
    mejorado = true
    while mejorado
        mejorado = false
        for i in 1:(n-1)
            for j in (i+1):n
                nueva_permutacion = copy(permutacion)
                nueva_permutacion[i:j] = reverse(permutacion[i:j])
                nuevo_costo = costo(nueva_permutacion, D, F)
                if nuevo_costo < mejor_costo
                    permutacion = nueva_permutacion
                    mejor_costo = nuevo_costo
                    mejorado = true
                end
            end
        end
    end
    return permutacion, mejor_costo
end

function busqueda_local_intercambio(permutacion, D, F)
    n = length(permutacion)
    mejor_costo = costo(permutacion, D, F)
    mejorado = true
    while mejorado
        mejorado = false
        for i in 1:n
            for j in 1:n
                if i != j
                    nueva_permutacion = copy(permutacion)
                    nueva_permutacion[i], nueva_permutacion[j] = nueva_permutacion[j], nueva_permutacion[i]
                    nuevo_costo = costo(nueva_permutacion, D, F)
                    if nuevo_costo < mejor_costo
                        permutacion = nueva_permutacion
                        mejor_costo = nuevo_costo
                        mejorado = true
                    end
                end
            end
        end
    end
    return permutacion, mejor_costo
end

function optimizacion_colonia_ant(D, F; num_ants=20, alpha=1.0, beta=2.0, rho=0.1, Q=100, iteraciones=100, feromonas_min=1e-6, feromonas_max=10.0, limite_estancamiento=10, usar_intercambio=false)
    n = size(D, 1)
    feromonas = rand(n, n)
    heuristica = 1.0 ./ (D .+ 1e-6)

    mejor_permutacion_global = []
    mejor_costo_global = Inf
    iteraciones_sin_mejora = 0

    for iter in 1:iteraciones
        soluciones_ante = []
        costos_ante = []

        for _ in 1:num_ants
            no_visitados = collect(1:n)
            permutacion = Int[]

            while !isempty(no_visitados)
                i = length(permutacion) + 1
                probabilidades = Float64[]
                for u in no_visitados
                    tau = feromonas[i, u] ^ alpha
                    eta = heuristica[i, u] ^ beta
                    push!(probabilidades, tau * eta)
                end
                
                suma_probs = sum(probabilidades)
                if suma_probs > 0
                    probabilidades = probabilidades / suma_probs
                else
                    probabilidades = fill(1.0 / length(no_visitados), length(no_visitados))
                end

                if any(isnan, probabilidades) || any(x -> x < 0.0, probabilidades)
                    error("Probabilidades generadas inválidas: $probabilidades")
                end

                epsilon = 0.1
                if rand() < epsilon
                    idx_facilidad_siguiente = rand(1:length(no_visitados))
                else
                    idx_facilidad_siguiente = rand(Categorical(probabilidades))
                end
                
                facilidad_siguiente = no_visitados[idx_facilidad_siguiente]
                push!(permutacion, facilidad_siguiente)
                deleteat!(no_visitados, idx_facilidad_siguiente)
            end

            if usar_intercambio
                permutacion, costo_permutacion = busqueda_local_intercambio(permutacion, D, F)
            else
                permutacion, costo_permutacion = busqueda_local_2opt(permutacion, D, F)
            end

            push!(soluciones_ante, permutacion)
            push!(costos_ante, costo_permutacion)

            if costo_permutacion < mejor_costo_global
                mejor_permutacion_global = permutacion
                mejor_costo_global = costo_permutacion
                iteraciones_sin_mejora = 0
            else
                iteraciones_sin_mejora += 1
            end
        end

        feromonas *= (1 - rho)
        for k in 1:num_ants
            permutacion = soluciones_ante[k]
            for i in 1:n
                for j in 1:n
                    feromonas[i, permutacion[j]] += Q / costos_ante[k]
                    feromonas[i, permutacion[j]] = clamp(feromonas[i, permutacion[j]], feromonas_min, feromonas_max)
                end
            end
        end

        if iteraciones_sin_mejora > limite_estancamiento
            feromonas = rand(n, n)
            println("Reiniciando feromonas después de estancamiento en la iteración ", iter)
            iteraciones_sin_mejora = 0
        end

        @printf("Iteración %d: Mejor costo: %f\n", iter, mejor_costo_global)
    end

    return mejor_permutacion_global, mejor_costo_global
end

function fitness_aco(parametros, D, F, usar_intercambio=false)
    alpha, beta, rho, Q = parametros
    _, mejor_costo = optimizacion_colonia_ant(D, F; num_ants=20, alpha=alpha, beta=beta, rho=rho, Q=Q, iteraciones=50, usar_intercambio=usar_intercambio)
    return mejor_costo
end

function evolucion_diferencial_ACO(D, F; tam_poblacion=20, max_iteraciones=25, escala_F=0.8, CR=0.75, usar_intercambio=false)
    rangos_parametros = [
        (0.1, 1.0),
        (0.1, 1.0),
        (0.01, 1.0),
        (0.0, 10.0)
    ]
    
    poblacion = [rand(Float64, length(rangos_parametros)) .* (rangos_parametros[j][2] - rangos_parametros[j][1]) .+ rangos_parametros[j][1] for _ in 1:tam_poblacion, j in 1:length(rangos_parametros)]
    
    fitness = [fitness_aco(p, D, F) for p in poblacion]
    
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

            fitness_prueba = fitness_aco(vector_prueba, D, F)
            if fitness_prueba < fitness[i]
                poblacion[i] = vector_prueba
                fitness[i] = fitness_prueba
            end

            if fitness_prueba < mejor_costo
                mejores_parametros = vector_prueba
                mejor_costo = fitness_prueba
            end
        end
        @printf("Iteración DE %d: Mejor costo ACO: %f\n", iter, mejor_costo)
    end

    return mejores_parametros, mejor_costo
end
