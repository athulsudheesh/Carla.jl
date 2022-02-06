## Estimation ==================================
abstract type Estimation end

struct ImportanceSerial <: Estimation end
struct ImportanceParallel <: Estimation end
struct ExactmissingSerial <: Estimation end
struct ExactmissingParallel <: Estimation end

## Search Direction ============================

abstract type SearchDirection end

struct Gradient <: SearchDirection end
struct MomentumGrad <: SearchDirection end
struct Lbfgs <: SearchDirection end

## Learning =====================================
abstract type Learning end

### Adaptive Learning 
Base.@kwdef struct Adaptive <: Learning
    initial_stepsize::Float16
    max_iterations::Int16
    period::Int16
    search_halflife::Int16 = Int(max_iterations * 0.3)
    converge_halflife::Int16 = Int(max_iterations * 0.5)
end

### Batch Learning 
Base.@kwdef struct Batch <: Learning
    search_dir::SearchDirection
    max_search_dev::Float64
    levenmarq_eigval::Float64
    inner_cycles::Int16
    momentum_const::Int16
    search_direction_max_norm::Float16
    numerical_zero::Float64
    max_diffx::Float64
    max_grad_norm::Float64
    max_iter::Int16
    stepsize::Float16
    use_min_stepsize::Bool
    min_stepsize = stepsize / 1000
    max_stepsize_cycle::Int16
    wolfe_step_alpha::Float16
    wolfe_step_beta::Float16
    stepsize_rescale::Float16
end


# Response Functions ================================
abstract type ResponseFunction end

struct DINA <: ResponseFunction end
struct DINO <: ResponseFunction end
struct FUZZYDINA <: ResponseFunction end

# GDM Models ================================
Base.@kwdef struct GDM
    estimate_beta::Bool
    estimate_delta::Bool
    psi_func::ResponseFunction
    phi_func::ResponseFunction
    forceblockdiagonal::Bool
end


abstract type summandfunctioncall end

struct  getlikelhood_completealpha <: summandfunctioncall end
struct getgradient_completealpha <: summandfunctioncall end 
struct gethessian_completealpha <: summandfunctioncall end 
struct expected_alphamax <: summandfunctioncall end 