@testset "Testing Probability Functions" begin
    # J = 3, K = 2, T = 2
    αMatirx = [1 1; 0 1]
    QMatrix = [1 0; 1 1; 0 1]
    
    # Testsets for local_emission_pmf
    let t = 1, j = 1
       @test local_emission_pmf(DINA(), QMatrix,j,t,αMatirx) == [1;-1]
    end

    let t = 1, j = 3
        @test local_emission_pmf(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
     end

    let t = 1, j = 2
        @test local_emission_pmf(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
    end
end