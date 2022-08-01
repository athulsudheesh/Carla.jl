# These tests don't check for the correctness! 
# The goal of this test file is to make sure API's are not breaking 
# during the development stage.   

using Carla

temperature = 1.0
J = 3; K = 2; T = 1;
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

∇riskαᵢ(M1,data,αMatrix, QMatrix, QMatrix, θ, temperature)
θ1 = (β = β, δ0 = δ0, δ = δ)
data = [StudentResponse(rand([1,0],J,T),ones(J,T)) for i in 1:4]
maprisk(M1,data, QMatrix, QMatrix, θ1)
∇risk(M1,data, QMatrix,QMatrix,θ1)


#innercycle = 1 
#gt = rand(12); gtlast = rand(12); stepsize = 0.5; dtlast = rand(12)

#autosearch(0, gt, gtlast,stepsize, dtlast, optim = LBFGS(), learning = Batch())

#dt = rand(12)
#Vt = -100.0

#autostep(M1,data,QMatrix, QMatrix, θ1, dt,-gt,Vt, e_strategy=Exact(), linesearch = LineSearch())

#batchdecent(M1, soa(data), QMatrix, nothing, θ1, 
 #   e_strategy = Exact(), 
 #   linesearch = BackTracking(), learning = Batch(), m_strategy = GradientDescent())
using CDMrdata
    M1 = CPM(varianceprior=900/2922)
    using DataFrames
    dat = load_data("ecpe")
    X = dat["data"][:,Not(:id)][1:1,1:1]
    QMatrix = Matrix(dat["q.matrix"])[1:1,1:2]
    
    data = convertX(X)
  a = CARLA(M1,data, QMatrix, linesearch=BackTracking(stepsize=0.01))
