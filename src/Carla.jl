module Carla 
    include(joinpath("datastructs", "latentresponses.jl"))
    include(joinpath("datastructs", "probmodels.jl"))
    include("probabilities.jl")
end
