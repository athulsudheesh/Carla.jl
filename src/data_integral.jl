
# Defined for ImportanceSerial with summandfunctioncall as getgradientcompletealpha
"""
    expectation(summandfunction_call, thedata, params, data_params, modelcons, algcons, algcons.missingdataintegral::ImportanceSerial)
"""
function expectation(summandfunction_call::getgradientcompletealpha, thedata, params, data_params, modelcons, algcons, missingdata_integral::ImportanceSerial)
    quitsampling = false 

    parforloopmax = algcons.OMCparforloopmax
    thetavectorinitial = unpackparams(params)[1]
    hessdim = length(thetavectorinitial)
    while !quitsampling
        funkvallist = zeros(hessdim, parforloopmax)
        wtfactorlist = zeros(algcons,parforloopmax)

        for parforindex = 1:parforloopmax
            
            # Generate a sample profile trajectory
        end 
    end 
    return funvalstat, tracenormcovfunk, covfunk, nrbootsamples 
end