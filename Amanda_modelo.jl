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

