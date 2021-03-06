% script_G3CdOBREGONfinal.m
%
% Computes:
% - Matrix for CdOBREGON group.
% - Dysart-Georganas algorithm.
% - Steiglitz-Weiner-Kleitman algorithm for Dysart's 
%   concentrators (along with CdOBREGON city)
% - Plot of group, with connected concentrators.
% 

clear all
close all
clc

load MAT_CdOBREGON
load MAT_fullDistance

% Parameters
k = 4; % Connectivity for Dysart-Georganas
R = 3; % Redundancy for Steiglitz-Weiner-Kleitman
minpop = 20000; % min population to be concentrator
%

POB_CdOBREGON = POB(nodes_CdOBREGON);

[nodos concentrador v freqs] = ...
    dysartGeorganas(4, nodes_CdOBREGON, dist_CdOBREGON);

% force Cd Obregon City into the main nodes.
concentrador(LAT(nodes_CdOBREGON)==CdOBREGON(1)) = true;
concentrador(POB_CdOBREGON<=minpop) = false;

Dc = dist_CdOBREGON(concentrador==true, ...
                concentrador==true);
%
[Kc, totDist, defi, permi] = ...
    steiglitzWeinerKleitman1(Dc, concentrador, ...
                            nodes_CdOBREGON, 2, 100);
                        
                        
[groupindx, numberOfGroups] = buildSubgroups(concentrador,...
                                             nodes_CdOBREGON,...
                                             dist_CdOBREGON);
CM_CdOBREGON = zeros(size(dist_CdOBREGON)); %full conectivity matrix.
concentrators = nodes_CdOBREGON(concentrador==true);

localindx = 1:length(nodes_CdOBREGON);
for i=1:numberOfGroups
    Dindx = dist_CdOBREGON(groupindx==i,groupindx==i);
    Nindx = nodes_CdOBREGON(groupindx==i);
    Cindx = concentrators(i);
    
    Kret = esauWilliams(Dindx, Cindx, Nindx);
    CM_CdOBREGON(groupindx==i,groupindx==i) = Kret;
end
               
% FULL CONECTIVITY MATRIX!!
CM_CdOBREGON(concentrador==true, concentrador==true) = Kc;

cell_CdOBREGON  = toCell(NOMBRES(nodes_CdOBREGON), CM_CdOBREGON, 'MatricesResultingMaps/Matriz-CdOBREGON-G3.csv');

% Plot
clc
% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

% LatLong discriminated by concentrators
LATc = LAT(nodes_CdOBREGON(concentrador==true));
LONc = LON(nodes_CdOBREGON(concentrador==true));

LATnc = LAT(nodes_CdOBREGON(concentrador==false));
LONnc = LON(nodes_CdOBREGON(concentrador==false));

LATch = LAT(nodes_CdOBREGON);
LONch = LON(nodes_CdOBREGON);

figure(5)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Mexico - CdOBREGON - Grupo 3');

n = length(nodes_CdOBREGON);

for i=1:n
    for j=1:n
        if CM_CdOBREGON(i,j)~=0
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
    NOMBRES(nodes_CdOBREGON(concentrador==true)));

h = plotm([LATc(nc) LONc(nc); LATc(1) LONc(1)],...
           '*-','Color','m');
set(h, 'MarkerSize',bigmarker);

h = plotm(LATnc, LONnc,...
    'linestyle','o','Color','b');
set(h, 'MarkerSize',marker);

h = plotm(CdOBREGON,...
    'linestyle','o','Color','k');
set(h, 'MarkerSize',bigmarker);