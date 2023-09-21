#intento de desarollo de modelo matemático para evaluar ...

#Clase 1

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

#Clase 2

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

using Plots
#bucle while

##
t = 0.0
h = 0.1
tfinal = 100
while t<=tfinal
    t = t + h
    @info t
end
##

#función para crescimiento explonencial (revendo)
##
function crec_exp(λ,N₀,tfinal,h=1.0) #asumiendo un intervalo de tiempo = 1 
    pop = [N₀] #vector de población
    ts = [0.0] #vector de tiempo
    i = 1 #indice para decir en que elemento del vector voy a guardar la población
    t = 0.0 #tiempo (que se va incrementando con h) #hacer que la variable tiempo se sume
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"
        pop1 = pop[i] + h * λ * pop[i] #guardamos lo que va a ser el proximo valor de nuestra población 
        t = ts[i] + h
        i += 1
        push!(pop, pop1) #vou agregando população a uma coleção mutável (neste caso, a um vetor)
        push!(ts, t) #vou agregando tempo ao vetor de tempo
    
    end
    return ts, pop
end

c1 = crec_exp(0.1, 1.0, 100, 0.1)
c2 = crec_exp(0.1, 1.0, 100, 0.5)
c3 = crec_exp(0.1, 1.0, 100, 1.0)

plot(c1)
plot!(c2)
plot!(c3)
#lambda tasa de crescimiento fijo (en 1/area) #h representa algo que multiplica eso
#o sea, mi tasa de crescimiento es una fracción de lambda
#si hago el h muy chiquito, aplico Euler (transformo una ecuacion discreta en continua y tengo una ec. diferencial)
##

# Si quiero hacer (simular?) un repique de bacterias que crecen en un medio

function crec_exp(λ,N₀,tfinal,h=1.0, trepique=0.0) #asumiendo un intervalo de tiempo = 1 
    pop = [N₀] #vector de población
    ts = [0.0] #vector de tiempo
    i = 1 #indice para decir en que elemento del vector voy a guardar la población
    t = 0.0 #tiempo (que se va incrementando con h) #hacer que la variable tiempo se sume
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"
        pop1 = pop[i] + h * λ * pop[i] #guardamos lo que va a ser el proximo valor de nuestra población 
        t = ts[i] + h
        i += 1
        if t % trepique <= 0.01
            pop1 = 0.1 * pop1
        end
        push!(pop, pop1) #vou agregando população a uma coleção mutável (neste caso, a um vetor)
        push!(ts, t) #vou agregando tempo ao vetor de tempo
    
    end
    return ts, pop
end

c4 = crec_exp(0.1, 1.0, 1000, 0.01, 10.0)
plot(c4)

for i in 1:30
    @info i % 5
end 



##
# Crescimiento explonencial estocástico, se calcula tiempo que transcurre hasta un evento (cuando va pasar el crescimiento y no simular exactamente lo que va pasando en un intervalo de tiempo)
# Se simula el tiempo en que transcurre algo, en un evento discreto, utilizando una distribución exponencial (una dist. exponencial es exactamente el tiempo que transcurre hasta que pasa un evento).
# Suposiciones en un tiempo h sucede 1 solo evento 
# Tomamos como evento a la reproduccion de un individuo
#
# la tasa per capita es λ la tasa total es Numero de individuos * λ

# Crear una funcion para calcular la distribución exponencial con tasa λ
# Como se ve una dist. exponencial con tasa λ
function distr_exp()  
    n = 10000
    de = zeros(n) #lo ponemos en un vector que contiene 10000 zeros
    λ = .1
    for i in 1:n #hacemos este calculo 10000 x.
        de[i] = log(rand())/λ #a partir de un numero al azar entre 0 y 1 -- rand. Esta formula da una dist. exponencial
    end
    return de
end

## Para graficar la densidad de la distribución

using StatsPlots

de = distr_exp(0) 
plot(de)

#para ver la forma de la dist. de esta fç, tengo que usar el paquete StatsPlots y:

density(de)


## modelo estocastico #a medida que la poblacion es mas grande, es tiempo entre eventos es menor

function crec_exp_sto(λ,N₀,tfinal)    
    pop = [N₀]                        # Vector para la poblacion
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = pop[i]*λ
        t = ts[i] - log(rand()) / B
        pop1 = pop[i] + 1 #en el proximo tiempo, sucede solo un evento: la poblacion aumenta en 1 #el tiempo se va actualizando con esta fç exp.
        i += 1                  
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end


s1 = crec_exp_sto(0.1,1.0,100)
c1 = crec_exp(0.1,1.0,100,0.001)

plot(s1)
plot!(c1)
s2 = crec_exp_sto(0.1,1.0,100)
plot!(s2)


