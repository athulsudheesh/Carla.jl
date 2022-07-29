"""
    ∇riskαᵢ(
            model::CPM, data::StudentResponse, αMatrix,
            QMatrix, RMatrix, θ, temperature
            )

Computes the gradient of the empirical risk of a given student for a particular skill profile             

### Arguments 

- `model`: the Carla Probability Model 
- `data`: `StudentResponse` of the examinee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matrix
- `RMatrix`: RMatrix specifies how skills are temporally connected

- `θ`: Parameter values, A named tuple θ = (β, δ0, δ)
- `temperature`: temperature parameter for importance sampling 

## Output 

2J when estimatebeta = 1 and estimatedelta=0 for T = 1 \\
2J+K when estimatebeta =1 and estimatedelta = 1  for T=1 \\
2J when estimatebeta = 1 and estimatedelta = 0 for T > 1 \\
2J + 2K + K when estimatebeta = 1 and estimatedelta = 1 for T > 1 
"""
function ∇riskαᵢ(
            model::CPM, data::StudentResponse, αMatrix,
            QMatrix, RMatrix, θ, temperature)
    
    β, δ0, δ = θ.β, θ.δ0, θ.δ
    x, obsloc = data.itemResponse, data.missingindicator
    nrskills, nrtimepoints = size(αMatrix)
    _, nritems = size(obsloc')
    estimateδ = model.opts.estimatedelta
    estimateβ = model.opts.estimatebeta
    gradcomplete = []

    if estimateβ

        # Compute the gradient of -log emission probabilities (time-invariant case)
        for itemID = 1:nritems
            Σemissiongrad = [0,0]
            for t = 1:nrtimepoints

                psivec = emission_responsevec(model.emissionprob, QMatrix,
                                            itemID,t, αMatrix)
                if Bool(obsloc[itemID,t])
                    pemiss = local_emission(model.emissionprob, QMatrix,
                                            itemID, t, αMatrix, β[itemID])
                    emissgrad = -(x[itemID,t] - pemiss) * psivec
                else
                    emissgrad = 0 * psivec
                end
                
                Σemissiongrad = Σemissiongrad + emissgrad
            end # end of time loop

            gradcomplete = [gradcomplete; Σemissiongrad]
        end # end of itemID loop
    end

    if estimateδ

        # Compute gradient of -log initial transition probabilities (time-invariant case)
        t = 1 
        for skillID = 1:nrskills
            phivec = transition_responsevec(model.transitionprob, RMatrix,
                                            skillID,t,αMatrix)
            pt = local_transition(model.transitionprob, RMatrix,
                                            skillID, t, αMatrix, δ0[skillID], δ[t], temperature)
            gradsubvec = -(αMatrix[skillID,t] -pt)
            gradcomplete = [gradcomplete; gradsubvec]
        end # end of skillID loop

        if nrtimepoints != 1
            for skillID = 1:nrskills
                Σtransgrad = [0,1]
                for t = 2:nrtimepoints
                    phivec = transition_responsevec(model.transitionprob, RMatrix,
                                                    skillID,t,αMatrix)
                    pt = local_transition(model.transitionprob, RMatrix,
                                                skillID, t, αMatrix, δ0[skillID], δ[t], temperature)
                    gradsubvec = -(αMatrix[skillID,t] - pt) * phivec
                    Σtransgrad = Σtransgrad + gradsubvec
                end # end of time loop 
                gradcomplete = [gradcomplete; Σtransgrad]
            end
        end
    end
    return gradcomplete
end

export ∇riskαᵢ
"""
    ∇risk(model::CPM, data, QMatrix, RMatrix, θ;e_strategy::Exact)

Computes the expectation of the complete gradient of the empirical risk 
computed in [`∇riskαᵢ`](@ref).


### Arguments 

- `model`: the Carla Probability Model 
- `data`: `StudentResponse` of the examinee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matrix
- `RMatrix`: RMatrix specifies how skills are temporally connected
- `θ`: Parameter values, A named tuple θ = (β, δ0, δ)

## Output 

2J when estimatebeta = 1 and estimatedelta=0 for T = 1 \\
2J+K when estimatebeta =1 and estimatedelta = 1  for T=1 \\
2J when estimatebeta = 1 and estimatedelta = 0 for T > 1 \\
2J + 2K + K when estimatebeta = 1 and estimatedelta = 1 for T > 1 
"""
function ∇risk(model::CPM, data, QMatrix, RMatrix, θ;e_strategy::Exact=Exact())
    data = soa(data)
    nrexaminees = length(data)
    nrtimepoints, nritems = size(data.itemResponse[1]')
    nrskills = length(θ.δ0)
    temperature = 1.0
    nrterms = 2^(nrskills*nrtimepoints)
    all_patterns = AllPatterns(nrskills*nrtimepoints)'
    θvals = (β = θ.β.val, δ0 = θ.δ0.val, δ = θ.δ.val)
    paramdims = compute_paramdims(model, nritems, nrskills, nrtimepoints)
    
    # Compute the gradient of the -ve normalized log-likelihood risk 
    gradavgmx = zeros(nrexaminees, paramdims)
    for i = 1:nrexaminees
        thedata = data[i]
        gradcompletemx = zeros(nrterms, paramdims)
        likelihoodcomplete = zeros(nrterms)
         for Σᵢ = 1:nrterms
            αMatrix  = reshape(all_patterns[Σᵢ, :], (nrskills, nrtimepoints))

            likelihoodcomplete[Σᵢ] = likelihoodcompletealpha(
                                                model, thedata, QMatrix, 
                                                RMatrix, αMatrix, θvals, temperature
                                                )
            gradcompletemx[Σᵢ,:] = ∇riskαᵢ(model, thedata, αMatrix,
                                            QMatrix, RMatrix, θvals, temperature)'   
        end
        wts = likelihoodcomplete / (eps() + sum(likelihoodcomplete))
        gradavg = gradcompletemx' * wts
        gradavgmx[i,:] = gradavg'
    end
    gradmean = vec(mean(gradavgmx,dims=1))

    # Add the gradient of the -ve log prior probablily term 
    ∇logθprior = all_∇logpriors(model, θ, nrtimepoints)
    gradmean - (∇logθprior / nrexaminees)
end
export ∇risk