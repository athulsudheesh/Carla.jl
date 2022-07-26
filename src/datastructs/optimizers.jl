abstract type Optimizer end

struct LBFGS <: Optimizer end

abstract type Learning end

@doc raw"""
    Batch(
        maxsearchdev, levenmarq_eigval,
        innercycles, momentum_const, 
        searchdirection_maxnorm,
        numerical0, maxdiffx,
        maxgradnorm, maxiter,
        stepsize, useminstepsize, 
        minstepsize,maxstepsizecycle,
        wolfestepalpha, wolfestepbeta,
        stepsizerescale, stepdiagnostics
    )
"""
Base.@kwdef struct Batch <: Learning 
    maxsearchdev = 1e-4
    levenmarq_eigval = 1e-4
    innercycles = 10 
    momentum_const = 1 
    searchdirection_maxnorm = 1.0
    numerical0 = 1e-8
    maxdiffx = 1e-8
    maxgradnorm = 0.0001
    maxiter = 50
    stepsize = 1.0
    useminstepsize = false
    minstepsize = stepsize / 1000
    maxstepsizecycle = 3
    wolfestepalpha = 0.01
    wolfestepbeta = 0.9
    stepsizerescale = 0.7
    stepdiagnostics = false
end

export Batch 