using Distributions
a = [rand(Uniform(0,1)) for i in range(1, 100)]
b = [quantile(Gamma(3, 1/2), i) for i in a]
print(b)