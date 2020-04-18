using Documenter, CovidNYT

makedocs(
    modules = [CovidNYT],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Rob J Goedman",
    sitename = "CovidNYT.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/goedman/CovidNYT.jl.git",
    push_preview = true
)
