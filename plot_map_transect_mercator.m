function plot_map_transect_mercator(latsec,lonsec)
%
fgeo = figure;
geoplot(latsec,lonsec,'r.');
print(fgeo,'tmpgeoimg','-dpng'); % save a file geoimg.png
close(fgeo);