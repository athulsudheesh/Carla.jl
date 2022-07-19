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