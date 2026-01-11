using ExperimentalDesign
using Test

@testset "ExperimentalDesign.jl" begin
    design_space = [
        DiscreteNumericFactor(:T, 3), DiscreteNumericFactor(:P, [1, 3]), CategoricalFactor(:Level, ["A", "B"])
    ]
    design = solve(FullFactorial(), design_space)

    # 3 * 2 * 2 = 12 runs, 3 factors
    @test size(design) == (12, 3)
    @test Set(string.(propertynames(design))) == Set(["T", "P", "Level"])
end
