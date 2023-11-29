function GRIDONEnc2mat
% Download GEBCO One Minute Grid, file GRIDONE_2D.nc, from link
% (https://www.gebco.net/data_and_products/historical_data_sets/#gebco_one)
% Unzip and save GRIDONE_2D.nc in your Matlab working directory. 
% Execute ...\Perplex7\Utilities\GRIDONEnc2mat.m, select the nc-file and 
% choosethe output folder ..\Perplex7\Dataset. 

% Select the directory where GRIDONE_2D.nc is located. 
pn = uigetdir;
gebco_file = fullfile(pn,'GRIDONE_2D.nc');

% open file:
ncid = netcdf.open(gebco_file,'NC_NOWRITE');

% If another netCDF is used, the following instructions can be used to get
% an overview of the file.
%
% [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
% [dimname0, dimlen0] = netcdf.inqDim(ncid,0);
% [dimname1, dimlen1] = netcdf.inqDim(ncid,1);
% [varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,0);
% [varname1,xtype1,dimids1,natts1] = netcdf.inqVar(ncid,1);
% [varname2,xtype2,dimids2,natts2] = netcdf.inqVar(ncid,2);
% varid = netcdf.inqVarID(ncid,'z');

%retrieve lat, lon and elivation
varid = netcdf.inqVarID(ncid,'lat');
lat = netcdf.getVar(ncid,varid);


varid = netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid,varid);

varid = netcdf.inqVarID(ncid,'elevation');
z = netcdf.getVar(ncid,varid);
Z = double(z);


outfile = fullfile(pn,'GRIDONE_2D.mat');
save(outfile,'lat','lon','Z');
disp('end');

% To use this MAT-file together with Perplex7 copy file to
% ..\Perplex\Dataset 

end