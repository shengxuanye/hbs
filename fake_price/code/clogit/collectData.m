function [ data ] = collectData( idStrs, folderName )
%COLLECTDATA collect all bootstrap data
%   idStrs: cell array of strings that identify the data
%
%   Shengxuan Ye 6/3/2015

if ~exist('folderName', 'var')
	folderName = '.'; 
end

filename = 'stata_logit_subsample_do_bootstrap.log'; 

folders = dir([folderName '/itr_*']); 

data = table(); 

for i = length(folders):-1:1
	text = fileread([folderName '/' folders(i).name '/' filename]); 
 
	for j = 1:length(idStrs)
		pos = strfind(text, idStrs{j}); 
		pos = pos(end); 
        %text(pos+7:pos+20)
		data.(idStrs{j})(i,1) = str2double(text(pos+10:pos+20));
    end
    
    
end


end