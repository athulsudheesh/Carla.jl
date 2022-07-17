
response_prob(a::DINO, selectedalpha) = 1 - prod(1 .- selectedalpha)
response_prob(a::DINA, selectedalpha) = prod(selectedalpha)
response_prob(a::FUZZYDINA, selectedalpha) = sum(selectedalpha)/length(selectedalpha)


"""
    emission_responsevec(
        EmissionType::ResponseFunction, QMatrix::Matrix,
        itemID::Integer, t::Integer, αMatrix::Matrix
    )

Computes the local emission response vectors ``\\psi_{jt} (\\alpha)`` 

## Arguments

- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `itemID`:  Integer denoting the jth item 
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix

## Output:

A 2-element Vector{Float64} (Probability Vectors)

Note: *This is equivalent to the psiemission function in MATLAB Carla*
"""
function emission_responsevec(
    EmissionType::ResponseFunction, QMatrix,
    itemID, t, αMatrix
    )

    αvec = αMatrix[:,t]
    qrow = QMatrix[itemID,:]
    selectedalpha = αvec[Bool.(qrow)]
    probval = response_prob(EmissionType, selectedalpha)

    return [probval; -1]
end

"""
    transition_responsevec(
        EmissionType::ResponseFunction, RMatrix::Matrix,
        skillID::Integer, t::Integer, αMatrix::Matrix
    )

Computes the local transition response vectors ``\\phi_{kt} (\\alpha)``

## Arguments

- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `RMatrix`: K (No. of Skills) × K (No. of Skills) Matirx
- `skillID`:  Integer denoting the jth skill
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix

## Output:

A 2-element Vector{Float64} (Probability Vectors)

Note: *This is equivalent to the phitransition function in MATLAB Carla*
"""
function transition_responsevec(
    EmissionType::ResponseFunction, RMatrix,
    skillID, t, αMatrix
    )

    αvec = αMatrix[:,t]
    rrow = RMatrix[skillID,:]
    selectedalpha = αvec[Bool.(rrow)]
    probval = response_prob(EmissionType, selectedalpha)

    return [probval; -1]
end
export emission_responsevec, transition_responsevec