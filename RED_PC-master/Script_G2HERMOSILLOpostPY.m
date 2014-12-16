clear all
close all
clc

cd ./PYTHON/

CSV_HERMOSILLO = csvread('Distance_HERMOSILLO_grupo.csv',0,1);

cd ..
%
nodes_HERMOSILLO = unique([CSV_HERMOSILLO(:,1);CSV_HERMOSILLO(:,2)]);
n_HERMOSILLO = length(nodes_HERMOSILLO);
dist_HERMOSILLO = zeros(n_HERMOSILLO);

count = 1;

for i=1:n_HERMOSILLO
    for j=i:n_HERMOSILLO
        if i~=j
            dist_HERMOSILLO(i,j) = CSV_HERMOSILLO(count,7);
            count=count+1;
        end
    end
end
dist_HERMOSILLO = dist_HERMOSILLO + dist_HERMOSILLO';

HERMOSILLO = [29.0814 -110.98899];

clear count i j;

save MAT_HERMOSILLO