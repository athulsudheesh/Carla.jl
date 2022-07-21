"""

Computes the gradient of the emperical risk for a given student 
"""
function Δriskᵢ(
            model::CPM, data::StudentResponse, αMatrix)
    
    nrskills, nrtimepoints = size(αMatrix)
    nritems, _ = size()
end