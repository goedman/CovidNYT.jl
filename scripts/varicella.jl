using StatisticalRethinking, DataFrames, NamedArrays, OrderedCollections

na = NamedArray(
    [18 134 152; 3 4 7; 21 138 159], 
    (   [:vaccinated, :unvaccinated, :total], 
        [:varicella, :noninfected, :total]
    ),
    ("Rows", "Cols")
)

na |> display
println()

# Risk of varicella among vaccinated children = 18 / 152 = 0.118 = 11.8%

risk_vac = na[:vaccinated, :varicella] / na[:vaccinated, :total]

# Risk of varicella among unvaccinated children = 3 / 7 = 0.429 = 42.9%

risk_unvac = na[:unvaccinated, :varicella] / na[:unvaccinated, :total]

# Risk ratio = 0.118 / 0.429 = 0.28

rr = risk_vac / risk_unvac

# EXAMPLE: Calculating Vaccine Effectiveness
# Calculate the vaccine effectiveness from the varicella data in Table 3.13.

# VE = (42.9 – 11.8) / 42.9 = 31.1 / 42.9 = 72%

ve = (risk_unvac - risk_vac) /risk_unvac

# Alternatively, VE = 1 – RR = 1 – 0.28 = 72%

1 - rr |> display

# So, the vaccinated group experienced 72% fewer varicella cases
# than they would have if they had not been vaccinated.

df_covid = DataFrame(
    :completed => [true, true, false, false],
    :company => [:pfizer, :moderna, :jj, :astra],
    :unvaccinated => [18261, 15000, missing, missing],
    :vaccinated => [18262, 15000, missing, missing],
    :inf_unv => [162, 185, missing, missing],
    :inf_vac => [8, 11, missing, missing]
)

df_covid |> display

df = df_covid[df_covid.completed, :]
