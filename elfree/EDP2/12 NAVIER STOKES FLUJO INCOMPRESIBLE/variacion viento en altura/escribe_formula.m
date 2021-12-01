function escribe_formula(ea, cep)

global k h uo_h z0

switch(ea)
    case {'I','i'}     				      
        %Perfíl logarítmico del viento 
        disp('Perfíl logarítmico del viento (Condiciones atmosféricas inestables)');
 		disp('uo_hz = (u/k) * (log(hz/z0) + 2*(atan(nur)-atan(nu0)) +')
 		disp('   log(((nu0^2+1)*(nu0+1)^2)/((nur^2+1)*(nur+1)^2)))')
        disp('donde:')
        str = sprintf('k = %0.1f', k);
        disp(str);
        str = sprintf('z0 = %f', z0);
        disp(str);
        disp('nur = (1-15*hz/L)^0.25')
        disp('nu0 = (1-15*z0/L)^0.25')
        
        %Longitud de Monin-Obukhov
        switch(cep) 
            case {'A','a'} %Extremadamente inestable
                a = -0.096;
                b = 0.029;
                
                str = sprintf('\nAtmósfera extremadamente inestable\n');
                disp(str);
            case {'B', 'b'} %Moderadamente inestable 
                a = -0.037;
                b = 0.025;
                
                str = sprintf('\nAtmósfera moderadamente inestable\n');
                disp(str);
            case {'C', 'c'} %Ligeramente inestable
                a = -0.002;
                b = 0.018;
                
                str = sprintf('\nAtmósfera ligeramente inestable\n');
                disp(str);
            otherwise
                disp('ERROR en la elección de la CEP (I)');
        end %Fin del switch que comprueba la CEP: Clase de estabilidad de Pasquill
        
        disp('Longitud de Monin-Obukhov:')
		L = 1/(a + b*log10(z0));
        disp('L = 1/(a + b*log10(z0))');
        str = sprintf('L = 1/(%0.4f+%0.4f*log10(%f))', a, b, z0);
        disp(str);
		str = sprintf('L = %f\n', L);
        disp(str);
        
        %Cálculo de la velocidad de fricción 
        disp('Cálculo de la velocidad de fricción (u):');
        str = sprintf('Imponemos la condición: hz = %f; uo_hz = %f, y despejamos:', ...
            h, uo_h);
        disp(str);
        disp('u = (uo_hz*k) / (log(hz/z0) + 2*(atan(nur)-atan(nu0)) +')
		disp('   log(((nu0^2+1)*(nu0+1)^2)/((nur^2+1)*(nur+1)^2)))')
        nur = (1-15*h/L)^0.25;
        str = sprintf('nur = %f', nur);
        disp(str);
        nuo = (1-15*z0/L)^0.25;
		str = sprintf('nu0 = %f', nuo);
        disp(str); 
		u = (uo_h*k) / (log(h/z0) + 2*(atan(nur)-atan(nuo)) + ...
			log(((nuo^2+1)*(nuo+1)^2)/((nur^2+1)*(nur+1)^2)));
        str = sprintf('u = %f\n', u);
        disp(str);      
		       
        disp(' hz    nur  uo_hz   uox    uoy')
        
    case {'N', 'n'}
        %Perfíl logarítmico del viento
		disp('Perfíl logarítmico del viento (Condiciones atmosféricas neutras)');
		disp('uo_hz = (u/k)*(log(hz/z0))')
        disp('donde:')
        str = sprintf('k = %0.1f', k);
        disp(str);
        str = sprintf('z0 = %f', z0);
        disp(str);
        
		%Cálculo de la velocidad de fricción
        str = sprintf('\nCálculo de la velocidad de fricción (u):');
        disp(str);
        str = sprintf('Imponemos la condición: hz = %f; uo_hz = %f, y despejamos:', ...
            h, uo_h);
        disp(str);
        disp('u = (uo_hz*k)/(log(hz/z0))')
		u = (uo_h*k)/(log(h/z0));
		str = sprintf('u = %f\n', u);
        disp(str);        
        
        disp(' hz   uo_hz   uox   uoy')
        
    case {'E', 'e'}
        %Perfíl logarítmico del viento 
        disp('Perfíl logarítmico del viento (Condiciones atmosféricas estables)');
        disp('uo_hz = (u/k)*(log(hz/z0)+(4.7/L)*(hz-z0));')
        disp('donde:')
        str = sprintf('k = %0.1f', k);
        disp(str);
        str = sprintf('z0 = %f', z0);
        disp(str);
        
        %Longitud de Monin-Obukhov
        switch (cep)
            case {'E', 'e'} %Ligeramente estable
                a = 0.004;
                b = -0.018;
                
                str = sprintf('\nAtmósfera ligeramente estable\n');
                disp(str);
            case {'F', 'f'} %Moderadamente estable
                a = 0.035;
                b = -0.0365;
                
                str = sprintf('\nAtmósfera moderadamente estable\n');
                disp(str);
            otherwise
                disp('ERROR en la elección de la CEP (E)');
        end %Fin del switch que comprueba la CEP:  Clase de estabilidad de Pasquill
		
		disp('Longitud de Monin-Obukhov:')
		L = 1/(a + b*log10(z0));
        disp('L = 1/(a + b*log10(z0))');
        str = sprintf('L = 1/(%0.4f+%0.4f*log10(%f))', a, b, z0);
        disp(str);
		str = sprintf('L = %f\n', L);
        disp(str);
         
        %Cálculo de la velocidad de fricción 
        disp('Cálculo de la velocidad de fricción (u):');
        str = sprintf('Imponemos la condición: hz = %f; uo_hz = %f, y despejamos:', ...
            h, uo_h);
        disp(str);
        disp('u = (uo_hz*k)/(log(hz/z0)+(4.7/L)*(hz-z0))')		
        u = (uo_h*k)/(log(h/z0)+(4.7/L)*(h-z0));
        str = sprintf('u = %f\n', u);
        disp(str); 

		disp(' hz   uo_hz   uox   uoy')
        
    otherwise
        disp('ERROR en la elección de la estabilidad atmosférica');
end %Fin del switch que comprueba la estabilidad atmosférica    

end