function [ ] = writetablefast( T, formatSpec, filename )
%WRITETABLEFAST fast write table function, only for csv 
%   This function prepare the data in memory, then flush it into file
%   Shengxuan Ye 2015/7/10

fid = fopen(filename,'Wb');

for i = 1:length(T.Properties.VariableNames)
    if i ~= length(T.Properties.VariableNames)
        fprintf(fid, '"%s",', T.Properties.VariableNames{i});
    else
        fprintf(fid, '"%s"\n', T.Properties.VariableNames{i});
    end
end
fprintf('generating cell...\n'); 
aa = table2cell(T); 
fprintf('start writing...\n'); 
for i = 1:height(T)
    if rem(i, 1000) == 0
        fprintf('%d / %d...\n', i, height(T)); 
    end
    fprintf(fid, formatSpec, aa{i,:}); 
end

fclose(fid); 
end
