function plot_map_transect_stereo(latsec,lonsec)
%

fgeo = figure;

LATLIM = [min(latsec) max(latsec)];
LONLIM = [min(lonsec) max(lonsec)];
        [latm,lonm] = meanm(latsec,lonsec);
        OY = round(latm,0); 
        if lonm < 100
            OX = round(lonm,0);
        else
            OX = round(lonm,-1);
        end
        % latmin to OY == FLAT
        FLAT = round((latm - LATLIM(1)),0);
    PTYPE = 'stereo';
    MGRID = 'on';
    FLATLIM = [-inf FLAT];
    FLONLIM = [-180 180];
    OYOX = [OY OX OX];

    DLON = 360;
    
    x = [0.025 0.05 0.25 0.5 1 2 5 10 15 30 45];
    m = 2.*FLAT ./ x;
    xx=x(m<=10 & m>=2);
    dpll=min(xx);
    pll=round(LATLIM(1)):dpll:90;
    clear m xx;
    m=DLON./x;
    xx=x(m<=10 & m>=2);
    dmll=min(xx);
    mll=-180:dmll:360;
    
    if dpll<1 || dmll<1
        lunits='dm';
    else
        lunits='degrees';
    end
    ax = axesm('MapProjection',PTYPE,...
        'FLatLimit'             ,FLATLIM,...
        'FLonLimit'             ,FLONLIM,...
        'MeridianLabel'         ,'on',...
        'ParallelLabel'         ,'on',...
        'Origin'                ,OYOX,...
    'MLabelLocation'        ,mll,...
    'PLabelLocation'        ,pll,...
    'LabelFormat'           ,'signed',...
    'LabelUnits'            ,'degrees',...
    'MLineLocation'         ,dmll,...
    'PLineLocation'         ,dpll,...
    'LabelUnits'            ,lunits,...
    'ParallelLabel'         ,'on',...
    'MLabelParallel'        ,OY,...
    'PLabelMeridian'        ,OX+10,...
    'FontSize', 8 ,...
    'Grid',MGRID);
    
    % remove frame
    set(ax,'XColor',[1 1 1]);
    set(ax,'YColor',[1 1 1]);

    % plot the coastline (blue)
    load('coastlines.mat');
    h1=plotm(coastlat,coastlon,'b-');
    set(h1,'LineWidth',1.5);

    % plot waypoints
    h2=plotm(latsec,lonsec,'r.');
    set(h2,'MarkerSize',15);
    
 
print(fgeo,'tmpgeoimg','-dpng'); % save a file geoimg.png
close(fgeo);