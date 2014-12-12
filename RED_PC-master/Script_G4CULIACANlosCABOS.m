CULIACAN = [24.80522 -107.42297];
CULIACAN_group = GROUPS_51(LAT==CULIACAN(1));
nodes_CULIACAN = IDS(GROUPS_51==CULIACAN_group);
Lat_CULIACAN = LAT(GROUPS_51==CULIACAN_group);
Lon_CULIACAN = LON(GROUPS_51==CULIACAN_group);
n_CULIACAN = length(nodes_CULIACAN);
output_CULIACAN = zeros(n_CULIACAN^2,7);

count=1;
aux = zeros(n_CULIACAN^2,1);

for i=1:n_CULIACAN
    for j=i:n_CULIACAN
        if i~=j
            output_CULIACAN(count, :) = ...
                [nodes_CULIACAN(i) nodes_CULIACAN(j)...
                Lat_CULIACAN(i) Lon_CULIACAN(i) ...
                Lat_CULIACAN(j) Lon_CULIACAN(j) 0];
            aux(count) = 1;
            count = count+1;
        end
    end
end

output_CULIACAN = output_CULIACAN(aux==1,:);
str = strcat('CULIACAN_grupo.csv');
csvwrite(str,output_CULIACAN);