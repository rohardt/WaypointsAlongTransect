function Plot_Map_Transect(latsec,lonsec)
%
%

% create figure
fsec = figure;
% Map limits:
LATLIM(1) = round(min(latsec) - 1);
LATLIM(2) = round(max(latsec) + 1);
LONLIM(1) = round(min(lonsec) - 1);
LONLIM(2) = round(max(lonsec) + 1);


% If latmax < 86 map projection is "mercator" otherwise "stereo"
if LATLIM < 86 
    % map settings for mercator:
    PTYPE = 'mercator';
    MGRID = 'on';
    
    % setting for the tick label
    x=[0.025 0.05 0.25 0.5 1 2 5 10 15 30 45];
    % latitude ticks
    m=(abs(diff(LATLIM)))./x;
    xx=x(m<=10 & m>=2);
    dpll=min(xx);
    pll=-90:dpll:90;
    clear m xx;
    %longitude ticks
    m=(abs(diff(LONLIM)))./x;
    xx=x(m<=10 & m>=2);
    dmll=min(xx);
    mll=-180:dmll:360;
    if dpll<1 || dmll<1
        lunits='dm';
    else
        lunits='degrees';
    end
    ax = axesm('MapProjection',PTYPE,...
	    'MapLatLimit',LATLIM,'MapLonLimit',LONLIM,...
	    'MeridianLabel','on','ParallelLabel','on',...
	    'MLabelLocation',mll,'PLabelLocation',pll,...
	    'LabelFormat','signed','LabelUnits','degrees',...
	    'MLineLocation',dmll,'PLineLocation',dpll,...
	    'LabelUnits',lunits,'FontSize',9,...
        'FontSize', 8 ,...
	    'Grid',MGRID);
    framem('FlineWidth',1,'FEdgeColor','black');
    mstruct = getm(ax);
else
    % map settings for "stereo"
    % compute center of all locations
    [latm,lonm] = meanm(latsec,lonsec);
    OY = round(latm,-1);
    if lonm < 100
        OX = round(lonm,0);
    else
        OX = round(lonm,-1);
    end
    % latmin to OY == FLAT
    FLAT = round((latm - LATLIM(1)),0).*2;
        LATLIM = [OY-FLAT OY+FLAT];
    LONLIM = [-180 180];
    if LATLIM(2) > 2
        LATLIM(2) = 90;
    end        
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
    pll=-90:dpll:90;
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
    'PLabelMeridian'        ,OX,...
    'FontSize', 8 ,...
    'Grid',MGRID);
end

hold on;
% plot coast lines:
load('coastlines.mat');
h1 = plotm(coastlat,coastlon,'b-');
set(h1,'LineWidth',1.5);
% plot marker waypoints (red)
h2 = plotm(latsec, lonsec);
set(h2,'LineStyle','none','Marker','.',...
    'MarkerSize',12,...
    'MarkerEdgeColor',[1 0 0], ...
    'MarkerFaceColor',[1 0 0]);

% Save figure in temporary image, which will be displayed in app
% WayPointsAlongTransect.mlapp:

print(fsec,'tmpgeoimg','-dpng'); % save a file geoimg.png
close(fsec);

 