# This file contains the functions for initializing parameters 

# modelcons_init is similar to setmodelconstants in MatlabCarla
# with the exception that data-specific constants are obtained using the 
# extract(X_df, Q_df, R) function defined in src/datahandling.jl  
"""
    modelcons_init()

Initializes probability model constants. If no arguments are passed default values will be used. 

# Optional Arguments:
- estimatebeta: Boolean type; default `true`  
- estimatedelta: Boolean type; default `false` 
- ψ: A ResponseFunction type (e.g.  DINA(), DINO(), FUZZYDINA()); default `DINA()`
- ϕ: A ResponseFunction type (e.g.  DINA(), DINO(), FUZZYDINA()); default `DINA()`
- forceblockdiagonal: Boolean type;  If true forces the off-diagonal submatrices of the B matrix equal to 0; default `true`
- std: Floating point number; std.dev. additive noise to initial parameters; default `0.0` 
- variance: parameter for gaussian model prior; default `400/536` 
- wt_vec: weight vector; default `[0,0]` 
"""
function modelcons_init(;
    estimateβ = true,
    estimateδ = false,
    ψ = DINA(),
    ϕ = DINA(),
    forceblockdiagonal = true,
    std = 0.0,
    variance = 400 / 536,
    wt_vec = [0, 0],
)

    return (
        estimatebeta = estimateβ,
        estimatedelta = estimateδ,
        psifunctiontype = ψ,
        phifunctiontype = ψ,
        forceblockdiagonal = forceblockdiagonal,
        initparamstd = std,
        varianceprior = variance,
        initialweightvector = wt_vec,
    )
end


