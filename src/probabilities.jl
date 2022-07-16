
response_prob(a::DINO, selectedalpha) = 1 - prod(1 .- selectedalpha)
response_prob(a::DINA, selectedalpha) = prod(selectedalpha)
response_prob(a::FUZZYDINA, selectedalpha) = sum(selectedalpha)/length(selectedalpha)


"""
    local_emission_pmf(
        EmissionType::ResponseFunction, QMatrix::Matrix,
        itemID::Integer, t::Integer, αMatrix::Matrix
    )

Computes the local emission probability vectors

### Inputs

- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `itemID`:  Integer denoting the jth item 
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix

### Output:

Vector of probability values 

### Note

This is equivalent to the psiemission function in MATLAB Carla
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