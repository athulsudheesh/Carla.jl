# This file contains all the required data structures for Carla 

# Response Functions ================================
abstract type ResponseFunction end
export ResponseFunction
struct DINA <: ResponseFunction end
struct DINO <: ResponseFunction end
struct FUZZYDINA <: ResponseFunction end

"""
CPM stands for Carla Probability Model and has the following fields:
    - emissionprob
    - transitionprob
    - initialvwec
    - varianceprior
    - initparamstd
    - estimatebeta
    - estimatedelta

All the fields can be assigned using the appropriate keywords 
e.g.


M1 = CPM(
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