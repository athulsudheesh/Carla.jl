
"""
    EstimandOpts()
    EstimandOpts(kwargs...)

Sets the options for CPM estimands

## Keyword Arguments 
- `initparamnoiseSD::Float64` - S.D of the random noise to be added during parameter initialization, by default `0.2`
- `estimatebeta::Bool` - should betas be estimated as part of learning, by default `true`
- `estimatedelta::Bool` - should deltas be estimated as part of learning, by default `false`

## Example 

```julia-repl 
julia> EstimandOpts()
EstimandOpts(0.2, true, false)

julia> EstimandOpts(estimatedelta = true)
EstimandOpts(0.2, true, true)
```
"""
Base.@kwdef struct EstimandOpts
    initparamnoiseSD::Float64 =0.2
    estimatebeta::Bool = true
    estimatedelta::Bool = false
end

@doc raw"""
    CPM()
    CPM(kwargs...)

CPM is the data structure for Carla Probability Model.

## Keword Arguments 
- `emissionprob::ResponseFunction` -- Emission Probability function
- `transitionprob::ResponseFunction` -- Transition Probability function
- `initialwvec::Vector{Float64}` -- Weight Vector to initialize gaussian priors
- `varianceprior` -- Variance for initializing a gaussian prior 
- `opts` -- Options for estimands, 
            by default uses `EstimandOpts(initparamnoiseSD = 0.2, 
                                            estimatebeta = true, estimatedelta = false)`

## Notes
All the fields can be assigned using the appropriate keywords.
The initialization constructor CPM(), uses the values in the example,
as default for the fields in CPM. 

## Examples
```julia-repl
julia> M1 = CPM()
CPM(DINA(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, false))

julia> M2 = CPM(emissionprob = DINO())
CPM(DINO(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, false))

julia> M3 = CPM(emissionprob = DINO(), opts = EstimandOpts(estimatedelta=true))
CPM(DINO(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, true))
```
"""
Base.@kwdef struct CPM
    emissionprob::ResponseFunction = DINA()
    transitionprob::ResponseFunction = DINA()
    initialwvec::Vector{Float64} = [1.2, 0.6]
    varianceprior::Float64 = 100/536
    opts::EstimandOpts = EstimandOpts()
end

export CPM, EstimandOpts
