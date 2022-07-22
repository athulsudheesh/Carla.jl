
abstract type ExpectationStrategy end

"""
Exact Method
"""
struct Exact <: ExpectationStrategy end

"""
Importance Sampling
"""
struct IS <: ExpectationStrategy end 