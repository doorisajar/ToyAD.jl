"""
Placeholder for a short summary about ToyAD.
"""
module ToyAD

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


# forward mode differentiation
function forward_diff(f::Function, x::Real)

    x_dual = DualNumber(x, 1.0)
    y_dual = f(x_dual)

    return y_dual.derivative

end


function scalarize(f::Function, x::Array, i::Int)

    new_x = convert(Vector{Any}, deepcopy(x))

    new_f = function new_f(x_new)

        new_x[i] = x_new
        return f(new_x)

    end

    return new_f

end


function gradient(f::Function, x::Array{<:Real})

    grads = zeros(length(x))

    for i in eachindex(x)
        f_i = scalarize(f, x, i)
        grads[i] = forward_diff(f_i, x[i])
    end

    return grads

end



export DualNumber, forward_diff


end # module
