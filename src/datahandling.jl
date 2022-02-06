"""
extractX(X::DataFrame)

Returns X_matrix, subject names, and item names. 
"""
function extractX(X_df)
    @assert typeof(X_df) == DataFrame "Expected X to be of type DataFrame"
    subject_names = X_df[!, 1]
    nr_timepoints = length(unique(X_df[!, 2]))
    X = X_df[!, Not([1, 2])]
    X_matrix = Matrix(X)
    item_names = names(X)
    return X_matrix, subject_names, item_names, nr_timepoints
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
