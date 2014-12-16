% script pruebas 2
% 




%% 

clear all
close all
clc

load MAT_fullDistance

n = length(GROUPS_51);
maxperGROUP = [];

for i=1:n
    indices = IDS(GROUPS_51==i);
    nidx = length(indices);
    
    if nidx > 1
        nodos = indices(nidx);
        lati = LAT(nodos);
        longi = LON(nodos);
        
        maxperGROUP = [maxperGROUP;[nodos lati longi]];
    end
end

%% 
m = 51;
count = 1;
aux = zeros(m^2,1);
output_51 = zeros(m^2,7);

for i=1:m
    for j=i:m
        if i~=j
            output_51(count, :) = ...
                [maxperGROUP(i,1) maxperGROUP(j,1)...
                maxperGROUP(i,2) maxperGROUP(i,3) ...
                maxperGROUP(j,2) maxperGROUP(j,3) 0];
            aux(count) = 1;
            count = count+1;
        end
    end
end

output_51 = output_51(aux==1,:);
str = strcat('CiudadesPrincipales_51_grupo.csv');
csvwrite(str,output_51);

%% build main network - "51 groups"

clear all
close all
clc

cd ./PYTHON/

CSV_51 = csvread('Distance_CiudadesPrincipales_51_grupo.csv',...
                0,1);
cd ..

nodes_51 = unique([CSV_51(:,1);CSV_51(:,2)]);
n_51 = length(nodes_51);
dist_51 = zeros(n_51);

count = 1;

for i=1:n_51
    for j=i:n_51
        if i~=j
            dist_51(i,j) = CSV_51(count,7);
            count=count+1;
        end
    end
end
dist_51 = dist_51 + dist_51';

clear count i j;

save MAT_51CITIES

%%  build main network - "51 groups"

load MAT_51CITIES
load MAT_fullDistance

%parameters
R = 2;

concentrador = ones(size(nodes_51));

[Kc, tD] = steiglitzWeinerKleitman1(...
                dist_51, concentrador,nodes_51, R, 100);
% PLOT
LATc = LAT(nodes_51);
LONc = LON(nodes_51);

NOMc = NOMBRES(nodes_51);

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Red Principal - 51 Ciudades');

nc = sum(concentrador);

for i=1:nc
    for j=1:nc
        if Kc(i,j)~=0
            h = plotm([LATc(i) LONc(i); LATc(j) LONc(j)],...
                'o-','Color','m');
            set(h, 'MarkerSize',5);
        end
    end
end

%textm(LATc, LONc, NOMc);



