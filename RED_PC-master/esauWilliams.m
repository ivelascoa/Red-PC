function [Kret] = esauWilliams(Dindx, Cindx, Nindx)
%
%                ESAU-WILLIAMS ALGORITHM
% 
% Finds the most cost-effective way of connecting a set of nodes to a
% concentrator. 
%
%       OUTPUT:
%            Kret := Connection matrix of the nodes to be connected. 
%
%        INPUT:
% 
%           Dindx := distance Matrix for Cindx
%           Cindx := Node index
%           Nindx := Nodes to be connected
%
%        USAGE:
%           [Kret] = esauWilliams(Dindx, Cindx, Nindx)
%
% SEE ALSO dysartGeorganas.m, steiglitzWeinerKleitman1.m
%

N = length(Nindx);
indx = find(Nindx == Cindx);
worked = zeros(N,1);

% Building the Difference Matrix
diffM = zeros(size(Dindx));
K = diffM; 
K(indx,:) = Dindx(indx,:);
K(:,indx) = Dindx(:,indx);

for i=1:N
    for j=1:N
        if i ~= j
            diffM(i,j) = Dindx(i,j) - Dindx(i,indx);
        end
    end
end

termine = false;
while ~termine
    [minCol Icol] = min(diffM);
    [~, Irow] = min(minCol);
    % min value for diffM is at (Icol(Irow), Irow)!!!
    
    if ~worked(Icol(Irow))
        
        K(Icol(Irow), Irow) = Dindx(Icol(Irow), Irow);
        K(Irow, Icol(Irow)) = Dindx(Icol(Irow), Irow);
        
        if Dindx(Icol(Irow), indx) <= Dindx(Irow, indx)
            K(indx,Irow) = 0;
            K(Irow,indx) = 0;
        else
            K(Icol(Irow), indx) = 0;
            K(indx, Icol(Irow)) = 0;
        end
        
    end
    
    diffM(Icol(Irow), Irow) = 0;
    diffM(Irow, Icol(Irow)) = 0;
    
    worked(Icol(Irow)) = true;
    
    termine = (min(min(diffM)) >= 0); 
end

Kret = K;
    

