using Pkg
Pkg.activate(".")
using LinearAlgebra
using Match
include(joinpath(pwd(), "src", "structs.jl"))
include(joinpath(pwd(), "src", "init.jl"))
include(joinpath(pwd(), "src", "datahandling.jl"))
include(joinpath(pwd(), "src", "data_integral.jl"))
include(joinpath(pwd(), "src", "probvals.jl"))
using CDMrdata
using DataFrames
using PrettyPrinting
using StatsFuns: logistic
# ============================ DATA LOADING =====================================
data = load_data("fraction1")
X = data["data"]
Q = data["q.matrix"]

X_df, Q_df = convert_CDMdat_to_CARLAdat(X, Q)

# =============================================================================
"""
    getgradientrisk(xdataset, params, data_params, modelcons, algcons, R)

Computes the expectation of the complete gradient of the empirical risk. 
"""
function getgradientrisk(xdataset, params, data_params, modelcons, algcons, R, Q)
    summandfunction_call = getgradientcompletealpha()
    missingdata_integral = algcons.missingdataintegral
    nrexamininees = data_params.nr_subjects
    for i = 1:nrexamininees
        thedata = xdataset[i] # Selecting the i_th student's response; Matrix of nr_items * nr_timepoints

        gradavg, opgmisserror, opgmisscovi, nriterations = expectation(
            summandfunction_call,
            thedata,
            params,
            data_params,
            modelcons,
            algcons,
            missingdata_integral,
            R,
            Q,
        )
    end
end

"""
    batchdescentalg(xdataset, params, data_params, modelcons, algcons, R)

Implements a batch gradient descent algorithm to provide MAP estimate of parameter vector thetavector = [params[:beta]; params[:delta]]
"""
function batchdescentalg(xdataset, params, data_params, modelcons, algcons, R, Q)
    thetavector, betavector, initialdeltavector, deltavector = unpackparams(params) # is this needed here ?

    iteration = 0
    while keepgoing
        iteration = iteration + 1

        gt, gmx, _, _, _ =
            getgradientrisk(xdataset, params, data_params, modelcons, algcons, R, Q)
    end
    return nothing, nothing
end



"""
    run_carla(X_df,Q_df)

- Do ?`modelcons_init` to learn more about configurable model constants.     
- Do ?`algocons_init` to learn more about configurable algorithm constants.
"""
function run_carla(
    X_df,
    Q_df;
    R = nothing,
    configurable_modelcons = modelcons_init(),
    algcons = algocons_init(),
)
    xdataset, Q_matrix, R_matrix, data_params, modelcons, params =
        extract(X_df, Q_df, R, configurable_modelcons)
    print_init(params, modelcons, algcons)

    # Run Parameter Estimation 
    params, convergeresults = batchdescentalg(
        xdataset,
        params,
        data_params,
        modelcons,
        algcons,
        R_matrix,
        Q_matrix,
    )
    params[:deltavec]
end
