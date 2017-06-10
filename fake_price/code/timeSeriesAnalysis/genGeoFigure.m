function genGeoFigure (latitude, longitude, prefix, id, titleStr, dotLatNew, dotLonNew, dotTypeNew, dotLatOld, dotLonOld, dotTypeOld)

maxTHold = 8; 
doNormalize = true; 

lldata = [latitude, longitude];
%figure(111);hist3(lldata,[300,1200])
%set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');

f = figure(112); clf(f); ax = usamap('conus');
setm(ax, 'FFaceColor', [.5 .7 .9])

min1 = 10; max1 = 70; 
min2 = -175; max2 = 150; 

xb = linspace(min1, max1, 300*2); 
yb = linspace(min2, max2, 1625*2); 

[NN,CC]=hist3(lldata,{xb, yb});


% read shapefile of US states with names and locations
states = geoshape(shaperead('usastatehi.shp', 'UseGeoCoords', true));

% display map
geoshow(states, 'Parent',ax)


% latitude/longitude coordinates and corresponding labels

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
dotLatNewC3 = dotLatNew(dotTypeNew == 3); 
dotLatNewC5 = dotLatNew(dotTypeNew == 5); 
dotLonNewC3 = dotLonNew(dotTypeNew == 3); 
dotLonNewC5 = dotLonNew(dotTypeNew == 5); 

dotLatOldC3 = dotLatOld(dotTypeOld == 3);
dotLatOldC5 = dotLatOld(dotTypeOld == 5); 
dotLonOldC3 = dotLonOld(dotTypeOld == 3); 
dotLonOldC5 = dotLonOld(dotTypeOld == 5); 

if ~isempty(dotLatNewC3)
    linem(dotLatNewC3, dotLonNewC3, 'LineStyle','none', 'LineWidth',2, 'Color',[1 0 1], ...
        'Marker','x', 'MarkerSize',6)
end
if ~isempty(dotLatNewC5)
    linem(dotLatNewC5, dotLonNewC5, 'LineStyle','none', 'LineWidth',2, 'Color',[.7 .6 0], ...
        'Marker','x', 'MarkerSize',6)
end
if ~isempty(dotLatOldC3)
    linem(dotLatOldC3, dotLonOldC3, 'LineStyle','none', 'LineWidth',2, 'Color',[1 0 1], ...
        'Marker','s', 'MarkerSize',5)
end
if ~isempty(dotLatOldC5)
    linem(dotLatOldC5, dotLonOldC5, 'LineStyle','none', 'LineWidth',2, 'Color',[.7 .6 0], ...
        'Marker','s', 'MarkerSize',5)
end

[XX,YY] = meshgrid(CC{2},CC{1});
if ~doNormalize
    NNN = log(NN); 
    limits = [0,maxTHold]; 
else
    NNN = log(NN./sum(NN(:))); 
    NNN(isinf(NNN)) = nan; 
    limits = [-11,3]; 
end
surfm(YY,XX,NNN); 
cmapsea = [0 0 1; 1 1 0];
cmapland = [0 0 1; 0 0 1]; 
demcmap(limits, 120, cmapsea, cmapland); 
%colorbar;

title([titleStr,' - m:', num2str(max(NNN(:))), '-', num2str(min(NNN(:)))]);  
alpha(0.5)

set(f, 'Position', [0, 0, 1920, 1080]);
set(f, 'PaperUnits', 'inches'); 
set(f, 'PaperPosition', [0, 0, 18, 12]); 
print(f, sprintf('./figures/%s_%d', prefix, id), '-dpng'); 

% hold on; 
