function depth = find_bdepth_gebco(latgrd,longrd,Zgrd,LAT,LON)
% depth = find_bdepth_gebco(latgrd,longrd,Zgrd,LAT,LON)
% this is a function to be used together with Perplex7.mlapp where 
% Zgrd         21601x10801            1866499208  double              
% latgrd       10801x1                     86408  double              
% longrd       21601x1                    172808  double 
% was loaded from 'GRIDONE_2D.mat' in startupfnc. It retrieves the water
% depth along the cruise track respectivily at waypoints and stations.
% See GRIDONEnc2mat.m (..\Utilities) to convert the original netCDF (GRIDONE_2D.nc) into
% the MAT-file.
% Gerd Rohardt; 20.02.2023
    
    n = length(LAT);
    
    depth = nan(n,1);
    
    for k = 1:n
        % y-axis or matrix row of Zgrd(i,j): (LONGITUDE)
        i = find(longrd>LON(k));
        if isempty(i) % LON == 180
            i2 = length(longrd);
            i1 = i2 - 2;
        elseif length(i) == length(longrd)-1 % LON == -180
            i1 = 1;
            i2 = 3;
        else
            i1 = i(1) - 1;
            i2 = i(1) + 1;
        end 
        i = i1:i2;
        
        % x-axis or matrix column of Zgrd(i,j): (LATITUDE)
        j = find(latgrd>LAT(k));
        if isempty(j) % LAT == 90
            j2 = length(latgrd);
            j1 = j2 - 2;
        elseif length(j) == length(latgrd)-1 % LAT == -90
            j1 = 1;
            j2 = 3;
        else
            j1 = j(1) - 1;
            j2 = j(1) + 1;
            if j2 >10801
                j2 = 10801;
            end
        end 
        j = j1:j2;
        
        
        X = latgrd(j);
        Y = longrd(i);
        A = Zgrd(i,j);
        
        depth(k) = interp2(X,Y,A,LAT(k),LON(k));
    end

end
