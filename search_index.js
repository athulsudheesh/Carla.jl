var documenterSearchIndex = {"docs":
[{"location":"lib/functions/","page":"Functions","title":"Functions","text":"Modules = [Carla]\nPages   = [\"functions/latent_responsevecs.jl\",\n            \"functions/local_probabilities.jl\",\n            \"functions/global_probabilities.jl\",\n            \"functions/likelihoods.jl\",\n            \"functions/gradients_risk.jl\",\n            \"functions/empirical_risk.jl\",\n            \"functions/search_algos.jl\"]","category":"page"},{"location":"lib/functions/#Carla.emission_responsevec-Tuple{Carla.ResponseFunction, Any, Any, Any, Any}","page":"Functions","title":"Carla.emission_responsevec","text":"emission_responsevec(\n    EmissionType::ResponseFunction, QMatrix::Matrix,\n    itemID::Integer, t::Integer, αMatrix::Matrix\n)\n\nComputes the local emission response vectors psi_jt (alpha) \n\npsi_jt (alpha) =\nbegincases\n1 Pi_k in S_jt alpha_k  text  if DINA-type emission \n1 1 - Pi_k in S_jt (1 - alpha_k)  text  if DINO-type emission \n1 fracSigma_k in S_jt alpha_kK  text  if FUZZYDINA-type emission\nendcases\n\nArguments\n\nEmissionType: Emission Response Type (DINA(),DINO(), or FUZZYDINA())\nQMatrix: J (No. of Items) × K (No. of Skills) Matirx\nitemID:  Integer denoting the jth item \nt: time index\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\n\nOutput:\n\nA 2-element Vector{Float64}\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.transition_responsevec-Tuple{Carla.ResponseFunction, Any, Any, Any, Any}","page":"Functions","title":"Carla.transition_responsevec","text":"transition_responsevec(\n    TransitionType::ResponseFunction, RMatrix::Matrix,\n    skillID::Integer, t::Integer, αMatrix::Matrix\n)\n\nComputes the local transition response vectors phi_kt (alpha)\n\nWhen t = 1\n\nphi_kt (alpha) = -1\n\nelse\n\nphi_kt (alpha) =\nbegincases\n1 Pi_k in S_kt alpha_k  text  if DINA-type transition \n1 1 - Pi_k in S_kt (1 - alpha_k)  text  if DINO-type transition \n1 fracSigma_k in S_kt alpha_kK  text  if FUZZYDINA-type transition\nendcases\n\nArguments\n\nTransitionType: DINA(),DINO(), or FUZZYDINA()\nRMatrix: K (No. of Skills) × K (No. of Skills) Matirx\nskillID:  Integer denoting the jth skill\nt: time index\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\n\nOutput:\n\nA 2-element Vector{Float64}\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.local_emission-Tuple{Carla.ResponseFunction, Any, Any, Any, Any, Any}","page":"Functions","title":"Carla.local_emission","text":"local_emission(\n    EmissionType::ResponseFunction, QMatrix,\n    itemID, t, αMatrix, betavector\n    )\n\nComputes the probability that an examinee with the given skill profile (αMatrix) will correctly answer the item - itemID, at given time t. This is also known as the complete-data local emission conditional probability P_beta_j^alpha (t)\n\nP_beta_j^alpha (t) = rho (beta_j(t)^T psi_jt (alpha(t)))\n\nwhere rho is a logistic sigmoidal function. rho(x) = frac11 + e^-x\n\nArguments\n\nEmissionType: Emission Response Type (DINA(),DINO(), or FUZZYDINA())\nQMatrix: J (No. of Items) × K (No. of Skills) Matirx\nitemID:  Integer denoting the jth item \nt: time index\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\nbetavector - β values for the given item\n\nOutput:\n\nA Float64\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.local_transition-Tuple{Carla.ResponseFunction, Any, Any, Any, Any, Any, Any, Any}","page":"Functions","title":"Carla.local_transition","text":"local_transition(\n    TransitionType::ResponseFunction, RMatrix,\n    skillID, t, αMatrix, δ0, δ, temperature\n    )\n\nComputes the probability that an examinee has mastered the latent skill k at assessment time t, given the examinee's latent skill profile at t-1. This is also  known as the complete-data local transition probability P_delta_k^alpha (t)\n\nP_delta_k^alpha (t) = rho(delta_k(t)^T phi_kt(alpha (t -1))) \n\nwhere rho is a logistic sigmoidal function. rho(x) = frac11 + e^-x\n\nArguments\n\nTransitionType: Transition Response Type (DINA(),DINO(), or FUZZYDINA())\nRMatrix: K (No. of Skills) × K (No. of Skills) Matirx\nskillID:  Integer denoting the jth skill\nt: time index\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\nδ0 - initial delta values \nδ - delta values \n\nOutput\n\nA Float64\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.global_emission-Tuple{Carla.ResponseFunction, Any, Any, Any, Any}","page":"Functions","title":"Carla.global_emission","text":"global_emission(\n    EmissionType::ResponseFunction, data, QMatrix, αMatrix, β)\n\nComputes the likelihood of the evidence for an examinee  given their evidence & proficiency models.\n\nArguments\n\nEmissionType: specifies if it's a DINA(), DINO(), or FUZZYDINA() emission response \ndata: StudentResponse of the examinee\ndata.itemResponse: J (No. of items) × T (No. of Time points)\ndata.missingindicator:  J (No. of items) × T (No. of Time points)\nQMatrix: J (No. of Items) × K (No. of Skills) Matirx\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\nβ: β values for the item bank, Vector of length J\n\nOutput\n\nA Float64\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.global_transition-Tuple{Carla.ResponseFunction, Any, Any, Any, Any, Any}","page":"Functions","title":"Carla.global_transition","text":"global_transition(\n    TransitionType::ResponseFunction, RMatrix, αMatrix, δ0, δ, temperature)\n\nComputes the latent skill profile trajectory probability for an examinee. \n\nArguments\n\nTransitionType: Specify if it's a DINA(), DINO() or FUZZYDINA() transition type\nRMatrix: \nαMatrix: latent attribute profile trajectory (K × T)\nδ0: initial detlas, δ[0]\nδ: delta values \ntemperature: temeprature parameter strictly positive. (used during importance sampling)\n\nOutput\n\nA Float64\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.likelihoodcompletealpha-Tuple{CPM, Any, Any, Any, Any, Any, Any}","page":"Functions","title":"Carla.likelihoodcompletealpha","text":"likelihoodcompletealpha(\n    model::CPM, data, QMatrix, \n    RMatrix, αMatrix, θ, temperature\n    )\n\nComputes the likelihood of the αMtrix and the observed responses of an examinee where  we assume αMatrix is fully observable.\n\nmathitddotL^i (mathbftheta  alpha) = \nPi_t=1^T Pi_j=1^J Pi_k=1^K\np_beta_j (t) (x_ij(t)  alpha(t))\np_delta_k (t) (alpha_k(t)  alpha (t-1))\n\nArguments\n\nmodel: The Carla Probability Model\ndata: StudentResponse of the examiniee \ndata.itemResponse: J (No. of items) × T (No. of Time points)\ndata.missingindicator:  J (No. of items) × T (No. of Time points)\nQMatrix: J (No. of Items) × K (No. of Skills) Matirx\nRMatrix: RMatrix specifies how skills are temporally connected\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\nθ: Parameter values, A named tuple θ = (β, δ0, δ)\ntemperature: temeprature parameter for importance sampling \n\nOutput\n\nA Float64\n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.∇risk-Tuple{CPM, Any, Any, Any, Any}","page":"Functions","title":"Carla.∇risk","text":"∇risk(model::CPM, data, QMatrix, RMatrix, θ;e_strategy::Exact)\n\nComputes the expectation of the complete gradient of the empirical risk  computed in ∇riskαᵢ.\n\nArguments\n\nmodel: the Carla Probability Model \ndata: StudentResponse of the examinee \ndata.itemResponse: J (No. of items) × T (No. of Time points)\ndata.missingindicator:  J (No. of items) × T (No. of Time points)\nQMatrix: J (No. of Items) × K (No. of Skills) Matrix\nRMatrix: RMatrix specifies how skills are temporally connected\nθ: Parameter values, A named tuple θ = (β, δ0, δ)\n\nOutput\n\n2J when estimatebeta = 1 and estimatedelta=0 for T = 1 \n2J+K when estimatebeta =1 and estimatedelta = 1  for T=1 \n2J when estimatebeta = 1 and estimatedelta = 0 for T > 1 \n2J + 2K + K when estimatebeta = 1 and estimatedelta = 1 for T > 1 \n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.∇riskαᵢ-Tuple{CPM, StudentResponse, Any, Any, Any, Any, Any}","page":"Functions","title":"Carla.∇riskαᵢ","text":"∇riskαᵢ(\n        model::CPM, data::StudentResponse, αMatrix,\n        QMatrix, RMatrix, θ, temperature\n        )\n\nComputes the gradient of the empirical risk of a given student for a particular skill profile             \n\nArguments\n\nmodel: the Carla Probability Model \ndata: StudentResponse of the examinee \ndata.itemResponse: J (No. of items) × T (No. of Time points)\ndata.missingindicator:  J (No. of items) × T (No. of Time points)\nαMatrix: K (No. of Skills) × T (No. of Timepoints) Matrix\nQMatrix: J (No. of Items) × K (No. of Skills) Matrix\nRMatrix: RMatrix specifies how skills are temporally connected\nθ: Parameter values, A named tuple θ = (β, δ0, δ)\ntemperature: temperature parameter for importance sampling \n\nOutput\n\n2J when estimatebeta = 1 and estimatedelta=0 for T = 1 \n2J+K when estimatebeta =1 and estimatedelta = 1  for T=1 \n2J when estimatebeta = 1 and estimatedelta = 0 for T > 1 \n2J + 2K + K when estimatebeta = 1 and estimatedelta = 1 for T > 1 \n\n\n\n\n\n","category":"method"},{"location":"lib/functions/#Carla.maprisk-Tuple{CPM, Any, Any, Any, Any}","page":"Functions","title":"Carla.maprisk","text":"maprisk(model::CPM, data,\n        QMatrix, RMatrix, θ;e_strategy=Exact())\n\nComputes the MAP risk using exact method.\n\nddotl(theta) = - (1n) log P_theta (theta) - (1n) Sigma_i=1^n log Sigma_alpha ddotL^i (theta alpha)\n\nwhere ddotL^i (theta alpha) is the likelihoodcompletealpha\n\nArguments\n\nmodel: The Carla Probability Model\ndata: StudentResponse of the examiniee \ndata.itemResponse: J (No. of items) × T (No. of Time points)\ndata.missingindicator:  J (No. of items) × T (No. of Time points)\nQMatrix: J (No. of Items) × K (No. of Skills) Matirx\nRMatrix: RMatrix specifies how skills are temporally connected\n\nθ: Parameter values, A named tuple θ = (β, δ0, δ)\n\nOutput\n\n(MAPrisk, ML Risk)\n\n\n\n\n\n","category":"method"},{"location":"lib/types/#Probability-Model","page":"Data Structures","title":"Probability Model","text":"","category":"section"},{"location":"lib/types/","page":"Data Structures","title":"Data Structures","text":"Modules = [Carla]\nPages   = [\"datastructs/probmodels.jl\"]","category":"page"},{"location":"lib/types/#Carla.CPM","page":"Data Structures","title":"Carla.CPM","text":"CPM()\nCPM(kwargs...)\n\nCPM is the data structure for Carla Probability Model.\n\nKeword Arguments\n\nemissionprob::ResponseFunction – Emission Probability function\ntransitionprob::ResponseFunction – Transition Probability function\ninitialwvec::Vector{Float64} – Weight Vector to initialize gaussian priors\nvarianceprior – Variance for initializing a gaussian prior \nopts – Options for estimands,            by default uses EstimandOpts(initparamnoiseSD = 0.2,                                            estimatebeta = true, estimatedelta = false)\nparamconstraints::NamedTuple – Parameter Cosntraints (min = -Inf, max = Inf)\n\nNotes\n\nAll the fields can be assigned using the appropriate keywords. The initialization constructor CPM(), uses the values in the example, as default for the fields in CPM. \n\nExamples\n\njulia> M1 = CPM()\nCPM(DINA(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, false))\n\njulia> M2 = CPM(emissionprob = DINO())\nCPM(DINO(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, false))\n\njulia> M3 = CPM(emissionprob = DINO(), opts = EstimandOpts(estimatedelta=true))\nCPM(DINO(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, true))\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.EstimandOpts","page":"Data Structures","title":"Carla.EstimandOpts","text":"EstimandOpts()\nEstimandOpts(kwargs...)\n\nSets the options for CPM estimands\n\nKeyword Arguments\n\ninitparamnoiseSD::Float64 - S.D of the random noise to be added during parameter initialization, by default 0.2\nestimatebeta::Bool - should betas be estimated as part of learning, by default true\nestimatedelta::Bool - should deltas be estimated as part of learning, by default false\n\nExample\n\njulia> EstimandOpts()\nEstimandOpts(0.2, true, false)\n\njulia> EstimandOpts(estimatedelta = true)\nEstimandOpts(0.2, true, true)\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Data","page":"Data Structures","title":"Data","text":"","category":"section"},{"location":"lib/types/","page":"Data Structures","title":"Data Structures","text":"Modules = [Carla]\nPages   = [\"datastructs/data.jl\"]\n","category":"page"},{"location":"lib/types/#Carla.StudentResponse","page":"Data Structures","title":"Carla.StudentResponse","text":"StudentResponse(itemResponse::Matrix\n                missingindicator::Matrix)\n\nData structure for one examinee.\n\nFields\n\nitemResponse: A student's item-responses for the entire course \nmissingindicator: Indicates if the data was observable \n\nThe observable responses of an examinee across all exams,\n\ny = S  X \n\nwhere S is the missing data indicator and  X is item response\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Latent-Response","page":"Data Structures","title":"Latent Response","text":"","category":"section"},{"location":"lib/types/","page":"Data Structures","title":"Data Structures","text":"Modules = [Carla]\nPages   = [\"datastructs/latentresponses.jl\"]","category":"page"},{"location":"lib/types/#Carla.DINA","page":"Data Structures","title":"Carla.DINA","text":"DINA <: ResponseFunction\n\nDINA Response Function\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.DINO","page":"Data Structures","title":"Carla.DINO","text":"DINO <: ResponseFunction\n\nDINO Response Function\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.FUZZYDINA","page":"Data Structures","title":"Carla.FUZZYDINA","text":"FUZZYDINA <: ResponseFunction\n\nFUZZYDINA Response Function\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.ResponseFunction","page":"Data Structures","title":"Carla.ResponseFunction","text":"ResponseFunction\n\nAbstract type for response functions\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Parameters","page":"Data Structures","title":"Parameters","text":"","category":"section"},{"location":"lib/types/","page":"Data Structures","title":"Data Structures","text":"Modules = [Carla]\nPages   = [\"datastructs/params.jl\"]","category":"page"},{"location":"lib/types/#Carla.GaussianParameterInit","page":"Data Structures","title":"Carla.GaussianParameterInit","text":"GaussianParameterInit(mean::Union{Float64,Vector{Float64}},\n                varianceprior::Float64, noiseSD::Float64 (optional))\n\nInitializes a gaussian parameter prior with the given mean, and co-variance\n\nExamples\n\njulia> GaussianParameterInit(0.5,0.1) \nGaussianParameterInit(0.5, 0.2, 0.1, [10.0;;])\n\njulia> GaussianParameterInit([0.2, 0.6], 0.5)\nGaussianParameterInit([0.2, 0.6], 0.2, 0.5, [2.0 0.0; 0.0 2.0])\n\njulia> GaussianParameterInit([0.2, 0.6], 0.5, 0.5) # Also passing initparamsd (0.5)\nGaussianParameterInit([0.2, 0.6], 0.5, 0.5, [2.0 0.0; 0.0 2.0])\n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Carla.params","page":"Data Structures","title":"Carla.params","text":"params(prior::GaussianParameterInit)\n\nExample\n\njulia> M1 = CPM()\nCPM(DINA(), DINA(), [1.2, 0.6], 0.1865671641791045, EstimandOpts(0.2, true, false))\n\njulia> # Initializing βparams for our M1 model. \njulia>  βparams = params(GaussianParameterInit(M1.initialwvec,\n                                       M1.varianceprior))\nparams(GaussianParameterInit([1.2, 0.6], 0.2, 0.1865671641791045, [5.359999999999999 0.0; 0.0 5.359999999999999]), [1.3862321329853542, 0.6293077030876637])\n\njulia> # Initializing initialδoarams for our M1 model \njulia> prioralpha = 0\njulia> initialδprior = initialdelta_init(M1.initialwvec, M1.varianceprior,prioralpha)\njulia> initialδparams = params(initialδprior)\nparams(GaussianParameterInit(-0.6, 0.2, 0.1865671641791045, [5.359999999999999;;]), [-0.5142508455381457])\n\njulia> # Suppose we had 4 skills \njulia> initialdeltas =[params(initialδprior) for i in 1:4]\njulia> # We'll turn this into a StructArray object for better element access and manipulation \njulia> initialdeltas = soa(initialdeltas)\njulia> # While accessing values of initialdeltas, always use flat function\njulia> flat(initialdeltas.val)\n4-element Vector{Float64}:\n -0.5152143458269017\n -0.5816928334586648\n -0.5639140047678437\n -0.4054633302643975 \n\n\n\n\n\n","category":"type"},{"location":"lib/types/#Learning-Algorithm","page":"Data Structures","title":"Learning Algorithm","text":"","category":"section"},{"location":"lib/types/","page":"Data Structures","title":"Data Structures","text":"Modules = [Carla]\nPages = [\"datastructs/optimizers.jl\"]","category":"page"},{"location":"lib/types/#Carla.LBFGS","page":"Data Structures","title":"Carla.LBFGS","text":"LBFGS()\nLBFGS(kwargs...)\n\nFields\n\nsearchdirectionmaxnorm: maximum search direction norm; defulat = 1.0\ninnercycles: no. of batch inner cycles; defualt = 40\nmaxsearchdev: reset research direction if search direction is almost ⟂ to -ve gradient; default = 1e-4\n\n\n\n\n\n","category":"type"},{"location":"#Carla.jl","page":"Introduction","title":"Carla.jl","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"Welcome to Carla.jl documentation.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Competency-based Assessment using Robust Latent-transition Analysis (CARLA) is a framework for modeling the evolution of a student's latent skills during the course of a semester. Key objectives of this framework are:","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Provide the course instructor with diagnostic information regarding the  probabilities of student's latent skill status \nProvide a psychometric framework for comparing and evaluating exam assessments  and instructional strategies with respect to student latent skill profiles ","category":"page"},{"location":"#This-package-is-under-active-development.","page":"Introduction","title":"This package is under active development.","text":"","category":"section"}]
}