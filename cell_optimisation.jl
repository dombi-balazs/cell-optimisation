function initial_population()
    initial_population_size = 10000
    population_matrix = rand(1:10, initial_population_size, 5)
    return population_matrix
end

function fitness(population_matrix)
    #fitness(f): cellwall(c), energy_demand(e), motility(m), immunity(i), size(s)
    #f = ((c + m + i) * s^2) / (e * i) + (s + m)
    fitness_values = ((population_matrix[:, 1] .+ population_matrix[:, 3] .+ population_matrix[:, 4]) .* population_matrix[:, 5] .^ 2) ./ (population_matrix[:, 2] .* population_matrix[:, 4]) .+ (population_matrix[:, 5] .+ population_matrix[:, 3])
    population_with_fitness = hcat(population_matrix, fitness_values)
    ranked_indices = sortperm(population_with_fitness[:, 6], rev=true)
    ranked_population_with_fitness = population_with_fitness[ranked_indices, :]
    return ranked_population_with_fitness
end

function selection(ranked_population_with_fitness)
    top_half_population = ranked_population_with_fitness[1:end÷2, :]
    bottom_half_population = ranked_population_with_fitness[end÷2+1:end, :]
    return top_half_population, bottom_half_population
end

function crossover(top_half_population, bottom_half_population)
    top_genes = top_half_population[:, 1:5]
    num_offspring = size(bottom_half_population, 1)
    new_chromosomes = Array{Int64}(undef, num_offspring, 5)
    for i in 1:num_offspring
        parent1_index = rand(1:size(top_genes, 1))
        parent2_index = rand(1:size(top_genes, 1))
        parent1 = top_genes[parent1_index, :]
        parent2 = top_genes[parent2_index, :]
        child_genes = [parent1[1:3]; parent2[4:5]]
        new_chromosomes[i, :] = child_genes
    end
    return new_chromosomes
end

function mutation(new_chromosomes)
    new_generation = copy(new_chromosomes)
    for i in axes(new_generation, 1)
        mutation_point = rand(1:5)
        new_value = rand(1:10)
        new_generation[i, mutation_point] = new_value
    end
    return new_generation
end

function cell_optimisation()
    max_generations = 100
    fitness_target_value = 2000
    population = initial_population()
    for generation in 1:max_generations
        ranked_population_with_fitness = fitness(population)
        best_fitness = ranked_population_with_fitness[1, 6]
        if best_fitness >= fitness_target_value
            println("Exit, reached the target fitness value at ", fitness_target_value, " by the ", generation, ". generation.")
            break
        end
        top_half, bottom_half = selection(ranked_population_with_fitness)
        new_chromosomes = crossover(top_half, bottom_half)
        mutated_chromosomes = mutation(new_chromosomes)
        population = vcat(top_half[:, 1:5], mutated_chromosomes)
    end
    final_ranked_population = fitness(population)
    println("Best fitness found: ", final_ranked_population[1, 6], "which genes are ", final_ranked_population[1, 1:5])
end

cell_optimisation()
