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

"""
    protected_log(x)

This is a "protected" natural logarithm function.

If the input to the function is too small of a positive
number, then the input is replaced by a small positive number
to prevent generating minus infinity.
"""
function protected_log(x)
    myrealmin = 2.2251e-305
    protectedX = ((x .<= myrealmin) .* myrealmin) .+ ((x .> myrealmin) .*x)
    log.(protectedX)
end
export protected_log

function protected_exp(x)
    mylogmaxnum = 702.8750
    protectedX = ((x .>= mylogmaxnum) .* mylogmaxnum) .+ ((x .< mylogmaxnum) .*x)
    exp.(protectedX)
end 
export protected_exp