#intento de desarollo de modelo matemático para evaluar ...

#primeiro: activar paquete (en el terminal, poner 'activate .')
#segundo: que paquetes voy a usar

#tipos de variáveis
x = 10
typeof(x)

y = 10.0
typeof(y)

z = "love"
typeof(z)

#vetores e matrizes

a = [10, 10, 10]

b = [10, 10.0]

c = zeros(10)

d = zeros(3, 4)

e = [Float64]

f = [10, a]

g = [10 11; 12 13]

#multiplicar escalares x vectores

5 * g

log(g)

#log vectores

log.(a)

#condicionales

if length(a) == 1
    @info "El vector es de largo 1"
else 
    @info "El vector es mayor que 1"
end 

if length(a) == 1
    @info "El vector es de largo 1"
elseif length(a) == 2
    @info "El vector es de largo 2"
elseif length(a) == 3
    @info "El vector es de largo 3"
else 
    @info "El vector es mayor que 3"
end 

if typeof(x) == "vector"
    @info "El tipo es vector"
else 
    @info "El tipo es $(typeof(x))"
end 

#Bucles - loops

for i in 1:10
    @info "i = $(i)"
end

#combinar bucles y condicionales

for i in 1:10
    if i == 5
        @info "i es igual a $(i)"
    end 
end 

#

h = rand(10)
for i in 1:10
    if h[i]<0.2
        @info "Evaluamos la probabilidad de 0.2"
    end
end 

p = 0.2
for i in 1:10
    if( rand() < p)
        @info "Verdadero"
    else 
        @info "False"
    end
end 

#funciones

function evento_aleatorio(p)
    if rand() < p
        return true
    else 
        return false
    end 
end 

evento_aleatorio(0.1)
evento_aleatorio(0.2)

#True or false - booleanos
eventos = true
typeof(eventos)

eventos_ = Bool[]
typeof(eventos_)

#push modifica la variable (agrega)
push!(eventos_, false)
length(eventos_)

eventos_ = Bool[]

for i in 1:100
    push!(eventos.evento_aleatorio(0.1))
end

count(eventos)


#Ejercício: hacer una función caminante aleatoria que nos diga la nueva posición del caminante con parametro p 

function caminhante_aleatorio(p)
    # número aleatório entre 0 e 1
    aleatorio = rand()

    # Determina a direção do movimento com base em 'p'
    if aleatorio < p
        # Move para a direita
        nova_posicao = 1
    else
        # Move para a esquerda
        nova_posicao = -1
    end

    return nova_posicao
end

# Exemplo de uso com p=0.5 (50% de chance de cada direção)
nova_posicao = caminhante_aleatorio(0.5)
@info "Nova posição: $(nova_posicao)"


#código da página do Andres
pasos = 100

function pos_caminante2(p,pasos)
    caminata_aleatoria = Int16[]
    for i in 1:pasos
        if evento_aleatorio(p) == true
            push!(caminata_aleatoria,1)
        else
            push!(caminata_aleatoria,-1)
        end
    end
    return caminata_aleatoria
end 

eventos = pos_caminante2(0.5,pasos)
sum(eventos)

using Plots

plot(eventos)
scatter!(eventos)

#función para crescimiento explonencial
function crec_exp(λ,N₀,tfinal) #asumiendo un intervalo de tiempo = 1
    pop = [N₀]

    for t in 1:tfinal-1
        pop1 = pop[t] + λ * pop[t] #guardamos lo que va a ser el proximo valor de nuestra población 
        push!(pop, pop1)
    end
    return pop
end

p1 = crec_exp(0.1, 1.0, 100) #crescimiento explonencial
plot(p1)

p2 = crec_exp(0.015, 1.0, 100)
plot(p2)

p3 = crec_exp(0.0015, 1.0, 100)
plot!(p3)




    
end



