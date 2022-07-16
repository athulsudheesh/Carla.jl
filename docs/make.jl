using Documenter, Carla

makedocs(
    # options
    doctest = true,
    clean = false,
    sitename = "Carla.jl",
    format = Documenter.HTML(
        canonical = "https://juliadata.github.io/DataFrames.jl/stable/",
        assets = ["assets/favicon.ico"],
        edit_link = "main"
    ),
    pages = Any[
        "Introduction" => "index.md",
 ],
    strict = true
)

deploydocs(
    repo = "github.com/athulsudheesh/Carla.jl.git",
    branch = "gh-pages",
)