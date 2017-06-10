function writeChoiceSetTable(minRange, maxRange)
%WRITECHOICESETTABLE generate full logit table
% Shengxuan Ye 7/9/2015

%minRange = 1; 
%maxRange = 100; 

basePath = '/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/fake_price/data/processed_data/choiceSets/160213'; 
%saveFile = '/scratch/choicesets/full_logitTable2_1_1000.csv'; 
saveFile = '/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/fake_price/data/processed_data/full_logitTable2_3000_5000_3.csv';  % this saves to memory! 

fullTable = {}; 
gidcount = 1; 
count = 1; 
for i = minRange:maxRange
    f = sprintf('%s/logitTable_%d.mat', basePath, i); 
    if ~exist(f, 'file'); continue; end
    
    fprintf('%s: working on %d...\n', datestr(now), i); 
    
    load(f); 
    
    gidOld = unique(logitTable.gid); 
    gidNew = gidcount:gidcount+length(gidOld)-1; 
    
    gidcount = gidcount+length(gidOld); 
    
    for j = 1:length(gidOld)
        logitTable.gid(logitTable.gid == gidOld(j)) = gidNew(j); 
    end
    
    fullTable{count} = logitTable; 
    count = count + 1; 
end

fprintf('starting writing table...\n'); 
catTable = vertcat(fullTable{:}); 

delete(saveFile); 

formatSpec='%d,%d,"%s","%s","%s","%s","%s","%s",%.2f,%d,%.2f,%d,%d,%d,%.2f,%,2f,%.2f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n'; 
writetable(catTable, saveFile); 