@testset "Testing CPM Constructors" begin
    M1 = CPM()
    M2 = CPM(
        emissionprob=DINA(),
        transitionprob=DINA(),
        initialwvec = [1.2, 0.6],
        varianceprior = 100/536,
        opts = EstimandOpts())

    @test M1.emissionprob == M2.emissionprob
    @test M1.transitionprob == M2.transitionprob
    @test M1.initialwvec == M2.initialwvec
    @test M1.opts. initparamnoiseSD == M2.opts. initparamnoiseSD
    @test M1.varianceprior == M2.varianceprior
    @test M1.opts.estimatebeta == M2.opts.estimatebeta 
    @test M1.opts.estimatedelta == M2.opts.estimatedelta
end

