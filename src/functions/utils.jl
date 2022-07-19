"""
    sigmoid(x::Union{Float64,Vector{Float64}})

Implements a logistic signmoid function. Also 
known as inverse logit in psychometric literature
"""
sigmoid(x) = 1 ./ (1 .+ exp.(-x))
export sigmoid

"""
Initialization of means for initialdelta
"""
function initialdelta_init(initialwvec, varianceprior, priorαvec)
    initialwprior = (initialwvec[1] - initialwvec[2]) * priorαvec - ((1 - priorαvec) * initialwvec[2])
    GaussianParameterInit(initialwprior,varianceprior)
end
export initialdelta_init

soa(x) = StructArray(x)
flat(x) = Float64.(Iterators.flatten(x))
export soa, flat