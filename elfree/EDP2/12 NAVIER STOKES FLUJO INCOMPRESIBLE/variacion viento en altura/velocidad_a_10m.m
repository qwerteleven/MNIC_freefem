function [uo_10m] = velocidad_a_10m()

global k h uo_h insolac fracnub z0

if insolac ~= 0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Clase de Estabilidad de Pasquill A
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    %Longitud de Monin-Obukhov 
	a = -0.096;
	b = 0.029;
	L = 1/(a + b*log10(z0));
		
	%Imponemos la condición: uo(h) = u0_h m/s
	nur_h =(1-15*h/L)^0.25;
	nuo = (1-15*z0/L)^0.25;
	
	%Cálculo de la velocidad de fricción
	u = (uo_h*k) / (log(h/z0) + 2*(atan(nur_h)-atan(nuo)) + ...
        log(((nuo*nuo+1)*(nuo+1)^2)/((nur_h*nur_h+1)*(nur_h+1)^2)));
	
	%Cálculo del perfíl logarítmico del viento
	nur_10m = (1-15*10./L)^0.25;		
	uo(1) = (u/k) * (log(10./z0) + 2*(atan(nur_10m)-atan(nuo)) + ...
        log(((nuo*nuo+1)*(nuo+1)^2)/((nur_10m*nur_10m+1)*(nur_10m+1)^2)));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Clase de Estabilidad de Pasquill B
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	%Longitud de Monin-Obukhov 
    a = -0.037;
    b = 0.029;
    L = 1/(a + b*log10(z0));
		
	%Imponemos la condición: uo(h) = U0_h m/s
    nur_h = (1-15*h/L)^0.25;
    nuo = (1-15*z0/L)^0.25;
	
	%Cálculo de la velocidad de fricción 
    u = (uo_h*k) / (log(h/z0) + 2*(atan(nur_h)-atan(nuo)) + ...
        log(((nuo*nuo+1)*(nuo+1)^2)/((nur_h*nur_h+1)*(nur_h+1)^2)));
	
	%Cálculo del perfíl logarítmico del viento
    nur_10m = (1-15*10./L)^0.25;		
	uo(2) = (u/k) * (log(10./z0) + 2*(atan(nur_10m)-atan(nuo)) + ...
        log(((nuo*nuo+1)*(nuo+1)^2)/((nur_10m*nur_10m+1)*(nur_10m+1)^2)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Clase de Estabilidad de Pasquill C
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    %Longitud de Monin-Obukhov
    a = -0.002;
    b = 0.018;
    L = 1/(a + b*log10(z0));
		
	%Imponemos la condición: uo(h) = U0_h m/s
    nur_h = (1-15*h/L)^0.25;
    nuo = (1-15*z0/L)^0.25;
	
	%Cálculo de la velocidad de fricción 
    u = (uo_h*k) / (log(h/z0) + 2*(atan(nur_h)-atan(nuo)) + ...
        log(((nuo*nuo+1)*(nuo+1)^2)/((nur_h*nur_h+1)*(nur_h+1)^2)));
	
	%Cálculo del perfíl logarítmico del viento
    nur_10m	= (1-15*10./L)^0.25;
    uo(3) = (u/k) * (log(10./z0) + 2*(atan(nur_10m)-atan(nuo)) + ...
        log(((nuo*nuo+1)*(nuo+1)^2)/((nur_10m*nur_10m+1)*(nur_10m+1)^2)));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Clase de Estabilidad de Pasquill D 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	%Imponemos la condición: uo(h) = u0_h m/s
    %Cálculo de la velocidad de fricción
    u = (uo_h*k)/(log(h/z0));
		
	%Cálculo del perfíl logarítmico del viento
    uo(4) = (u/k)*(log(10./z0));

    if insolac <= 350 
        %Radiación Solar Débil (<= 350 W/m^2)
        if uo(2) < 2.057776
            uo_10m = uo(2);
        else
            if uo(3) < 5.14444
                uo_10m = uo(3);
            else
                if uo(4) >= 5.14444
                    uo_10m = uo(4);
                else
                   disp('ERROR - calculando la velocidad del viento a 10m. sobre el suelo')
                end
            end
        end
    elseif insolac < 700
        %Radiación Solar Moderada (> 350 W/m^2 && < 700 W/m^2)
        if uo(1) < 1.028888
            uo_10m = uo(1);
        else
            if uo(2) < 4.115552
                uo_10m = uo(2);
            else
                if uo(3) < 6.173328
                    uo_10m = uo(3);
                else
                    if uo(4) >= 6.173328
                        uo_10m = uo(4);
                    else
                        disp('ERROR - calculando la velocidad del viento a 10m. sobre el suelo');
                    end
                end
            end
        end
    else
        %Radiación Solar Fuerte (>= 700 W/m^2)
        if uo(1) < 3.086664
            uo_10m = uo(1);
        else
            if uo(2) < 5.14444
                uo_10m = uo(2);
            else
                if uo(3) >= 5.14444
                    uo_10m = uo(3);
                else
                    disp('ERROR - calculando la velocidad del viento a 10m. sobre el suelo');
                end
            end
        end
    end
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Clase de Estabilidad de Pasquill D 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Imponemos la condición: uo(h) = u0_h m/s 
    %Cálculo de la velocidad de fricción
    u = (uo_h*k)/(log(h/z0));
	
    %Cálculo del perfíl logarítmico del viento
    uo(4) = (u/k)*(log(10./z0));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Clase de Estabilidad de Pasquill E 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    %Longitud de Monin-Obukhov
    a = 0.004;
    b = -0.018;
    L = 1/(a + b*log10(z0));
	
    %Imponemos la condición: uo(h) = u0_h m/s
    %Cálculo de la velocidad de fricción
    u = (uo_h*k)/(log(h/z0)+(4.7/L)*(h-z0));
	
    %Cálculo del perfíl logarítmico del viento
    uo(5) = (u/k)*(log(10./z0)+(4.7/L)*(10.-z0));
	
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Clase de Estabilidad de Pasquill F
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    %Longitud de Monin-Obukhov
    a = 0.035;
    b = -0.036;
    L = 1/(a + b*log10(z0));
	
    %Imponemos la condición: uo(h) = u0_h m/s
    %Cálculo de la velocidad de fricción
    u = (uo_h*k)/(log(h/z0)+(4.7/L)*(h-z0));
	
    %Cálculo del perfíl logarítmico del viento
    uo(6) = (u/k)*(log(10./z0)+(4.7/L)*(10.-z0));
	
    %Noche (desde una hora antes de ponerse el sol hasta
    %una hora después de salir el sol
    if fracnub < 0.5
        if uo(6) < 3.601108
            uo_10m = uo(6);
        else
            if uo(5) < 5.14444
                uo_10m = uo(5);
            else
                if uo(4) >= 5.14444
                    uo_10m = uo(4);
                else
                    disp('printf("\n\nERROR - calculando la velocidad del viento a 10m. sobre el suelo');
                end
            end
        end
    else
        if uo(6) < 2.057776
            uo_10m = uo(6);
        else
            if uo(5) < 3.601108
                uo_10m = uo(5);
            else
                if uo(4) >= 3.601108
                    uo_10m = uo(4);
                else
                    disp('ERROR - calculando la velocidad del viento a 10m. sobre el suelo');
                end
            end
        end
    end
end

end