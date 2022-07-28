
abstract type ExpectationStrategy end

"""
Exact Method
"""
struct Exact <: ExpectationStrategy end
export Exact

"""
Importance Sampling
"""
struct IS <: ExpectationStrategy end 