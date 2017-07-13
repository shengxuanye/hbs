function getChoiceSetMinMax
%GETCHOICESETMINMAX Generate choice set based on min purchase date and max purchase date
% Shengxuan Ye 7/9/2015

addpath(genpath('/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/_common/utils/'));

%% read data
ds = datastore('/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/processed_data/subsampled_subsampleDataAllHousehold_do.csv'); 
ds.SelectedVariableNames(9) = [];
ds.SelectedFormats{3} = '%s'; 
%ds.SelectedFormats{4} = '%s'; 
ds.SelectedFormats{5} = '%s'; 
data = readall(ds); 
data = data(data.channel_code == 3 | data.channel_code == 5, :); 
data.style_item_color = strcat(data.item_color, {','}, data.style);
 
savePath = '/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/fake_price/data/processed_data/choiceSets'; 

if ~exist(savePath, 'dir')
    mkdir(savePath); 
end

fprintf('.'); 
% 
% data.store_zip = str2doubleq(data.store_zip);
% data.amount = str2doubleq(data.amount); 
% 
% data = data(~isnan(data.store_code) & ~isnan(data.store_zip),:); 
% 
% fprintf('.'); 

uniqueStore = unique(data.store_code); 
%minDate = min(data.transaction_date); 
%maxDate = max(data.transaction_date); 

fprintf('.\n'); 

%% calculate min and max date for each unique store
fprintf('total # of stores = %d\n', length(uniqueStore)); 
choiceData = cell(1, length(uniqueStore)); 
for i = 1:length(uniqueStore)
    fprintf('%s: %d/%d ...',datestr(now), i,length(uniqueStore)); 
    
    tTransactions = data(data.store_code == uniqueStore(i), :); 
    
    if height(tTransactions) < 100
        fprintf('skipped.\n'); 
        continue; 
    end
 
    % get unique products in that store and calculate min and max
    
    uStyle = unique(tTransactions.style_item_color); 
    minDate = nan(length(uStyle),1); 
    maxDate = nan(length(uStyle),1); 
    for j = length(uStyle):-1:1 
        tDates = tTransactions.transaction_date( ...
            strcmp(tTransactions.style_item_color, uStyle{j}));
        minDate(j) = min(tDates); 
        maxDate(j) = max(tDates); 
    end
    
    choiceData{i} = table(uStyle, minDate, maxDate); 
    
    fprintf('\n'); 

end

%% save the data
if ~exist(savePath, 'dir'); mkdir(savePath); end
save ([savePath '/choiceData.mat'], 'choiceData', 'uniqueStore'); 

fprintf('\n'); 