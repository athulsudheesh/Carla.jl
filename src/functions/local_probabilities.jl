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

@doc raw"""
    local_transition(
        EmissionType::ResponseFunction, RMatrix,
        skillID, t, αMatrix, deltavec, temperature) 

Computes the probability that an examinee has mastered the latent skill k
at assessment time t, given the examinee's latent skill profile at t-1. This is also 
known as the complete-data local transition probability ``P_{\delta_k}^{\alpha} (t)``


```math
P_{\delta_k}^{\alpha} (t) = \rho(\delta_k(t)^T \phi_{kt}(\alpha (t -1))) 
```
where ``\rho`` is a logistic sigmoidal function. ``\rho(x) = \frac{1}{1 + e^{-x}}``
## Arguments 
- `EmissionType`: Emission Response Type (DINA(),DINO(), or FUZZYDINA())
- `RMatrix`: K (No. of Skills) × K (No. of Skills) Matirx
- `skillID`:  Integer denoting the jth skill
- `t`: time index
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix
- `deltavec` - delta values for a given skill at time t

## Output 

A Float64
"""
function local_transition(
    EmissionType::ResponseFunction, RMatrix,
    skillID, t, αMatrix, deltavec, temperature)
 
    phivec = transition_responsevec(
        EmissionType::ResponseFunction, RMatrix,
        skillID, t, αMatrix)
    
    sigmoid((deltavec' * phivec)/temperature)
end

export local_transition