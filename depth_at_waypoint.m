function wdepth = depth_at_waypoint(latgrd, ...
    longrd,Zgrd,distrh,distgc,LAT1,LON1,LAT2,LON2)
%
wd = find_bdepth_gebco(latgrd,longrd,Zgrd,lattrk,lontrk);
x(1)=0;
for i = 2:length(lattrk)-1
    y = distance('rh',lattrk(i-1),lontrk(i-1),lattrk(i),lontrk(i));
    x(i) = deg2nm(y);
end
x_rh = cumsum(x);
wdepth_rh = wd(~isnan(wd));

clear np lattrk lontrk wd x;

% rhombus line depth profile
np = round(distgc);
[lattrk,lontrk] = track('gc',lat,lon,S,'degrees',np);
wd = find_bdepth_gebco(latgrd,longrd,Zgrd,lattrk,lontrk);
x(1)=0;
for i = 2:length(lattrk)-1
    y = distance('gc',lattrk(i-1),lontrk(i-1),lattrk(i),lontrk(i));
    x(i) = deg2nm(y);
end
x_gc = cumsum(x);
wdepth_gc = wd(~isnan(wd));

