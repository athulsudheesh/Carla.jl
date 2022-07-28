abstract type Optimizer end

"""
    LBFGS()
    LBFGS(kwargs...)

## Fields
- `searchdirectionmaxnorm`: maximum search direction norm; defulat = 1.0
- `innercycles`: no. of batch inner cycles; defualt = 40
-  `maxsearchdev`: reset research direction if search direction is almost ⟂ to -ve gradient; default = 1e-4
"""
Base.@kwdef struct LBFGS <: Optimizer
    searchdirectionmaxnorm = 1.0
    innercycles = 40
    maxsearchdev = 1e-4
end
export LBFGS

Base.@kwdef struct GradientDescent<: Optimizer 
    maxsearchdev = 1e-4
end 

export GradientDescent

abstract type Learning end

Base.@kwdef struct Batch <: Learning
    numerical0 = 1e-8
    maxdiffx = 1e-8
    maxgradnorm = 0.001
    maxiteration = 50
end
export Batch

abstract type LineSearch end
Base.@kwdef struct BackTracking <: LineSearch 
    stepsize = 1
    useminstepsize = false
    minstepsize = stepsize / 1000
    maxstepsizecycles = 3
    wolfestepalpha = 0.01
    wolfestepbeta = 0.9
    stepsizerescaler = 0.7
end
export BackTracking