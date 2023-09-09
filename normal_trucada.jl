# Implementação do Artigo 
# SIMULATION OF POSITIVE NORMAL VARIABLES
# USING SEVERAL PROPOSAL DISTRIBUTIONS

using Distributions
using SpecialFunctions

# Objective

# Apesar dde calcularmos o C, ele sera apenas usado para o calculo
# da taxa de aceitacao Teorica

C(μ, σ) = sqrt(π*σ^2/2) * (1 + erf(μ/sqrt(2σ^2)))
p(x, μ, σ) = exp(-((x-μ)^2)/2σ^2) * Int(x>=0)

# Proposed Functions

# 1 

g₁(x, μ, σ) = 1/sqrt(2π*σ^2) * exp((-(x - μ)^2)/(2σ^2))

# 2
function g₂(x, μ, σ) 
    nucleo = Int(x>=0)/(μ + sqrt((π*σ^2)/2))
    x >= μ ? nucleo*exp((-(x-μ)^2)/(2σ^2)) : nucleo
end


# 3

function g₃(x, μ, σ)
    r = 2/(sqrt(2π*σ^2)) * exp(-((x-μ)^2)/2σ^2)
    return Int(x>=μ) * r
end

#4

function g₄(x, μ, σ)
    α = (sqrt(μ^2 + 4σ^2) - μ)/2σ^2
    return α*exp(-α*x) * Int(x >=0)
end

M₁(σ) = sqrt(2π*σ^2)
M₂(μ, σ) = (μ + sqrt(π*σ^2/2))
M₃(σ) = sqrt(2π*σ^2)/2
function M₄(μ, σ)
    α = (sqrt(μ^2 + 4σ^2) - μ)/2σ^2
    r =  exp((α/2) * (2μ + α*σ^2) ) / α
    return r
end

functions = [(g₁, M₁), (g₂, M₂), (g₃, M₃), (g₄, M₄)]

# 1 - Ok 

function generate(f, μ, σ)
    tries = 1
    q = functions[f][1]
    M = functions[f][2](σ)
    θ = rand(Normal(μ, σ), 1)[1]
    u = rand(Uniform(0, 1), 1)[1]
    #println("θ: ", θ)
    #println("p: ",  p(θ, μ, σ))
    R = p(θ, μ, σ)/ (M * q(θ, μ, σ))
    while u > R
        θ = rand(Normal(μ, σ), 1)[1]
        u = rand(Uniform(0, 1), 1)[1]
        R = p(θ, μ, σ)/ (M * q(θ, μ, σ))
        tries += 1
    end
    return (θ, tries)
end

function generate_n(n, f, μ, σ)
    tries = 0
    q = functions[f][1]
    M = functions[f][2](σ)
    println("Taxa de Aceitacao Teorica: ", C(μ, σ)/M)
    values = []
    while(length(values) < n)
        v,t = generate(f, μ, σ)
        tries += t
        push!(values, v)
    end
    return(values, tries)
end

n = 100000
v, t = generate_n(n, 1, 1, 1 )
println("Taxa de Aceitacao Experimental: ", n/t)