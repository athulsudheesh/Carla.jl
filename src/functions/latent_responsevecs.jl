
response_prob(a::DINO, selectedalpha) = 1 - prod(1 .- selectedalpha)
response_prob(a::DINA, selectedalpha) = prod(selectedalpha)
response_prob(a::FUZZYDINA, selectedalpha) = sum(selectedalpha)/length(selectedalpha)


@doc raw"""
    emission_responsevec(
        EmissionType::ResponseFunction, QMatrix::Matrix,
        itemID::Integer, t::Integer, αMatrix::Matrix
    )

Computes the local emission response vectors ``\psi_{jt} (\alpha)`` 
```math
\psi_{jt} (\alpha) =
\begin{cases}
[1, \Pi_{k \in S_{jt}} \alpha_k] & \text{  if DINA-type emission} \\
[1, 1 - \Pi_{k \in S_{jt}} (1 - \alpha_k)] & \text{  if DINO-type emission} \\
[1, \frac{\Sigma_{k \in S_{jt}} \alpha_k}{K}] & \text{  if FUZZYDINA-type emission}
\end{cases}
```

## Arguments

- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `itemID`:  Integer denoting the jth item 
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix

## Output:

A 2-element Vector{Float64}
"""
function emission_responsevec(
    EmissionType::ResponseFunction, QMatrix,
    itemID, t, αMatrix
    )

    αvec = αMatrix[:,t]
    qrow = QMatrix[itemID,:]
    
    if isempty(qrow)
        probval = 0
    else
        selectedalpha = αvec[Bool.(qrow)]
        probval = response_prob(EmissionType, selectedalpha)
    end 

    return [probval; -1]
end

@doc raw"""
    transition_responsevec(
        TransitionType::ResponseFunction, RMatrix::Matrix,
        skillID::Integer, t::Integer, αMatrix::Matrix
    )

Computes the local transition response vectors ``\phi_{kt} (\alpha)``

When t = 1
```math
\phi_{kt} (\alpha) = -1
```
else
```math
\phi_{kt} (\alpha) =
\begin{cases}
[1, \Pi_{k \in S_{kt}} \alpha_k] & \text{  if DINA-type transition} \\
[1, 1 - \Pi_{k \in S_{kt}} (1 - \alpha_k)] & \text{  if DINO-type transition} \\
[1, \frac{\Sigma_{k \in S_{kt}} \alpha_k}{K}] & \text{  if FUZZYDINA-type transition}
\end{cases}
```

## Arguments
 
- `TransitionType`: DINA(),DINO(), or FUZZYDINA()
- `RMatrix`: K (No. of Skills) × K (No. of Skills) Matirx
- `skillID`:  Integer denoting the jth skill
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix

## Output:

A 2-element Vector{Float64}
"""
function transition_responsevec(
    TransitionType::ResponseFunction, RMatrix,
    skillID, t, αMatrix
    )
    if t == 1
        return -1
    else
        αvec = αMatrix[:,t - 1]
        rrow = RMatrix[skillID,:]
        if isempty(rrow)
            probval = 0
        else
            selectedalpha = αvec[Bool.(rrow)]
            probval = response_prob(TransitionType, selectedalpha)
        end
        return [probval; -1]
    end
end
export emission_responsevec, transition_responsevec


# need to update the test functions for transition_responsevec