load mat_fullDistance;
[aux] = csvread('Matriz-51Ciudades(revTANIA)2.csv',1,1);
length(aux)
for i=1:length(aux)
    latitud = aux(:,1);
    longitud = aux(:,2);
    grupo(i) = GROUPS_51(LAT == latitud(i));
end
