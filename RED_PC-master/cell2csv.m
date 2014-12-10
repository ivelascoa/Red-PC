function cell2csv(fName, CELL, delimiter)
%          
%                      CELL TO CSV
% 
% Converts a cell-type into a CSV-file. The default delimiter is ',' but it
% can be modified by the user.
% 
%           INPUT:
%               fName := Name of the file to be saved.
%                CELL := Cell variable to convert.
%           delimiter := (optional) Delimiter of the csv file. Comma (,) is
%                        chosen by default.
% 
if nargin < 3
    del = ',';
else
    del = delimiter;
end

linea = '';
ff = fopen(fName,'w');
[n m] = size(CELL);

for i=1:n
    for j=1:m
        val = CELL{i,j};
        if isnumeric(val)
            val = num2str(val);
        end
        
        linea = strcat(linea,val,del);
    end
    fprintf(ff ,'%s \n', linea{1,1});
    linea = '';
end
fclose(ff);
        