
@doc raw"""
    likelihoodcompletealpha(
        model::CPM, data, QMatrix, 
        RMatrix, αMatrix, θ, temperature
        )
Computes the likelihood of the αMtrix and the observed responses of an examinee where 
we assume αMatrix is fully observable.

```math
\mathit{\ddot{L}^i (\mathbf{\theta ; \alpha})} = 
\Pi_{t=1}^T \Pi_{j=1}^J \Pi_{k=1}^K
p_{\beta_j (t)} (x_{ij}(t) | \alpha(t))
p_{\delta_k (t)} (\alpha_k(t) | \alpha (t-1))
```

## Arguments 
- `model`: The Carla Probability Model
- `data`: `StudentResponse` of the examiniee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `RMatrix`: RMatrix specifies how skills are temporally connected
- `αMatrix`: K (No. of Skills) × T (No. of Timepoints) Matrix
- `θ`: Parameter values, A named tuple θ = (β, δ0, δ)
- `temperature`: temeprature parameter for importance sampling 

## Output
A Float64
"""
function likelihoodcompletealpha(
                    model::CPM, data, QMatrix, 
                    RMatrix, αMatrix, θ, temperature)

    emission = global_emission(model.emissionprob, 
                                data, QMatrix, αMatrix, θ.β)
    transition = global_transition(model.transitionprob, 
                                RMatrix, αMatrix, θ.δ0, θ.δ, temperature)

    emission * transition
end

export likelihoodcompletealpha