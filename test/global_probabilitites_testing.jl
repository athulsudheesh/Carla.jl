# These tests don't check for the correctness! 
# The goal of this test file is to make sure API's are not breaking 
# during the development stage.   

using Carla

temperature = 1.0
J = 3; K = 2; T = 2;
αMatrix = rand([0,1],K,T)
QMatrix = rand([0,1],J,K)

M1 = CPM(transitionprob = DINO(),opts=EstimandOpts(estimatedelta=true))

βprior = params(GaussianParameterInit(M1.initialwvec, M1.varianceprior))
β = [βprior for i in 1:J]
β = soa(β)

δprior = params(GaussianParameterInit(M1.initialwvec,M1.varianceprior))
δ = [δprior for i in 1:K]

priorα = 0
δ0prior =  initialdelta_init(M1.initialwvec, M1.varianceprior, priorα)
δ0 = [params(δ0prior) for i in 1:K]
δ0 = soa(δ0)
δ = soa(δ)

data = StudentResponse(rand([1,0],J,T),ones(J,T))

global_emission(M1.emissionprob, data,QMatrix,αMatrix,β.val)

# Testing local transition 
a = zeros(K,T)
for t = 1:T
    for j = 1:K
        a[j,t] = local_transition(M1.transitionprob, QMatrix,j,t,αMatrix, flat(δ0.val), δ.val[t], temperature)
    end
end

# Testing global emission
global_transition(
    M1.transitionprob, QMatrix, αMatrix, δ0.val, δ.val, temperature)

θ = (β = β.val, δ0 = δ0.val, δ = δ.val)

# Testing likelihoodcompletealpha 
likelihoodcompletealpha(M1, data, QMatrix, QMatrix, αMatrix, θ, temperature)

Δriskαᵢ(M1,data,αMatrix, QMatrix, QMatrix, θ, temperature)

data = [StudentResponse(rand([1,0],J,T),ones(J,T)) for i in 1:4]
maprisk(M1,data, QMatrix, QMatrix, θ)