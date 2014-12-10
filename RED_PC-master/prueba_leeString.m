% script

clear all
close all
clc

fileName = 'Localidades.csv';

fid = fopen(fileName,'r');
C = textscan(fid, repmat('%s',1,10), 'delimiter',',', 'CollectOutput',true);
C = C{1};
fclose(fid);

%%

clear all
close all
clc

load MAT_fullDistance
load MAT_CHIH
load MAT_CHTUX

cell_CHIH = cell(n_CHIH+1,n_CHIH+1);
cell_CHTUX = cell(n_CHTUX+1,n_CHTUX+1);

linea = '';
for i=1:(n_CHIH+1)
    for j=1:(n_CHIH+1)
        if i==1 || j==1
            if i==1 && j==1
                cell_CHIH{i,j} = 'LOCALIDADES';
            end
            if i==1 && j~=1
                cell_CHIH{i,j} = NOMBRES(nodes_CHIH(j-1));
            else
                if i~=1 && j == 1
                    cell_CHIH{i,j} = NOMBRES(nodes_CHIH(i-1));   
                end
            end            
        else
            cell_CHIH{i,j} = dist_CHIH(i-1,j-1);
        end
    end
end

cell2csv('fprueba-CHIH.csv',cell_CHIH);