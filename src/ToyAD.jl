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


# forward mode differentiation
function forward_diff(f::Function, x::Number)

    x_dual = DualNumber(x, 1.0)

    y_dual = f(x_dual)

    return y_dual.derivative

end

export DualNumber, forward_diff


end # module
