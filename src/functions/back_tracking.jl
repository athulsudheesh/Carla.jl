"""
    autostep(args...)

Back-tracing routine which uses quadratic approximations to make improved guesses

## Arguments 

- `model`: The Carla Probability Model
- `data`: `StudentResponse` of the examiniee 
    - `data.itemResponse`: J (No. of items) × T (No. of Time points)
    - `data.missingindicator`:  J (No. of items) × T (No. of Time points)
- `QMatrix`: J (No. of Items) × K (No. of Skills) Matirx
- `RMatrix`: RMatrix specifies how skills are temporally connected
`θ`: Parameter values, A named tuple θ = (β, δ0, δ)
- `dt`: search direction (vector)
- `gt`:gradient of the objective function evaluated at time t 
- `Vt`: objective function evaluated at time t 
- `e_strategy`: estimation strategy 
- `linesearch`: `LineSearch()`

## Output
- (`stepsize`, `Vbest`, `iteration`)
"""
function autostep(
    model::CPM, data, QMatrix, RMatrix, θ,
    dt, gt, Vt; e_strategy, linesearch::BackTracking)

    data = soa(data)
    _, nrtimepoints = size(data.itemResponse[1])
    nritems, nrskills = size(QMatrix)
    useminstepsize = linesearch.useminstepsize
    minstepsize = linesearch.minstepsize
    maxiterations = linesearch.maxstepsizecycles
    alpha = linesearch.wolfestepalpha
    beta = linesearch.wolfestepbeta
    scaledecreasefactor = linesearch.stepsizerescaler
    Vbest = 0
    stepsize = 0
    # Get curvature information regarding error at initial point
    slope0 = dt' * gt
    if slope0 > 0
        @warn "BadSearchDirection \n Search direction uphill!"
    end

    keepgoing = true
    iteration = 1
    step1 = 1 # test step size

    while keepgoing

        updateθ!(model, θ, step1 * dt, nritems, nrskills, nrtimepoints)
        V1 = maprisk(model, data, QMatrix, RMatrix, θ, e_strategy=e_strategy)[1]

        # Check for sufficient decrease of objective function
        suffdecrease = V1 <= (Vt + step1 * alpha * slope0)

        # If the current test stepsize did not decrease error sufficiently 
        # try quadratic approximatio; If ok, then terminate. 
        if !suffdecrease
            # Compute Quadratic Approximation Stepsize 
            step2 = -slope0 / (2 * (V1 - Vt - slope0))

            # Evaluate objective function at quadratic approximation stepsize 
            updateθ!(θ, step2 * alpha * slope0)
            V2 = maprisk(model, data, QMatrix, RMatrix, θ, e_strategy=e_strategy)[1]

            # Check for sufficient decrease of objective function 
            suffdecrease2 = V2 <= (Vt + step2 * alpha * slope0)

            # If not sufficient decrease, try an initial guess 
            # which is closer to the origignal starting point
            # to improve quality of quadratic approximation 
            # by scaling down the initial stepsize guess. 
            # If ok, then terminate 
            if !suffdecrease2
                s1 = scaledecreasefactor * step1
                iteration = iteration + 1
                keepgoing = (iteration < maxiterations)
                if !keepgoing
                    if useminstepsize
                        stepsize = rand() * (1 - minstepsize) + minstepsize
                        updateθ!(model, θ, stepsize * dt, nritems, nrskills, nrtimepoints)
                        Vbest = maprisk(model, data, QMatrix, RMatrix, θ, e_strategy=e_strategy)[1]
                    else
                        stepsize = step2
                        Vbest = V2
                    end
                end
            else
                stepsize = step2
                Vbest = V2
                keepgoing = false
            end # end of suffdecrese2
        else
            stepsize = step1
            Vbest = V1
            keepgoing = false
        end # end of suffdecrease 
    end # end of while loop 

    if stepsize < 0
        stepsize = eps()
    end
    return stepsize, Vbest, iteration
end
export autostep