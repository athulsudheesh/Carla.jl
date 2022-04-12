
# Defined for ImportanceSerial with summandfunctioncall as getgradientcompletealpha
"""
    expectation(summandfunction_call, thedata, params, data_params, modelcons, algcons, algcons.missingdataintegral::ImportanceSerial, R)
"""
function expectation(
    summandfunction_call::getgradientcompletealpha,
    thedata,
    params,
    data_params,
    modelcons,
    algcons,
    missingdata_integral::ImportanceSerial,
    R,
    Q,
)
    quitsampling = false
    nrskills = data_params.nr_skills
    nrtimepoints = data_params.nr_timepoints
    parforloopmax = algcons.OMCparforloopmax
    thetavectorinitial = unpackparams(params)[1]
    hessdim = length(thetavectorinitial)
    temperature = algcons.OMCtemperature
    estimatebeta = params[:estimatebeta]
    nritems = data_params.nr_items

    while !quitsampling
        funkvallist = zeros(hessdim, parforloopmax)
        wtfactorlist = zeros(algcons, parforloopmax)

        for parforindex = 1:parforloopmax

            # Generate a sample profile trajectory
            alphamx = zeros(nrskills, nrtimepoints)
            transpobvectemp = zeros(nrskills)

            for t = 1:nrtimepoints
                for skillid = 1:nrskills
                    transpobvectemp[skillid] = getransitionprobval(
                        temperature,
                        skillid,
                        t,
                        alphamx,
                        params,
                        modelcons,
                        R,
                    )
                end
                alphamx[:, t] = rand(nrskills) .<= transpobvectemp
            end

            # Evaluate Statistic at alphamx
            if estimatebeta
                # Compute the gradient of -log emission probabilities (time invariant case)
                for itemid = 1:nritems
                    sumemissgrad = 0.0
                    for t = 1:nrtimepoints
                        psivector = psiemission(itemid, t, alphamx, modelcons, Q)
                        pemiss = getemissionprobval(itemid, t, alphamx, params, modelcons)
                    end

                end
            end
        end
    end
    return funvalstat, tracenormcovfunk, covfunk, nrbootsamples
end
