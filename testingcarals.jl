using DataFrames
using CSV
X = CSV.read("Fraction.X.csv", DataFrame)
X = Matrix(X[:,Not([:Time,:Column1])])
Q = CSV.read("Fraction.Q.csv", DataFrame)
Q = Matrix(Q[:,Not(:Column1)])
using Revise
using Carla
M1 = CPM(varianceprior=100/536, opts = EstimandOpts(initparamnoiseSD=0.0))
M1 = CPM()
data = convertX(X)
data = soa(data)
nritems, nrskills = size(Q)
θ = param_init(M1, nritems, nrskills)

maprisk(M1,data,Q, nothing, θ)[1]

θ.β.val .=  m2vecvec([
[1.30401202029109 0.595994429671492];
[1.19304578279430 0.440367283087172];
[1.40373705642572 0.573356504098453];
[1.05709396724257 0.870277153685331];
[1.15504578878948 0.482194193855840];
[1.14124928045292 0.430414751272413];
[0.975974339751254 1.10519993842366];
[1.53109951857747 0.661507031847650];
[0.948576328129589 0.426906393889039];
[1.16469317715371 0.758283212325727];
[0.933599115736951 0.134026568838985];
[0.910180541432252 0.666702166613161];
[1.27827072088658 0.690335883785648];
[1.17394306937086 0.636737819172388];
[1.10476939667619 0.772404322311384];
])

θ.δ0.val .= m2vecvec(
[-0.600000000000000;
-0.600000000000000;
-0.600000000000000;
-0.600000000000000;
-0.600000000000000])
a= param_init(M1,nritems,nrskills)
riskgrad = ∇risk(M1,data,Q,nothing,θ)
map = maprisk(M1,data,Q,Q,θ, e_strategy = Exact())
batchdecent(M1,data,Q,nothing,θ,m_strategy = GradientDescent(),
     e_strategy=Exact(), linesearch=BackTracking(), learning = Batch())

res = CARLA(M1, data,Q, learning = Batch(maxiteration=1000), m_strategy=LBFGS())

h = ∇²risk(M1,data,Q,Q,a, Exact())
∇²logpriors(M1, a, 1)
a = [1, 0, 0, 1, 1]

∇²riskαᵢ(M1,data[1], a, Q,Q, θ, 1)
z = ∇²opgrisk(M1,data,Q,Q,a,Exact())

##### Unit testing batch routine 
learning = Batch()
m_strategy = LBFGS()
e_strategy = Exact()
linesearch = BackTracking()
maxdiffx = learning.maxdiffx
    maxgradnorm = learning.maxgradnorm
    maxiterations = learning.maxiteration

    stepsize = linesearch.stepsize
     data = soa(data)
    nrtimepoints, nritems = size(data.itemResponse[1]')
    _, nrskills = size(Q)
    xtdims = compute_paramdims(M1, nritems, nrskills, nrtimepoints)

    # Run Batch Learning Descent Algorithm 

    dtlast = zeros(xtdims)
    gtlast = zeros(xtdims)
    laststepsize = 0
    θhist = []
    innercycleid = 0
    keepgoing = true
    iteration = 0


        iteration = iteration + 1

        gt = ∇risk(M1, data, Q, Q, θ, e_strategy = e_strategy)[1]

        dt, angulardeviation, innercycleid = autosearch(innercycleid,
            gt, gtlast, laststepsize,
            dtlast, m_strategy,learning)

        mapriskval, mlrisk, mapriskvec = maprisk(M1, data,
            Q, Q, θ,
            e_strategy = e_strategy)

        thestepsize , Vbest, stepsizecycles = autostep(
            M1, data, Q, Q, θ,
            dt, gt, mapriskval, e_strategy = e_strategy, linesearch = linesearch)
    
        lastθ = deepcopy(θ)
        updateθ!(M1, θ, thestepsize*dt, nritems, nrskills, nrtimepoints)
        boundboxed!(θ,M1.paramconstraints.min, M1.paramconstraints.max)
        dtlast = dt
        gtlast = gt 
        laststepsize = thestepsize


        absgradnorm = maximum(abs.(gt))
        gradnorm2large = absgradnorm > maxgradnorm
        absdiffx = absdiffθ(lastθ, θ, M1, nrtimepoints)
        change2large = absdiffx > maxdiffx
        toomanyiterations = iteration  >= maxiterations
        keepgoing = change2large & gradnorm2large & !toomanyiterations