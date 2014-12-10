% script de pruebitas
%

%% Prueba de tabla de vecindades
clear all
clc

distanceMatrix = ...
    [0 3 5 4 3 4 7 8 13 11
    3 0 2 2 1 2 5 5 9 9
    5 2 0 2 2 3 6 5 9 11
    4 2 2 0 1 2 5 3 7 9
    3 1 2 1 0 1 4 4 8 8 
    4 2 3 2 1 0 3 3 7 7 
    7 5 6 5 4 3 0 1 5 4
    8 5 5 3 4 3 1 0 4 6
    13 9 9 7 8 7 5 4 0 2
    11 9 11 9 8 7 4 6 2 0];
nodos = (1:10)';
k = 3;

M = length(nodos);
freqs = zeros(M,1);

[vec I] = sort(distanceMatrix);
indx = I(1:k+1,:)';

for i=1:M
    freqs(i) = length(find(indx==i));
end

%% Prueba Dysart-Georganas

clear all
clc

k =3;
nodos = (1:10)';
distanceMatrix = ...
    [0 3 5 4 3 4 7 8 13 11
    3 0 2 2 1 2 5 5 9 9
    5 2 0 2 2 3 6 5 9 11
    4 2 2 0 1 2 5 3 7 9
    3 1 2 1 0 1 4 4 8 8 
    4 2 3 2 1 0 3 3 7 7 
    7 5 6 5 4 3 0 1 5 4
    8 5 5 3 4 3 1 0 4 6
    13 9 9 7 8 7 5 4 0 2
    11 9 11 9 8 7 4 6 2 0];

[nodos concentrador v freqs] = dysartGeorganas(k, nodos,...
                                         distanceMatrix);
                                     
% escocger concentrador: Cindx
% construir matriz para dicho concentrador: Dindx

%% Prueba Esau-W 1

clear all
close all
clc

D = [0 2 52 13 45 15 58 59
    2 0 52 14 43 16 58 62
    52 52 0 60 85 41 23 55
    13 14 60 0 50 18 72 50
    45 43 85 50 0 59 81 95
    15 16 41 18 59 0 55 42
    58 58 23 72 81 55 0 78
    59 62 55 50 95 42 78 0];
C = 1;
Nindx = (1:8)';

[K] = esauWilliams(D, C, Nindx);

                                     
%% 
clear all
close all
clc

s = cputime;

M = csvread('Localidades.csv', 1, 2);
M = M(:,1:3);

% definition of the quadrant to evaluate
maxLat = 27;
minLat = 22;

maxLon = -103;
minLon = -107;

LAT = M(:,2);
LON = M(:,3);

LAT = LAT(LAT>=minLat);
LON = LON(LAT>=minLat);
LAT = LAT(LAT<=maxLat);
LON = LON(LAT<=maxLat);

LAT = LAT(LON>=minLon);
LON = LON(LON>=minLon);
LAT = LAT(LON<=maxLon);
LON = LON(LON<=maxLon);

n = length(LAT);
D = zeros(n);

for i = 1:n
    for j=i:n
            D(i,j) = distance(LAT(i), LON(i), LAT(j), LON(j));
    end
end

s = cputime - s;

save MAT_quadrantDistance;

display('Listo, tiempo de computo (en segundos):');
display(s);
    

%% pruebas Steigltz

clear all 
close all
clc

distanceMatrix = ...
    [0 3 5 4 3 4 7 8 13 11
    3 0 2 2 1 2 5 5 9 9
    5 2 0 2 2 3 6 5 9 11
    4 2 2 0 1 2 5 3 7 9
    3 1 2 1 0 1 4 4 8 8 
    4 2 3 2 1 0 3 3 7 7 
    7 5 6 5 4 3 0 1 5 4
    8 5 5 3 4 3 1 0 4 6
    13 9 9 7 8 7 5 4 0 2
    11 9 11 9 8 7 4 6 2 0];

nodes = (1:10)';
pe = randperm(10);

%% K-means tries

load MAT_fullDistance

p = lla2ecef([LAT LON 6378100.*ones(size(LAT))]);

clusterNumber = 52;

% Resetting the seed
stream = RandStream.getGlobalStream;
reset(stream);

[cidx C] = kmeans(p, clusterNumber, 'Replicate', 5);

figure(3)
worldmap('Mexico')
load coast
plotm(lat,long)

str = strcat('Mexico - ', num2str(clusterNumber), ' groups.');
title(str)
for i=1:clusterNumber
    colour = 0.9.*[rand(1) rand(1) rand(1)];
    h = plotm(LAT(cidx==i),LON(cidx==i),...
        'linestyle','o','Color',colour);
    set(h, 'MarkerSize',4);
end

q = ecef2lla(C);

h = plotm(q(:,1),q(:,2),'linestyle','+', 'Color','k');
set(h,'MarkerSize',8);

%% Create real distances locations 
%
% 25.november.2014
%
% We're creating a CSV with the location (lat-lon) of towns.
% It will contain the locations that are really supposed to be
% computed with the Google Directions API. 
%
% It takes into account the distance matrix (D) in the
% MAT_fullDistance.mat file, taking its highest value and 
% dividing it by L, so that only the most realistic 
% distances-by-road are considered and requested in the 
% API.
%
clear all
close all
clc

load MAT_fullDistance.mat

L = 40; % change this to modify the highest distance considered. 
MAX_D = max(max(D))/L;

n = length(D);
OUT_M = zeros(n^2,7); % this will be the CSV!
aux = zeros(n^2,1);
count = 1;
for i=1:n
    for j=i:n
        if D(i,j) <= MAX_D && i~=j
            %                     |    start    |    finish   |                   
            %                     | LAT    LON  |  LAT    LON |
            OUT_M(count, :) = [i j M(i,2) M(i,3) M(j,2) M(j,3) 0];
            aux(count) = 1;
            count = count +1;
        end
    end
end

OUT_M = OUT_M(aux==1,:);

str = strcat('For_Python_',num2str(L),'.csv');
csvwrite(str,OUT_M);

realmaxDistance = deg2km(MAX_D);

