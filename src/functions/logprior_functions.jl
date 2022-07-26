""" 
    logpriors(θ)
Computes the log of the parameter priors passed to the function
"""
function logpriors(θ)
    n = length(θ)
    logθ = 0.0
    for i in 1:n
        diff = θ.val[i] .- θ.prior[i].mean
        logθᵢ = 0.5 * diff' * θ.prior[i].invcovmx * diff
        logθ = logθ + logθᵢ
    end
    return logθ
end
export logpriors

function all_logpriors(model,θ)
    if model.opts.estimatebeta
         logβprior = logpriors(θ.β)
    end 

    if model.opts.estimatedelta 
        logδ0prior = logpriors(θ.δ0)
        logδprior = logpriors(θ.δ)
    end
    return logβprior, logδ0prior, logδprior
end
export all_logpriors

function ∇logpriors(θ)
    Δ = []
    n = length(θ)
    for i = 1:n
        diff = θ.val[i] .- θ.prior[i].mean
        Δᵢ = -θ.prior[i].invcovmx * diff
        Δ = [Δ; Δᵢ]
    end
    return Δ
end
export ∇logpriors

"""
    all_∇logpriors(model, θ)

Computes the derivative of the functions in [`all_logpriors`](@ref)
"""

function all_∇logpriors(model, θ)
    if model.opts.estimatebeta
        Δlogβprior = ∇logpriors(θ.β)
   end 

   if model.opts.estimatedelta 
       Δlogδ0prior = ∇logpriors(θ.δ0)
       Δlogδprior = ∇logpriors(θ.δ)
   end
   return Δlogβprior, Δlogδ0prior, Δlogδprior
end
export all_∇logpriors