function convertX(X)
    students, items = size(X)
    [StudentResponse(Vector(X[i,:]), fill(1,items)) for i in 1:students]
end
export convertX