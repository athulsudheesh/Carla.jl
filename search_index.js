var documenterSearchIndex = {"docs":
[{"location":"lib/functions/","page":"Functions","title":"Functions","text":"Modules = [Carla]\nPages   = [\"functions/latent_responsevecs.jl\"]","category":"page"},{"location":"lib/functions/#Carla.emission_responsevec-Tuple{ResponseFunction, Any, Any, Any, Any}","page":"Functions","title":"Carla.emission_responsevec","text":"emission_responsevec(\n    EmissionType::ResponseFunction, QMatrix::Matrix,\n    itemID::Integer, t::Integer, αMatrix::Matrix\n)\n\nComputes the local emission response vectors psi_jt (alpha) \n\nArguments\n\nEmissionType: Emission Response Type (DINA(),DINO(), or FUZZYDINA())\nQMatrix: J (No. of Items) × K (No. of Skills) Matirx\nitemID:  Integer denoting the jth item \nt: time index\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\n\nOutput:\n\nA 2-element Vector{Float64} (Probability Vectors)\n\nNote: This is equivalent to the psiemission function in MATLAB Carla\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.transition_responsevec-Tuple{ResponseFunction, Any, Any, Any, Any}","page":"Functions","title":"Carla.transition_responsevec","text":"transition_responsevec(\n    EmissionType::ResponseFunction, RMatrix::Matrix,\n    skillID::Integer, t::Integer, αMatrix::Matrix\n)\n\nComputes the local transition response vectors phi_kt (alpha)\n\nArguments\n\nEmissionType: Emission Response Type (DINA(),DINO(), or FUZZYDINA())\nRMatrix: K (No. of Skills) × K (No. of Skills) Matirx\nskillID:  Integer denoting the jth skill\nt: time index\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\n\nOutput:\n\nA 2-element Vector{Float64} (Probability Vectors)\n\nNote: This is equivalent to the phitransition function in MATLAB Carla\n\n\n\n\n\n","category":"method"},{"location":"lib/types/","page":"Data Structures","title":"Data Structures","text":"Modules = [Carla]\nPages   = [\"datastructs/probmodels.jl\",\n            \"datastructs/latentresponses.jl\"]","category":"page"},{"location":"lib/types/#Carla.CPM","page":"Data Structures","title":"Carla.CPM","text":"CPM is the data structure for Carla Probability Model.\n\nKeword Arguments\n\nemissionprob – Emission Probability function, type of ResponseFunction \ntransitionprob – Transition Probability function, type of ResponseFunction\ninitialvwec – Initial Weight Vector, Vector of Float64\nvarianceprior – Variance Prior, a Float64\ninitparamstd – Initial Parameter S.D., a Float64\nestimatebeta – Estimate Beta Parameters?, Bool type\nestimatedelta – Estimate Delta Parameters?, Bool type\n\nNotes\n\nAll the fields can be assigned using the appropriate keywords. The initialization constructor CPM(), uses the values in the example, as default for the fields in CPM. \n\nExample\n\nM1 = CPM(   emissionprob=DINA(),   transitionprob=DINA(),   initialwvec = [1.2, 0.6],   varianceprior = 100/536,   initparamstd = 0.2,   estimatebeta = true,   estimatedelta = false)\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.DINA","page":"Data Structures","title":"Carla.DINA","text":"DINA <: ResponseFunction\n\nDINA Response Function\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.DINO","page":"Data Structures","title":"Carla.DINO","text":"DINO <: ResponseFunction\n\nDINO Response Function\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.FUZZYDINA","page":"Data Structures","title":"Carla.FUZZYDINA","text":"FUZZYDINA <: ResponseFunction\n\nFUZZYDINA Response Function\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.ResponseFunction","page":"Data Structures","title":"Carla.ResponseFunction","text":"ResponseFunction\n\nAbstract type for response functions\n\n\n\n\n\n","category":"type"},{"location":"#Carla.jl","page":"Introduction","title":"Carla.jl","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Welcome to Carla.jl documentation.","category":"page"}]
}
