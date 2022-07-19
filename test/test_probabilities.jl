@testset "Testing Probability Functions" begin
    J = 3; K = 2; T = 2
    αMatirx = [1 1; 1 0]
    QMatrix = [1 0; 1 1; 0 1]
    M1 = CPM(opts = EstimandOpts(initparamnoiseSD=0.0))
    betas = [params(GaussianParameterInit(M1.initialwvec,
                                       M1.varianceprior)) for i in 1:J]
    betas = soa(betas)
    
    deltas = [params(GaussianParameterInit(M1.initialwvec,
                                        M1.varianceprior)) for i in 1:K]
    deltas = soa(deltas)
    temperature = 1.0
    
    # Initializing δ(0)
    prioralpha = 0
    delta1prior = initialdelta_init(M1.initialwvec, M1.varianceprior,prioralpha)
    delta1s = [params(delta1prior) for i in 1:K]
    delta1s = soa(delta1s)
    
    # Testsets for emission_responsevec & transition_responsevec
    let t = 2, j = 1, k = 1
       @test emission_responsevec(DINA(), QMatrix,j,t,αMatirx) == [1;-1]
       @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == [1;-1]

      # Test for emission probability
      emission_prob = local_emission(DINA(),QMatrix,j,t,αMatirx, betas.val[j])
      @test isapprox(emission_prob,0.6494881694864728,rtol=0.1)

      transition_prob = local_transition(DINA(),QMatrix,k,t,αMatirx,deltas.val[k], temperature)
      @test isapprox(transition_prob,0.6311626022341116,rtol=0.1)
    end

    let t = 2, j = 3
        @test emission_responsevec(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
        @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == [1;-1]
        
        # Test for emission probability
        emission_prob = local_emission(DINA(),QMatrix,j,t,αMatirx, betas.val[j])
       @test isapprox(emission_prob,0.342092242335137,rtol=0.1)
     end

    let t = 2, j = 2
        @test emission_responsevec(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
        @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == [1;-1]
    end

    let t = 1, j = 2, k = 1
        @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == -1 
        transition_prob = local_transition(DINA(),QMatrix,k,t,αMatirx,flat(delta1s.val)[k], temperature)
        @test isapprox(transition_prob, 0.6133653786749024,rtol=0.1)
    end
end