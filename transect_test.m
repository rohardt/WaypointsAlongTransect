function [latsec,lonsec,X,WD,nstat] = transect_test

pn = cd;
grdfile = fullfile(pn,'Dataset','GRIDONE_2D.mat');
load(grdfile);
latgrd = lat;
longrd = lon;
Zgrd = Z;
clear lat lon Z;

% Start/Stop of transect:
LAT = [-68 -60];
LON = [10 -30];
% rhombus line:
rhgc = "gc";
% spacing in 60 nautical miles
dist_stat = 60;
% flg = 0; % nautical miles
flg = 1; % distance = 60 minutes

% latORlon = 1; % not needed if flg = 0
% latORlon = 0; % 60 minutes longitude spacing
latORlon = 1; % 60 minutes latitude spacing

% compute
[latsec,lonsec,X,WD,nstat] = transect(latgrd,longrd,Zgrd,LAT,LON,rhgc,dist_stat,flg,latORlon);


function [latsec,lonsec,X,WD,nstat] = transect(latgrd,longrd,Zgrd,LAT,LON,rhgc,dist_stat,flg,latORlon)
% [latsec,lonsec,X,WD] = transect(latgrd,longrd,Zgrd,LAT,LON,rhgc,dist_stat,flg)
% compute stations along a section
% Input:
% LAT :== [start latitude of section, end latitude of section]
% LON :== [start longitude of section, end longitude of section]
% rhgc :== "rh" sections is a rhombus line
%          "gc" section is greate circle
% dist_stat := distance between stations in nautical miles
% flg :== determine if station spacing set on regular latitude or longitude
% spacing otherwise flg = 0
% latORlon :== (1) for equal latitude spacing  
%              (0) for equal longitude spacing  

% Topograpic grid from GRIDONE_2D.mat to find water depth at the stations
% along the section:
% Z         21601x10801            1866499208  double              
% lat       10801x1                     86408  double              
% lon       21601x1                    172808  double
% Output:
% [latsec,lonsec,X,WD,nstat]
% latsec, lonsec :== loctions of the stations along the section
% X              :== distance in nautical miles (0 nm is the section start)
% WD             :== waterdepth at the station
% nstat          :== number of stations along the section

switch rhgc
    case 'rh'
        [course,dist] = legs(LAT,LON,rhgc);
        nstat = round(dist/dist_stat);
        % last station in distance ndistance = nstat * dist_stat
        ndistance  = nstat * dist_stat;
        % replace end position of section
        arclen = nm2deg(ndistance);
        [latx,lonx] = reckon(rhgc,LAT(1),LON(1),arclen,course);
        LAT(2) = latx;
        LON(2) = lonx;
        wgs84 = wgs84Ellipsoid("nm");
        [latsec,lonsec] = track2('rh',LAT(1),LON(1),LAT(2),LON(2),wgs84,'degrees',nstat+1);

        if flg % station placed along latitude or longitude in equal regular spacing
            [latsec,lonsec] = Make_Station_LatLon(latsec,lonsec,dist_stat,latORlon);
        end
        nstat = length(latsec);            
        [~,x] = legs(latsec,lonsec,"rh");
    case 'gc'
        dist_section = deg2nm(distance(rhgc,LAT(1),LON(1),LAT(2),LON(2)));
        nstat = round(dist_section/dist_stat);
        [latsec,lonsec] = gcwaypts(LAT(1),LON(1),LAT(2),LON(2),nstat);

        if flg % station placed along latitude or longitude in equal regular spacing
            [latsec,lonsec] = Make_Station_LatLon(latsec,lonsec,dist_stat,latORlon);
        end
        nstat = length(latsec);        
        [~,x] = legs(latsec,lonsec,"gc");
end
x = [0; x];
X = cumsum(x);
WD = find_bdepth_gebco(latgrd,longrd,Zgrd,latsec,lonsec);

function [slat,slon] = Make_Station_LatLon(glat,glon,dx,latlon)
% [slat,slon] = Make_Station_LatLon(glat,glon)
% This funktion used locations along a section given in regular spacing in
% nautical miles to compute locations as regular spaced latitudes or
% longitudes. 
% glat, glon == lat/lon of section
% dx == spacing in minutes
% latlon == (1) for equal latitude spacing  
%           (0) for equal longitude spacing

% if range(glat) >= range(glon)
%     latlon = 1;
% else
%     latlon = 0;
% end

dx = dx/60;

xmod = mod(glat,dx);
latlim = glat-xmod;
latlim = sort(latlim);
latlim(2) = latlim(length(latlim));
x = latlim(1) : dx : latlim(2);

xmod = mod(glon,dx);
lonlim = glon-xmod;
lonlim = sort(lonlim);
lonlim(2) = lonlim(length(lonlim));
y = lonlim(1) : dx : lonlim(2);


if latlon
    n=2*length(x);
    lat=ones(1,n);
    lon=ones(1,n);
    i1 = 4:4:n;
    i2 = 2:4:n;
    lat(1:2:n) = x;
    lat(2:2:n) = x;
    lon(i1) = lonlim(1);
    lon(i1+1) = lonlim(1);
    lon(i2) = lonlim(2);
    lon(i2+1) = lonlim(2);
    lon= lon(1:n);
    lon(1) = lonlim(1);
    lon(n) = lonlim(2);
else
    n=2*length(y);
    lat=ones(1,n);
    lon=ones(1,n);
    i1 = 4:4:n;
    i2 = 2:4:n;
    lon(1:2:n) = y;
    lon(2:2:n) = y;
    lat(i1) = latlim(1);
    lat(i1+1) = latlim(1);
    lat(i2) = latlim(2);
    lat(i2+1) = latlim(2);
    lat= lat(1:n);
    lat(1) = latlim(1);
    lat(n) = latlim(2);
end

[slat,slon] = polyxpoly(lat,lon, ...
                    glat,glon);
% sort column 1 (latitude) or 2 (longitude)
T = table(slat,slon);
if latlon
    if glat(2) < glat(1)
        A = sortrows(T,1,"descend");
    else
        A = sortrows(T,1,"ascend");
    end
else
    if glon(2) < glon(1)
        A = sortrows(T,2,"descend");
    else
        A = sortrows(T,2,"ascend");
    end
end
slat = A.slat;
slon = A.slon;

% slat = slat';
% slon = slon';