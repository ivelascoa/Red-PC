function [nodos concentrador v freqs] = dysartGeorganas(k, nodes,...
                                                 distanceMatrix)
%                   DYSART-GEORGANAS ALGORITHM
%
% Finds the most suitable candidates to become main nodes (concentrators) 
% regarding closeness to their neighbours. It produces an array of boolean
% entries that indicate whether the ith node is a concentrator or not. 
%
%           OUTPUT:
%            nodos := Whole list of nodes.
%     concentrador := boolean-array. TRUE in ith place if ith node is a
%                     candidate for a concentrator.
%                v := Average number of neighbors connected to another node.
%            freqs := Vecinity chart (check algorithm).
%
%            INPUT:
%                k := Connectivity parameter. Identifies number of nodes to
%                     be connected to a concentrator. 
%            nodes := nodes' identifier (replicates itself to output 'nodos')
%   distanceMatrix := Matrix (D) that has in its entry d_ij the distance 
%                     between ith and jth node.
%
%         USAGE: 
%        [nodos concentrador v freqs] = dysartGeorganas(k, nodes,dM)
% 
% SEE ALSO steiglitzWeinerKleitman1.m, esauWilliams.m
%              
%
[freqs] = tablaVecindades(k, nodes, distanceMatrix);

N = length(nodes);
M = max(freqs);
J = [(1:M)' zeros(M,1)];

concentrador = zeros(N,1);

for i=1:M
    Sj = length(find(freqs==i));
    if Sj > 0
        J(i,2) = Sj;
    end
end

v = floor((J(:,1)'*J(:,2))/sum(J(:,2)))+1;

concentrador(find(freqs>=v)) = true;
nodos = nodes;

end

function [freqs] = tablaVecindades(k, nodes, distanceMatrix)
%                   TABLA DE VECINDADES
% Calcula la tabla de vecindades del algoritmo Dysart-Georganas
%
M = length(nodes);
freqs = zeros(M,1);

[vec I] = sort(distanceMatrix);
indx = I(1:k+1,:)';

for i=1:M
    freqs(i) = length(find(indx==i));
end

end