function [ea, cep] = CEPasquill(viento)

global insolac fracnub

if viento ~= 0
    if insolac ~= 0
        if insolac <= 350
            %Radiación Solar Débil (<= 350 W/m^2) 
            if viento < 2.057776
                ea = 'I';
                cep = 'B';
            else
                if viento < 5.14444
                    ea = 'I';
                    cep = 'C';
                else
                    ea = 'N';
                    cep = 'D';
                end
            end
        elseif insolac < 700
            %Radiación Solar Moderada (> 350 W/m^2 && < 700 W/m^2)
            if viento < 1.028888
                ea = 'I';
                cep = 'A';
            else
                if viento < 4.115552
                    ea = 'I';
                    cep = 'B';
                else
                    if viento < 6.173328
                        ea = 'I';
                        cep = 'C';
                    else
                        ea = 'N';
                        cep = 'D';
                    end
                end
            end
        else
            %Radiación Solar Fuerte (>= 700 W/m^2) 
            if viento < 3.086664
                ea = 'I';
                cep = 'A';
            else
                if viento < 5.14444
                    ea = 'I';
                    cep = 'B';
                else
                    ea = 'I';
                    cep = 'C';
                end
            end
        end
    else
        %Noche (desde una hora antes de ponerse el sol hasta
        %una hora después de salir el sol 
        if fracnub < 0.5
            if viento < 3.601108
                ea = 'E';
                cep = 'F';
            else
                if viento < 5.14444
                    ea = 'E';
                    cep = 'E';
                else
                    ea = 'N';
                    cep = 'D';
                end
            end
        else
            if viento < 2.057776
                ea = 'E';
                cep = 'F';
				
            else
                if viento < 3.601108
                    ea = 'E';
                    cep = 'E';					
                else
                    ea = 'N';
                    cep = 'D';
                end
            end
        end
    end
else
    disp('ERROR- No se ha podido estimar un valor válido');
	disp(' para la Clase de Estabilidad de Pasquill: v = 0 m/s');
end
    
end