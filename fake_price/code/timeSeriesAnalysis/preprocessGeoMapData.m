%% this script preprocesses data extracted from STATA
%  Jerry Ye 5/28/2015

clear; 
addpath(genpath('/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/_common/utils/'));

%% load all data 
datapath = '/net/hbsfs01/srv/export/ngwe_hbs_lab/share_root/Lab/fake_price/data/processed_data/'; 

ds = datastore([datapath 'subsampled_subsampleDataAllHouseholdAllChn_do.csv']); 
zipds = datastore('./zip_codes_states.csv'); 

%ds.SelectedFormats = {'%f','%f','%s','%s','%f','%s','%f','%f'}; 
ds.SelectedFormats = {'%f','%f','%s','%s','%f','%f'}; 
data = readall(ds); 

fprintf('.'); 

zipds.SelectedFormats{2} = '%s';
zipds.SelectedFormats{3} = '%s';
zips = readall(zipds);

fprintf('.'); 

zips.zip_code = cellfun(@str2doubleNoQuote, zips.zip_code);
zips.latitude = cellfun(@str2doubleNoQuote, zips.latitude);
zips.longitude = cellfun(@str2doubleNoQuote, zips.longitude);

zips(:,{'city','state','county'}) = []; 

% %% convert store_zip and cust_zip to double 
% data.store_zip_d = cellfun(@str2double, data.store_zip); 
% data.cust_zip_d = cellfun(@str2double, data.cust_zip); 

fprintf('.\n'); 

%% add columns for new/old customer 
data.new_customer = data.transaction_date == data.original_purchase_date; 
%data.customer_age = data.transaction_date - data.original_purchase_date; 




%% extract data from online channel (channel_code == 1) 
online = table(data.cust_zip(data.channel_code == 1), data.transaction_date(data.channel_code == 1), data.new_customer(data.channel_code == 1)); 
online.Properties.VariableNames = {'cust_zip','transaction_date','new_customer'}; 

online.cust_zip_d = cellfun(@str2double, online.cust_zip); 
online = online(~isnan(online.cust_zip_d) & online.cust_zip_d ~= 0,:); 
online.cust_zip = []; 
online.Properties.VariableNames{3} = 'zip_code'; 

online = outerjoin(online, zips, 'MergeKeys', true,'Type','left');
online = online(~isnan(online.latitude),:); 

fprintf('.\n'); 

%% extract data from offline channel (channel_code == 3 or 5) 
offlineAll = data(data.channel_code == 3 | data.channel_code == 5,:); 

offlineAll.cust_zip_d = str2doubleq(offlineAll.cust_zip); 
offlineAll = offlineAll(~isnan(offlineAll.cust_zip_d) & offlineAll.cust_zip_d ~= 0,:); 
offlineAll.cust_zip = []; 
offlineAll.Properties.VariableNames{7} = 'zip_code'; 
fprintf('.'); 

offlineAll.store_zip_d = str2doubleq(offlineAll.store_zip); 
offlineAll = offlineAll(~isnan(offlineAll.store_zip_d) & offlineAll.store_zip_d ~= 0,:); 
offlineAll.store_zip = []; 
offlineAll.Properties.VariableNames{7} = 'store_zip'; 
fprintf('.'); 

offlineAll = outerjoin(offlineAll, zips, 'MergeKeys', true,'Type','left');
offlineAll = offlineAll(~isnan(offlineAll.latitude),:); 

fprintf('.\n'); 


%% extract data for or individual stores 
[uniqueStore, loc] = unique(data.store_code); 
loc = loc(~isnan(uniqueStore)); 
uniqueStore = uniqueStore(~isnan(uniqueStore)); 
storeZip = cellfun(@str2double,data.store_zip(loc)); 
channelCode = data.channel_code(loc); 

uniqueStore = uniqueStore(~isnan(storeZip)); 
storeZip = storeZip(~isnan(storeZip)); 
channelCode = channelCode(~isnan(storeZip)); 

% find count and min for each store
minStore = nan(size(uniqueStore)); 
countStore = nan(size(uniqueStore)); 

for i = 1:length(uniqueStore) 
    minStore(i) = min(data.transaction_date(data.store_code == uniqueStore(i))); 
    countStore(i) = sum(data.store_code == uniqueStore(i));
    fprintf('.'); if rem(i, 100) == 0; fprintf('\n'); end
end

offline = table(uniqueStore, storeZip, minStore, countStore, channelCode); 
offline.Properties.VariableNames = {'store_code','zip_code','min_date','num_transaction','channel_code'};
offline = outerjoin(offline, zips, 'MergeKeys', true,'Type','left');

offline = offline(~isnan(offline.latitude) & offline.num_transaction > 1000,:); 

fprintf('\n'); 

%% no use
% %% plot online graph
% startDate = min(online.transaction_date); 
% endDate = max(online.transaction_date); 
% 
% interval = 7; % by week
% 
% tt = startDate; i=1; 
% 
% while tt < endDate
%     dotLatNew = offline.latitude(offline.min_date > startDate & offline.min_date < tt); 
%     dotLonNew = offline.longitude(offline.min_date > startDate & offline.min_date < tt); 
%     dotTypeNew = offline.channel_code(offline.min_date > startDate & offline.min_date < tt);
%     dotLatOld = offline.latitude(offline.min_date <= startDate); 
%     dotLonOld = offline.longitude(offline.min_date <= startDate);
%     dotTypeOld = offline.channel_code(offline.min_date <= startDate); 
%     genGeoFigure(online.latitude(online.transaction_date>=tt & online.transaction_date<tt+7), ...
%         online.longitude(online.transaction_date>=tt & online.transaction_date<tt+7), 'onlinewstart_newnochange', ...
%         i, sprintf('%d - %d', tt, tt+interval-1), dotLatNew, dotLonNew, dotTypeNew, dotLatOld, dotLonOld, dotTypeOld);
%     tt = tt+interval; i=i+1; 
%     fprintf('%.4f\n', (tt-startDate)/(endDate-startDate)); 
% end
% 
