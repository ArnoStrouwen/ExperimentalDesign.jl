using ExperimentalDesignBase
using Test
using Aqua
using JET

@testset "ExperimentalDesignBase.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ExperimentalDesignBase)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(ExperimentalDesignBase; target_defined_modules=true)
    end
    @testset "ContinuousNumericFactor" begin
        f1 = ContinuousNumericFactor(:Temperature; min_value=20.0, max_value=30.0)
        @test f1.name == :Temperature
        @test f1.min_value == 20.0
        @test f1.max_value == 30.0
        @test isa(f1, ContinuousNumericFactor{Float64})

        @test ContinuousNumericFactor(:Pressure) == ContinuousNumericFactor(:Pressure; min_value=-1.0, max_value=1.0)

        f2 = ContinuousNumericFactor(:Time; min_value=0, max_value=10)
        @test f2.min_value == 0
        @test isa(f2, ContinuousNumericFactor{Int})

        @test_throws ArgumentError ContinuousNumericFactor(:Speed, min_value=-1.0, max_value=-1.0)
        @test_throws ArgumentError ContinuousNumericFactor(:Speed, min_value=-1.0, max_value=-2.0)
    end

    @testset "DiscreteNumericFactor" begin
        f1 = DiscreteNumericFactor(:Voltage, 3; min_value=1.0, max_value=5.0)
        @test f1.name == :Voltage
        @test f1.values == (1.0, 3.0, 5.0)
        @test isa(f1, DiscreteNumericFactor{Float64,3 - 1}) # Need to split of first element for Aqua

        @test DiscreteNumericFactor(:Concentration, 2) ==
            DiscreteNumericFactor(:Concentration, 2; min_value=-1.0, max_value=1.0)

        f2 = DiscreteNumericFactor(:Current, [10, 20, 30])
        @test f2.values == (10, 20, 30)
        @test isa(f2, DiscreteNumericFactor{Int,3 - 1}) # Need to split of first element for Aqua

        @test_throws ArgumentError DiscreteNumericFactor(:Position, 0)
        @test_throws ArgumentError DiscreteNumericFactor(:Position, -1)
    end

    @testset "CategoricalFactor" begin
        f1 = CategoricalFactor(:Color, [:Red, :Green, :Blue])
        @test f1.name == :Color
        @test f1.levels == (:Red, :Green, :Blue)
        @test isa(f1, CategoricalFactor{Symbol,3 - 1}) # Need to split of first element for Aqua

        f2 = CategoricalFactor(:Shape, ["Circle", "Square"])
        @test f2.name == :Shape
        @test f2.levels == (:Circle, :Square)
        @test isa(f2, CategoricalFactor{Symbol,2 - 1}) # Need to split of first element for Aqua

        @test_throws ArgumentError CategoricalFactor(:Empty, Symbol[])
        @test_throws ArgumentError CategoricalFactor(:Empty, String[])
    end
end
