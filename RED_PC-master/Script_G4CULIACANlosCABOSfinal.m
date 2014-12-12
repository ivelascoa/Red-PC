% script_G4CULIACANfinal.m
%
% Computes:
% - Matrix for CULIACAN group.
% - Dysart-Georganas algorithm.
% - Steiglitz-Weiner-Kleitman algorithm for Dysart's 
%   concentrators (along with CULIACAN and Los CABOScity)
% - Plot of group, with connected concentrators.
% 

clear all
close all
clc

load MAT_CULIACAN
load MAT_fullDistance

% Parameters
k = 4; % Connectivity for Dysart-Georganas
R = 3; % Redundancy for Steiglitz-Weiner-Kleitman
minpop = 20000; % min population to be concentrator
%

POB_CULIACAN = POB(nodes_CULIACAN);

[nodos concentrador v freqs] = ...
    dysartGeorganas(4, nodes_CULIACAN, dist_CULIACAN);

% force Culiacan and Los Cabos into the main nodes.
concentrador(LAT(nodes_CULIACAN)==CULIACAN(1)) = true;
concentrador(LAT(nodes_CULIACAN)==LosCABOS(1)) = true;
concentrador(POB_CULIACAN<=minpop) = false;

Dc = dist_CULIACAN(concentrador==true, ...
                concentrador==true);
%
[Kc, totDist, defi, permi] = ...
    steiglitzWeinerKleitman1(Dc, concentrador, ...
                            nodes_CULIACAN, 2, 100);
                        
                        
[groupindx, numberOfGroups] = buildSubgroups(concentrador,...
                                             nodes_CULIACAN,...
                                             dist_CULIACAN);
CM_CULIACAN = zeros(size(dist_CULIACAN)); %full conectivity matrix.
concentrators = nodes_CULIACAN(concentrador==true);

localindx = 1:length(nodes_CULIACAN);
for i=1:numberOfGroups
    Dindx = dist_CHTUX(groupindx==i,groupindx==i);
    Nindx = nodes_CHTUX(groupindx==i);
    Cindx = concentrators(i);
    
    Kret = esauWilliams(Dindx, Cindx, Nindx);
    CM_CULIACAN(groupindx==i,groupindx==i) = Kret;
end
               
% FULL CONECTIVITY MATRIX!!
CM_CULIACAN(concentrador==true, concentrador==true) = Kc;

cell_CULIACAN  = toCell(NOMBRES(nodes_CULIACAN), CM_CULIACAN, 'Matriz-CULIACAN-G4.csv');

% Plot
clc
% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

% LatLong discriminated by concentrators
LATc = LAT(nodes_CULIACAN(concentrador==true));
LONc = LON(nodes_CULIACAN(concentrador==true));

LATnc = LAT(nodes_CULIACAN(concentrador==false));
LONnc = LON(nodes_CULIACAN(concentrador==false));

LATch = LAT(nodes_CULIACAN);
LONch = LON(nodes_CULIACAN);

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico - CULIACAN - Grupo 4');

n = length(nodes_CULIACAN);

for i=1:n
    for j=1:n
        if CM_CULIACAN(i,j)~=0
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
                '+-','Color','m');
            set(h, 'MarkerSize',bigmarker);
        end
    end
end

%textm(CHTUX(1), CHTUX(2),'Tuxtla Gutierrez');
offs = -0.001 + (0.002).*rand(size(LATc));
textm(LATc.*(1+offs),LONc,...
    NOMBRES(nodes_CULIACAN(concentrador==true)));

h = plotm([LATc(nc) LONc(nc); LATc(1) LONc(1)],...
           '*-','Color','m');
set(h, 'MarkerSize',bigmarker);

h = plotm(LATnc, LONnc,...
    'linestyle','o','Color','b');
set(h, 'MarkerSize',marker);

h = plotm(CULIACAN,...
    'linestyle','o','Color','k');
set(h, 'MarkerSize',bigmarker);