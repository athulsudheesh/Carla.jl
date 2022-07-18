@testset "Testing Parameter Data Types" verbose=true begin 
    @testset "Gaussian Prior" begin
        a = GaussianPrior(0.5,0.1,0.8)
        @test a.mean == 0.5
        @test a.sd == 0.1
        @test a.varianceprior == 0.8
        @test a.covmx[1,1] == 1.25

        b = GaussianPrior([0.5,0.6],0.1,0.8)
        @test b.mean == [0.5, 0.6]
        @test b.sd == 0.1
        @test b.varianceprior == 0.8
        @test b.covmx == [1.25 0.0; 0.0 1.25]
    end

    @testset "params" begin
        M1 = CPM()
        c = params(GaussianPrior(M1.initialwvec, 
        M1.initparamstd, M1.varianceprior))
       
        @test c.prior.mean == [1.2, 0.6]
        @test c.prior.sd == 0.2
        @test c.prior.varianceprior == 0.1865671641791045
    end
end