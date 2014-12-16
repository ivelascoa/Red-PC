CdOBREGON = [27.48228 -109.94289];
CdOBREGON_group = GROUPS_51(LAT==CdOBREGON(1));
nodes_CdOBREGON = IDS(GROUPS_51==CdOBREGON_group);
Lat_CdOBREGON = LAT(GROUPS_51==CdOBREGON_group);
Lon_CdOBREGON = LON(GROUPS_51==CdOBREGON_group);
n_CdOBREGON = length(nodes_CdOBREGON);
output_CdOBREGON = zeros(n_CdOBREGON^2,7);

count=1;
aux = zeros(n_CdOBREGON^2,1);

for i=1:n_CdOBREGON
    for j=i:n_CdOBREGON
        if i~=j
            output_CdOBREGON(count, :) = ...
                [nodes_CdOBREGON(i) nodes_CdOBREGON(j)...
                Lat_CdOBREGON(i) Lon_CdOBREGON(i) ...
                Lat_CdOBREGON(j) Lon_CdOBREGON(j) 0];
            aux(count) = 1;
            count = count+1;
        end
    end
end

output_CdOBREGON = output_CdOBREGON(aux==1,:);
str = strcat('CdOBREGON_grupo.csv');
csvwrite(str,output_CdOBREGON);