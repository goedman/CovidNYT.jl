using CovidNYT
using StatsPlots

ProjDir = @__DIR__

dfusdata = CSV.read(rel_path_covidnyt("..", "data", "us.csv"))
dfusstatesdata = CSV.read(rel_path_covidnyt("..", "data", "us-states.csv"))
dfuscountiesdata = CSV.read(rel_path_covidnyt("..", "data", "us-counties.csv"))

plot(leg=:topleft)
plot!(dfusdata[:, :date], dfusdata[:, :cases], lab="cases")
plot!(dfusdata[:, :date], dfusdata[:, :deaths], lab="deaths")

savefig("$(ProjDir)/usdata.png")
