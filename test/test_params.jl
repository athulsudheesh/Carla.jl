@testset "Testing Parameter Data Types" verbose=true begin 
    @testset "Gaussian Prior" begin
        a = GaussianParameterInit(0.5,0.1,0.8)
        @test a.mean == 0.5
        @test a.noiseSD == 0.8
        @test a.varianceprior == 0.1
        @test a.invcovmx[1,1] == 10
    end

    @testset "params" begin
        M1 = CPM()
        c = params(GaussianParameterInit(M1.initialwvec,M1.varianceprior))
        @test c.prior.mean == [1.2, 0.6]
        @test c.prior.varianceprior == 0.1865671641791045
    end

end