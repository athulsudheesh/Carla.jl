@doc raw"""
    local_emission(EmissionType::ResponseFunction, QMatrix,
    itemID, t, αMatrix, betavector)

Computes the probability that an examinee with the given skill profile (αMatrix)
will correctly answer the item - itemID, at given time t. This is also known as
the complete-data local emission conditional probability ``P_{\beta_j}^{\alpha} (t)``

```math
P_{\beta_j}^{\alpha} (t) = \rho (\beta_j(t)^T \psi_{jt} (\alpha(t)))
```

where ``\rho`` is a logistic sigmoidal function. ``\rho(x) = \frac{1}{1 + e^{-x}}``

## Arguments

- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `itemID`:  Integer denoting the jth item 
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix
- `betavector` - β values for the given item

## Output:

A Float64
"""
function local_emission(
    EmissionType::ResponseFunction, QMatrix,
    itemID, t, αMatrix, betavector)

    psivec = emission_responsevec(
        EmissionType, QMatrix,
        itemID, t, αMatrix)
    
    sigmoid(betavector' * psivec) 
end

export local_emission

# The definition of this function is probably wrong! 
# I am guessing the MATLAB implementation is also wrong
function local_transition(
    EmissionType::ResponseFunction, RMatrix,
    skillID, t, αMatrix, deltavec, temperature)

    phivec = transition_responsevec(
        EmissionType::ResponseFunction, RMatrix,
        skillID, t, αMatrix)
    
    sigmoid((deltavec' * phivec)/temperature)
end

export local_transition