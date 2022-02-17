using DataFrames, StatsBase, StatsPlots, CSV, Dates
using CovidNYT

gr(size=(700, 1000))

import CompatHelperLocal as CHL
CHL.@check()

ProjDir = @__DIR__

function ma(x::Vector{Float64}, wind::Int)
    len = length(x)
    y = Vector{Float64}(undef, len)
    for i in 1:len
        if i < wind
            y[i] = 0.0
        else
            y[i] = mean(x[i - wind + 1:i])
        end
    end
    return y
end

df_states = CSV.read(rel_path_covidnyt("..", "data", "us-states.csv"), DataFrame)
df_states[!, :month] = Dates.month.(df_states[:, :date])
df_states[!, :day] = Dates.day.(df_states[:, :date])
#first(df_states, 5) |> display

states = ["New York", "Florida", "California", "Colorado"]
counties = ["New York City", "San Diego", "District of Columbia", "Denver"]

wind = 7

p = Vector{Plots.Plot{Plots.GRBackend}}(undef, 2*length(states))
df = Vector{DataFrame}(undef, length(states))

plot_indx = 0
for (indx, state) in enumerate(states)
  global plot_indx += 1
  df[indx] = df_states[df_states.state .== state, :]

  p[plot_indx] = plot(leg=:topleft, title=state, ylab="log10")
  plot!((df[indx][:, :date]), log10.(df[indx][:, :cases]), lab="cases")
  plot!(df[indx][:, :date], log10.(df[indx][:, :deaths]), lab="deaths")

  local c = df[indx][:, :cases]
  c[2:end] = c[2:end] - c[1:end-1]
  df[indx][!, :new_cases] = c
  local d = df[indx][:, :deaths]
  d[2:end] = d[2:end] - d[1:end-1]
  df[indx][!, :new_deaths] = d

  df[indx][!, :ma] = ma(Float64.(df[indx][:, :new_cases]), wind)

  plot_indx += 1
  p[plot_indx] = plot(leg=:topleft, title=state, ylab="new cases", )
  plot!(df[indx][:, :date], df[indx][:, :new_cases], lab="New cases", color=:lightblue)
  plot!(df[indx][:, :date], df[indx][:, :new_deaths], lab="New deaths")
  yminmax = (0.0, maximum(df[indx][:, :ma]))
  plot!(df[indx][:, :date], df[indx][:, :ma], lab="$(wind) day ma", color=:darkblue, ylims=yminmax)

end

plot(p..., layout=(4, 2))
savefig("$(ProjDir)/graphs/s_$(string(today())).png")
#savefig("$(ProjDir)/graphs/s_$(string(today())).pdf")

df_counties = CSV.read(rel_path_covidnyt("..", "data", "us-counties.csv"), DataFrame)
df_counties[!, :month] = Dates.month.(df_counties[:, :date])
df_counties[!, :day] = Dates.day.(df_counties[:, :date])
#first(df_counties, 5) |> display
max_values = [15000, 10000, 3000, 3000]

plot_indx = 0
for (indx, county) in enumerate(counties)
  global plot_indx += 1
  df[indx] = df_counties[df_counties.county .== county, :]
  
  p[plot_indx] = plot(leg=:topleft, title=county, ylab="log10")
  plot!((df[indx][:, :date]), log10.(df[indx][:, :cases]), lab="cases")
  plot!(df[indx][:, :date], log10.(df[indx][:, :deaths]), lab="deaths")

  local c = df[indx][:, :cases]
  c[2:end] = c[2:end] - c[1:end-1]
  df[indx][!, :new_cases] = c
  local d = df[indx][:, :deaths]
  d[2:end] = d[2:end] - d[1:end-1]
  df[indx][!, :new_deaths] = d

  df[indx][!, :ma] = ma(Float64.(df[indx][:, :new_cases]), wind)

  plot_indx += 1
  yminmax = (0.0, max_values[indx])
  #yminmax = (0.0, maximum(df[indx][:, :new_cases]))
  p[plot_indx] = plot(leg=:topleft, title=county, ylims=yminmax, ylab="new cases")
  plot!(df[indx][:, :date], df[indx][:, :new_cases], lab="New cases", color=:lightblue)
  plot!(df[indx][:, :date], df[indx][:, :new_deaths], lab="New deaths")
  plot!(df[indx][:, :date], df[indx][:, :ma], lab="$(wind) day ma", color=:darkblue)

end

plot(p..., layout=(4, 2))
savefig("$(ProjDir)/graphs/c_$(string(today())).png")
#savefig("$(ProjDir)/graphs/c_$(string(today())).pdf")
