using ToyAD

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
