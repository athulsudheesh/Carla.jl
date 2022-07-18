using Documenter
using Carla
DocMeta.setdocmeta!(Carla, :DocTestSetup, :(using Carla); recursive=true)
makedocs(
    sitename = "Carla.jl",
    format = Documenter.HTML(edit_link=:commit),
    modules = [Carla],
    pages = Any[
        "Introduction" => "index.md",
        "API" => Any[
            "Data Structures" => "lib/types.md",
            "Functions" => "lib/functions.md",

        ]
    ],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/athulsudheesh/Carla.jl.git",
    versions = nothing, 
)