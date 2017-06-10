%% plot online graph
startDate = min(online.transaction_date); 
endDate = max(online.transaction_date); 

% find all store within the startDate and endDate +- 2 months
intervalBack = 10;
intervalFwd = 365; 
areaRange = 0.5; 

validOffline = offline(offline.min_date > startDate + intervalBack & offline.min_date < endDate - intervalFwd & ...
    offline.channel_code == 3,:); 
fprintf('# valid offline = %d\n', height(validOffline)); 

xab = linspace(-areaRange, areaRange, 600);  
%plotData = zeros(height(validOffline), length(-intervalBack:intervalFwd), 600, 600); 



for i =height(validOffline):-1:1
    tDate = validOffline.min_date(i); 
    tLat = validOffline.latitude(i);
    tLon = validOffline.longitude(i); 
    
    xNearby(i) = sum(offline.latitude >= tLat - areaRange*2 & offline.latitude <= tLat + areaRange*2 ...
            & offline.longitude >= tLon - areaRange & offline.longitude <= tLon + areaRange & offline.min_date < tDate); 
    xDate(i) = tDate; 
    xLat(i) = tLat;
    xLon(i) = tLon;
    xChnCode(i) = validOffline.channel_code(i); 
    
    count = 1; 
    tRange = offlineAll.latitude >= tLat - areaRange*2 & offlineAll.latitude <= tLat + areaRange*2 ...
            & offlineAll.longitude >= tLon - areaRange & offlineAll.longitude <= tLon + areaRange; 
    for j = -intervalBack:intervalFwd
        %tOnline = online.transaction_date == tDate+j & online.latitude >= tLat - areaRange*2 & online.latitude <= tLat + areaRange*2 ...
        %    & online.longitude >= tLon - areaRange & online.longitude <= tLon + areaRange; 
        %tOnlineNew = tOnline & online.new_customer; 
        %tOnlineOld = tOnline & ~online.new_customer;
        
        tOffline = offlineAll.transaction_date == tDate+j & tRange;
        tOfflineNew = tOffline & offlineAll.new_customer; 
        tOfflineOld = tOffline & ~offlineAll.new_customer; 
        
        %tOfflineStore = tOffline & offlineAll.store_code == validOffline.store_code(i); 
        %tOfflineStoreOld = tOfflineStore & offlineAll.new_customer; 
        %tOfflineStoreNew = tOfflineStore & ~offlineAll.new_customer; 
        
        
        %sumTotalOnline(i,count) = sum(online.transaction_date == tDate+j);
        %sumTotalOffline(i,count) = sum(offlineAll.transaction_date == tDate+j); 
        
        
        
        %sumOnline(i,count) = sum(tOnline); 
        %sumOnlineNew(i,count) = sum(tOnlineNew); 
        %sumOnlineOld(i,count) = sum(tOnlineOld); 
        sumOffline(i,count) = sum(tOffline); 
        sumOfflineNew(i,count) = sum(tOfflineNew);
        sumOfflineOld(i,count) = sum(tOfflineOld); 
        %sumOfflineStore(i,count) = sum(tOfflineStore); 
        %sumOfflineStoreOld(i,count) = sum(tOfflineStoreOld); 
        %sumOfflineStoreNew(i,count) = sum(tOfflineStoreNew); 
        count = count + 1; 
        
        %[NN,CC]=hist3([online.latitude(tTransactions)-tLat, online.longitude(tTransactions)-tLon] ,{xab, xab});
        %NN = NN ./ sum(online.transaction_date == tDate+j); 

        %plotData(i,j+intervalBack+1,:,:) = NN; 
    end
    
    
    
    fprintf('.'); 
end

fprintf('\n'); 

%save sumData_smallsmall xNearby xDate xLat xLon xChnCode sumOnline sumOnlineNew sumOnlineOld sumOffline sumOfflineNew sumOfflineOld sumOfflineStore sumOfflineStoreOld sumOfflineStoreNew
save sumData_365_end_3 xNearby xDate xLat xLon xChnCode sumOffline sumOfflineNew sumOfflineOld; %sumOfflineStore sumOfflineStoreOld sumOfflineStoreNew


% save plotData
%save plotDataRegional_normAll plotData -v7.3

