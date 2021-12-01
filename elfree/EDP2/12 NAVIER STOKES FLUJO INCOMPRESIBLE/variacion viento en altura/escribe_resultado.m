function escribe_resultado(ea, L, hz, u0_hz)

global theta

switch(ea)
    case {'I','i'}
        nur = (1-15*hz/L)^0.25;
        str = sprintf('%0.3f %0.3f %0.3f %0.3f %0.3f', ...
            hz, nur, u0_hz, u0_hz*cos(theta), u0_hz*sin(theta)); 
        disp(str)
        
    case {'N', 'n'}
        str = sprintf('%0.3f %0.3f %0.3f %0.3f', ...
            hz, u0_hz, u0_hz*cos(theta), u0_hz*sin(theta)); 
        disp(str)
  
    case {'E', 'e'}
        str = sprintf('%0.3f %0.3f %0.3f %0.3f', ...
            hz, u0_hz, u0_hz*cos(theta), u0_hz*sin(theta)); 
        disp(str)
                
    otherwise
        disp('ERROR en la elección de la estabilidad atmosférica');
end %Fin del switch que comprueba la estabilidad atmosférica    

end