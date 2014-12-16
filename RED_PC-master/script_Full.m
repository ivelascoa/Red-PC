% Script: Full program
%
% Description: Full implementation of the program that generates the
% Distance Matrix, taking into account great circle distances (as the crow
% flies).
%

%% Getting the full distance Matrix.
clear all
close all
clc

s = cputime;

M = csvread('Localidades.csv', 1, 2);
M = M(:,1:3);

LAT = M(:,2);
LON = M(:,3);

n = max(size(M));
D = zeros(n);

for i = 1:n
    for j=i:n
        D(i,j) = distance(LAT(i), LON(i), LAT(j), LON(j));
    end
end

D = D + D';

s = cputime - s;

save MAT_fullDistance;

display('Listo, tiempo de computo (en segundos):');
display(s);

%% Getting a partial distance matrix (only 300 entries)

clear all
close all
clc

s = cputime;

M = csvread('Localidades.csv', 1, 2);
M = M(1:300,1:3);
LAT = M(:,2);
LON = M(:,3);
 
n = 300; %max(size(M));
D = zeros(n);

for i = 1:n
    for j=i:n
            D(i,j) = distance(LAT(i), LON(i), LAT(j), LON(j));
    end
end

D = D + D';

s = cputime - s;

save MAT_partialDistance;

display('Listo, tiempo de computo (en segundos):');
display(s);

%% Definition by quadrant
clear all
close all
clc

s = cputime;

M = csvread('Localidades.csv', 1, 2);
M = M(:,1:3);

% definition of the quadrant to evaluate
maxLat = 27;
minLat = 23;

maxLon = -103;
minLon = -107;
%

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

%% Nodes algorithm - Dysart-Georganas

[nodos concentrador v freqs] = ...
    dysartGeorganas(10, (1:n)', D);

POBLACION = M(:,1);

concentradorPonderado = concentrador(POBLACION>=1000000);

% Nodes algorithm - Esau-Williams
Cindx = nodos(concentrador==true);
nC = length(Cindx); % main nodes' total.

%[K] = esauWilliams(D, Cindx(1), nodos);

% Accurate graphics!

LATc = LAT(concentradorPonderado==true);
LONc = LON(concentradorPonderado==true);

LATnc = LAT(concentrador==false);
LONnc = LON(concentrador==false);

figure(2)
worldmap('Mexico')
%worldmap([minLat-0.5 maxLat+0.5],[minLon-0.5 maxLon+0.5]);
load coast
plotm(lat,long)

title('Mexico')
h = plotm(LATnc,LONnc,'linestyle','o','Color','k');
set(h, 'MarkerSize',3);
h2 = plotm(LATc,LONc,'linestyle','*','Color','r');
set(h2, 'MarkerSize',3);

%% Graph all nodes
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico')
h = plotm(LAT,LON,'linestyle','o','Color','b');
set(h, 'MarkerSize',2);




