%% Create distance matrices by sector. 
%
% On this script, we're constructiong 51 groups using the K-means
% clustering algorithm. Then we check that the 51 most important
% cities are included in each of the groups (we might add another
% variable of "importance"). 
% Next, we're selecting three clusters, one for Chihuahua, one
% for Chiapas and one for Puebla. Then we're constructing the 
% distance matrices for those three states. 
% Finally, we're using Dysart-Georganas algorithm to find the 
% best suited cities to be turned into MAIN NODES. 
%
% update: 30/11/2014. Thanks to the Steiner-Weiner-Kleitman Algorithm,
% where we update the random number generator, it is very hard now to get
% the same groups as before. It is suggested that we set the seed like: 
%   
%                   rng('default');
%                   % Resetting the seed
%                   stream = RandStream.getGlobalStream;
%                   reset(stream);
%
% So that whenever this script is run, the same output is produced. 
% IT IS VERY IMPORTANT to notice that the files: 
%
%       - ChiapasTuxtla_grupo.csv
%       - Chihuahua_grupo.csv
%       - Puebla_grupo.csv
% 
% WILL CHANGE if this script is run again. 
%        
%
clear all
close all
clc

load MAT_fullDistance

% Here we have loaded: 
%
% -----------------------------------------------
%   Name   |      Size    |      Bytes  Class  
% -----------------------------------------------
%   D      |   3651x3651  |  106638408  double              
%   LAT    |   3651x1     |      29208  double              
%   LON    |   3651x1     |      29208  double
%   IDS    |   3651x1     |      29208  double
%   M      |   3651x3     |      87624  double                           
%   n      |      1x1     |          8  double              
% -----------------------------------------------
%

% Building the groups
p = lla2ecef([LAT LON 6378100.*ones(size(LAT))]);
clusterNumber = 51;

% Resetting the seed
rng('default');
stream = RandStream.getGlobalStream;
reset(stream);

[GROUPS_51] = kmeans(p, clusterNumber, 'Replicate', 5);


clear stream;
clear p;

% Checking the groups
%
% CHIHUAHUA := [28.67113 -106.10523]
% PUEBLA    := [19.04005 -98.19297]
% CHIAPAS   := [16.746 -93.13263]
%% Plot 51-groups
figure(4)
worldmap('Mexico')
load coast
plotm(lat,long)

title('Division de Mexico en grupos');

for i=1:clusterNumber
    marker = 3;
    colour = 0.8.*[rand(1) rand(1) rand(1)];
    h = plotm(LAT(cidx==i),LON(cidx==i),...
    'linestyle','o','Color',colour);
    set(h, 'MarkerSize',marker);
end
    


%%

CHIH = [28.67113 -106.10523];
PUE = [19.04005 -98.19297];
CHTUX = [16.746 -93.13263];

CHIH_group = cidx(LAT==CHIH(1));
PUE_group = cidx(LAT==PUE(1));
CHTUX_group = cidx(LAT==CHTUX(1));

nodes_CHIH = IDS(cidx==CHIH_group);
nodes_PUE = IDS(cidx==PUE_group);
nodes_CHTUX = IDS(cidx==CHTUX_group);

n_CHIH = length(nodes_CHIH);
n_PUE = length(nodes_PUE);
n_CHTUX = length(nodes_CHTUX);
%
output_CHIH = zeros(n_CHIH^2,7);
output_PUE = zeros(n_PUE^2,7);
output_CHTUX = zeros(n_CHTUX^2,7);

%% Build for Chihuahua
count=1;
aux = zeros(n_CHIH^2,1);

for i=1:n_CHIH
    for j=i:n_CHIH
        if i~=j
            output_CHIH(count, :) = ...
                [nodes_CHIH(i) nodes_CHIH(j)...
                M(nodes_CHIH(i),2) M(nodes_CHIH(i),3) ...
                M(nodes_CHIH(j),2) M(nodes_CHIH(j),3) 0];
            aux(count) = 1;
            count = count+1;
        end
    end
end

output_CHIH = output_CHIH(aux==1,:);
str = strcat('Chihuahua_grupo.csv');
csvwrite(str,output_CHIH);

% Build for Puebla
count=1;
aux = zeros(n_PUE^2,1);

for i=1:n_PUE
    for j=i:n_PUE
        if i~=j
            %                          |    start   |    finish   |                   
            %                          | LAT   LON  |  LAT    LON |
            output_PUE(count, :) = ...
                [nodes_PUE(i) nodes_PUE(j) ...
                M(nodes_PUE(i),2) M(nodes_PUE(i),3)...
                M(nodes_PUE(j),2) M(nodes_PUE(j),3) 0];
            aux(count) = 1;
            count = count +1;
        end
    end
end

output_PUE = output_PUE(aux==1,:);
str = strcat('Puebla_grupo.csv');
csvwrite(str,output_PUE);

% Build for Chiapas
count=1;
aux = zeros(n_CHTUX^2,1);

for i=1:n_CHTUX
    for j=i:n_CHTUX
        if i~=j
            %                            |    start   |    finish   |                   
            %                            | LAT   LON  |  LAT    LON |
            output_CHTUX(count, :) = ...
                [nodes_CHTUX(i) nodes_CHTUX(j) ...
                M(nodes_CHTUX(i),2) M(nodes_CHTUX(i),3)...
                M(nodes_CHTUX(j),2) M(nodes_CHTUX(j),3) 0];
            aux(count) = 1;
            count = count +1;
        end
    end
end

output_CHTUX = output_CHTUX(aux==1,:);
str = strcat('ChiapasTuxtla_grupo.csv');
csvwrite(str,output_CHTUX);

%% PLOT CHIHUAHUA+PUEBLA+CHIAPAS

% meaningless variables (just to plot pretty)
marker = 4;
bigmarker = 2*marker;
colour = 0.8.*[rand(1) rand(1) rand(1)];
cities = ones(size(colour)) - colour;

figure(4)
worldmap('Mexico')
load coast
plotm(lat,long)

str = 'Mexico - CHIHUAHUA + PUEBLA + CHIAPAS';
title(str)


h = plotm(LAT(cidx==CHIH_group),LON(cidx==CHIH_group),...
    'linestyle','o','Color',colour);
set(h, 'MarkerSize',marker);
h = plotm(CHIH,'linestyle','+','Color',cities);
set(h, 'MarkerSize',bigmarker);

h = plotm(LAT(cidx==PUE_group),LON(cidx==PUE_group),...
    'linestyle','o','Color',colour);
set(h, 'MarkerSize',marker);
h = plotm(PUE,'linestyle','+','Color',cities);
set(h, 'MarkerSize',bigmarker);

h = plotm(LAT(cidx==CHTUX_group),LON(cidx==CHTUX_group),...
    'linestyle','o','Color',colour);
set(h, 'MarkerSize',marker);
h = plotm(CHTUX,'linestyle','+','Color',cities);
set(h, 'MarkerSize',bigmarker);


