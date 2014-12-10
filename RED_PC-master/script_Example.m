% script - Example
% Definition by quadrant
%

clear all
close all
clc

s = cputime;

M = csvread('Localidades.csv', 1, 2);
M = M(:,1:3);

% definition of the quadrant to evaluate
maxLat = 28;
minLat = 23;

maxLon = -98;
minLon = -101;

LAT = M(:,2);
LON = M(:,3);
POBLACION = M(:,1);

LAT = LAT(LAT>=minLat);
LON = LON(LAT>=minLat);
LAT = LAT(LAT<=maxLat);
LON = LON(LAT<=maxLat);

LAT = LAT(LON>=minLon);
LON = LON(LON>=minLon);
LAT = LAT(LON<=maxLon);
LON = LON(LON<=maxLon);

k = 10; % Connectivity parameter for Dysart-Georganas

n = length(LAT);
D = zeros(n);

fprintf('\nSe van a calcular distancias para %d nodos.', n);

for i = 1:n
    for j=i:n
            D(i,j) = distance(LAT(i), LON(i), LAT(j), LON(j));
    end
end

s = cputime - s;

save MAT_quadrantDistance;

fprintf('\n\tMatriz de distancias estimada. Tiempo de computo: %f seg. \n',s);

% Nodes algorithm - Dysart-Georganas
[nodos concentrador v freqs] = ...
    dysartGeorganas(k, (1:n)', D);

aux1 = sum(concentrador);
fprintf('\nTermino el algoritmo de Dysart-Georganas.');
fprintf('\n\tExisten %d candidatos a ser nodos principales', aux1);
fprintf('\n\tEl parametro de conectividad es k = %d\n',k);

% Nodes algorithm - Esau-Williams
Cindx = nodos(concentrador==true);
nC = length(Cindx); % main nodes' total.

[K] = esauWilliams(D, Cindx(1), nodos);

% Accurate graphics!

LATc = LAT(concentrador==true);
LONc = LON(concentrador==true);

LATnc = LAT(concentrador==false);
LONnc = LON(concentrador==false);

%%
figure(1)
worldmap('Mexico')
%worldmap([minLat-1.5 maxLat+1.5],[minLon-1.5 maxLon+1.5]);
load coast
plotm(lat,long)

title('Mexico - Guanajuato')
h = plotm(LAT,LON,'linestyle','o','Color','b');
set(h, 'MarkerSize',3);
grid on
%% 
figure(2)
%worldmap('Mexico')
worldmap([minLat-1.5 maxLat+1.5],[minLon-1.5 maxLon+1.5]);
load coast
plotm(lat,long)

title('Mexico - K=10')
h = plotm(LATnc,LONnc,'linestyle','-','Color','k');
set(h, 'MarkerSize',3);
h2 = plotm(LATc,LONc,'linestyle','o','Color','r');
set(h2, 'MarkerSize',4);

%% para Monterrey

mLat = 25.6488;
mLon = -100.3031;
%textm(mLat,mLon, 'Monterrey');
h2 = plotm(mLat,mLon,'linestyle','o','Color','c');
set(h2, 'MarkerSize',4);

%% poblaciones de mas de 100,000 habitantes

concentradorPonderado = concentrador(POBLACION>=10000);

LATcpnd = LAT(concentradorPonderado==true);
LONcpnd = LON(concentradorPonderado==true);

LATncpnd = LAT(concentradorPonderado==false);
LONncpnd = LON(concentradorPonderado==false);

h = plotm(LATcpnd,LONcpnd,'linestyle','*','Color','m');
set(h, 'MarkerSize',4);
