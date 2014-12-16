clear all
close all
clc

cd ./PYTHON/

CSV_CdOBREGON = csvread('Distance_CdOBREGON_grupo.csv',0,1);

cd ..
%
nodes_CdOBREGON = unique([CSV_CdOBREGON(:,1);CSV_CdOBREGON(:,2)]);
n_CdOBREGON = length(nodes_CdOBREGON);
dist_CdOBREGON = zeros(n_CdOBREGON);

count = 1;

for i=1:n_CdOBREGON
    for j=i:n_CdOBREGON
        if i~=j
            dist_CdOBREGON(i,j) = CSV_CdOBREGON(count,7);
            count=count+1;
        end
    end
end
dist_CdOBREGON = dist_CdOBREGON + dist_CdOBREGON';

CdOBREGON = [27.48228 -109.94289];

clear count i j;

save MAT_CdOBREGON