module Carla 
using LinearAlgebra, StructArrays, Statistics
    include(joinpath("datastructs", "latentresponses.jl"))
    include(joinpath("datastructs", "probmodels.jl"))
    include(joinpath("datastructs","params.jl"))
    include(joinpath("datastructs","data.jl"))
    include(joinpath("datastructs", "expectationstrategies.jl"))
    include(joinpath("datastructs", "optimizers.jl"))

    include(joinpath("functions", "latent_responsevecs.jl"))
    include(joinpath("functions","local_probabilities.jl"))
    include(joinpath("functions","global_probabilities.jl"))
    include(joinpath("functions","likelihoods.jl"))
    include(joinpath("functions","gradients_risk.jl"))
    include(joinpath("functions","empirical_risk.jl"))
    include(joinpath("functions", "logprior_functions.jl"))
    include(joinpath("functions","search_algos.jl"))
    include(joinpath("functions", "back_tracking.jl"))
    include(joinpath("functions","batch.jl"))
    include(joinpath("functions","runcarla.jl"))
    include(joinpath("functions","data_handling.jl"))
    include(joinpath("functions", "hessians.jl"))

    include(joinpath("functions", "utils.jl"))
end
