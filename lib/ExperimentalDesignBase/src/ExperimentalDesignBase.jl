module ExperimentalDesignBase

export AbstractFactor, ContinuousNumericFactor, DiscreteNumericFactor, CategoricalFactor
export solve, AbstractExperimentalDesign

abstract type AbstractExperimentalDesign end
function solve end

abstract type AbstractFactor end

struct ContinuousNumericFactor{T<:Real} <: AbstractFactor
    name::Symbol
    min_value::T
    max_value::T
end
function ContinuousNumericFactor(name::Symbol; min_value::T=-1.0, max_value::T=1.0) where {T<:Real}
    if min_value >= max_value
        throw(ArgumentError("min_value must be strictly less than max_value."))
    end
    return ContinuousNumericFactor(name, min_value, max_value)
end

struct DiscreteNumericFactor{T<:Real,N} <: AbstractFactor
    name::Symbol
    values::Tuple{T,Vararg{T,N}}
end
function DiscreteNumericFactor(name::Symbol, n_values::Int; min_value::T=-1.0, max_value::T=1.0) where {T<:Real}
    if n_values <= 0
        throw(ArgumentError("Number of values (n_values) must be positive."))
    end
    vals = Tuple(LinRange(min_value, max_value, n_values))
    return DiscreteNumericFactor(name, vals)
end
function DiscreteNumericFactor(name::Symbol, values::Vector{T}) where {T<:Real}
    return DiscreteNumericFactor(name, Tuple(values))
end

struct CategoricalFactor{T<:Symbol,N} <: AbstractFactor
    name::Symbol
    levels::Tuple{T,Vararg{T,N}}
end
function CategoricalFactor(name::Symbol, levels::Vector{T}) where {T<:Symbol}
    if isempty(levels)
        throw(ArgumentError("CategoricalFactor levels cannot be empty."))
    end
    return CategoricalFactor(name, Tuple(levels))
end
function CategoricalFactor(name::Symbol, levels::Vector{String})
    return CategoricalFactor(name, Symbol.(levels))
end

end
