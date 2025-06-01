using FullFactorialDesign
using Test
using Aqua
using JET

@testset "FullFactorialDesign.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(FullFactorialDesign)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(FullFactorialDesign; target_defined_modules=true)
    end
    @testset "factorial_design" begin
        design = fullfactorial([3, 2, 2])
        @test design[:, 1] == [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]
        @test design[:, 2] == [1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2]
        @test design[:, 3] == [1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2]

        design_large = fullfactorial([3, 2, 2]; container_type=Int128)
        @test eltype(design_large) == Int128

        @test_throws ArgumentError fullfactorial(Int[])
        @test_throws ArgumentError fullfactorial([3, 0, 2])
        @test_throws ArgumentError fullfactorial([3, -1, 2])
        @test_throws MethodError fullfactorial([3, 1.0, 2])
    end

    @testset "integration" begin
        design_space = [
            DiscreteNumericFactor(:T, 3), DiscreteNumericFactor(:P, 2), CategoricalFactor(:Shape, ["Circle", "Square"])
        ]
        design = solve(FullFactorial(), design_space)
        @test design.T == [-1.0, -1.0, -1.0, -1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0]
        @test design.P == [-1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0]
        @test design.Shape == [
            :Circle, :Square, :Circle, :Square, :Circle, :Square, :Circle, :Square, :Circle, :Square, :Circle, :Square
        ]
        @test_throws ArgumentError solve(FullFactorial(), [ContinuousNumericFactor(:Voltage)])
    end
end
