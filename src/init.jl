# This file contains the functions for initializing parameters 

function algo_params_init()
    maxnr_samples = 50
    return (
        pval = 0.05,
        missingdataintegral = ExactmissingSerial(), # exactmissing_serial is a subtype of estimation (Ref. src/init.jl)
        OMCmaxnr_samples = maxnr_samples, # Maximum no. of Monte Carlo samples to be generated 
        OMCtemperature = 0.25, # Sampling temperature for importance sampling (+ve number)
        # OMCtemp = 1 (regular); temp = 0.0001 (high probability states); temp = 5 (low probability states)
        # temp = 100000000 (almost true random sampling)
        OMCsamplingerror = 0.01,
        OMCinfsamplemultiply = 10, # Multiplier for increasing number of monte carlo samples for inference purposes.
        OMCburninperiod = Int(maxnr_samples / 2),
        COVARIANCEnumericalzero = 1e-6, # Force sinular values whose magnitude is smaller than this to 0 for PINV calculations 
        COVARIANCEmulticollinearity = 1e+12, # Condition number larger than this indicate multicollinearity 

        # refer src/structs.jl to know more about the implementation of Batch
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
        ),
    )
end




function model_init()
    return GDM(
        estimate_beta = true,
        estimate_delta = false,
        psi_func = DINA(),
        phi_func = DINA(),
        forceblockdiagonal = false,
    )
end

function model_params_init(nr_skills, nr_items, nr_timepoints; weight_vec = [0,0])
    std = 0.0
    prior_alpha = zeros(nr_skills)
    variance_prior = 400/536
    prior_weight = ((weight_vec[1] - weight_vec[2]) .* prior_alpha) .- ((1 .- prior_alpha) .* weight_vec[2])
    
    beta_means = fill(weight_vec, nr_items)
    beta_invcov = Matrix(I(2)) / variance_prior

    initial_delta_means = prior_weight
    initial_delta_invcov = 1 / variance_prior

    delta_means = fill(weight_vec, nr_skills)
    delta_invcov = Matrix(I(2)) / variance_prior

    betavec = beta_means + fill(rand(2,1) * std,nr_items)
    initial_deltavec = initial_delta_means .+ fill(rand()*std, nr_skills)
    delta_vec = delta_means + fill(rand(2,1)*std, nr_skills)

     # returning values as tuples 
     return (
         std = std,
         prior_alpha = prior_alpha,
         variance_prior = variance_prior,
         prior_weight = prior_weight,
         beta_means = beta_means,
         beta_invcov = beta_invcov,
         initial_delta_means =initial_delta_means,
         initial_delta_invcov = initial_delta_invcov,
         delta_means =  delta_means,
         delta_invcov = delta_invcov,
         betavec = betavec,
         initial_deltavec = initial_deltavec,
        delta_vec = delta_vec
     )
end 

function init_theta(estimatedelta::Bool, estimatebeta::Bool, nr_timepoints, beta_vec, initial_delta_vec, delta_vec)
    if estimatebeta
        thetavector = beta_vec
    end

    if estimatedelta
        thetavector = [thetavector; initial_delta_vec]

        if nr_timepoints > 1 
            thetavector = [thetavector; delta_vec] # I have some doubts here regarding the size of thetavector - is it going have be nr_times + 1 terms?
        end
    end
    return thetavector
end 