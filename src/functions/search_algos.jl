"""
    autosearch(
                innercycleid,
                gt, gtlast, dtlast, 
                stepsizelast;optim::LBFGS, learning::Batch
                ) 
Specifies the search direction for the Batch learning algorithm

## Arguments 
- `innercycleid`: innercycle counter for LBFGS
- `gt`: current gradient; q-dimensional vector 
- `gtlast`: previous gradient; q-dimensional vector  
- `dtlast`: previous search direction; q-dimensional vector 
- `stepsizelast`: previous step size; positive number

## Output 
- `dt`: search direction; q-dimensional vector 
- `angulardeviation`: angular deviation of search direction from -ve gradient 
- `innercycleid`: tracks the number of times this routien is called
"""

function autosearch(innercycleid,
    gt,
    gtlast, stepsizelast, dtlast, optim::GradientDescent, learning::Batch)
    dt = -gt
    innercycleid = 0
    numerical0 = learning.numerical0
    maxsearchdev = optim.maxsearchdev
    cosineangle = 0
    directionnorm = norm(dt)
    gradnorm = norm(gt)

    if gradnorm <= numerical0 || directionnorm <= numerical0
        cosineangle = 0
    else
        cosineangle = (gt / gradnorm)' * (dt / directionnorm)
    end
    if cosineangle > -maxsearchdev
        dt = -gt
        cosineangle = -1
        angulardev = 0
    else
        angulardev = real(acosd(-round(cosineangle, digits=5)))
    end
    return dt, angulardev, innercycleid
end

function autosearch(innercycleid,
    gt,
    gtlast, stepsizelast, dtlast, optim::LBFGS, learning::Batch)

    numerical0 = learning.numerical0
    maxinnercycles = optim.innercycles
    maxsearchdev = optim.maxsearchdev

    if innercycleid == 0
        dt = -gt
    else
        ut = gt - gtlast
        denomt = dtlast' * ut
        if abs(denomt) < numerical0
            dt = -gt
        else
            atscalar = (dtlast' * gt) / denomt
            btscalar = (ut' * gt) / denomt
            ctscalar = stepsizelast + (ut' * ut) / denomt
            actscalar = atscalar * ctscalar
            dt = -gt + (atscalar * ut) + (btscalar - actscalar) * dtlast

        end
    end
    innercycleid += 1
    if innercycleid == maxinnercycles
        innercycleid = 0
    end

    cosineangle = 0
    directionnorm = norm(dt)
    gradnorm = norm(gt)

    if gradnorm <= numerical0 || directionnorm <= numerical0
        cosineangle = 0
    else
        cosineangle = (gt / gradnorm)' * (dt / directionnorm)
    end
    if cosineangle > -maxsearchdev
        dt = -gt
        cosineangle = -1
        angulardev = 0
    else
        angulardev = real(acosd(-round(cosineangle, digits=5)))
    end
    return dt, angulardev, innercycleid

end

export autosearch
