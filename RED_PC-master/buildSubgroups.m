function [groupindx, clusterNumber] = buildSubgroups(concentrador, nodes,...
                                                     distanceMatrix)
% 
%                    BUILD SUBGROUPS
%
% Function to determine which nodes are being connected to each of the
% concentrators. It returns a vector of local indexes that determine if the
% ith node corresponds to the jth concentrator. It simply .
%
%           OUTPUT:
%        groupindx := vector that shows which of the nodes belong to which
%                     group.
%    clusterNumber := number of clusters created.
%
%            INPUT:
%     concentrador := Boolean array. It shows whether the ith entry is a
%                     concentrator.
%            nodes := Nodes' ID vector.
%
% SEE ALSO dysartGeorganas.m, esauWilliams.m, steiglitzWeinerKleitman1.m
% 
%
n = length(nodes);
nC = sum(concentrador);

groups = (1:nC)';
resp = zeros(n,1);
resp(concentrador==true) = groups;

tryM = distanceMatrix(:, concentrador==true);

for i=1:n
    [~, r] = min(tryM(i,:));
    resp(i) = groups(r);
end        

groupindx = resp;
clusterNumber = nC;
