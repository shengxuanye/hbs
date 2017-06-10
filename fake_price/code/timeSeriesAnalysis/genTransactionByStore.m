
gminDate = min(offline.min_date); 
offlineValid = offline(offline.min_date >= gminDate+7, :); 
storeTransactions = cell(height(offlineValid), 1); 

for i = 1:height(offlineValid)
    tStoreCode = offline.store_code(i); 
    tMinDate = offline.min_date(i); 
    storeTransactions{i} = data.transaction_date(data.store_code == tStoreCode) - tMinDate; 
    fprintf('.'); if rem(i, 100) == 0; fprintf('\n'); end
end
fprintf('\n'); 


%save storeTransactions storeTransactions