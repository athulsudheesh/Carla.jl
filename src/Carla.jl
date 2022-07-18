module Carla 
using LinearAlgebra
    include(joinpath("datastructs", "latentresponses.jl"))
    include(joinpath("datastructs", "probmodels.jl"))
    include(joinpath("functions", "latent_responsevecs.jl"))
    include(joinpath("datastructs","params.jl"))
end
