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
struct Adaptive <: Learning end

### Batch Learning 
struct Batch <: Learning end


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

struct getlikelhoodcompletealpha <: summandfunctioncall end
struct getgradientcompletealpha <: summandfunctioncall end
struct gethessiancompletealpha <: summandfunctioncall end
struct expectedalphamax <: summandfunctioncall end
