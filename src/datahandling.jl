"""
    extractX(X::DataFrame)

# Output
Returns xdataset, subject names, and item names. 
- xdataset is an Vector of Matrix with length = `nr_timepoints`
- xdataset[i] = Matrix of size `nr_subjects`, `nr_items`
"""
function extractX(X_df)
    @assert typeof(X_df) == DataFrame "Expected X to be of type DataFrame"
    subject_names = X_df[!, 1]
    nr_timepoints = length(unique(X_df[!, 2]))
    X_df = X_df[!, Not([1])] # Removing Subject Names 
    
    item_names = names(X_df[!,Not(:time)])

    X = Array{Matrix}(undef, nr_timepoints)
    for i in 1:nr_timepoints
        X[i] = Matrix(X_df[X_df[!, :time] .==i, Not(:time)])
    end
    X
    return X, subject_names, item_names, nr_timepoints
end

"""
extractQ(Q::DataFrame)

Returns Q_matrix, skill names, and item names 
"""
function extractQ(Q_df)
    @assert typeof(Q_df) == DataFrame "Expected Q to be of type DataFrame"
    item_names = Q_df[!, 1]
    Q = Q_df[!, Not(1)]
    Q_matrix = Matrix(Q)
    skill_names = names(Q)
    return Q_matrix, skill_names, item_names
end

"""
convert_CDMdat_to_CARLAdat(X_df,Q)

Converts the data from CDM R Package to a format compatible with CARLA. 
Returns the new X and Q Matrix as DataFrame. 
"""
function convert_CDMdat_to_CARLAdat(X_df, Q)
    X = deepcopy(X_df) # To avoid mutating the original X matrix from CDM package 
    subj_names = string.("S", 1:size(X)[1])
    item_names = names(X)
    alpha_names = string.("A", 1:size(Q)[2])

    insertcols!(X, 1, :subject => subj_names)
    insertcols!(X, 2, :time => fill(1, size(X)[1]))

    Q = DataFrame(Q, :auto)

    rename!(Q, alpha_names)
    insertcols!(Q, 1, :item_names => item_names)

    return X, Q
end


function extractR(R, nr_skills, nr_timepoints)
    if nr_timepoints > 1
        if nr_skills != size(R)[1] != size(R)[2]
            println("R and Q not matching")
            exit()
        else
            R = Matirx(R)
        end
    else
        R = nothing
    end
end

"""
    extract(X_df, Q_df, R, configurable_modelcons) 

Given X, Q and R in a Carla compatible data format, returns the X,Q,R matrices and other data-specific constants (like skill names, no of skills, subject names etc.).

Note: If you are loading a dataset from CDMrdata, use [`convert_CDMdat_to_CARLAdat`](@ref) to convert the data into Carla compatible format.

# Usage
```jldoctest
julia>  X_matrix, Q_matrix, R_matrix, data_params = extract(X_df, Q_df, R)
```
"""
function extract(X_df, Q_df, R, configurable_modelcons)
    X_matrix, subject_names, item_names, nr_timepoints = extractX(X_df)
    Q_matrix, skill_names, item_namesQ = extractQ(Q_df)
    nr_items = length(item_names)
    nr_itemsQ, nr_skills = size(Q_matrix)
    R_matrix = extractR(R, nr_skills, nr_timepoints)

    # Checking agreement between X and Q 
    @assert nr_items == nr_itemsQ "X and Q Matrix doesn't match"
    if item_names != item_namesQ
        @info "Item names in X not matching with item names in Q"
    end
    # Routines in updatepriors.m ===================================================================
    prior_α = zeros(nr_skills)
    wt_vec = configurable_modelcons.initialweightvector
    variance_prior = configurable_modelcons.varianceprior
    std = configurable_modelcons.initparamstd
    initial_wt_prior = ((wt_vec[1] - wt_vec[2]) .* prior_α) .- ((1 .- prior_α) .* wt_vec[2])
    initial_delta_means = initial_wt_prior
    initial_delta_invcov = 1 / variance_prior

    beta_means = fill(wt_vec, nr_items)
    beta_invcov = Matrix(I(2)) / variance_prior

    delta_means = fill(wt_vec, nr_skills)
    delta_invcov = Matrix(I(2)) / variance_prior

    # =============================================================================================
    # Routines in initializeparams.m ===================================================================
    betavec = beta_means + fill(rand(2, 1) * std, nr_items)
    initial_deltavec = initial_delta_means .+ fill(rand() * std, nr_skills)
    delta_vec = delta_means + fill(rand(2, 1) * std, nr_skills)
    # =============================================================================================
    if nr_timepoints > 1
        time = true
    else
        time = false
    end

    data_params = (
        subject_names = subject_names,
        item_names = item_names,
        nr_timepoints = nr_timepoints,
        skill_names = skill_names,
        nr_skills = nr_skills,
        nr_items = nr_items,
    )

    modelcons = (
        psifunctiontype = configurable_modelcons.psifunctiontype,
        phifunctiontype = configurable_modelcons.phifunctiontype,
        forceblockdiagonal = configurable_modelcons.forceblockdiagonal,
        initparamstd = configurable_modelcons.initparamstd,
        varianceprior = configurable_modelcons.varianceprior,
        initialweightvector = configurable_modelcons.initialweightvector,
        prioralphavector = prior_α,
        PRIORSbetameans = beta_means,
        PRIORSbetainvcovs = beta_invcov,
        PRIORSinitialdeltameans = initial_delta_means,
        PRIORSinitialdeltaincovs = initial_delta_invcov,
        PRIORSdeltameans = delta_means,
        PRIROSdeltaincovs = delta_invcov,
    )

    params = Dict(
        :estimatebeta => configurable_modelcons.estimatebeta,
        :estimatedelta => configurable_modelcons.estimatedelta,
        :betavec => betavec,
        :initialdeltavec => initial_deltavec,
        :deltavec => delta_vec,
        :time => time
    )
   
    return X_matrix, Q_matrix, R_matrix, data_params, modelcons, params
end


"""
    unpackparams(params)

This function unpacks the params structure and returns the beta and delta parameter vectors as well as the concatenation which is theta. 

# Argument
params: A dictionary with the following fields:
- estimatebeta: Boolean 
- estimatedelta: Boolean 
- betavec: vector of length nr_items 
- deltavec:
- initialdeltavec

# Returns

- thetavector: [betavec; delta_vec]
- betavec
- initialdeltavec
- deltavec
"""
function unpackparams(params)
    if params[:estimatebeta]
        thetavector = params[:betavec]
    end 

    if params[:estimatedelta]
        thetavector = [thetavector; params[:initialdeltavec]]
    
        if params[:time] # if nr_timepoints > 1 
            thetavector = [thetavector; params[:deltavec]] # Not sure about this 
        end
    end
    return thetavector, params[:betavec], params[:initialdeltavec], params[:deltavec]
end 