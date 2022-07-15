
response_prob(a::DINO, selectedalpha) = 1 - prod(1 .- selectedalpha)
response_prob(a::DINA, selectedalpha) = prod(selectedalpha)
response_prob(a::FUZZYDINA, selectedalpha) = sum(selectedalpha)/length(selectedalpha)

# This is equivalent to the psiemission function in MATLAB Carla
"""
This function computes the emission probability vector.

    INPUTS:
        - EmissionType: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
        - QMatrix: J (No. of Items) × K (No. of Skills) Matirx
        - itemID:  Integer denoting the jth item 
        - t: time index
        - αMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix

    OUTPUT:
        - emission probability vector 

"""
function local_emission_pmf(
    EmissionType::ResponseFunction, QMatrix,
    itemID, t, αMatrix
    )

    αvec = αMatrix[:,t]
    qrow = QMatrix[itemID,:]
    selectedalpha = αvec[Bool.(qrow)]
    probval = response_prob(EmissionType, selectedalpha)

    return [probval; -1]
end

export local_emission_pmf