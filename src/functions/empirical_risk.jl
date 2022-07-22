function maprisk(model::CPM, data,
                QMatrix, RMatrix, θ;e_strategy=Exact())


    # Compute the -ve normalized log-likelihood risk
    data = soa(data)
    nrexaminees = length(data)
    nritems, nrtimepoints = size(data.itemResponse[1])
    nrskills = length(θ.δ0)
    temperature = 1.0
    nrterms = 2^(nrskills*nrtimepoints)
    likelihoodcomplete = zeros(nrterms)
    all_patterns = AllPatterns(nrterms-)'

    Σrisk = 0.0; loglikelihood = zeros(nrexaminees)
 
    for i = 1:nrexaminees
        thedata = data[i]
        for Σᵢ = 1:nrterms
            αMatrix  = reshape(all_patterns[Σᵢ, :], (nrskills, nrtimepoints))

            likelihoodcomplete[nrterms] = likelihoodcompletealpha(
                                                model, thedata, QMatrix, 
                                                RMatrix, αMatrix, θ, temperature
            )
        end
        funkvalsat = sum(likelihoodcomplete)
    end
end

export maprisk 