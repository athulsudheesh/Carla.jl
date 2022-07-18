
# Probability Model definition 
@doc raw"""
    CPM()
    CPM(kwargs...)

CPM is the data structure for Carla Probability Model.

## Keword Arguments 
- `emissionprob` -- Emission Probability function, type of `ResponseFunction` 
- `transitionprob` -- Transition Probability function, type of `ResponseFunction`
- `initialvwec` -- Initial Weight Vector, Vector of `Float64`
- `varianceprior` -- Variance Prior, a `Float64`
- `initparamstd` -- Initial Parameter S.D., a `Float64`
- `estimatebeta` -- Estimate Beta Parameters?, `Bool` type
- `estimatedelta` -- Estimate Delta Parameters?, `Bool` type

## Notes
All the fields can be assigned using the appropriate keywords.
The initialization constructor CPM(), uses the values in the example,
as default for the fields in CPM. 

## Example
```julia-repl
julia> M1 = CPM()

CPM(DINA(), DINA(), [1.2, 0.6], 0.1865671641791045, 0.2, true, false)
```
"""
Base.@kwdef struct CPM
    emissionprob::ResponseFunction = DINA()
    transitionprob::ResponseFunction = DINA()
    initialwvec::Vector{Float64} = [1.2, 0.6]
    varianceprior::Float64 = 100/536
    initparamstd::Float64 = 0.2
    estimatebeta::Bool = true
    estimatedelta::Bool = false
end

export CPM 