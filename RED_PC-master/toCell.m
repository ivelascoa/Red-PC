function CELL = toCell(names, matrix, fname)
% 
%                   TO CELL
% Converts a matrix into a CELL to be then converted into a CSV.
%

if nargin < 3
    % Do not make the file
    convertfile = false;
else 
    convertfile = true;
end

n = length(names);
CELL = cell(n,n);

for i=1:(n+1)
    for j=1:(n+1)
        if i==1 || j==1
            if i==1 && j==1
                CELL{i,j} = 'LOCALIDADES';
            end
            if i==1 && j~=1
                CELL{i,j} = names(j-1);
            else
                if i~=1 && j == 1
                    CELL{i,j} = names(i-1);   
                end
            end            
        else
            CELL{i,j} = matrix(i-1,j-1);
        end
    end
end

if convertfile == true
    cell2csv(fname,CELL);
end

end
