#--------------------------MODELO AMANDA PARA CONCLUSIÓN CURSO--------------------------#

#intento de desarollo de modelo matemático para evaluar la dinamica poblacional
#de bacterias que decomponen material organico en la salida de una ETE - 
#y en un pequeño trayecto después del descarte?

#para desarrollar el modelo, pensé en considerar:
#1. [lo que ingresa de material organico] - [lo que es consumido por las bacterias]
#2. [lo que ingresa de oxígeno] - [lo que es consumido de oxígeno por las bacterias]
#3. [el crescimiento poblacional de las bacterias] - [mortalidad de individuos]

#a tener en cuenta:
#- pensé en considerar el oxígeno principalmente porque la cantificación más sensilla
#de la carga orgánica seria a traves de analisis de DBO o DQO;
#- no consideraria muchos otros fenomenos y no se si me equivoco ahí. No estoy pen-
#sando en caudal, velocidad del agua, sedimentación, etc. Pero considero la tasa de
#reoxigenación, que está asociada a las características físicas del río;
#- la tercera ecuacion es exactamente igual a la de dinamica de poblacion que vimos 
#en las clases practicas;
#- necesité ayuda para poder desarrollar el codigo: literatura, foruns, IA, etc.

#---------------------------------------------------------------------------------------#

#PARAMETROS 
#C = carga organica (MO)
#Ci = carga organica que ingresa con descarte de efluente
#Ce = carga organica ya presente en el río

#O = oxígeno disuelto
#Oi = oxígeno disuelto que ingresa con el descarte de efluente
#Oe = oxígeno disuelto presente en el río
#Os = oxígeno de saturación
#K1 = tasa de reoxigenación (depende del tipo de cuerpo de agua)
#K2 = tasa de desoxigenación (depende del tipo de descarte)

#B = población (bacterias de decomposición de MO)
#K3 = tasa de asimilación de nutrientes
#K4 = tasa de mortalidad de la población

#ECUACIONES
#dC = (Ci + Ce) - B*C*K2 
#dO = (Oi + Oe - Os)*K1 - B*C*K2
#dB = B*C*K3 - B*K4 

#DUDAS!
#- no se si seria necesario haber 3 ecuaciones o solamente 2;
#- no se si hice bien en poner condiciones iniciales para C y O, ya que en el mode-
#lo, yo considero Ce (mat. organica presente en el río) y Oe (OD del río)
#- no se si el modelo es representativo y esta correcto.

#---------------------------------------------------------------------------------------#

#paquetes
using DifferentialEquations
using Plots

#Dinamica de poblacion con nutrientes determinística

#ECUACIONES
#da = vector de derivadas; a = vector de variables (tiempo t); p = vector de parametros
function deterministica(da, a, p, t) 
    C, O, B = a 
    Ci, Ce, Oi, Oe, Os, K1, K3, K4 = p 

    dC = (Ci + Ce) - B * C * K2
    dO = (Oi + Oe - Os) * K1 - B * C * K2
    dB = B * C * K3 - B * K4

    da[1] = dC #armaceno C en da[1]
    da[2] = dO #armaceno 0 en da[2]
    da[3] = dB #armaceno B en da[3]
end

#DEFINO CONDICIONES INICIALES
C0 = 1.0
O0 = 7.0
B0 = 10.0

#CONDICIONES INICIALES
a0 = [C0, O0, B0]

#DEFINO PARAMETROS 
Ci = 80.0     #Ci = carga organica que ingresa con descarte de efluente mg/L
Ce = 5.0      #Ce = carga organica ya presente en el río mg/L
Oi = 1.0      #Oi = oxígeno disuelto que ingresa con el descarte de efluente mg/L
Oe = 5.0      #Oe = oxígeno disuelto presente en el río mg/L
Os = 9.2      #Os = oxígeno de saturación mg/L
K1 = 0.7      #K1 = tasa de reoxigenación (depende del tipo de cuerpo de agua) t^-1
K2 = 0.4      #K2 = tasa de desoxigenación (depende del tipo de descarte) t^-1
K3 = 0.3      #K3 = tasa de asimilación de nutrientes t^-1
K4 = 0.5      #K4 = tasa de mortalidad de la población t^-1

#PARAMETROS
p = [Ci, Ce, Oi, Oe, Os, K1, K2, K3, K4]

#TIEMPO
tfinal = 100.0
tspan = (0.0, tfinal)  # tiempo va de 0 a tfinal

#RESOLUCIÓN ODE
prob = ODEProblem(deterministica, a0, tspan, p)
sol = solve(prob) #contine soluciones en diferentes puntos del tiempo

# EXTRAIR SOLUCIONES EN EL TIEMPO 
#ni idea de porque lo tuve que usar. Sin eso, no andava mi codigo
t = sol.t
C = sol[1, :]  # Variável C
O = sol[2, :]  # Variável O
B = sol[3, :]  # Variável B

# PLOTAR GRAFICOS 
plot(t, C, label="Carga Orgânica", xlabel="Tempo", ylabel="Valor")
plot!(t, O, label="Oxigênio Dissolvido")
plot!(t, B, label="População de Bactérias")

#---------------------------------------------------------------------------------------#

#Dinamica de poblacion con nutrientes estocástica

#(EL DE LA CLASE (sin usar ODEProblem y solve))
#* dN = a - b N P - e N
#* dP = c N P - d P 

#function nutri_phyto_sto(par,ini,tfinal)    
#    a , b , e, c, d  = par                       # desempaquetamos los parámetros
#    N1,P1  = ini                                 # desempaquetamos los valores iniciales
#    N = Float64[N1]                              # Forzamos variable a Float64 (numero real)
#    P = Float64[P1]
#    ts  = [0.0]
#    i = 1
#    t = 0.0
#    while t <= tfinal
#       
#        Bn = a
#        Dn = b*N[i]*P[i] + e * N[i]
#        Bp = c * N[i]*P[i]
#        Dp = d* P[i]
#        R = Bn + Dn + Bp + Dp 
#        t = ts[i] - log(rand()) / R
#        rnd = rand()
#        if rnd < Bn/R                   # probabilidad de nacimiento 
#            N1 = N[i] + 1
#        elseif rnd < (Bn+Dn)/ R
#            N1 = N[i] - 1
#        elseif rnd <  (Bn+Dn+Bp)/ R
#            P1 = P[i] + 1
#        else
#            P1 = P[i] - 1 
#        end
#        if P1<= 0.0
#            P1 = 0.0 
#        end
#        if N1<= 0.0
#            N1 = 0.0 
#        end
#
#        i += 1                  
#        push!(N, N1)
#        push!(P, P1)
#        push!(ts,t)
#    end
#    return ts,N,P
#end