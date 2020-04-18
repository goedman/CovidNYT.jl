module CovidNYT

using StatisticalRethinking
using DocStringExtensions: SIGNATURES, FIELDS, TYPEDEF

const src_path = @__DIR__

"""

# rel_path_covidnyt

Relative path using the StatisticalRethinking src/ directory.

### Example to get access to the data subdirectory
```julia
rel_path_covid("..", "data")
```

"""
rel_path_covidnyt(parts...) = normpath(joinpath(src_path, parts...))

#include("refresh_dataframes.jl")

export
  rel_path_covidnyt

end # module
