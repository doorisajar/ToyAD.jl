using ToyAD
using Zygote

x = DualNumber(3.0, 1.0)
y = DualNumber(4.0, 1.0)

z = 2.5

x + y
x + z

myfunc(x) = 3x + 2

forward_diff(myfunc, 5.0)

# correctness check for composition of + and * operators in forward_diff
myfancyfunc(x) = (3x + 2) * (2x + 1)

myfancyfuncprime(x) = 3 * (2x + 1) + 2 * (3x + 2)

forward_diff(myfancyfunc, 5.0) == myfancyfuncprime(5.0)

# exponentiation
x^2

powfunc(x) = x^3

powfuncprime(x) = 3x^2

forward_diff(powfunc, 5.0) == powfuncprime(5.0)

powfancyfunc(x) = 4x^3 + 2x^2

powfancyfuncprime(x) = 12x^2 + 4x

function vectoroutputfunc(x)
    return [12x[1]^2 + 4x[2], 4x[1]^3 + 2x[2]^2]
end

forward_diff(powfancyfunc, 5.0) == powfancyfuncprime(5.0)

powzerofunc(x) = 2 * x^0

powzerofuncprime(x) = 0

forward_diff(powzerofunc, 5.0) == powzerofuncprime(5.0)

dualpowfunc(x) = x^DualNumber(2, 3)

dualpowfunc(x)

forward_diff(dualpowfunc, 5)

# gradient
vec_func(x) = sin(x[1]) + cos(x[2])

ToyAD.gradient(vec_func, [0.5, 1.5])

# jacobian
ToyAD.jacobian_tabular(vectoroutputfunc, [2.0, 3.0, 4.0])
ToyAD.jacobian_columnar(vectoroutputfunc, [2.0, 3.0, 4.0])

Zygote.jacobian(vectoroutputfunc, [2.0, 3.0, 4.0])
