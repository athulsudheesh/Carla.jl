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

function all_logpriors(model,θ, T)
    estimatebeta = model.opts.estimatebeta 
    estimatedelta = model.opts.estimatedelta 

    logβprior = logpriors(θ.β)
    logδ0prior = logpriors(θ.δ0)
    logδprior = logpriors(θ.δ)

    if T == 1
        if estimatebeta == true && estimatedelta == false
            return logβprior
        end

        if estimatebeta == true && estimatedelta == true 
            return [logβprior; logδ0prior]
        end
    else
        if estimatebeta == true && estimatedelta == false 
            return logβprior
        end
        if estimatebeta == true && estimatedelta == true 
            return [logβprior; logδ0prior; logδprior]
        end
    end
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

function all_∇logpriors(model, θ,T)
    estimateβ = model.opts.estimatebeta
    estimateδ = model.opts.estimatedelta
    Δlogβprior = ∇logpriors(θ.β)
    Δlogδ0prior = ∇logpriors(θ.δ0)
    Δlogδprior = ∇logpriors(θ.δ)

    if T == 1
        if estimateβ == true && estimateδ == false
            return Δlogβprior
        end

        if estimateβ == true && estimateδ == true
            [Δlogβprior; Δlogδ0prior]
        end
    else
        if estimateβ == true && estimateδ == false
            Δlogβprior
        end
        if estimateβ == true && estimateδ == true
            [Δlogβprior; Δlogδ0prior; Δlogδprior]
        end
    end
end
export all_∇logpriors

function ∇²logpriors(model, θ, T)
    estimateδ = model.opts.estimatedelta 
    estimateβ = model.opts.estimatebeta  
    nritems = length(θ.β)
    nrskills = length(θ.δ0)
    βmeans = soa(θ.β.prior).mean 
    δ0means = soa(θ.δ0.prior).mean 
    βinvcov = soa(θ.β.prior).invcovmx 
    δ0invcov = soa(θ.δ0.prior).invcovmx 
    if T != 1 
        δmeans = soa(θ.δ.prior).mean 
        δinvcov = soa(θ.δ.prior).invcovmx
    end

    logpriorhessian = 0
    eyenritems = Matrix(I(nritems)); logpriorhessitems = 0
    eyenrskills = Matrix(I(nrskills));

    if estimateβ
        for j = 1:nritems
            logβpriorhess = - βinvcov[j]
            jselect = eyenritems[:,j]*eyenritems[:,j]'
            logpriorhessitems = logpriorhessitems .+ kron(jselect, logβpriorhess)
        end
    end

    if estimateδ
        initialpriorhesskills = 0
        loginitialdeltaprior = 0
        for k = 1:nrskills
            loginitialdeltapriorhess =  - flat(δ0invcov[k])
            kselect = eyenrskills[:,k]*eyenrskills[:,k]'
            initialpriorhesskills = initialpriorhesskills .+ kron(kselect, loginitialdeltapriorhess)
        end
    end

    if estimateδ && T != 1 
        logpriorhesskills = 0
        for k = 1:nrskills
            logdeltapriorhess = - δinvcov[k]
            kselect = eyenrskills[:,k]*eyenrskills[:,k]'
            logpriorhesskills = logpriorhesskills .+ kron(kselect, logdeltapriorhess)
        end
    end

    if estimateβ && !estimateδ
        logpriorhessian = logpriorhessitems
    end 

    if estimateβ && estimateδ
        logpriorhessian = [logpriorhessitems zeros(2*nritems, nrskills);
                            zeros(nrskills,2*nritems) initialpriorhesskills]
        if T != 1
            logpriorhessian = [logpriorhessian zeros(2*nritems+nrskills, 2*nrskills);
                            zeros(2*nrskills, 2*nritems + nrskills) logpriorhesskills]
        end
    end
    return logpriorhessian    
end

export ∇²logpriors
