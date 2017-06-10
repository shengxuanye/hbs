% addpath(genpath('/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/_common/utils/'));
% 
% ds = datastore('/n/home12/sye/ngwe_hbs_lab/Lab/fake_price/data/processed_data/subsampled_subsampleDataAllHousehold_do.csv'); 
% ds.SelectedFormats{3} = '%s'; 
% %ds.SelectedFormats{4} = '%s'; 
% ds.SelectedFormats{5} = '%s'; 
% data = readall(ds); 
% data = data(data.channel_code == 3 | data.channel_code == 5, :); 
% % 
% savePath = '/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/fake_price/data/processed_data/choiceSets'; 
% 
% if ~exist(savePath, 'dir')
%     mkdir(savePath); 
% end
% 
% fprintf('.'); 
% 
% data.store_zip = str2doubleq(data.store_zip);
% data.amount = str2doubleq(data.amount); 
% 
% data = data(~isnan(data.store_code) & ~isnan(data.store_zip),:); 
% 
% fprintf('.'); 
% 
% uniqueStore = unique(data.store_code); 
% minDate = min(data.transaction_date); 
% maxDate = max(data.transaction_date); 
% 
% fprintf('.\n'); 


inventorySize = nan(maxDate-minDate+1,length(uniqueStore)); 
meanInventorySize = []; 

fprintf('total # of stores = %d\n', length(uniqueStore)); 
for i = 43:length(uniqueStore)
    fprintf('%d ',i); 
    
    tTransactions = data(data.store_code == uniqueStore(i), :); 
    
    if height(tTransactions) < 100
        continue; 
    end
   
   
    
    % get average store inventory
    
    for j = minDate:maxDate
        inventorySize(j-minDate+1,i) = length(unique(data.style(tTransactions.transaction_date == j)));
    end
    
    tminDate = min(tTransactions.transaction_date) - minDate + 1;
    tmaxDate = max(tTransactions.transaction_date) - minDate + 1;
    
    tminDate = tminDate + round((tmaxDate-tminDate+1) * 0.2); 
    tmaxDate = tmaxDate - round((tmaxDate-tminDate+1) * 0.2);
    
    meanInventorySize(i) = round(mean(inventorySize(tminDate:tmaxDate,i)));  % mean might not be the best way -> max? 
    minDateAll(i) = tminDate;
    maxDateAll(i) = tmaxDate; 
    
    % create choice set
    tid = (1:height(tTransactions))'; 
    transaction_date = tTransactions.transaction_date; 
    styles = tTransactions.style; 
    operationTable = table(tid, transaction_date, styles); 
    
    uniqueTable = table(transaction_date, styles); 
    [~, ia] = unique(uniqueTable); 
    operationTable = operationTable(ia,:); 
    
    mkdir([savePath sprintf('%d', uniqueStore(i))]); 
    choice = nan(length(minDate:maxDate),meanInventorySize(i)); 
    count = 1;
    fprintf('%d ', maxDate-minDate+1); 
    for j = minDate:maxDate
        
        operationTable.diff = abs(operationTable.transaction_date - j);
        operationTable = sortrows(operationTable, [4, 3]); 
        [~, u] = unique(operationTable.styles, 'stable'); 
        choice(count,:) = operationTable.tid(u(1:meanInventorySize(i))); 
        count = count+1; 
        
        if rem(count, 100) == 0
            fprintf('.'); 
        end
    end
    save([savePath sprintf('/%d', uniqueStore(i)) '/data.mat'], 'tminDate', 'tmaxDate', 'choice', 'tTransactions'); 
    fprintf('\n'); 
end

fprintf('\n'); 