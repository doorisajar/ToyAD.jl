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

    # TODO tests with Ints
    x = DualNumber(3.0, 1.0)
    y = DualNumber(4.0, 1.0)

    z = 2.5


    # addition of duals
    @test x + y == DualNumber(7.0, 2.0)

    @test x + z == DualNumber(5.5, 1.0)

    # subtraction
    @test x - y == DualNumber(-1.0, 0.0)

    @test x - z == DualNumber(0.5, 1.0)


    # correctness check for composition of + and * operators in forward_diff
    add_mult_func(x) = (3x + 2) * (2x + 1)

    add_mult_func_prime(x) = 3 * (2x + 1) + 2 * (3x + 2)

    @test forward_diff(add_mult_func, 5.0) == add_mult_func_prime(5.0)

    add_sub_func(x) = (3x - 2) * (2x + 1)

    add_sub_func_prime(x) = 3 * (2x + 1) + 2 * (3x - 2)

    @test forward_diff(add_sub_func, 5.0) == add_sub_func_prime(5.0)


    # powers (including zero) and composition thereof
    pow_func(x) = x^3

    pow_func_prime(x) = 3x^2

    @test forward_diff(pow_func, 5.0) == pow_func_prime(5.0)

    pow_add_mult_func(x) = 4x^3 + 2x^2

    pow_add_mult_func_prime(x) = 12x^2 + 4x

    @test forward_diff(pow_add_mult_func, 5.0) == pow_add_mult_func_prime(5.0)

    pow_zero_func(x) = 2 * x^0

    pow_zero_func_prime(x) = 0

    @test forward_diff(pow_zero_func, 5.0) == pow_zero_func_prime(5.0)

    two_exp(x) = 2^x
    two_exp_prime(x) = 2^(x) * log(2)
    @test forward_diff(two_exp, 4.2) == two_exp_prime(4.2)

    dual_to_real(x) = x^(3 * x)
    dual_to_real_prime(x) = 3 * x^(3 * x) * (1 + log(x))
    @test forward_diff(dual_to_real, 1.2) ≈ dual_to_real_prime(1.2) #Note: not precisely accurate due to floating point arithmetic

end
