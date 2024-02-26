# see documentation at https://juliadocs.github.io/Documenter.jl/stable/

using Documenter, ToyAD

makedocs(
    modules = [ToyAD],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Raja Doake",
    sitename = "ToyAD.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

# Some setup is needed for documentation deployment, see “Hosting Documentation” and
# deploydocs() in the Documenter manual for more information.
deploydocs(
    repo = "github.com/doorisajar/ToyAD.jl.git",
    push_preview = true
)
