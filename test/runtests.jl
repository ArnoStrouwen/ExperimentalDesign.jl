using ExperimentalDesign
using Test
using Aqua
using JET

@testset "ExperimentalDesign.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ExperimentalDesign)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(ExperimentalDesign; target_defined_modules = true)
    end
    # Write your tests here.
end
