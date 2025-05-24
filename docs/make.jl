using ExperimentalDesign
using Documenter

DocMeta.setdocmeta!(ExperimentalDesign, :DocTestSetup, :(using ExperimentalDesign); recursive=true)

makedocs(;
    modules=[ExperimentalDesign],
    authors="Arno Strouwen <contact@arnostrouwen.com>",
    sitename="ExperimentalDesign.jl",
    format=Documenter.HTML(;
        canonical="https://ArnoStrouwen.github.io/ExperimentalDesign.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ArnoStrouwen/ExperimentalDesign.jl",
    devbranch="master",
)
