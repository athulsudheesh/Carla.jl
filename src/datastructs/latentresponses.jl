# This file contains all the required data structures for Carla 

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