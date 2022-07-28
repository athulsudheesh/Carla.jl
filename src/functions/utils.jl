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
    GaussianParameterInit(initialwprior, varianceprior)
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
    protectedX = ((x .<= myrealmin) .* myrealmin) .+ ((x .> myrealmin) .* x)
    log.(protectedX)
end
export protected_log

function protected_exp(x)
    mylogmaxnum = 702.8750
    protectedX = ((x .>= mylogmaxnum) .* mylogmaxnum) .+ ((x .< mylogmaxnum) .* x)
    exp.(protectedX)
end
export protected_exp

"""
    AllPatterns(k)

Generate all possible α patterns for a given number of skills

## Argument
- `k`: No of skills 

## Output 

A Matrix of size k × 2^k   
"""
struct AllPatterns <: AbstractArray{Bool,2}
    k::Int
end
Base.size(p::AllPatterns) = (p.k, 2^(p.k))
Base.getindex(p::AllPatterns, i::Int, j::Int) = isodd(j >> (i - 1))

export AllPatterns



function compute_paramdims(model, J, K, T)
    estimateβ = model.opts.estimatebeta
    estimateδ = model.opts.estimatedelta

    if T == 1
        if estimateβ == true && estimateδ == false
            2J
        end

        if estimateβ == true && estimateδ == true
            2J + K
        end
    else
        if estimateβ == true && estimateδ == false
            2J
        end
        if estimateβ == true && estimateδ == true
            2J + 2K + K
        end
    end
end
export compute_paramdims

function updateθ!(model, θ, value::Vector, J, K, T)
    estimateβ = model.opts.estimatebeta
    estimateδ = model.opts.estimatedelta

    if T == 1
        if estimateβ == true && estimateδ == false
            θ.β.val .= θ.β.val + m2vecvec(reshape(value[1:2J], J, 2))
        end

        if estimateβ == true && estimateδ == true
            θ.β.val .= θ.β.val + m2vecvec(reshape(value[1:2J], J, 2))
            θ.δ0.val .= θ.δ0.val + m2vecvec(value[2J+1:2J+K])
        end
    else
        if estimateβ == true && estimateδ == false
            θ.β.val .= θ.β.val + m2vecvec(reshape(value[1:2J], J, 2))
        end
        if estimateβ == true && estimateδ == true
            θ.β.val .= θ.β.val + m2vecvec(reshape(value[1:2J], J, 2))
            θ.δ0.val .= θ.δ0.val + m2vecvec(value[2J+1:2J+K])
            θ.δ.val .= θ.δ.val + m2vecvec(reshape(value[2J+K+1:2J+3K], K, 2))
        end
    end
end


function updateθ!(θ, value::Float64)
    θ.β.val .= m2vecvec(hcat(θ.β.val...)' .+ value)
    θ.δ0.val .= m2vecvec(flat(θ.δ0.val) .+ value)
    θ.δ.val .= m2vecvec(hcat(θ.δ.val...)' .+ value)
end
export updateθ!

function m2vecvec(temp)
    [temp[i, :] for i in 1:size(temp, 1)]
end
export m2vecvec

function boundbox(θ, xmin,xmax)
    val = hcat(θ.val...)'
    xmaxmask = val .>= xmax
    xminmask = val .<= xmin
    inboundmask = (val .> xmin) .* (val .< xmax)
    
    val = val .* inboundmask
    θ.val .= m2vecvec(val)

    if !isinf(xmax)
        val = (1 .- xmaxmask) .* val + (xmax .* xmaxmask)
        θ.val .= m2vecvec(val)
    end
    if !isinf(xmin)
        val = (1 .- xminmask) .* val + (xmin .* xminmask)
        θ.val .= m2vecvec(val)
    end
end

function boundboxed!(θ, min, max)
    boundbox(θ.β,min,max);
    boundbox(θ.δ0,min,max);
    boundbox(θ.δ,min,max);
    return 
end
export boundbox, boundboxed!

function absdiffθ(θ1, θ2, model, T)
    estimateβ = model.opts.estimatebeta
    estimateδ = model.opts.estimatedelta

    if T == 1
        if estimateβ == true && estimateδ == false
            maximum(abs.(flat(θ1.β.val) - flat(θ2.β.val)))
        end

        if estimateβ == true && estimateδ == true
            value1 = [flat(θ1.β.val); flat(θ1.δ0.val)]
            value2 = [flat(θ2.β.val); flat(θ2.δ0.val)]
            maximum(abs.(value1 - value2))
        end
    else
        if estimateβ == true && estimateδ == false
            maximum(abs.(flat(θ1.β.val) - flat(θ2.β.val)))
        end
        if estimateβ == true && estimateδ == true
            value1 = [flat(θ1.β.val); flat(θ1.δ0.val); flat(θ1.δ.val)]
            value2 = [flat(θ2.β.val); flat(θ2.δ0.val); flat(θ2.δ.val)]
            maximum(abs.(value1 - value2))
        end
    end
end
export absdiffθ   

#= Depreciated functions 
"""
    AllPatterns(k)

Generate all possible α patterns for a given number of skills

## Argument
- `k`: No of skills 

## Output 

A Matrix of size 2^k × k

## Example 

```julia-repl
julia> AllPatterns(3)'
8×3 adjoint(::AllPatterns) with eltype Bool:
 1  0  0
 0  1  0
 1  1  0
 0  0  1
 1  0  1
 0  1  1
 1  1  1
 0  0  0 
```
"""
function all_patterns(k)
    reduce(hcat,[digits(i,base=2,pad=k) for i in 0:2^k-1])'
end

function add_one_binary!(x::BitVector)
    d = length(x)
    for i in d:-1:1
        if !x[i]
            x[i] = true
            for j in i+1:d
                x[j] = false
            end
            return x
        end
    end
    return x
end
=#