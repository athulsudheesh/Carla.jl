@doc raw"""
    GaussianPrior(mean::Union{Float64,Vector{Float64}},
                    sd::Float64,
                    varianceprior::Float64)

Creates a gaussian prior object with the given mean, sd, and co-variance

## Examples 
```julia-repl
julia> initialδprior = GaussianPrior(0.5,0.1,0.8)
GaussianPrior(0.5, 0.1, 0.8, [1.25;;])

julia> βprior = GaussianPrior([0.2,0.5],0.1,0.8)
GaussianPrior([0.2, 0.5], 0.1, 0.8, [1.25 0.0; 0.0 1.25])
```

"""
struct GaussianPrior
    mean::Union{Float64,Vector{Float64}}
    sd::Float64
    varianceprior::Float64
    covmx::Matrix{Float64}

    GaussianPrior(mean,sd,varianceprior) = begin 
        covmx = Matrix(I(length(mean))) / varianceprior
        new(mean,sd,varianceprior,covmx)
    end
end
export GaussianPrior

# There is some error in the way initialdeltaparams are initialized. Check with Dr. Golden
# Update the bellow example as well. 
@doc raw"""
    params(prior::GaussianPrior)

# Example 
```julia-repl
julia> M1 = CPM() # Initializing a Carla Probability Model 
CPM(DINA(), DINA(), [1.2, 0.6], 0.1865671641791045, 0.2, true, false)

julia> # Initializing βparams for our M1 model. 
julia> βparams = params(GaussianPrior(M1.initialwvec,
                                M1.initparamstd,
                                M1.varianceprior))
params(GaussianPrior([1.2, 0.6], 0.2, 0.1865671641791045, [5.359999999999999 0.0; 0.0 5.359999999999999]), [1.2069019080708794, 0.6959083361750591])

julia> # Initializing initialδparams for our M1 Model
initialδparams = params(GaussianPrior(M1.initialwvec[1], M1.initparamstd, M1.varianceprior))
params(GaussianPrior(1.2, 0.2, 0.1865671641791045, [5.359999999999999;;]), [1.2190006135375588])
```
"""
mutable struct params 
    prior::GaussianPrior
    val::Union{Float64, Vector{Float64}}

    params(prior) = begin 
        val = prior.mean .+ (rand(length(prior.mean)) * prior.sd)
        new(prior,val)
    end
end 
export params