## 
#  Crecimiento estocástico con repique cada 50
#
#  Usamos la misma funcion agregando otro parametro
#
tmax = 5; tmin=2;
tt=1:24

#Clase 3

## 
# Crecimiento y muerte
#
#
# ahora tenemos dos eventos: Nacimiento y muerte  
#
# Podemos simularla de forma deterministica
#
# Introducimos el empaquetamiento de parametros 



##
#
#   par = tupla, tuplas son vectores invariantes
#
function nac_mue_det(par,N₀,tfinal,h=1.0)    # asume intervalo de tiempo = h
    
    λ , μ = par                              #λ natalidad; μ mortalidad
    
    pop = Float64[N₀]                        #poblacion que imprime el valor inicial de poblacion            # Forzamos variable a Float64 (numero real)
    ts  = [0.0]                              #tiempo
    i = 1                                    #indice valores de la poblacion
    t = 0.0                                  #tiempo
    #@info "Pop[1] $(pop[i]) indice $(i)"

    while t <= tfinal                        #que t quede dando vueltas y que sea menor que el tiempo final
        pop1 = pop[i] + h * ( λ - μ) * pop[i]#la poblacion, en tiempo h, los nascimientos dados por λ menos las muertes μ 
        #@info "Pop1 $(pop1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end


p1 = nac_mue_det( [0.3, 0.3], 100, 100 )    #[x, x] es la tupla con los datos de la variable 'par'
p2 = nac_mue_det( [0.5, 0.3], 100, 100 )
p3 = nac_mue_det( [0.3, 0.3], 100, 100 ) #p3 = p1 fiz somente pra rodar bem no meu pc
using Plots
plot(p3, legend=false)
plot!(p2, legend=false)

# Simulación crecimiento muerte estocástica
#
"""
    nac_mue_det(par, fin_t, N₀,h)

Simula el proceso de nacimiento muerte 

## Argumentos
- `par::Tuple{Float64, Float64}`: Tupla de parámetros de crecimiento, tasa de crecimiento, tasa de mortalidad
- `fin_t::Float64`: tiempo de simulación
- `N₀::Float64`: población inicial.

## Retorno
- `tiempo::Vector{Float64}`: Vector de tiempo simulado.
- `poblacion::Vector{Float64}`: Vector de la población simulada en función del tiempo.
"""
function nac_mue_sto(par,N₀,tfinal)    
    λ , μ = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                 # Forzamos variable a Float64 (numero real)
 
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = pop[i]*λ                  #nascimientos
        M = pop[i]*μ                  #muertes (depende del numero poblacional por la tasa μ)
        R = B + M                     #tasa total de eventos
        t = ts[i] - log(rand()) / R   #tiempo pasa a una tasa igual a la tasa total de eventos (antes teníamos solamente evento B. Ahora, con las muertes, lo dividimos por R). #O sea, el proximo evento (vida o muerte) va a suceder a una tasa R y calculamos el tiempo usando la fç aleatoria log(rand()) con dist expon.
        if rand() < B/R               # probabilidad de nacimiento (para saber si sucede evento o muerte, ya que ya sabemos que algo va a pasar)
            pop1 = pop[i] + 1         #ESTO NO SERIA MENOR O IGUAL?
        else
            pop1 = pop[i] - 1
        end

        i += 1                  
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end


p1 = nac_mue_det( [0.2, 0.3], 100, 100, 0.01 )
plot(p1, legend=false)

p2 = nac_mue_sto( [0.2, 0.3], 100, 100 )
plot!(p2)


p1 = nac_mue_det( [0.2, 0.2], 100, 100, 0.01 )
plot(p1, legend=false)
p2 = nac_mue_sto( [0.2, 0.2], 100, 100 )
plot!(p2)


## 
# Crecimiento logistico estocástico
#
#  dpop = λ pop (1 - pop / K  )  = λ pop -  pop * pop * λ / K 
#
function logistico_sto(par,N₀,tfinal)    
    λ , K = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                 # Forzamos variable a Float64 (numero real)
 
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = pop[i]*λ
        M = pop[i]*pop[i]*λ/K         #esto cambia para encuadrarse en la fç logística
        R = B + M 
        t = ts[i] - log(rand()) / R
        if rand() < B/R                   # probabilidad de nacimiento 
            pop1 = pop[i] + 1
        else
            pop1 = pop[i] - 1
        end

        i += 1                  
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end

p2 = logistico_sto( [0.2, 100], 10, 1000 )
plot(p2)
p3 = logistico_sto( [0.4, 200], 10, 1000 )
plot!(p3)
p4 = logistico_sto( [1, 200], 10, 1000 )
plot!(p4)


## 
# Ejercicio
#
# 1) Crecimiento logístico deterministica
#
# 2) Crecimiento logistico estocástico + cosecha
#