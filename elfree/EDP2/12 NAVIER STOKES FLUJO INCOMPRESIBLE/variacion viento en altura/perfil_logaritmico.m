function [uo_hz, L] = perfil_logaritmico (hz, ea, cep, uo_10m)

global k z0

L = 0; %Inicializamos la variable L

switch(ea)
    case {'I','i'}
        switch(cep) 
            case {'A','a'} %Extremadamente inestable
                a = -0.096;
                b = 0.029;
            case {'B', 'b'} %Moderadamente inestable 
                a = -0.037;
                b = 0.025;
            case {'C', 'c'} %Ligeramente inestable
                a = -0.002;
                b = 0.018;
            otherwise
                disp('ERROR en la elección de la CEP (I)');
        end %Fin del switch que comprueba la CEP: Clase de estabilidad de Pasquill
		
		%Longitud de Monin-Obukhov
		L = 1/(a + b*log10(z0));
        
		%Imponemos la condición: uo(10m) = uo_10m m/s
		nur_h = (1-15*10./L)^0.25;
		nuo = (1-15*z0/L)^0.25;
		
		%Cálculo de la velocidad de fricción 
		u = (uo_10m*k) / (log(10./z0) + 2*(atan(nur_h)-atan(nuo)) + ...
			log(((nuo^2+1)*(nuo+1)^2)/((nur_h^2+1)*(nur_h+1)^2)));
		
		%Cálculo del perfíl logarítmico del viento 
		nur = (1-15*hz/L)^0.25;
		
		uo_hz = (u/k) * (log(hz/z0) + 2*(atan(nur)-atan(nuo)) + ...
			log(((nuo^2+1)*(nuo+1)^2)/((nur^2+1)*(nur_h+1)^2)));     
        
    case {'N', 'n'}
        %Imponemos la condición: uo(10m) = uo_10m m/s
		%Cálculo de la velocidad de fricción
		u = (uo_10m*k)/(log(10./z0));
		
		%Cálculo del perfíl logarítmico del viento
		uo_hz = (u/k)*(log(hz/z0));
  
    case {'E', 'e'}
        switch (cep)
            case {'E', 'e'} %Ligeramente estable
                a = 0.004;
                b = -0.018;
            case {'F', 'f'} %Moderadamente estable
                a = 0.035;
                b = -0.0365;
            otherwise
                disp('ERROR en la elección de la CEP (E)');
        end %Fin del switch que comprueba la CEP:  Clase de estabilidad de Pasquill
		
		%Longitud de Monin-Obukhov
		L = 1/(a + b*log10(z0));
		        
		%Imponemos la condición: uo(10 m) = uo_10m m/s 
        %Cálculo de la velocidad de fricción
		u = (uo_10m*k)/(log(10./z0)+(4.7/L)*(10.-z0));

		%Cálculo del perfíl logarítmico del viento
		uo_hz = (u/k)*(log(hz/z0)+(4.7/L)*(hz-z0));
        
    otherwise
        disp('ERROR en la elección de la estabilidad atmosférica');
end %Fin del switch que comprueba la estabilidad atmosférica    
    
end