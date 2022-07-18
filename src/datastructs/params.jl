@doc raw"""
    GaussianParameterInit(mean::Union{Float64,Vector{Float64}},
                    varianceprior::Float64, noiseSD::Float64 (optional))

Initializes a gaussian parameter prior with the given mean, and co-variance

## Examples 
```julia-repl
julia> GaussianParameterInit(0.5,0.1) 
GaussianParameterInit(0.5, 0.2, 0.1, [10.0;;])

julia> GaussianParameterInit([0.2, 0.6], 0.5)
GaussianParameterInit([0.2, 0.6], 0.2, 0.5, [2.0 0.0; 0.0 2.0])

julia> GaussianParameterInit([0.2, 0.6], 0.5, 0.5) # Also passing initparamsd (0.5)
GaussianParameterInit([0.2, 0.6], 0.5, 0.5, [2.0 0.0; 0.0 2.0])
```
"""
struct GaussianParameterInit
    mean::Union{Float64,Vector{Float64}}
    noiseSD::Float64
    varianceprior::Float64
    invcovmx::Matrix{Float64}

    GaussianParameterInit(mean,varianceprior) = begin 
        noiseSD = 0.2
        invcovmx = Matrix(I(length(mean))) / varianceprior
        new(mean,noiseSD,varianceprior,invcovmx)
    end
    GaussianParameterInit(mean,varianceprior, noiseSD) = begin 
        invcovmx = Matrix(I(length(mean))) / varianceprior
        new(mean,noiseSD,varianceprior,invcovmx)
    end
end
export GaussianParameterInit

# There is some error in the way initialdeltaparams are initialized. Check with Dr. Golden
# Update the bellow example as well. 
@doc raw"""
    params(prior::GaussianParameterInit)

# Example 
```julia-repl
julia> M1 = CPM()
CPM(DINA(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, false))

julia> # Initializing βparams for our M1 model. 
julia>  βparams = params(GaussianParameterInit(M1.initialwvec,
                                       M1.varianceprior))
params(GaussianParameterInit([1.2, 0.6], 0.2, 0.1865671641791045, [5.359999999999999 0.0; 0.0 5.359999999999999]), [1.3862321329853542, 0.6293077030876637])

julia> # Initializing initialδoarams for our M1 model 
julia> prioralpha = 0
julia> initialδprior = initialδprior = initialdelta_init(M1.initialwvec, M1.varianceprior,prioralpha)
julia> initlaδparams = params(initialδprior)
params(GaussianParameterInit(-0.6, 0.2, 0.1865671641791045, [5.359999999999999;;]), [-0.5142508455381457])
```
"""
mutable struct params 
    prior::GaussianParameterInit
    val::Union{Float64, Vector{Float64}}

    params(prior) = begin 
        val = prior.mean .+ (rand(length(prior.mean)) * prior.noiseSD)
        new(prior,val)
    end
end 
export params

