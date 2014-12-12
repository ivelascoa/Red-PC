CANCUN = [21.1214 -86.85588];
CANCUN_group = GROUPS_51(LAT==CANCUN(1));
nodes_CANCUN = IDS(GROUPS_51==CANCUN_group);
Lat_CANCUN = LAT(GROUPS_51==CANCUN_group);
Lon_CANCUN = LON(GROUPS_51==CANCUN_group);
n_CANCUN = length(nodes_CANCUN);
output_CANCUN = zeros(n_CANCUN^2,7);

count=1;
aux = zeros(n_CANCUN^2,1);

for i=1:n_CANCUN
    for j=i:n_CANCUN
        if i~=j
            output_CANCUN(count, :) = ...
                [nodes_CANCUN(i) nodes_CANCUN(j)...
                Lat_CANCUN(i) Lon_CANCUN(i) ...
                Lat_CANCUN(j) Lon_CANCUN(j) 0];
            aux(count) = 1;
            count = count+1;
        end
    end
end

output_CANCUN = output_CANCUN(aux==1,:);
str = strcat('CancunMerida_grupo.csv');
csvwrite(str,output_CANCUN);