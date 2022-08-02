function ∇²riskαᵢ(model::CPM, data::StudentResponse, αMatrix,
                QMatrix, RMatrix, θ, temperature)

    nrtimepoints, nrskills = size(αMatrix')
    _, nritems = size(data.itemResponse')
    obsloc = data.missingindicator
    estimateδ = model.opts.estimatedelta
    estimateβ = model.opts.estimatebeta
    β, δ0, δ = θ.β.val, θ.δ0.val, θ.δ.val
    eyenrskills = Matrix(I(nrskills))
    eyenritems = Matrix(I(nritems))
    paramdims = compute_paramdims(model, nritems, nrskills, nrtimepoints)
    hesscompleteitems = 0

    if estimateβ
        for itemID = 1:nritems
            for t = 1:nrtimepoints
                psivec = emission_responsevec(model.emissionprob, QMatrix,
                            itemID,t, αMatrix)
                psidim = length(psivec)
            if Bool(obsloc[itemID,t])
                pemiss = local_emission(model.emissionprob, QMatrix,
                            itemID, t, αMatrix, β[itemID])   
                emisshess = (1 - pemiss)*pemiss*psivec*psivec'     
            else
                emisshess = zeros(psidim)
            end
            submxselect = eyenritems[:, itemID]*eyenritems[:,itemID]'
            hessmxitemid = kron(submxselect, emisshess)
            hesscompleteitems = hesscompleteitems .+ hessmxitemid
            end # end of time loop
        end # end of itemID
    end # end of estimateβ

    if estimateδ
        hesscompleteskills = 0;
        t = 1 
        for skillID = 1:nrskills
            phivec = transition_responsevec(model.transitionprob, RMatrix,
                                            skillID,t,αMatrix)
            pt = local_transition(model.transitionprob, RMatrix,
                                            skillID, t, αMatrix, δ0[skillID], δ[t], temperature)  
        
            transsubmx = pt*(1-pt)*phivec*phivec'
            eyeselect = eyenrskills[:, skillID]*eyenrskills[:, skillID]'
            skillhess = kron(eyeselect, transsubmx)
            hesscompleteskills = hesscompleteskills .+ skillhess
        end # skillID loop    

        if nrtimepoints != 1
            hesscompleteskills = 0; 
            for skillID = 1:nrskills
                for t= 2:nrtimepoints
                    phivec = transition_responsevec(model.transitionprob, RMatrix,
                                                    skillID,t,αMatrix)
                    pt = local_transition(model.transitionprob, RMatrix,
                                                skillID, t, αMatrix, δ0[skillID], δ[t], temperature)
                    transsubmx = pt*(1-pt)*phivec*phivec'
                    eyeselect = eyenrskills[:,skillID]*eyenrskills[:,skillID]'
                    skillhess = kron(eyeselect, transsubmx)
                    hesscompleteskills = hesscompleteskills .+ skillhess
                end # time loop
            end # skillID loop
        end
    end # end of estimateδ
    estimateδtrans = estimateδ && nrtimepoints !=1

    if estimateβ && !estimateδ
        hesscomplete = hesscompleteitems
    end

    if estimateβ && estimateδ
        # this may break for t > 1 && delta==true
        hesscomplete = [hesscompleteitems zeros(2*nritems,nrskills); 
                        zeros(nrskills, 2*nritems) hesscompleteskills]
        if estimateδtrans
            hesscomplete = [hesscomplete zero(2*nritems+nrskills, 2*nrskills);
                            zeros(2*nrskills, 2*nritems+nrskills) hesscompleteskills]
        end
    end
    return hesscomplete
end

function ∇²risk(model::CPM, data, QMatrix, RMatrix, θ, e_strategy)
    data = soa(data)
    nrexaminees = length(data)
    nrtimepoints, nritems = size(data.itemResponse[1]')
    nrskills = length(θ.δ0)
    temperature = 1.0
    nrterms = 2^(nrskills*nrtimepoints)
    all_patterns = AllPatterns(nrskills*nrtimepoints)'
    θvals = (β = θ.β.val, δ0 = θ.δ0.val, δ = θ.δ.val)
    paramdims = compute_paramdims(model, nritems, nrskills, nrtimepoints)
    
    Σhess = zeros(paramdims,paramdims)
    hessvecompletemx = zeros(nrterms, paramdims*paramdims)
    hessavg = zeros(paramdims, paramdims)
    for i = 1:nrexaminees
        likelihoodcomplete = zeros(nrterms)
        thedata = data[i]
        for Σᵢ = 1:nrterms
            αMatrix  = reshape(all_patterns[Σᵢ, :], (nrskills, nrtimepoints))
    
            likelihoodcomplete[Σᵢ] = likelihoodcompletealpha(
                                                    model, thedata, QMatrix, 
                                                    RMatrix, αMatrix, θvals, temperature
                                                    )
            hessvecompletemx[Σᵢ, :] = ∇²riskαᵢ(model::CPM, thedata, αMatrix,
                                                QMatrix, RMatrix, θ, temperature)'
        end
        wts = likelihoodcomplete / (eps() + sum(likelihoodcomplete))
        weightedhessvec = hessvecompletemx'*wts
        hessavg =  reshape(weightedhessvec, paramdims, paramdims)
        Σhess = Σhess + hessavg
    end
    MLcompletehess = Σhess / nrexaminees

    hesslogprior = ∇²logpriors(model,θ,nrtimepoints) / nrexaminees
    complehessian = MLcompletehess - hesslogprior
    return complehessian 
end

function ∇²opgrisk(model::CPM, data, QMatrix, RMatrix, θ, e_strategy)
    completehessian =  ∇²risk(model::CPM, data, QMatrix, RMatrix, θ, e_strategy)
    
end
export ∇²riskαᵢ, ∇²risk