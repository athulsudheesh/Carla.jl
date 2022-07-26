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

"""
    AllPatterns(k)

Generate all possible α patterns for a given number of skills

## Argument
- `k`: No of skills 

## Output 

A Matrix of size k × 2^k   
"""
struct AllPatterns <: AbstractArray{Bool,2}; k::Int; end
Base.size(p::AllPatterns) = (p.k, 2^(p.k))
Base.getindex(p::AllPatterns, i::Int, j::Int) = isodd(j >> (i-1))

export AllPatterns



function compute_paramdims(model,J,K,T)
    estimateβ = model.opts.estimatebeta
    estimateδ = model.opts.estimatedelta 

    if T ==1
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
