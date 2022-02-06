using LinearAlgebra
using Match
include(joinpath(pwd(), "src", "structs.jl"))
include(joinpath(pwd(), "src", "init.jl"))
include(joinpath(pwd(), "src", "datahandling.jl"))
include(joinpath(pwd(), "src", "data_integral.jl"))
using CDMrdata
using DataFrames

# ============================ DATA LOADING =====================================
data = load_data("fraction1")
X = data["data"]
Q = data["q.matrix"]

X_df, Q_df = convert_CDMdat_to_CARLAdat(X, Q)

# =============================================================================


function get_gradientrisk(algo_params)
    
    grad_avg, opg_miss_error, opg_miss_covi = e_step(algo_params.missingdataintegral)
end

function batch_descent(algo_params)
    keep_going = true
    while keep_going 
        for iteration = 1:algo_params.max_iter
            get_gradientrisk(algo_params)
        end
    end
end
# =============================================================================

"""
Arguments: X Matrix and Q Matrix in DataFrame format 
Optional Keyword Argument: 
- `algo_params` (Algorithm parameters) : Following are the fields for algo_params and deafult values \n
        pval = 0.05,
        missingdataintegral = ExactmissingSerial(), # exactmissing_serial is a subtype of estimation (Ref. src/init.jl)
        OMCmaxnr_samples = maxnr_samples, # Maximum no. of Monte Carlo samples to be generated 
        OMCtemperature = 0.25, # Sampling temperature for importance sampling (+ve number)
        OMCtemp = 1 (regular); temp = 0.0001 (high probability states); temp = 5 (low probability states)
        OMCsamplingerror = 0.01,
        OMCinfsamplemultiply = 10, # Multiplier for increasing number of monte carlo samples for inference purposes.
        OMCburninperiod = Int(maxnr_samples / 2),
        COVARIANCEnumericalzero = 1e-6, # Force sinular values whose magnitude is smaller than this to 0 for PINV calculations 
        COVARIANCEmulticollinearity 1e+12, # Condition number larger than this indicate multicollinearity 

        learning = Batch(
            search_dir = Lbfgs(),
            max_search_dev = 1e-4,
            levenmarq_eigval = 1e-4,
            inner_cycles = 10,
            momentum_const = 1,
            search_direction_max_norm = 1.0,
            numerical_zero = 1e-8,
            max_diffx = 1e-8,
            max_grad_norm = 0.00001,
            max_iter = 100,
            stepsize = 1.0,
            use_min_stepsize = false,
            max_stepsize_cycle = 3,
            wolfe_step_alpha = 0.01,
            wolfe_step_beta = 0.9,
            stepsize_rescale = 0.7,
        )
"""
function run_carla(X_df, Q_df; algo_params = algo_params_init(), R = nothing, model = model_init(), model_params = nothing)
    X_matrix, subject_names, item_names, nr_timepoints = extractX(X_df)
    Q_matrix, skill_names, item_namesQ = extractQ(Q_df)
    nr_items = length(item_names)
    nr_itemsQ, nr_skills = size(Q_matrix)
    R_matrix = extractR(R, nr_skills, nr_timepoints)

    if model_params == nothing 
        model_params = model_params_init(nr_skills, nr_items, nr_timepoints)
    end
    thetavec = init_theta(model.estimate_delta, model.estimate_beta, nr_timepoints,
                         model_params.betavec, model_params.initial_deltavec, model_params.delta_vec)

    # Checking agreement between X and Q 
    @assert nr_items == nr_itemsQ "X and Q Matrix doesn't match"
    if item_names != item_namesQ
        @info "Item names in X not matching with item names in Q"
    end
     batch_descent(algo_params)
end
