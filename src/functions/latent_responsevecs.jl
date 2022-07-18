
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
    selectedalpha = αvec[Bool.(qrow)]
    probval = response_prob(EmissionType, selectedalpha)

    return [probval; -1]
end

@doc raw"""
    transition_responsevec(
        EmissionType::ResponseFunction, RMatrix::Matrix,
        skillID::Integer, t::Integer, αMatrix::Matrix
    )

Computes the local transition response vectors ``\phi_{kt} (\alpha)``

```math
\phi_{kt} (\alpha) =
\begin{cases}
[1, \Pi_{k \in S_{kt}} \alpha_k] & \text{  if DINA-type emission} \\
[1, 1 - \Pi_{k \in S_{kt}} (1 - \alpha_k)] & \text{  if DINO-type emission} \\
[1, \frac{\Sigma_{k \in S_{kt}} \alpha_k}{K}] & \text{  if FUZZYDINA-type emission}
\end{cases}
```

## Arguments

- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `RMatrix`: K (No. of Skills) × K (No. of Skills) Matirx
- `skillID`:  Integer denoting the jth skill
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix

## Output:

A 2-element Vector{Float64}
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