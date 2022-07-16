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
CPM stands for Carla Probability Model.

### Fields

- `emissionprob` -- Emission Probability function, type of `ResponseFunction` 
- `transitionprob` -- Transition Probability function, type of `ResponseFunction`
- `initialvwec` -- Initial Weight Vector, Vector of `Float64`
- `varianceprior` -- Variance Prior, a `Float64`
- `initparamstd` -- Initial Parameter S.D., a `Float64`
- `estimatebeta` -- Estimate Beta Parameters?, `Bool` type
- `estimatedelta` -- Estimate Delta Parameters?, `Bool` type

### Notes

All the fields can be assigned using the appropriate keywords.
The initialization constructor CPM(), uses the values in the example,
as default for the fields in CPM. 

### Example

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
    emissionprob::ResponseFunction
    transitionprob::ResponseFunction
    initialwvec::Vector{Float64}
    varianceprior::Float64
    initparamstd::Float64
    estimatebeta::Bool
    estimatedelta::Bool
end

# Constructor for CPM 
CPM() = CPM(
    emissionprob=DINA(),
    transitionprob=DINA(),
    initialwvec = [1.2, 0.6],
    initparamstd = 0.2,
    varianceprior = 100/536,
    estimatebeta = true,
    estimatedelta = false)
export CPM, DINA, DINO, FUZZYDINA