clear all
close all
clc

cd ./PYTHON/

CSV_CULIACAN = csvread('Distance_CULIACAN_grupo.csv',0,1);

cd ..
%
nodes_CULIACAN = unique([CSV_CULIACAN(:,1);CSV_CULIACAN(:,2)]);
n_CULIACAN = length(nodes_CULIACAN);
dist_CULIACAN = zeros(n_CULIACAN);

count = 1;

for i=1:n_CULIACAN
    for j=i:n_CULIACAN
        if i~=j
            dist_CULIACAN(i,j) = CSV_CULIACAN(count,7);
            count=count+1;
        end
    end
end
dist_CULIACAN = dist_CULIACAN + dist_CULIACAN';

CULIACAN = [24.80522 -107.42297];
LosCABOS = [23.07623 -109.71506];

clear count i j;

save MAT_CULIACAN