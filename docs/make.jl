using ExperimentalDesign
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(ExperimentalDesign, :DocTestSetup, :(using ExperimentalDesign); recursive=true)

makedocs(;
    modules=[ExperimentalDesign],
    authors="Arno Strouwen <contact@arnostrouwen.com>",
    sitename="ExperimentalDesign.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo="github.com/ArnoStrouwen/ExperimentalDesign.jl", devbranch="master", devurl="dev"
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/ArnoStrouwen/ExperimentalDesign.jl", devbranch="master")
