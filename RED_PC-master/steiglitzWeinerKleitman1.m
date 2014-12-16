function [Kc, totalDist,...
          defi, permi] = steiglitzWeinerKleitman1(Dc, concentrador, ...
                                                    nodes, R,replicate,...
                                                    verbose)
%
%           STEIGLITZ-WEINER-KLEITMAN HEURISTIC
%
% Finds a low-cost R-connected network of the concentrators (main nodes).
% Mind the '1' at the end of the name, it is important.
% 
%
%           OUTPUT:
%               Kc := Main-nodes' connection matrix.
%        totalDist := total distance of the output matrix.
%             defi := (optional) deficit vector.
%            permi := (optional) permutation vector.
%
%            INPUT:
%               Dc := Main nodes' distance matrix
%     concentrador := (boolean) Main-nodes' identifier
%            nodes := nodes' identifier
%                R := Redundancy factor
%        replicate := (optional) Times to run the heuristic. 
%                     DEFAULT = 5, RECOMMENDED ~ 50.
%          verbose := (optional - boolean) Shows debug info.
%
%           USAGE: 
%    (1) [Kc, tD] = steiglitzWeinerKleitman1(Dc, concentrador,nodes, R)
%              The easiest way is not to worry sbout deficit-output or
%              the permutation used. 
%
%    (2) [Kc, tD] = steiglitzWeinerKleitman1(Dc, concentrador,nodes, R, rep)
%              You might want to run the algorithm several times, to be
%              sure that you're proposing the most efficient network. Just
%              add the 'replicate' parameter.
%
%    (3) [Kc, tD] = steiglitzWeinerKleitman1(Dc, concentrador,nodes,...
%                                            R, rep, verbose)
%             If you want to show the development of the algorithm, showing
%             the iteration one's currently in, the preliminary cost of the
%             matrix and the final cost found yet.
%
% SEE ALSO dysartGeorganas.m, esauWilliams.m
%              
%
if nargin > 4
    rep = replicate;
else
    rep = 5;
end

verb = false;

if nargin > 5
    verb = verbose;
end

maxiter = 100;

nodesC = nodes(concentrador==true);
n = length(nodesC);

% final variables initialized
finalM = zeros(n);
finalC = 0;
 
if verb==true
    fprintf('\n| It  |  workC  |  finalC  |  :');
end

for i=1:rep
    % Set a random integer seed for the algorithm to start with.
    Rnum = randi(10000, 1, 1);
    rng(Rnum,'twister');
    % 
    
    % "Work" variables, that might turn into finalM and finalC
    workM = zeros(n);
    workC = 0;
    
    indx = 1:n;
    permutation = randperm(n)';
    deficit = R.*ones(n,1); 

    iter = 1;
    
    while ~isempty(deficit(deficit>=0)) && iter < maxiter
        
        maxwh = max(deficit);
        wh = indx(deficit==maxwh);
        
        if length(wh)>1
            wh = indx(permutation==min(permutation(wh)));
        end
        
        maxwith = max(deficit(indx~=wh));
        with = indx(deficit==maxwith);
        with = with(with~=wh);
        
        if length(with)>1
            to_choose = Dc(wh,with);
            [minwith where] = min(to_choose);
            with = indx(Dc(wh,:)==minwith);
            
            if length(with)>1
                with = ...
                    indx(permutation==min(permutation(with)));
            end
            
            while workM(wh,with) > 0
                to_choose(where) =...
                    max(to_choose)*2;
                with = indx(deficit==maxwith);
                [minwith where] = min(to_choose);
                with = indx(Dc(wh,:)==minwith);
                
                if length(with)>1
                    with = indx(min(permutation(with)));
                end
            end
            
        end
        
        % Update deficit
        deficit(wh) = deficit(wh)-1;
        deficit(with) = deficit(with)-1;
        
        workM(wh,with) = Dc(wh,with);
        iter = iter +1;
    end
       
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
    if verb==true
        fprintf('\n| %3d | %4.3f | %4.3f|', i, workC, finalC);
    end
end

Kc = finalM;
totalDist = finalC;
if nargout > 2
    defi = deficit;
    if nargout > 3
        permi = permutation;
    end
end

        
