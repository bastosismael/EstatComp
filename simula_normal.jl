using Distributions
using BenchmarkTools


# Gera uma amostra de uma Normal(0,1) com base na soma de n Uniformes
function gen_norm(n)
    θ =   Uniform(0,1)
    s = rand(θ, n)
    return (sum(s) - n*0.5)/(sqrt(1/12)*sqrt(n))
end

function gen_vn(n, q)
    values = Array{Float64}(undef, 0)
    for i in 1:q
        value = gen_norm(n)
        push!(values, value)
    end
    return values
end


@btime gen_vn(96, 1000)
v = gen_vn(96, 1000)
media = mean(v)
println("Media: ", media)
println("Variancia:", var(v))
println(">2.33: ", length(filter(x -> x>=2.33, v))/1000)
println(">1.96: ", length(filter(x -> x>=1.96, v))/1000)
println(">1.64: ", length(filter(x -> x>=1.64, v))/1000)
println(">1.28: ", length(filter(x -> x>=1.28, v))/1000)
println("<-2.33: ", length(filter(x -> x<=-2.33, v))/1000)
println("<-1.96: ", length(filter(x -> x<=-1.96, v))/1000)
println("<-1.64: ", length(filter(x -> x<=-1.64, v))/1000)
println("<-1.28: ", length(filter(x -> x<=-1.28, v))/1000)