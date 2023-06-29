function [x_rh,wdepth_rh,x_gc,wdepth_gc,lattrk_rh,lontrk_rh,lattrk_gc,lontrk_gc] = depth_along_transect(latgrd,longrd,Zgrd,distrh,distgc,LAT1,LON1,LAT2,LON2)
%

lat = [LAT1 LAT2];
lon = [LON1 LON2];

S = referenceSphere('earth');
% rhombus line depth profile
np = round(distrh);
[lattrk_rh,lontrk_rh] = track('rh',lat,lon,S,'degrees',np);
wd = find_bdepth_gebco(latgrd,longrd,Zgrd,lattrk_rh,lontrk_rh);
x(1)=0;
for i = 2:length(lattrk_rh)-1
    y = distance('rh',lattrk_rh(i-1),lontrk_rh(i-1),lattrk_rh(i),lontrk_rh(i));
    x(i) = deg2nm(y);
end
x_rh = cumsum(x);
wdepth_rh = wd(~isnan(wd));

clear np lattrk lontrk wd x;

% rhombus line depth profile
np = round(distgc);
[lattrk_gc,lontrk_gc] = track('gc',lat,lon,S,'degrees',np);
wd = find_bdepth_gebco(latgrd,longrd,Zgrd,lattrk_gc,lontrk_gc);
x(1)=0;
for i = 2:length(lattrk_gc)-1
    y = distance('gc',lattrk_gc(i-1),lontrk_gc(i-1),lattrk_gc(i),lontrk_gc(i));
    x(i) = deg2nm(y);
end
x_gc = cumsum(x);
wdepth_gc = wd(~isnan(wd));

