# Implementação do Artigo 
# SIMULATION OF POSITIVE NORMAL VARIABLES
# USING SEVERAL PROPOSAL DISTRIBUTIONS

# Proposed Functions

# 1 

g₁(x, μ, σ) = sqrt(2π*σ^2)^(-1)*exp((-(x - μ)^2)/(2σ^2))
println(g₁(0,0,1))

# 2
function g₂(x, μ, σ) 
    nucleo = (x>=0)/(μ+sqrt((π*σ^2)/2))
    x >= μ ? nucleo*exp((-(x-μ)^2)/(2σ^2)) : nucleo
end

println(g₂(0,0,1))

# 3

function g₃(x, μ, σ)
    r = 2/(sqrt(2π*σ^2)) * exp(-((x-μ)^2)/2σ^2)
    return x>=μ * r
end

#4

function g₄(x, μ, σ)
    α = (sqrt(μ^2 + 4σ^2) - μ)/2σ^2
    return α*exp(-α*x) * x >=0
end

