using ChainRulesCore

using Zygote

f(x) = 2x^3 + 5x

fp(x) = 6x^2 + 5

g(x) = 2 * f(x)

# bespoke example for f with known derivative fp, or g which is a simple extension of f

function ChainRulesCore.rrule(::typeof(f), x)

    Ω = f(x) # primal

    # sometimes called pullback
    function d_Ω(δ)

        # this is a matrix-free representation of the Jacobian for the function f
        fp_val = 6x^2 + 5
        
        @info δ
        
        # the need to return nothing first is a wrinkle of the fact that this could all work with
        # structs as well as functions
        return (nothing, δ * fp_val)

    end

    return Ω, d_Ω

end

Zygote.gradient(f, 3.5)

Zygote.pullback(f)

Zygote.gradient(g, 3.5)

  
myexp(x) = exp(x)

function ChainRulesCore.rrule(::typeof(myexp), x)

    Ω = myexp(x)

    function d_Ω(δ)

        # we don't need to do this because we already computed the derivative; we can re-use our calculation in this rule
        # fp_val = myexp(x)
        fp_val = Ω

        @info δ

        # in this case, we could simplify the entire rrule to δ * Ω
        return (nothing, δ * fp_val)

    end

    return Ω, d_Ω

end


Zygote.gradient(myexp, 2)


# this also gets at why the Julia AD ecosystem doesn't generally work with mutating operations;
# you need to know the value of x to create the pullback.
