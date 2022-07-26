@doc raw"""
    maprisk(model::CPM, data,
            QMatrix, RMatrix, θ;e_strategy=Exact())
Computes the MAP risk using exact method.

```math
\ddot{l(\theta)} = - (1/n) log P_{\theta} (\theta) - (1/n) \Sigma_{i=1}^n log \Sigma_{\alpha} \ddot{L^i} (\theta; \alpha)
```

where ``\ddot{L^i} (\theta; \alpha)`` is the [`likelihoodcompletealpha`](@ref)

## Arguments 
- `model`: The Carla Probability Model
- `data`: `StudentResponse` of the examiniee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `RMatrix`: RMatrix specifies how skills are temporally connected
`θ`: Parameter values, A named tuple θ = (β, δ0, δ)

## Output 

(`MAPrisk`, `ML Risk`)
"""
function maprisk(model::CPM, data,
                QMatrix, RMatrix, θ;e_strategy::Exact=Exact())


    # Compute the -ve normalized log-likelihood risk
    data = soa(data)
    nrexaminees = length(data)
    nritems, nrtimepoints = size(data.itemResponse[1])
    nrskills = length(θ.δ0)
    temperature = 1.0
    nrterms = 2^(nrskills*nrtimepoints)
    
    all_patterns = AllPatterns(nrskills*nrtimepoints)'
    θvals = (β = θ.β.val, δ0 = θ.δ0.val, δ = θ.δ.val)

    Σrisk = 0.0; loglikelihood = zeros(nrexaminees)
    for i = 1:nrexaminees
        funkvalsat = 0.0
        thedata = data[i]
        likelihoodcomplete = zeros(nrterms)
        for Σᵢ = 1:nrterms
            αMatrix  = reshape(all_patterns[Σᵢ, :], (nrskills, nrtimepoints))

            likelihoodcomplete[nrterms] = likelihoodcompletealpha(
                                                model, thedata, QMatrix, 
                                                RMatrix, αMatrix, θvals, temperature
            )
        end
        funkvalsat = sum(likelihoodcomplete)
    loglikelihood[i] = - protected_log(funkvalsat)
    Σrisk = Σrisk + loglikelihood[i]
    end
    μrisk = Σrisk / nrexaminees
    
    logβprior, logδ0prior, logδprior = all_logpriors(model, θ)
    logθprior = 0.0

    if model.opts.estimatebeta 
        logθprior = logθprior + logβprior
    end

    if model.opts.estimatedelta 
        logθprior = logθprior + logδ0prior

        if nrtimepoints > 1 
            logθprior = logθprior + logδprior
        end
    end 
    
    MAPpenalityterm = (1/nrexaminees) * logθprior
    MAPrisk = μrisk - MAPpenalityterm
    return MAPrisk, μrisk
end

export maprisk 