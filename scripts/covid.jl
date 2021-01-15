using StatisticalRethinking, OrderedCollections

df_covid = DataFrame(
    :completed => [true, true, false, false],
    :company => [:pfizer, :moderna, :jj, :astra],
    :unv => [18261, 15000, missing, missing],
    :vac => [18262, 15000, missing, missing],
    :cov_unv => [162, 185, missing, missing],
    :cov_vac => [8, 11, missing, missing]
)

function extract_company(df::DataFrame, c::Symbol)
    cv = df[df.company .== c, :cov_vac]
    ncv = df[df.company .== c, :vac] - cv
    v = df[df.company .== c, :vac]
    cu = df[df.company .== c, :cov_unv]
    ncu = df[df.company .== c, :unv] - cu
    u = df[df.company .== c, :unv]
    NamedArray(
        [cv ncv v; cu ncu u; cv+cu ncv+ncu v+u],
    (   [:vaccinated, :unvaccinated, :total], 
        [:covid, :noninfected, :total]
    ), ("Rows", "Cols"))
end

na_pfizer = extract_company(df_covid, :pfizer)
na_pfizer |> display
println()

# Risk of covid among vaccinated

@show risk_vac = na_pfizer[:vaccinated, :covid] / na_pfizer[:vaccinated, :total]

# Risk of covid among unvaccinated

@show risk_unvac = na_pfizer[:unvaccinated, :covid] / na_pfizer[:unvaccinated, :total]
@show rr_pfizer = risk_vac / risk_unvac
@show ve_pfizer = (risk_unvac - risk_vac) /risk_unvac

# Alternatively, using risk ratio

@show 1 - rr_pfizer

# So, the vaccinated group experienced 95% fewer covid cases
# than they would have if they had not been vaccinated.
println()

na_moderna = extract_company(df_covid, :moderna)
na_moderna |> display
println()

# Risk of covid among vaccinated

@show risk_vac = na_moderna[:vaccinated, :covid] / na_moderna[:vaccinated, :total]

# Risk of covid among unvaccinated

@show risk_unvac = na_moderna[:unvaccinated, :covid] / na_moderna[:unvaccinated, :total]
@show rr_moderna = risk_vac / risk_unvac
@show ve_moderna = (risk_unvac - risk_vac) /risk_unvac

# Alternatively, using risk ratio

@show 1 - rr_moderna

# So, the vaccinated group experienced 95% fewer covid cases
# than they would have if they had not been vaccinated.
println()

