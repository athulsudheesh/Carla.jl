# This file contains all the required data structures for Carla 

# Response Functions ================================
"""
    ResponseFunction

Abstract type for response functions
"""
abstract type ResponseFunction end
export ResponseFunction

"""
    DINA <: ResponseFunction

DINA Response Function
"""
struct DINA <: ResponseFunction end

"""
    DINO <: ResponseFunction

DINO Response Function
"""
struct DINO <: ResponseFunction end

"""
    FUZZYDINA <: ResponseFunction

FUZZYDINA Response Function
"""
struct FUZZYDINA <: ResponseFunction end

"""
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
- M1 = CPM(
    emissionprob=DINA(),
    transitionprob=DINA(),
    initialwvec = [1.2, 0.6],
    varianceprior = 100/536,
    initparamstd = 0.2,
    estimatebeta = true,
    estimatedelta = false)
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
export CPM, DINA, DINO, FUZZYDINA