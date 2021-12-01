clc   % Clear Command Window.
clear % Clear variables and functions from memory.

%DATOS DEL PERFIL A CREAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global k h uo_h theta insolac fracnub z0

%altura h (en m) de la estación sobre el terreno,
h = 10
%velocidad del viento a h m sobre el terreno (en m/s),
uo_h = 4.0;
%ángulo (en grados) que forma el vector velocidad con el semieje OX, 
theta = 0;
%insolación solar (medida en W/m2), 
%[Ejemplo: En Las Palmas entre 3.1 (invierno) y 5.5 kWh/m2 (verano), 3.1x1000/5.8=535 y 5.5x1000/8.54=645]
%[Radiación Solar Débil (<= 350 W/m^2) -> nublado]
%[Radiación Solar Moderada (> 350 W/m^2 && < 700 W/m^2) -> despejado, nubes y claros]
%[Radiación Solar Fuerte (>= 700 W/m^2) -> insolación exterma]
insolac =0;
%fracción de nubes (solo por la noche, cuando la insolación es cero) (valor entre 0 y 1, por ejemplo 0.25), 
fracnub = 0.;
%y altura característica de rugosidad (en m). Aproximadamente igual a hprom/30, 
%siendo hprom = altura promediada de los obstáculos en la zona de estudio.
z0 = 2;
%Altura (en m) hasta la que se calcula el perfil verical del viento
hmax = 40;

%Distancia (en m) entre dos puntos consecutivos en la vertical
dhz = 1;
%Parámetro de Von Karman 
k = 0.41;	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calcular el número de puntos en que se realizan los cálculos
nmax = hmax/dhz;

%Pasar el ángulo (dado en grados) a radianes
theta = theta*pi/180;

%Calcular la velocidad del viento a 10 m sobre el suelo
if(abs(h-10) < 1.E-3)
    uo_10m = uo_h;
else
    uo_10m = velocidad_a_10m();
end

%Estimar la Clase de Estabilidad de Pasquill 
[EA, CEP] = CEPasquill(uo_10m);

%Determinar la fórmula del perfil logarítmico
escribe_formula(EA, CEP);
    
xx = zeros(nmax,1);
yy = zeros(nmax,1);
hz = zeros(nmax,1);
uox = zeros(nmax,1);
uoy = zeros(nmax,1);
uoz = zeros(nmax,1);
uo_hz = zeros(nmax,1);
for ii = 1:nmax
    %Altura en m.
    hz(ii) = ii*dhz;    

    %Valor del perfil logaritmico del viento en la capa actual 
    [uo_hz(ii), L] = perfil_logaritmico(hz(ii), EA, CEP, uo_10m);
	
    escribe_resultado(EA, L, hz(ii), uo_hz(ii));
    
    %Establecemos el valor del campo uo en la estación de
    %medida 'virtual' que está a altura 'hz' sobre el terreno 
    uox(ii) = uo_hz(ii) * cos(theta);
    uoy(ii) = uo_hz(ii) * sin(theta);
end

quiver3(xx,yy,hz,uox,uoy,uoz,'LineWidth',1.5)
title('Perfil logarítmico del viento'); 
xlabel('X'); ylabel('Y'); zlabel('Altura sobre el terreno (m)')


