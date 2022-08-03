function final_inference(model,data,
    QMatrix, RMatrix, θ, e_strategy, learning, doprojection,
    convnumzero,projectnumber0multiplier)
    mineigval = convnumzero * projectnumber0multiplier
    infertime = @time begin
        MAPrisk, MLrisk, MAPriskvec = maprisk(model, data,
            QMatrix, RMatrix, θ,
            e_strategy=e_strategy)

        AmxHess, BmxOPG, completehessian, opgmisscov, fractioninfo, riskgradient =  ∇²opgrisk(model, 
                                         data, QMatrix, RMatrix, θ, e_strategy, convnumzero)
    end

    nrexaminees = length(data)
    if doprojection
        Pmxeigvals, Pmxtotal = eigen(AmxHess)
        selectedEvecs = Bool.(Pmxeigvals .>= mineigval)
        Pmx = Pmxtotal[:,selectedEvecs]

        PAmxhess = Pmx'*AmxHess*Pmx
        PBmxOPG = Pmx'*BmxOPG*Pmx

    else
        AmxHessdim = size(AmxHess)[1]
        PAmxhess = AmxHess
        PBmxOPG = BmxOPG
        Pmx = Matrix(I(AmxHessdim))
        Pmxeigvals = ones(AmxHessdim)
    end

    absgradnorm = maximum(abs.(riskgradient))
    convergedok = absgradnorm <= learning.maxgradnorm
    AmxHess = Pmx*PAmxhess*Pmx'
    BmxOPG = Pmx*PBmxOPG*Pmx'
    condA = mycondnum(PAmxhess, convnumzero)
    condB = mycondnum(PBmxOPG, convnumzero)
    invPAmxHess = mypinvsym(PAmxhess, convnumzero)
    invPBmxOPG = mypinvsym(PBmxOPG, convnumzero)

    acov = Pmx*invPAmxHess*Pmx' /nrexaminees
    bcov = Pmx*invPBmxOPG*Pmx' /nrexaminees
    ccov = Pmx*invPAmxHess*PBmxOPG*invPAmxHess*Pmx'/nrexaminees
    Adim = size(acov)[1]
    condCcov = mycondnum(ccov, convnumzero)
    rankprojection = rank(Pmx)

    imtrace, imInvtrace, imdet = imtmodelfit(PAmxhess, PBmxOPG,convnumzero)
    BIC, XBIC, GAIC = MSC(MLrisk, MAPrisk,PAmxhess, PBmxOPG, nrexaminees, convnumzero)

    betavector =  hcat(θ.β.val...)'
    δ0vector = hcat(θ.δ0.val...)'
    if model.opts.estimatedelta 
        deltavector = hcat(θ.δ.val...)'
    end

    pguess = sigmoid.(-betavector[:,2])
    pslip = 1 .- (sigmoid.(betavector[:,1] .- sigmoid.(betavector[:,2])))
    println("
    Converged?:                  \t $convergedok
    MAP Risk:                    \t $MAPrisk
    Gradient Infinity Norm:      \t $absgradnorm


    Hessian Condition Number:    \t $condA
    OPG Matrix Condition Number: \t $condB
    CCOV Condition Number:       \t $condCcov
    GAIC Model Fit:              \t $GAIC
    BIC Model Fit:               \t $BIC
    XBIC Model Fit:              \t $XBIC
    Missing Information Fraction:\t $fractioninfo
    Inverted Log Trace IMT:      \t $imInvtrace
    Log Trace IMT:               \t $imtrace
    Log Determinant IMT:         \t $imdet
    ")
    globalresults = (
        maprisk = MAPrisk,
        gradnorm = absgradnorm,
        conditionA = condA,
        conditionB = condB,
        AMatrix = AmxHess,
        BMatrix = BmxOPG,
        BIC = BIC,
        XBIC = XBIC,
        GAIC = GAIC,
        slip = pslip,
        guess = pguess
    )
    return globalresults
end
export final_inference


function imtmodelfit(Amxhess, BmxOPG, number0)
    imtrace = NaN; imInvtrace = NaN; imdet = NaN
    
    Adim = size(Amxhess)[1]
    ismulticollinear = isinf(mycondnum(Amxhess, number0)) || isinf(mycondnum(BmxOPG, number0))

    if !ismulticollinear
        invAmxhess = mypinvsym(Amxhess, number0)
        invBmxOPG = mypinvsym(BmxOPG, number0)
        imtrace = abs(protected_log(1/Adim)*tr(invAmxhess*BmxOPG))
        imInvtrace = abs(protected_log(1/Adim)*tr(invBmxOPG*Amxhess))
        imdet = abs((1/Adim)*protected_log(det(invAmxhess*BmxOPG)))
    end
    return imtrace, imInvtrace, imdet
end
export imtmodelfit

function MSC(MLrisk, MAPrisk, Amxhess, BmxOPG, nrexaminees, number0)
 bic = NaN; xbic = NaN; gaic = NaN 
 Adim = size(Amxhess)[1]
    ismulticollinear = isinf(mycondnum(Amxhess, number0)) || isinf(mycondnum(BmxOPG, number0))

    if !ismulticollinear
        bic = 2*nrexaminees*MLrisk + Adim*protected_log(nrexaminees)
        invAmxhess = mypinvsym(Amxhess, number0)
        invBmxOPG = mypinvsym(BmxOPG, number0)
        traceinvAB = tr(invAmxhess*BmxOPG)
        qlog2pi = Adim*protected_log(2*pi)
        logdetA = protected_log(det(Amxhess))
        xbic = 2*nrexaminees*MAPrisk + traceinvAB - qlog2pi + logdetA
        gaic = 2*nrexaminees*MLrisk + 2*traceinvAB
    end
    return bic, xbic, gaic
end
export MSC