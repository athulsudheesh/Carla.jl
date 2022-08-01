# Installation

To install the package 
```julia
using Pkg; Pkg.add("https://github.com/athulsudheesh/Carla.jl")
```

# Getting Data 

In this example we'll use one of the data available through `CDMrdata` package

```@example 1
using CDMrdata 
using DataFrames
dat = load_data("ecpe")
Q = dat["q.matrix"]
X = dat["data"]
first(X,3) # hide
```

In the above item-response data, we can se that we have an unwanted column - `id`. Always make sure you delete these kind of redundant columns first before doing any sort of data preparation using the functions available in `Carla.jl` package.  

```@example 1
X = X[:,Not(:id)]
first(X, 3) # hide
```

### Note 
Also make sure you convert the item response matrix and Q-Matrix into Matrices. (i.e don't work with dataframes). When you load a dataset from `CDMrpackage` or your own data using `CSV.read(path,DataFrame)` function, the `X` and `Q` will be in dataframe format. This needs to be converted to matrices. 

```@example 1
X = Matrix(X)
Q = Matrix(Q)
nothing # hide
```

The item-response data needs to be converted into [`StudentResponse`](@ref) data type, to be compatible with `Carla.jl` routines. This is achieved by the `convertX()` function.

```@example 1
using Carla
X = convertX(X)
first(X,3) # hide
```

# Initializing a model 

To instantiate a Carla Probability Model with defaults, you can call the `CPM` constructor 

```@example 1
M1 = CPM()
```

## Configuring the Model 
The above function create a Carla probability model with DINA type emission and transition probability. By default, the model is only configured to estimate beta. If you want to estimate delta also, it can be configured using `EstimandOpts`

```@example 1
M1 = CPM(opts = EstimandOpts(estimatedelta=true))
```

Suppose you are interested in a different emission response type (say DINO), in that case you initialize the model as follows: 

```@example 1
M1 = CPM(emissionprob=DINO(), opts = EstimandOpts(estimatedelta=true))
```

All configurable options available while initializing a model can be found in the documnetation for [`CPM`](@ref) and [`EstimandOpts`](@ref).

# Estimation 

The estimation process is initiated by the [`CARLA`](@ref) function. To initiate the estimation using the default configuration, you call the CARLA function with the `data` and `Q`:

```julia
results = CARLA(M1,data, Q)
```

By default, CARLA uses `GradientDescent` and `Exact` method. To change it to `LBFGS`

```julia
results = CARLA(M1,data,Q, m_strategy = LBFGS())
```

list of configurable options are available in the documentation for [`CARLA`](@ref) function.