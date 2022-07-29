"""
    CARLA(model,data,QMatrix, kwargs...)
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

end
export CARLA