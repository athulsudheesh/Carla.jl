module Carla 
using LinearAlgebra, StructArrays
    include(joinpath("datastructs", "latentresponses.jl"))
    include(joinpath("datastructs", "probmodels.jl"))
    include(joinpath("datastructs","params.jl"))

    include(joinpath("functions", "latent_responsevecs.jl"))
    include(joinpath("functions","local_probabilities.jl"))

    include(joinpath("functions", "utils.jl"))
end
