using DifferentialEquations
using Plots

# Parâmetros do modelo
E = 0.1  # Taxa de entrada de carga orgânica
Omax = 9.2 #O2 saturação
k1 = 0.05  # Taxa de consumo de carga orgânica pelas bactérias
k2 = 0.1  # Taxa de produção de oxigênio pelas bactérias
k3 = 0.02  # Taxa de consumo de oxigênio devido à decomposição da carga orgânica
k4 = 0.1  # Taxa de crescimento das bactérias devido à disponibilidade de carga orgânica
k5 = 0.05  # Taxa de mortalidade das bactérias

# Defina o sistema de equações diferenciais
function f(du, u, p, t)
    C, O, B = u

    #dC = −k1*(Ci + Ce) + k2*(Omax − O)
    #dC = - B * C * k1 + (Ci + Ce)
    #dB = C * k4 - B * k5 
 
    #du[1] = - k1 * B * C + E 
    du[1] = - k1 * E
    #du[2] = k2 * B * C - k3 * C
    du[2] = k2 * C * (Omax - O) / (k2 + C) - k3 * C #Michaelis-Menten
    #du[2] = Omax * (O/(k2 + O)) - k3 * C
    du[3] = k4 * C - k5 * B
end

# Condições iniciais
u0 = [10.0, 5.0, 0.5]

# Intervalo de tempo
tspan = (0.0, 40.0)

# Resolva o sistema de equações diferenciais
prob = ODEProblem(f, u0, tspan)
sol = solve(prob)

# Visualize os resultados
plot(sol, xlabel="Tempo", ylabel="Concentração", label=["Carga Orgânica" "Oxigênio Dissolvido" "População de Bactérias"])



using DifferentialEquations
using Plots

# Parâmetros do modelo
E = 15.0  # Taxa de entrada de carga orgânica
Omax = 9.2 # O2 saturação
k1 = 0.05  # Taxa de consumo de carga orgânica pelas bactérias
k2 = 0.1  # Taxa de produção de oxigênio pelas bactérias
k3 = 0.02  # Taxa de consumo de oxigênio devido à decomposição da carga orgânica
k4 = 0.1  # Taxa de crescimento das bactérias devido à disponibilidade de carga orgânica
k5 = 0.3  # Taxa de mortalidade das bactérias


# Defina o sistema de equações diferenciais
function f(du, u, p, t)
    C, O, B = u
    du[1] = E - k1 * B * C
    du[2] = k2 * C * (Omax - O) / (k2 + C) - k3 * C # Equação de saturação de oxigênio de Michaelis-Menten com saturação máxima de 9,2 mg/L
    du[3] = k4 * C - k5 * B
end

# Condições iniciais
u0 = [10.0, 5.0, 5.0]

# Intervalo de tempo
tspan = (0.0, 10.0)

# Resolva o sistema de equações diferenciais
prob = ODEProblem(f, u0, tspan)
sol = solve(prob)

# Visualize os resultados
plot(sol, xlabel="Tempo", ylabel="Concentração", label=["Carga Orgânica" "Oxigênio Dissolvido" "População de Bactérias"])