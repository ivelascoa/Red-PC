function [Kc, totalDist] = steiglitzWeinerKleitman(Dc, concentrador, ...
                                                    nodes, R,replicate)
%
%           STEIGLITZ-WEINER-KLEITMAN HEURISTIC
%
%           OUTPUT:
%               Kc := Main-nodes connection matrix
%
%            INPUT:
%               Dc := Main nodes' distance matrix
%     concentrador := boolean. Main-nodes' identifier
%            nodes := nodes' identifier
%                R := Redundancy factor
%        replicate := Times to run the heuristic.
%
%  version Incera
%

if nargin > 4
    rep = replicate;
else
    rep = 5;
end

maxiter = 100;

% Resetting the seed
stream = RandStream.getGlobalStream;
reset(stream);

nodesC = nodes(concentrador==true);
n = length(nodesC);

workM = zeros(n);
finalM = zeros(n);
workC = 0;
finalC = 0;

for i=1:rep
    % Enumerar nodos de manera aleatoria
    indx = 1:n;
    permutation = randperm(n)';
    % Hacer vector de deficit
    deficit = R.*ones(n,1); 
    % Seleccionar mayor deficit, con el menor identificador
    iter = 1;
    while ~isempty(deficit(deficit>=0)) && iter < maxiter
        [maxwh, wh] = max(deficit);
        if length(deficit(deficit==maxwh))>1
            wh = indx(indx==min(permutation(deficit==maxwh)));
        end
        deficit(wh) = deficit(wh)-1;
        maxwith = max(deficit(indx~=wh));
        with = indx(deficit==maxwith);
        
        if length(deficit(deficit==maxwith))>1
            [minwith,with] = min(Dc(wh,with));
            if length(deficit(deficit==minwith))>1
                with = indx(indx==min(permutation(Dc(wh,:)==minwidth)));
            end
        end
        deficit(with) = deficit(with)-1;
        workM(wh,with) = Dc(wh,with);
        iter = iter +1;
    end
    
    display(iter)
    
    if i==1
        finalC = sum(sum(workM));
        workC = finalC;
        finalM = workM;
    else
        workC = sum(sum(workM));
        if workC < finalC
            finalC = workC;
            finalM = workM;
        end
    end
    
end

Kc = finalM;
totalDist = finalC;
