function [latsec,lonsec,X,WD,nstat,i1] = add_wp_to_transect(x,rhgc, ...
                lat,lon,Xin,WDin,nstat,latgrd,longrd,Zgrd)
%

% x is the distance of the waypoint to be inserted
% find the index of x placed be X, the distances of the existing waypoints
x0 = Xin(Xin<=x);
i1 = length(x0);
i2 = i1 + 1;

% compute the direction from lat(i1)/lon(i1) to lat(i2)/lon(i2)
[course,~] = legs([lat(i1) lat(i2)],[lon(i1) lon(i2)],rhgc);
% dist = distance from X(i1) to x
dist = nm2deg(x - Xin(i1));
% compute lat, lon of the inserted waypoint
% pt(1) == latitude
% pt(2) == longitude
pt = reckon(rhgc,lat(i1),lon(i1),dist,course);

% water depth at x:
z = find_bdepth_gebco(latgrd,longrd,Zgrd,pt(1),pt(2));

% insert new waypoint, water depth and distance
latsec = lat(1:i1);
lonsec = lon(1:i1);
X = Xin(1:i1);
WD = WDin(1:i1);

latsec = [latsec; pt(1); lat(i2:nstat)];
lonsec = [lonsec; pt(2); lon(i2:nstat)];
X = [X; x; Xin(i2:nstat)];
WD = [WD; z; WDin(i2:nstat)];
% new number of waypoints:
nstat = nstat + 1;





