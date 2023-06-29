function [lg,lm,s]=deg2degmin(deg,sx)
% function [lg,lm,s]=deg2degmin(deg,sx)
% [lg,lm,s]=deg2degmin(-70.51)
% lg=-70, lm=30.6, s=[]
%
% [lg,lm,s]=deg2degmin(-70.51,'LAT')
% lg=70, lm=30.6, s='S'
%
% [lg,lm,s]=deg2degmin(70.51,'LON')
% lg=70, lm=30.6, s='E'
%
% Perplex7 uses position in decimal degrees, negativ values correspod to
% Latitude "South" or Longitude "West". Decemal degrees were convertes e.g.
% -65.5925 to 65 35.55 S for the station plan which is the common writing
% for nautical purpose.

if nargin < 2
   sx='#';
end

if deg == 0
    lg = 0;
    lm = 0;
    if strcmp(sx,'LAT')
        s = 'N';
    else
        s = 'E';
    end
else
    lg=floor(abs(deg));
    lm=(abs(deg)-abs(lg))*60;
    lm=roundn(lm,-4);
    if deg < 0
        if strcmp(sx,'#')
            lg=-lg;
            lm=-lm;  
        elseif strcmp(sx,'LAT')
            s='S';
        else
            s='W';
        end
    end
    if deg >= 0
        if strcmp(sx,'LAT')
            s='N';
        else
            s='E';
        end
    end
end
    if strcmp(sx,'#')
        s=[];
    end