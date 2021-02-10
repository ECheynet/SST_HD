function [SST,lon,lat,mask,time] = getSST(urldat,targetLat,targetLon,varargin)
% [SST,mask,time] = getSST(urldat,targetLat,targetLon) collects sea
% surface semperature (SST) data from the High Resolution Sea Surface
% Temperature (GHRSST) Level 4 sea surface temperature analysis. These data
% are produced on a daily basis by the JPL OurOcean group. A complete
% description of the data set is available at
% https://podaac.jpl.nasa.gov/dataset/JPL_OUROCEAN-L4UHfnd-GLOB-G1SST. The
% data are available on a 0.009 degree grid, i.e. a horizontal resolution
% of approximatively 1 km.
%
% Input:
%   -urldat: string file containing the url of the netcdf file to
%   download
%   -targetLat: scalar or vector: latitude of the location to get the SST
%   -targetLon: scalar or vector: longitude of the location to get the SST
%   - optional: errMax: maximal error in km between target and found location
%               It is 3 km by default. It is only used for the case where
%               a single location is requested.
%               resolution: in degree, resolution of the lat-lon grid in 
%               the case where multiple locations are requested
% 
% Output:
%   -SST: vector or 2D matrix containing the SST data at the target
%   locations
%   -lon: scalar or vector:  longitude of the location at which the SST
%   data is extracted
%   -lat: scalar or vector: latitude of the location at which the SST
%   data is extracted
%   -mask: mask for the coastline and terrain
%   -time: scalar: datetime at which the SST is extracted
%
% Author: E. Cheynet - UiB - last modified: 10-02-2021
%

%%
%% Inputparseer
p = inputParser();
p.CaseSensitive = false;
p.addOptional('errMax',3); % 3 km is the default "tolerance".
p.addOptional('resolution',0.01); %  resolution in degree if multiple loations are requested
p.parse(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%
errMax = p.Results.errMax ; % maximal error in km between target and found location
resolution = p.Results.resolution ; % default value is 0.01 deg

try
    lon00 = ncread(urldat,'lon');
    lat00 = ncread(urldat,'lat');
    
    %% If only one location is requested
    % Identify the location around the target latitudes and longitude
    
    if numel(targetLat)==1 && numel(targetLon)==1 % case where a single location is requested
        indLat = find(lat00>=targetLat-0.25 & lat00<=targetLat+0.25);
        indLon = find(lon00>=targetLon-0.25 & lon00<=targetLon+0.25);
        
    else
        indLat = find(lat00>=min(targetLat) & lat00<=max(targetLat));
        indLon = find(lon00>=min(targetLon) & lon00<=max(targetLon));
        [lon,lat] = meshgrid(targetLon(1):resolution:targetLon(end),targetLat(1):resolution:targetLat(end));
        [Nlat,Nlon]=size(lat);
    end
    
    lat00 = lat00(indLat);
    lon00 = lon00(indLon);
    startLoc = [indLon(1), indLat(1),1];
    count = [indLon(end)-indLon(1)+1, indLat(end)-indLat(1)+1,1];
    
    % Read the netcdf files to get the SST, mask and time
    T0 = ncread(urldat,'analysed_sst',startLoc,count);
    mask0 = ncread(urldat,'mask',startLoc,count);
    time0 = ncread(urldat,'time')./86400+datenum('1981-01-01 00:00:00');
    time = datetime(datestr(double(time0)));
    
    [lat0,lon0]=meshgrid(lat00,lon00);
    
    
    lon1 = double(lon0(:));
    lat1 = double(lat0(:));
    SST1 = T0(:);
    mask1 = mask0(:);
    
    
    if numel(targetLat)==1 && numel(targetLon)==1
        [indLonLat] = find(lon1<targetLon+0.25 & lon1 >targetLon-0.25 & lat1 >targetLat-0.25 & lat1 <targetLat+0.25 & ~isnan(SST1));
        if ~isempty(indLonLat)
            
            
            [ ~, indMinLat] = min(abs(lat1-targetLat));
            [ ~, indMinLon] = min(abs(lon1-targetLon));
            [d1km]=ll2km([targetLat,targetLon],[lat1(indMinLat) lon1(indMinLon)]);

            if d1km<=errMax % if target distance is at less than 3 km, interpolate to target lat ond lon
                F1 = scatteredInterpolant(lon1(indLonLat),lat1(indLonLat),SST1(indLonLat));
                F2 = scatteredInterpolant(lon1(indLonLat),lat1(indLonLat),mask1(indLonLat));
                
                SST = F1(targetLon,targetLat);
                mask = F2(targetLon,targetLat);
                lon = targetLon;
                lat = targetLat;
            else
                warning(['Distance between target and found location is more than ',num2str(round(errMax)),' km. Data set as NaN']);
                SST=nan;
                mask=nan;
                time = NaT;
                lon = nan;
                lat = nan;
            end
        else
            SST=nan;
            mask=nan;
            time = NaT;
        end
    else % case where multiple locations are requested
        
        [indLonLat] = find(lon1<=max(targetLon) & lon1 >=min(targetLon) & lat1 >=min(targetLat) & lat1 <=max(targetLat));
        if ~isempty(indLonLat)
            mask1 = mask1(indLonLat);
            
            F1 = scatteredInterpolant(lon1(indLonLat),lat1(indLonLat),SST1(indLonLat));
            F2 = scatteredInterpolant(lon1(indLonLat),lat1(indLonLat),mask1(indLonLat));
            SST = F1(lon,lat);
            mask = F2(lon,lat);

        else
            lon = nan(Nlat,Nlon);
            lat = nan(Nlat,Nlon);
            SST=nan(Nlat,Nlon);
            mask=nan(Nlat,Nlon);
            time = NaT;
        end
        
    end
    
catch exception
    warning on
    disp(exception);
    [~,name0,~] = fileparts(urldat);
    warning([name0, ' is not readable'])
    SST1=nan;
    mask1=nan;
    time = NaT;
end

%% Distance in km from lat/lon using the Haversine formula
    function [d]=ll2km(ll1,ll2)
        % [d]=ll2km(ll1,ll2) computes the distance between 2 points, based
        % on their coordiantes in terms of latitude and longitude using the
        % Haversine formula
        %
        % Distance:
        % d1km: distance in km based on Haversine formula
        %
        % Inputs:
        %   ll1 = [lat,lon] of point 1
        %   ll2 = [lat,lon] of point 2
        %
        % Outputs:
        % d: distance in km obtained using the Haversine formula
        a=sind((ll2(1)-ll1(1))/2)^2 + cosd(ll1(1))*cosd(ll2(1)) * sind((ll2(2)-ll1(2))/2)^2;
        c=2*atan2(sqrt(a),sqrt(1-a));
        d=6371*c;
    end
end

