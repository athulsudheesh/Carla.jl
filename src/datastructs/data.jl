
@doc raw"""
    StudentResponse(itemResponse::Matrix
                    missingindicator::Matrix)

Data structure for one examinee.

## Fields 
- `itemResponse`: A student's item-responses for the entire course 
- `missingindicator`: Indicates if the data was observable 

The observable responses of an examinee across all exams,

```math
y = S . X 
```
where ``S`` is the missing data indicator and 
``X`` is item response
"""
struct StudentResponse
    itemResponse::Matrix
    missingindicator::Matrix

    StudentResponse(itemResponse,
                    missingindicator) = begin 
    if size(itemResponse) == size(missingindicator)
        new(itemResponse,missingindicator)
    else
        @error("SizeMismatchError:")
        println("item response matrix and missingindicator matrix should be of same size")              
    end
end
end

export StudentResponse