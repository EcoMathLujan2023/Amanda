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
function deterministica(du, u, p, t) 
    C, O, B = u
    Ci, Ce, Omax, k1, k2, k3, k4, k5 = p 
    
    dC = (Ci + Ce) - k1 * C * B                   #variación Streeter-Phelps
    dO = k2 * C * (Omax - O) / (k2 + C) - k3 * C  #Michaelis-Menten kinetics
    dB = C * k4 - B * k5 
    #dB = (k4 * B * (1 - (B/k5))) - (k6 * B)      #crescimiento logistico con mortalidad?

    du[1] = dC #armaceno C en du[1]
    du[2] = dO #armaceno 0 en du[2]
    du[3] = dB #armaceno B en du[3]
end

#DEFINO CONDICIONES INICIALES
C0 = 5.0
O0 = 5.0
B0 = 0.5

#CONDICIONES INICIALES
u0 = [C0, O0, B0]

#DEFINO PARAMETROS 
Ci = 10.0     #Ci = carga organica que ingresa con descarte de efluente mg/L
Ce = 5.0      #Ce = carga organica ya presente en el río mg/L
Omax = 9.2    # O2 saturación mg/L
k1 = 0.8      #Tasa de consumo de carga organica por las bacterias
k2 = 0.5      #Tasa de produccion de oxígeno 
k3 = 0.2      #Tasa de consumo de oxígeno devido a la decomposición carga org.
k4 = 0.5      #Tasa de crescimiento de las bacterias decompositoras por la disponibilidad de carga org.
k5 = 0.4      #Tasa de capacidad de soporte de las bacterias en el ambiente - crescimiento maximo
#k6 = 0.1      #si uso crescimiento logístico: Tasa de mortalidad de las bacterias

#PARAMETROS
p = [Ci, Ce, Omax, k1, k2, k3, k4, k5] #, k6 (si incluo mortalidad)

#TIEMPO
tfinal = 10.0
tspan = (0.0, tfinal)  # tiempo va de 0 a tfinal

#RESOLUCIÓN ODE
prob = ODEProblem(deterministica, u0, tspan, p)
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