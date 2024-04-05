"""
ToyAD is an in-development library for experimenting with the internals of automatic differentiation techniques by hand-coding them. 
"""
module ToyAD

"""
    `DualNumber{T<:Number}`

Dual number type for holding a scalar value and an associated derivative. 

Currently supports `Float`s directly, and `Int`s by casting.
"""
struct DualNumber{T<:Number}
    value::T
    derivative::T
end

DualNumber(v::Int, d::AbstractFloat) = DualNumber(float(v), d)
DualNumber(v::AbstractFloat, d::Int) = DualNumber(v, float(d))


# addition
function Base.:+(x::DualNumber, y::DualNumber)
    return DualNumber(x.value + y.value, x.derivative + y.derivative)
end


function Base.:+(x::DualNumber, y::Real)
    return DualNumber(x.value + y, x.derivative)
end


function Base.:+(x::Real, y::DualNumber)
    return DualNumber(x + y.value, y.derivative)
end


# subtraction
function Base.:-(x::DualNumber, y::DualNumber)
    return DualNumber(x.value - y.value, x.derivative - y.derivative)
end


function Base.:-(x::DualNumber, y::Real)
    return DualNumber(x.value - y, x.derivative)
end


function Base.:-(x::Real, y::DualNumber)
    return DualNumber(x - y.value, y.derivative)
end


# multiplication
function Base.:*(x::DualNumber, y::DualNumber)
    return DualNumber(x.value * y.value, x.value * y.derivative + x.derivative * y.value)
end


function Base.:*(x::DualNumber, y::Real)
    return DualNumber(x.value * y, x.derivative * y)
end


function Base.:*(x::Real, y::DualNumber)
    return DualNumber(x * y.value, x * y.derivative)
end


# powers
function Base.:^(x::DualNumber, y::Real)
    dual_power = if y != 0
        DualNumber(x.value^y, y * x.value^(y - 1) * x.derivative)
    else
        DualNumber(1.0, 0.0)
    end
    return dual_power
end


function Base.:^(x::DualNumber, y::DualNumber)
    # https://math.stackexchange.com/questions/1914591/dual-number-ab-varepsilon-raised-to-a-dual-power-e-g-ab-varepsilon
    new_value = x.value^y.value
    return DualNumber(
        new_value, new_value * (y.derivative * log(x.value) + (x.derivative * y.value) / x.value)
    )
end


function Base.:^(x::Real, y::DualNumber)
    new_value = x^y.value
    return DualNumber(new_value, new_value * (y.derivative * log(x)))
end


function Base.sin(x::DualNumber)
    return DualNumber(sin(x.value), cos(x.value) * x.derivative)
end

function Base.cos(x::DualNumber)
    return DualNumber(cos(x.value), -sin(x.value) * x.derivative)
end

function Base.tan() end


"""
    `forward_diff(f::Function, x::Real)`

Forward mode differentiation of `f(x)` where `x` is a scalar. Returns the scalar derivative.
"""
function forward_diff(f::Function, x::Real)

    x_dual = DualNumber(x, 1.0)
    y_dual = f(x_dual)
    return extract_derivative(y_dual)

end


"""
   `scalarize(f::Function, x::Array, i::Int)`

Scalarize a function `f` that accepts an array input by fixing the input values of all but `x[i]`.

Necessary for gradients.
"""
function scalarize(f::Function, x::Array, i::Int)

    new_x = convert(Vector{Any}, deepcopy(x))

    new_f = function new_f(x_new)

        new_x[i] = x_new
        return f(new_x)

    end

    return new_f

end


"""
    `gradient(f::Function, x::Array{<:Real})`

Compute the gradient of a vector input, scalar output function `f` for a given input array `x`.
"""
function gradient(f::Function, x::Array{<:Real})

    grads = zeros(length(x))

    for i in eachindex(x)
        f_i = scalarize(f, x, i)
        grads[i] = forward_diff(f_i, x[i])
    end

    return grads

end

# row-wise Jacobian
function jacobian(f::Function, x::Array{<:Real})
    output = f(x)

    # TODO we need this to be a 2D array to which we add rows, or initialize it at the right size
    j = []
    for i in eachindex(output)
        f_i(y) = f(y)[i]
        gradient_i = gradient(f_i, x)
        append!(j, gradient_i)
    end
    return j
end

# column-wise Jacobian
function jacobian_2(f::Function, x::AbstractVector{T}) where {T<:Real}
    cols = mapreduce(hcat, eachindex(x)) do idx
        new_x = convert(Vector{Union{T,DualNumber{T}}}, deepcopy(x))
        new_x[idx] = DualNumber(x[idx], one(T))
        return extract_derivative.(f(new_x))
    end

    return cols
end

# ForwardDiff.jl does it like this: 
#  https://github.com/JuliaDiff/ForwardDiff.jl/blob/42b1554493f04a7e3d2606f328e2a0e365bf8f69/src/derivative.jl#L85-L91
extract_derivative(::T) where {T} = zero(T)
extract_derivative(x::DualNumber) = x.derivative


export DualNumber, forward_diff, gradient, jacobian, jacobian_2


end # module
