using ToyAD
using Test

# write tests here

## NOTE add JET to the test environment, then uncomment
# using JET
# @testset "static analysis with JET.jl" begin
#     @test isempty(JET.get_reports(report_package(ToyAD, target_modules=(ToyAD,))))
# end

## NOTE add Aqua to the test environment, then uncomment
# @testset "QA with Aqua" begin
#     import Aqua
#     Aqua.test_all(ToyAD; ambiguities = false)
#     # testing separately, cf https://github.com/JuliaTesting/Aqua.jl/issues/77
#     Aqua.test_ambiguities(ToyAD)
# end

@testset "Forward basics" begin

    x = DualNumber(3.0, 1.0)
    y = DualNumber(4.0, 1.0)

    z = 2.5

    x + y
    x + z

    # correctness check for composition of + and * operators in forward_diff
    add_mult_func(x) = (3x + 2) * (2x + 1)

    add_mult_func_prime(x) = 3 * (2x + 1) + 2 * (3x + 2)

    @test forward_diff(add_mult_func, 5.0) == add_mult_func_prime(5.0)

end
