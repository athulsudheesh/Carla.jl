
# Membership Value function based on the phifunctiontype ========================
function membershipval(phi::DINA, selectedalphas, selectedalphdim)
    prod(selectedalphas)
end

function membershipval(phi::DINO, selectedalphas, selectedalphdim)
    1 - prod(1 .- selectedalphas)
end

function membershipval(phi::FUZZYDINA, selectedalphas, selectedalphdim)
    sum(selectedalphas) / selectedalphdim
end
# ==============================================================================


"""
    phitransition(skillid, t, alphamx, modelcons, R)

This function implements the Boolean function associated with the transition probability model structure. 

# Usage
```jldoctest
julia> phivector = phitransition(skillid, t, alphamx, modelcons, R)
```

## Inputs
- skillid: Integer; index of latent skill 
- t: Integer; time index 
- alphamx: Matrix; Number of Skills by Number of Time Points 
- modelcons: Model Constants 
- R matrix 

## Output
- phivector: Membership function output vector 
"""
function phitransition(skillid, t, alphamx, modelcons, R)
    phifunctiontype = modelcons.phifunctiontype
    phivector = -1

    if t > 1
        rrow = R[skillid, :]
        membershipfunctionvalue = 0
        if !isempty(rrow)
            alphavector = alphamx[:, t-1]
            selectedalphas = alphavector[rrow]
            selectedalphdim = length(selectedalphas)

            if !isempty(selectedalphas)
                membershipfunctionvalue =
                    membershipval(phifunctiontype, selectedalphas, selectedalphdim)
            end
        end
    end
    phivector = [membershipfunctionvalue; -1]
end

"""
    psiemission(itemid, t, alphamx, modelcons, Q)
"""
function psiemission(itemid, t, alphamx, modelcons,Q)

end

"""
    getransitionprobval(temperature, skillid, t, alphamx, params, modelcons,R)

This function computes the probability that an examinee with attribute profile with binary vector "alphavector"
    at time t-1 will master latent skill k at time t. 
# Usage
```jldoctest
julia> transitionprobval = getransitionprobval(temperature, skillid, t, alphamx, params, modelcons,R)
```

## Inputs
- temperature: strictly positive number 
- skillid 
- t: time index
- alphamx: latent attribute trajectory (K X T) 
- params 
- modelcons 
- R Matrix

"""
function getransitionprobval(temperature, skillid, t, alphamx, params, modelcons, R)

    if t == 1
        deltavectorT = params[:initialdeltavec][skillid]
    else
        deltavectorT = Matrix(params[:deltavec][skillid]')
    end

    phivector = phitransition(skillid, t, alphamx, modelcons, R)
    netinput = deltavectorT * phivector
    transitionprobval = logistic.(netinput / temperature)
    return transitionprobval
end
