using Documenter
using Carla

makedocs(
    sitename = "Carla",
    format = Documenter.HTML(),
    modules = [Carla]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
