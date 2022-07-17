@testset "Testing Probability Functions" begin
    # J = 3, K = 2, T = 2
    αMatirx = [1 1; 0 1]
    QMatrix = [1 0; 1 1; 0 1]
    
    # Testsets for emission_responsevec & transition_responsevec
    let t = 1, j = 1
       @test emission_responsevec(DINA(), QMatrix,j,t,αMatirx) == [1;-1]
       @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == [1;-1]
    end

    let t = 1, j = 3
        @test emission_responsevec(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
        @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
     end

    let t = 1, j = 2
        @test emission_responsevec(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
        @test transition_responsevec(DINA(), QMatrix,j,t,αMatirx) == [0;-1]
    end
end