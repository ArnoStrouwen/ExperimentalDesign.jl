module FullFactorialDesign
using Reexport
using DataFrames
@reexport using ExperimentalDesignBase
export fullfactorial, FullFactorial

"""
    fullfactorial(levels_per_factor::Vector{T<:Integer}; container_type = T) where T

Generates a full factorial design.

# Arguments

  - `levels_per_factor`: A vector of integers representing the number of levels for the corresponding factor.
  - `container_type`: The desired element type of the output matrix.
    Defaults to the type of elements in `levels_per_factor` (`T`).
    This option is useful for large designs.
"""
function fullfactorial(levels_per_factor::Vector{T}; container_type::DataType=T) where {T<:Integer}
    num_factors = length(levels_per_factor)
    iszero(num_factors) && throw(ArgumentError("Cannot create a design with zero factors."))
    if any(level -> level <= zero(level), levels_per_factor)
        throw(ArgumentError("Number of levels for each factor must be positive."))
    end
    total_runs = prod(levels_per_factor)
    design_matrix = Matrix{container_type}(undef, total_runs, num_factors)
    keep_constant = total_runs
    for j in 1:num_factors
        levels = levels_per_factor[j]
        design_matrix[:, j] .= repeat(
            one(levels):levels; inner=keep_constant ÷ levels, outer=total_runs ÷ keep_constant
        )
        keep_constant ÷= levels
    end

    return design_matrix
end

struct FullFactorial <: AbstractExperimentalDesign end

function solve(design::FullFactorial, design_space::Vector{<:AbstractFactor})
    levels_per_factor = Int[]
    factor_names = Symbol[]
    factor_level_sources = Vector{Any}() # To store factor.values or factor.levels

    for factor in design_space
        push!(factor_names, factor.name)
        if factor isa DiscreteNumericFactor
            push!(levels_per_factor, length(factor.values))
            push!(factor_level_sources, factor.values)
        elseif factor isa CategoricalFactor
            push!(levels_per_factor, length(factor.levels))
            push!(factor_level_sources, factor.levels)
        else
            throw(ArgumentError("Full factorial designs only supports DiscreteNumericFactor and CategoricalFactor."))
        end
    end

    design_indices_matrix = fullfactorial(levels_per_factor)

    # Create a dictionary to build the DataFrame
    df_columns = Dict{Symbol,AbstractVector}()
    num_runs = size(design_indices_matrix, 1)

    df = DataFrame()
    for j in 1:length(factor_names)
        factor_name = factor_names[j]
        level_source = factor_level_sources[j]
        column_data = Vector{eltype(level_source)}(undef, num_runs)
        for i in 1:num_runs
            column_data[i] = level_source[design_indices_matrix[i, j]]
        end
        df[!, factor_name] = column_data
    end

    return df
end
end
