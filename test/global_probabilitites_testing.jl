using Carla

temperature = 1.0
J = 3; K = 2; T = 2;
αMatrix = [1 1; 0 0]
QMatrix = [1 0; 1 1; 0 1]

M1 = CPM()

βprior = params(GaussianParameterInit(M1.initialwvec, M1.varianceprior))
β = [βprior for i in 1:J]
β = soa(β)

δprior = params(GaussianParameterInit(M1.initialwvec,M1.varianceprior))
δ = [δprior for i in 1:K]

priorα = 0
δ0prior =  initialdelta_init(M1.initialwvec, M1.varianceprior, priorα)
δ0 = params(δ0prior)

δ = soa(δ)

data = StudentResponse(rand([1,0],2,2),ones(2,2))

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