"""
    algocons_init()
Initializes algorithm constants. If no arguments are passed default values will be used. 
# Optional Arguments 
- p: number between 0 & 1; significance level for confidence interval calculations; default `0.05`
- e_step: Estimation type; (e.g. ExactmissingSerial(), ExactmissingParallel(), ImportanceSerial(), ImportanceParallel())\n
 This is the strategy for expectation step, also known as missing data integral; default `ExactmissingSerial()` 

- OMCmaxnrsamples: Integer; Maximum number of Monte Carlo Samples to be generated before Monte Carlo Algorithm terminates; default `50`
- OMCtemperature:Positive Number; Sampling temperature for importance sampling algo; default `0.25`
    - OMCtemperature = 1 (regular OMC Sampling)
    - OMCtemperature = 0.0001 (OMC Sampling biased to visit high probability state; not recommended)
    - OMCtemperature =  5 (OMC Sampling biased to checkout low probability states)
    - OMCtemperature = 10000000 (almost true sampling)
- OMCsamplingerror: Floating number; Sampling Error is chosen so that with probability 95% the confidence interval surrounding the actual mean contains 
the estimated posterior mean. Monte Carlo algorithm will terminate at this point; default `0.01`
- OMCinfsamplemultiply: Positive Integer; Multiplier for increasing number of monte carlo samples; default `10`

- COVARIANCEnumericalzero: Floating number; Force singular values whose magnitude is smaller than this to zero when applying PINV for covariance matrix calculations
default `1e-6`  
- COVARIANCEmulticollinearity:Floating number; Condition number larger than this indicate multicollinearity; default `1e+12`
- learning: learning strategy (Batch() or Adaptive()); default `Batch()`

- ADAPTIVEinitialstepsize; default `0.5`
- ADAPTIVEmaxiterations; default `120`
- searchdirection; default `Lbfgs()` (available: Gradient(), MomentumGrad())
- maxsearchdev; default `1e-4` Reset search direction if search direction is almost orthogonal to negative gradient
- levenmarqeigvalue; default 1e-4; Critical smallest eigen value 
- innercycles; default `10` Number of batch inner cycles for LBFGS & Polak-Ribiere and Moemntum 
- momentumconstant; Moemntum direction constant control parameter; default `1`
- searchdirectionmaxnorm; Maximum search direction norm; default `1.0`
- numericalzero; Numerical zero for batch learning; default `1e-8`
- maxdiffx; Stopping Criteria for convergence is maximum absolute difference in parameter estimates; default `1e-8` 
- maxgradnorm; Terminate stopping citerial if max(abs(gradient vector)) is less than gradmax; default `0.00001` 
- BATCHmaxiterations; Terminate if max num of iterations exceed this number; default `100`
- BATCHstepsize; Maximum batch step size; default `1.0`
- BATCHuseminstepsize; Boolean; Batch step size control parameter; default `false`
- BATCHmaxstepsizecycles; Maximum number of cycles for autostepsize; default `3`
- BATCHwolfestepalpha; default `0.01`
- BATCHwolfestepbeta; default `0.9`
- BATCHstepsizescale; Autostepsize backtracking scaling constant; default 0.7

"""
function algocons_init(;
    p = 0.05,
    e_step = ExactmissingSerial(),
    OMCmaxnrsamples = 50,
    OMCtemperature = 0.25,
    OMCsamplingerror = 0.01,
    OMCinfsamplemultiply = 10,
    COVARIANCEnumericalzero = 1e-6,
    COVARIANCEmulticollinearity = 1e+12,
    learning = Batch(),
    ADAPTIVEinitialstepsize = 0.5,
    ADAPTIVEmaxiterations = 120,
    searchdirection = Lbfgs(),
    maxsearchdev = 1e-4,
    levenmarqeigvalue = 1e-4,
    innercycles = 10,
    momentumconstant = 1,
    searchdirectionmaxnorm = 1.0,
    numericalzero = 1e-8,
    maxdiffx = 1e-8,
    maxgradnorm = 0.00001,
    BATCHmaxiterations = 100,
    BATCHstepsize = 1.0,
    BATCHuseminstepsize = false,
    BATCHmaxstepsizecycles = 3,
    BATCHwolfestepalpha = 0.01,
    BATCHwolfestepbeta = 0.9,
    BATCHstepsizescale = 0.7,
)

    OMCburninperiod = Int(OMCmaxnrsamples / 2) # Do not terminate if number of samples is less than burn-in period
    OMCparforloopmax = Int(OMCmaxnrsamples / 2)

    ADAPTIVEsearchhalflife = Int(ADAPTIVEmaxiterations * 0.30)
    ADAPTIVEconvergehalflife = Int(ADAPTIVEmaxiterations * 0.50)
    ADAPTIVEperiod = Int(ADAPTIVEmaxiterations * 0.10)

    BATCHminstepsize = BATCHstepsize / 1000

    return (
        pval = p,
        missingdataintegral = e_step,
        OMCmaxnrsamples = OMCmaxnrsamples,
        OMCtemperature = OMCtemperature,
        OMCsamplingerror = OMCsamplingerror,
        OMCburninperiod = OMCburninperiod,
        OMCparforloopmax = OMCparforloopmax,
        OMCinfsamplemultiply = OMCinfsamplemultiply,
        COVARIANCEnumericalzero = COVARIANCEnumericalzero,
        COVARIANCEmulticollinearity = COVARIANCEmulticollinearity,
        doannealstepsize = learning,
        ADAPTIVEinitialstepsize = ADAPTIVEinitialstepsize,
        ADAPTIVEmaxiterations = ADAPTIVEmaxiterations,
        ADAPTIVEsearchhalflife = ADAPTIVEsearchhalflife,
        ADAPTIVEconvergehalflife = ADAPTIVEconvergehalflife,
        ADAPTIVEperiod = ADAPTIVEperiod,
        BATCHsearchdirection = searchdirection,
        BATCHmaxsearchdev = maxsearchdev,
        BATCHlevenmarqeigvalue = levenmarqeigvalue,
        BATCHinnercycles = innercycles,
        BATCHmomentumconstant = momentumconstant,
        BATCHsearchdirectionmaxnorm = searchdirectionmaxnorm,
        BATCHnumericalzero = numericalzero,
        BATCHmaxdiffx = maxdiffx,
        BATCHmaxgradnorm = maxgradnorm,
        BATCHmaxiterations = BATCHmaxiterations,
        BATCHstepsize = BATCHstepsize,
        BATCHuseminstepsize = BATCHuseminstepsize,
        BATCHminstepsize = BATCHminstepsize,
        BATCHmaxstepsizecycles = BATCHmaxstepsizecycles,
        BATCHwolfestepalpha = BATCHwolfestepalpha,
        BATCHwolfestepbeta = BATCHwolfestepbeta,
        BATCHstepsizescale = BATCHstepsizescale,
    )
end




"""
    print_init(params, modelcons, algcons)

Prints the initialized values for parameters and model constants 
"""
function print_init(params, modelcons, algcons)
    println(
        "========================= Initial Values for parameters ========================= \n",
    )
    pprint(params)
    println(
        "\n \n \n========================= Model Constants ========================= \n",
    )
    pprint(modelcons)
    println(
        "\n \n \n========================= Algorithm Constants ========================= \n",
    )
    pprint(algcons)
end
