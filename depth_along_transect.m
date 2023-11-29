function [x_rh,wdepth_rh,x_gc,wdepth_gc,lattrk_rh,lontrk_rh,lattrk_gc,lontrk_gc] = depth_along_transect(latgrd,longrd,Zgrd,distrh,distgc,LAT1,LON1,LAT2,LON2)
% From the GEBCO data set, the water depth is determined along the
% transect given with the position at the beginning and end.
% Input: 
% latgrd,longrd,Zgrd :== GRIDONE_2D.mat; GEBCO data set
% distrh :== total length in nautical miles of the transect along rhombus line
% distgc :== total length in nautical miles of the transect along great circle
% LAT1, LON1 :== start position of the transect
% LAT2, LON2 :== end position of the transect
% Output:
% x_rh :== distance (nautical miles) vector for the rhombus line
% wdepth_rh :== waterdepth (m) vector for the rhombus line
% x_gc :== distance (nautical miles) vector for the great circle
% wdepth_gc :== waterdepth (m) vector for the great circle
% lattrk_rh,lontrk_rh :== corresponding latitudes and longitudes for the
% rhombus line
% lattrk_gc,lontrk_c :== corresponding latitudes and longitudes for the
% great circle

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

