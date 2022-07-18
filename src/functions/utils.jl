"""
    sigmoid(x::Union{Float64,Vector{Float64}})

Implements a logistic signmoid function. Also 
known as inverse logit in psychometric literature
"""
sigmoid(x) = 1 ./ (1 .+ exp.(-x))
export sigmoid