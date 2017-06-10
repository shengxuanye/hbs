function genLogitTableMinMax(startT, endT)
%GENLOGITTABLEMINMAX generate logit table for STATA
% Shengxuan Ye 7/9/2015

%% load data
addpath(genpath('/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/_common/utils/'));

ds = datastore('/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/processed_data/subsampled_subsampleDataAllHousehold_do.csv'); 
ds.SelectedFormats{3} = '%s'; 
ds.SelectedVariableNames(9) = [];
%ds.SelectedFormats{4} = '%s'; 
ds.SelectedFormats{5} = '%s'; 
data = readall(ds); 

data = data(data.channel_code == 5,:); 

choiceDataPath = '/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/fake_price/data/processed_data/choiceSets'; 
load([choiceDataPath '/choiceData']); 
fprintf('.');

%% preprocessing 
%scratchPath = '/scratch/choicesets/150709'; 
scratchPath = [choiceDataPath '/160213']; 

if ~exist(scratchPath, 'dir');
    mkdir(scratchPath); 
end


% get all unique styles
[~, ia] = unique(data.style);
styleData = data(ia, :);   
styleData.Properties.RowNames = styleData.style;

% % this calculates mean price info, and is slow.. 
% fprintf('total styles = %d... \n', height(styleData));  
% for i = 1:height(styleData)
%     styleData.price(i) = mean(data.price(strcmp(data.style, styleData.style(i)))); 
%     if rem(i, 100) == 0
%         fprintf('%s: %d / %d...\n', datestr(now), i, height(styleData));
%     end
% end

%% subsample data
% based on random number
% rng(1026); 
% subSampleId = rand(height(data), 1) <= 0.05; 

% .. or use a specific range
subsetMin = 18322; % 2010.3.1
subsetMax = 18382; % 2010.4.30
subSampleId = data.transaction_date >= subsetMin & data.transaction_date <= subsetMax; 

sampledData = data(subSampleId, :); 
fprintf('total sampled transactions = %d... \n', height(sampledData));

% unique date - store
uStoreDate = unique(sampledData(:,{'store_code', 'transaction_date'})); 
fprintf('total unique store-date combinations = %d... \n', height(uStoreDate)); 

%% start generating table
logitTable = table(); 
count = 1; 

if ~exist('startT', 'var'); startT = 1; end
if ~exist('endT', 'var'); endT = height(uStoreDate); end

for i = startT:endT
    tStyle = extractChoiceSetFromMinMax(choiceData{uniqueStore == uStoreDate.store_code(i)}, uStoreDate.transaction_date(i)); 
    tTable = styleData(tStyle, :); 
    tTable.choice = zeros(height(tTable),1);
    
    tTable.store_code = ones(height(tTable),1)*uStoreDate.store_code(i); 
    tTable.transaction_date = ones(height(tTable),1)*uStoreDate.transaction_date(i); 
    
    % update price information (using closest transactions) 
    tPrice = data(data.store_code == uStoreDate.store_code(i),:); 
    for j = 1:height(tTable)
        ttPrice = tPrice(strcmp(tPrice.style, tTable.style(j)),:); 
        [~, loc] = min(ttPrice.transaction_date - uStoreDate.transaction_date(i)); 
        tTable.price(j) = mean(ttPrice.price(loc));
    end

    tTransactions = sampledData(sampledData.store_code == uStoreDate.store_code(i) & ...
        sampledData.transaction_date == uStoreDate.transaction_date(i), :); 
    fprintf('%s: %d / %d, current transacions = %d...\n', datestr(now), i, height(uStoreDate), height(tTransactions));
    
    ttTable = cell(1, height(tTransactions)); 
    for j = 1:height(tTransactions)
        ttTable{j} = tTable; 
        ttTable{j}{tTransactions.style(j), 'choice'} = 1;
        ttTable{j}.gid = ones(height(tTable),1)*count; 
        ttTable{j}.Properties.RowNames = {}; 
        
        count = count + 1; 
    end
    
    logitTable = vertcat(logitTable,ttTable{:}); 
    
    if rem(i,10) == 0
        save(sprintf('%s/logitTable_%d', scratchPath, i), 'logitTable');
        logitTable = table();
        fprintf('scratch saved to: %s/logitTable_%d\n', scratchPath, i);
    end
end

if ~isempty(logitTable)
    save(sprintf('%s/logitTable_%d', scratchPath, i), 'logitTable');
    logitTable = table();
    fprintf('scratch saved to: %s/logitTable_%d\n', scratchPath, i);
end


%% combine tables & write the table
% fprintf('combining table and write CSV file... \n'); 
% fullTable = table(); 
% for i = 1:length(logitTable)
%     fullTable = [fullTable; logitTable{i}]; 
% end
% fprintf('total %d rows in the table, start writing to %s...\n', height(fullTable), savePath); 
% 
% writetable(fullTable, savePath); 
