"""
    batchdecent(args...)

A Batch descent algorithm 

## Arguments 
- `model`: The Carla Probability Model
- `data`: `StudentResponse` of the examiniee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `RMatrix`: RMatrix specifies how skills are temporally connected
- `θ`: Parameter values, A named tuple θ = (β, δ0, δ)

## Keyword Arguments 
- `e_strategy`: Estimation Strategy (`Exact` or `IS`)
- `learning`: `Batch` or `Adaptive`
- `m_strategy`: Risk Minimization strategy (Gradient Descent/ LBFGS)
"""
function batchdecent(model::CPM, data,
    QMatrix, RMatrix, θ;
    e_strategy, linesearch, learning::Batch, m_strategy)

    maxdiffx = learning.maxdiffx
    maxgradnorm = learning.maxgradnorm
    maxiterations = learning.maxiteration

    stepsize = linesearch.stepsize

    nrtimepoints, nritems = size(data.itemResponse[1]')
    _, nrskills = size(QMatrix)
    xtdims = compute_paramdims(model, nritems, nrskills, nrtimepoints)

    # Run Batch Learning Descent Algorithm 

    dtlast = zeros(xtdims)
    gtlast = zeros(xtdims)
    laststepsize = 0
    θhist = []
    innercycleid = 0
    keepgoing = true
    iteration = 0

    while keepgoing
        iteration = iteration + 1

        gt = ∇risk(model, data, QMatrix, RMatrix, θ, e_strategy = e_strategy)[1]

        dt, angulardeviation, innercycleid = autosearch(innercycleid,
            gt, gtlast, laststepsize,
            dtlast, m_strategy,learning)

        mapriskval, mlrisk, mapriskvec = maprisk(model, data,
            QMatrix, RMatrix, θ,
            e_strategy = e_strategy)

        thestepsize , Vbest, stepsizecycles = autostep(
            model, data, QMatrix, RMatrix, θ,
            dt, gt, mapriskval, e_strategy = e_strategy, linesearch = linesearch)
    
        lastθ = deepcopy(θ)
        updateθ!(model, θ, thestepsize*dt, nritems, nrskills, nrtimepoints)
        boundboxed!(θ,model.paramconstraints.min, model.paramconstraints.max)
        dtlast = dt
        gtlast = gt 
        laststepsize = thestepsize


        absgradnorm = maximum(abs.(gt))
        gradnorm2large = absgradnorm > maxgradnorm
        absdiffx = absdiffθ(lastθ, θ, model, nrtimepoints)
        change2large = absdiffx > maxdiffx
        toomanyiterations = iteration  >= maxiterations
        keepgoing = change2large & gradnorm2large & !toomanyiterations

        println("Iteration = $iteration \t MAP Fit = $mapriskval \t ML Error = $mlrisk \t Angular deviation = $angulardeviation \t gradnorm = $absgradnorm \t stepsize = $laststepsize")
    end
end
export batchdecent