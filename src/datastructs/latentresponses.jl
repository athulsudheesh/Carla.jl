# This file contains all the latent response data structures 

# Response Functions ================================
"""
    ResponseFunction

Abstract type for response functions
"""
abstract type ResponseFunction end
export ResponseFunction

"""
    DINA <: ResponseFunction

DINA Response Function
"""
struct DINA <: ResponseFunction end

"""
    DINO <: ResponseFunction

DINO Response Function
"""
struct DINO <: ResponseFunction end

"""
    FUZZYDINA <: ResponseFunction

FUZZYDINA Response Function
"""
struct FUZZYDINA <: ResponseFunction end


export DINA, DINO, FUZZYDINA