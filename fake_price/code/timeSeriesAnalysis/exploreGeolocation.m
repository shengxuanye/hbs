
ds = datastore('subsampled_subsampleDataAllHousehold_do.csv');
zipds = datastore('zip_codes_states.csv'); 

ds.SelectedVariableNames = ds.VariableNames([2,17,18]);
ds.SelectedFormats = {'%s','%s','%f'};
data = readall(ds); 

ustore_code = unique(data.store_code);
tstorecust = data.cust_zip(strcmp(data.store_code,ustore_code{6}));

zipds.SelectedFormats{2} = '%s';
zipds.SelectedFormats{3} = '%s';
zips = readall(zipds);

zips.zip_code = cellfun(@str2doubleNoQuote, zips.zip_code);
zips.latitude = cellfun(@str2doubleNoQuote, zips.latitude);
zips.longitude = cellfun(@str2doubleNoQuote, zips.longitude);

tt = table(tstorecust);
tt.zip_code = tt.tstorecust;
tt2 = cellfun(@str2double, tt.zip_code);
tt2 = tt2(~isnan(tt2));
tt2table = table(tt2);
tt2table.zip_code = tt2table.tt2;
ttjoin = outerjoin(tt2table, zips, 'MergeKeys', true,'Type','left');

close all; 


lldata = [ttjoin.latitude,ttjoin.longitude];
%figure(111);hist3(lldata,[300,1200])
%set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');

% California map axes
figure(112); ax = usamap('conus');
setm(ax, 'FFaceColor', [.5 .7 .9])
title('USA map')

[NN,CC]=hist3(lldata,[300,1200]);


% read shapefile of US states with names and locations
states = geoshape(shaperead('usastatehi.shp', 'UseGeoCoords', true));

% display map
geoshow(states, 'Parent',ax)


% latitude/longitude coordinates and corresponding labels
lat = ttjoin.latitude;
lon = ttjoin.longitude;

% plot coordinates
%plot(lat, lon, 'rx')

% 
% CClat = []; 
% CClog = []; 
% CCnn = []; 
% for i = 1:150
%     for j = 1:300
%         CClat = [CClat CC{1}(i)];
%         CClog = [CClog CC{2}(j)]; 
%         CCnn = [CCnn NN(i,j)]; 
%     end
% end

% plot3m(CClat,CClog,CCnn,'LineStyle','none', 'LineWidth',2, 'Color','b', ...
%      'Marker','.', 'MarkerSize',10)

% linem(lat, lon, 'LineStyle','none', 'LineWidth',2, 'Color','r', ...
%     'Marker','.', 'MarkerSize',10)

[XX,YY] = meshgrid(CC{2},CC{1});
surfm(YY,XX,log(NN)); 
alpha(0.5)

% hold on; 

