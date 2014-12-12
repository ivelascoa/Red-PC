HERMOSILLO = [29.0814 -110.98899];
HERMOSILLO_group = GROUPS_51(LAT==HERMOSILLO(1));
nodes_HERMOSILLO = IDS(GROUPS_51==HERMOSILLO_group);
Lat_HERMOSILLO = LAT(GROUPS_51==HERMOSILLO_group);
Lon_HERMOSILLO = LON(GROUPS_51==HERMOSILLO_group);
n_HERMOSILLO = length(nodes_HERMOSILLO);
output_HERMOSILLO = zeros(n_HERMOSILLO^2,7);

count=1;
aux = zeros(n_HERMOSILLO^2,1);

for i=1:n_HERMOSILLO
    for j=i:n_HERMOSILLO
        if i~=j
            output_HERMOSILLO(count, :) = ...
                [nodes_HERMOSILLO(i) nodes_HERMOSILLO(j)...
                Lat_HERMOSILLO(i) Lon_HERMOSILLO(i) ...
                Lat_HERMOSILLO(j) Lon_HERMOSILLO(j) 0];
            aux(count) = 1;
            count = count+1;
        end
    end
end

output_HERMOSILLO = output_HERMOSILLO(aux==1,:);
str = strcat('HERMOSILLO_grupo.csv');
csvwrite(str,output_HERMOSILLO);