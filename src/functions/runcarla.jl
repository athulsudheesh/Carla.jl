"""
    CARLA(model,data,QMatrix, kwargs...)

## Arguments 
- `model`: The Carla Probability Model
- `data`: `StudentResponse` of the examiniee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `RMatrix`: RMatrix specifies how skills are temporally connected

## Keyword Arguments 
- `e_strategy`: Estimation Strategy (`Exact` by default)
- `learning`: `Batch` or `Adaptive` (`Batch` by default)
- `m_strategy`: Risk Minimization strategy. (`GradientDescent` by default)
- `linesearch`: Algorithm for stepsize selection (`BackTracking` by default)
"""
function CARLA(model::CPM, data, QMatrix; e_strategy = Exact(),  
                m_strategy = GradientDescent(), learning = Batch(),
                linesearch = BackTracking(), RMatrix = nothing)
    data = soa(data)
    nritems, nrskills = size(QMatrix)
    θ = param_init(model, nritems, nrskills)
    batchdecent(model, data, QMatrix, nothing, θ, 
    e_strategy = e_strategy, 
    linesearch = linesearch, learning = learning, m_strategy = m_strategy)
    return θ
end
export CARLA