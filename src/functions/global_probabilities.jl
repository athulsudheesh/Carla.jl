@doc raw"""
    global_emission(
        EmissionType::ResponseFunction, data, QMatrix, αMatrix, β)

Computes the likelihood of the evidence for an examinee 
given their evidence & proficiency models.

## Arguments 
- EmissionType: specifies if it's a `DINA()`, `DINO()`, or `FUZZYDINA()` emission response 
- `data`: `StudentResponse` of the examinee
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix
- `β`: β values for the item bank, Vector of length J

## Output 
A Float64
"""
function global_emission(
    EmissionType::ResponseFunction, data, QMatrix, αMatrix, β)

    # Computing individual local emissions 
    x = data.itemResponse
    obsloc = data.missingindicator

    nritems, nrtimeponts = size(x)
    emissions_local = zeros(nritems, nrtimeponts)

    for t = 1:nrtimeponts
        for itemID = 1:nritems
            emissions_local[itemID,t] = local_emission(
                                        EmissionType,
                                        QMatrix,
                                        itemID, t, αMatrix, β[itemID]
            )
        end
    end

    # Product of observable local emissions
    emissionMx = (x .* emissions_local) .+ ((1 .- x) .* (1 .- emissions_local))
    logemission = protected_log(emissionMx)
    maskedlogemission = logemission .* obsloc
    sumlogemission = sum(maskedlogemission)
    protected_exp(sumlogemission)
end

export global_emission

@doc raw"""
    global_transition(
        TransitionType::ResponseFunction, RMatrix, αMatrix, δ0, δ, temperature)

Computes the latent skill profile trajectory probability for an examinee. 

## Arguments 
- `TransitionType`: Specify if it's a `DINA()`, `DINO()` or `FUZZYDINA()` transition type
- `RMatrix`: 
- `αMatrix`: latent attribute profile trajectory (K × T)
-  `δ0`: initial detlas, δ[0]
- `δ`: delta values 
- `temperature`: temeprature parameter strictly positive. (used during importance sampling)

## Output 
A Float64
"""
function global_transition(
    TransitionType::ResponseFunction, RMatrix, αMatrix, δ0, δ, temperature)

    nrskills, nrtimepoints = size(αMatrix)
    transitions_local = zeros(nrskills, nrtimepoints)

    for t = 1:nrtimepoints
        for skillID in 1:nrskills
            transitions_local[skillID,t] = local_transition(TransitionType,RMatrix,
                                                        skillID, t,αMatrix, δ0[skillID], δ[t], temperature)
        end
    end

    # Product of local transition probabilites 
    transitionMx = (αMatrix .* transitions_local) .+ ((1 .- αMatrix) .* (1 .- transitions_local))
    logtransition = protected_log(transitionMx)
    sumlogtransition = sum(logtransition)
    protected_exp(sumlogtransition)
end
export global_transition
