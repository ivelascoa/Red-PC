% script_fullChihuahua.m
%
% Computes:
% - Matrix for Chihuahua group.
% - Dysart-Georganas algorithm.
% - Steiglitz-Weiner-Kleitman algorithm for Dysart's 
%   concentrators (along with Chihuahua city)
% - Plot of group, with connected concentrators.
% 

clear all
close all
clc

load MAT_CHIH
load MAT_fullDistance

% Parameters
k = 3; % Connectivity for Dysart-Georganas
R = 3; % Redundancy for Steiglitz-Weiner-Kleitman
minpop = 10000; % min population to be concentrator
%

POBch = POB(nodes_CHIH);

[nodos concentrador v freqs] = ...
    dysartGeorganas(k, nodes_CHIH, dist_CHIH);

% force Chihuahua City into the main nodes.
concentrador(LAT(nodes_CHIH)==CHIH(1)) = true;
concentrador(POBch<=minpop) = false;

Dc = dist_CHIH(concentrador==true, concentrador==true);
%
[Kc, totDist, defi, permi] = ...
    steiglitzWeinerKleitman1(Dc, concentrador, ...
                           nodes_CHIH, R, 1000);

[groupindx, numberOfGroups] = buildSubgroups(concentrador,...
                                             nodes_CHIH,...
                                             dist_CHIH);
CM_CHIH = zeros(size(dist_CHIH)); % full conectivity matrix.
concentrators = nodes_CHIH(concentrador==true);

localindx = 1:length(nodes_CHIH);
for i=1:numberOfGroups
    Dindx = dist_CHIH(groupindx==i,groupindx==i);
    Nindx = nodes_CHIH(groupindx==i);
    Cindx = concentrators(i);
    
    Kret = esauWilliams(Dindx, Cindx, Nindx);
    CM_CHIH(groupindx==i,groupindx==i) = Kret;
end

% FULL CONECTIVITY MATRIX!!
CM_CHIH(concentrador==true, concentrador==true) = Kc;

cell_CHIH  = toCell(NOMBRES(nodes_CHIH), CM_CHIH, 'Matriz-Chihuahua.csv');

                            
% Plot
clc
% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

% LatLong discriminated by concentrators
LATc = LAT(nodes_CHIH(concentrador==true));
LONc = LON(nodes_CHIH(concentrador==true));

LATnc = LAT(nodes_CHIH(concentrador==false));
LONnc = LON(nodes_CHIH(concentrador==false));

LATch = LAT(nodes_CHIH);
LONch = LON(nodes_CHIH);

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico - CHIHUAHUA');

n = length(nodes_CHIH);

for i=1:n
    for j=1:n
        if CM_CHIH(i,j)~=0
            h = plotm([LATch(i) LONch(i); LATch(j) LONch(j)],...
                'o-','Color','b');
            set(h, 'MarkerSize',marker);
        end
    end
end

nc = sum(concentrador);
I = [];

for i=1:nc
    for j=1:nc
        if Kc(i,j)~=0
            I = [I;i j];
            h = plotm([LATc(i) LONc(i); LATc(j) LONc(j)],...
                '*-','Color','m');
            set(h, 'MarkerSize',bigmarker);
        end
    end
end

%textm(CHIH(1), CHIH(2), 'Chihuahua');
textm(LATc,LONc, NOMBRES(nodes_CHIH(concentrador==true)));

h = plotm(LATnc, LONnc,...
    'linestyle','o','Color','b');
set(h, 'MarkerSize',marker);

h = plotm([LATc(nc) LONc(nc); LATc(1) LONc(1)],...
           '*-','Color','m');
set(h, 'MarkerSize',bigmarker);

h = plotm(CHIH,...
    'linestyle','o','Color','k');
set(h, 'MarkerSize',bigmarker);

