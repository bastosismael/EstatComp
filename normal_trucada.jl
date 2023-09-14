# Implementação do Artigo 
# SIMULATION OF POSITIVE NORMAL VARIABLES
# USING SEVERAL PROPOSAL DISTRIBUTIONS

using Distributions
using SpecialFunctions
using BenchmarkTools

# Objective

# Apesar dde calcularmos o C, ele sera apenas usado para o calculo
# da taxa de aceitacao Teorica

C(μ, σ) = sqrt(π*σ^2/2) * (1 + erf(μ/sqrt(2σ^2)))

# α used on exponential distribution
α(μ, σ) = (sqrt(μ^2 + 4σ^2) - μ)/2σ^2
# Objective distribution
p(x, μ, σ) = 1/C(μ, σ) * exp(-((x-μ)^2)/2σ^2) * Int(x>=0)

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
    α₁ =  α(μ, σ)
    return α₁*exp(-α₁*x) * Int(x >=0)
end


# CM - Calculation
# SOme distributions are paremtrized by μ even this parameter not been used. THis was kmade just to simplify the call of the function
M₁(μ, σ) = sqrt(2π*σ^2)/C(μ, σ)
M₂(μ, σ) = (μ + sqrt(π*σ^2/2))/C(μ, σ)
M₃(μ, σ) = sqrt(2π*σ^2)/(2*C(μ, σ))
function M₄(μ, σ)
    α₁ = α(μ, σ)
    r =  exp((α₁/2) * (2μ + α₁*σ^2) ) / (α₁ * C(μ, σ))
    return r
end


# Generating from proposed distributions

# 1
function s₁(μ, σ)
    x = rand(Normal(μ, σ), 1)[1] 
    return x
end

# 2

function s₂(μ, σ)
    Aᵤ = μ/(μ + sqrt(π*σ^2/2))
    Aᵧ = sqrt(π*σ^2/2)/(μ + sqrt(π*σ^2/2))
    u = rand(Uniform(0,1), 1)[1]
    if u < Aᵤ
        v = rand(Uniform(0,1), 1)[1]
        x = μ * v
    else
        v = rand(Normal(0,σ^2), 1)[1]
        x = abs(v) + μ
    end
    return x
end


# 3
function s₃(μ, σ)
    y = rand(Normal(0, σ^2), 1)[1] 
    x = abs(y) + μ 
    return x
end

# 4
function s₄(μ, σ)
    u = rand(Uniform(0,1), 1)[1]
    x = -log(1-u)/α(μ, σ)
    return x
end

functions = [(g₁, M₁, s₁), (g₂, M₂, s₂), (g₃, M₃, s₃), (g₄, M₄, s₄)]


function generate_n(n, f, μ, σ)
    tries = 0
    q = functions[f][1]
    M = functions[f][2](μ, σ)
    s = functions[f][3]
    println("C", C(μ, σ))
    println("M: ", M)
    println("Taxa de Aceitacao Teorica: ", 1/M)
    values = []
    while(length(values) < n)
        u = rand(Uniform(0, 1), 1)[1]
        θ = s(μ, σ)
        R = p(θ, μ, σ)/ (M * q(θ, μ, σ))
        tries +=1
        while(u > R)
            u = rand(Uniform(0, 1), 1)[1]
            θ = s(μ, σ)
            R = p(θ, μ, σ)/ (M * q(θ, μ, σ))
            tries += 1
        end
        push!(values, θ)
    end
    return(values, tries)
end

n = 10000000
# @btime generate_n(n, 1, 0, 1)
v, t = generate_n(n, 4, 0, 1)
println("Taxa de Aceitacao Experimental: ", n/t)

