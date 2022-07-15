@testset "Testing Data Structures" begin
   @testset "Testing CPM Constructor" begin 
    M1 = CPM();
    M2 = CPM(
        emissionprob=DINA(),
        transitionprob=DINA(),
        initialwvec = [1.2, 0.6],
        initparamstd = 0.2,
        varianceprior = 100/536,
        estimatebeta = true,
        estimatedelta = false);

        @test M1.emissionprob == M2.emissionprob
        @test M1.transitionprob == M2.transitionprob
        @test M1.initialwvec == M2.initialwvec
        @test M1.initparamstd == M2.initparamstd
        @test M1.varianceprior == M2.varianceprior
        @test M1.estimatebeta == M2.estimatebeta 
        @test M1.estimatedelta == M2.estimatedelta
    end
end

