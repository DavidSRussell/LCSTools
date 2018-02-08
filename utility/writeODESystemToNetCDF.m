function writeODESystemToNetCDF(ODESys, ODESysGrid)
% writeODESystemToNetCDF(ODESys, ODESysGrid): Converts "ODESys" (an object
% of type ODESystem) into a discrete netCDF dataset based on the grid
% "ODESysGrid" (an object of type Grid).

% Create file
fileName = [ODESys.name,'.nc'];
fileID = netcdf.create(fileName,'NOCLOBBER');

% Define dimensions
xi_uID = netcdf.defDim(fileID,'xi_u',length(ODESysGrid.xVector_u));
xi_vID = netcdf.defDim(fileID,'xi_v',length(ODESysGrid.xVector_v));
eta_uID = netcdf.defDim(fileID,'eta_u',length(ODESysGrid.yVector_u));
eta_vID = netcdf.defDim(fileID,'eta_v',length(ODESysGrid.yVector_v));
if ODESys.temporalDimension == 1
    ocean_timeID = netcdf.defDim(fileID,'ocean_time',length(ODESysGrid.tVector));
end
if ODESys.spatialDimension == 3
    xi_rhoID = netcdf.defDim(fileID,'xi_rho',length(ODESysGrid.xVector_w));
    eta_rhoID = netcdf.defDim(fileID,'eta_rho',length(ODESysGrid.yVector_w));
    s_rhoID = netcdf.defDim(fileID,'s_rho',length(ODESysGrid.zVector_u));
    s_wID = netcdf.defDim(fileID,'s_w',length(ODESysGrid.zVector_w));
end

% Define variables
if ODESys.spatialDimension == 2
    if ODESys.temporalDimension == 0
        uID = netcdf.defVar(fileID,'u','double',[xi_uID,eta_uID]);
        vID = netcdf.defVar(fileID,'v','double',[xi_vID,eta_vID]);
    elseif ODESys.temporalDimension == 1
        uID = netcdf.defVar(fileID,'u','double',[xi_uID,eta_uID,ocean_timeID]);
        vID = netcdf.defVar(fileID,'v','double',[xi_vID,eta_vID,ocean_timeID]);
        ocean_timeID = netcdf.defVar(fileID,'ocean_time','double',ocean_timeID);
    end
elseif ODESys.spatialDimension == 3
    if ODESys.temporalDimension == 0
        uID = netcdf.defVar(fileID,'u','double',[xi_uID,eta_uID,s_rhoID]);
        vID = netcdf.defVar(fileID,'v','double',[xi_vID,eta_vID,s_rhoID]);
        wID = netcdf.defVar(fileID,'w','double',[xi_rhoID,eta_rhoID,s_wID]);
    elseif ODESys.temporalDimension == 1
        uID = netcdf.defVar(fileID,'u','double',[xi_uID,eta_uID,s_rhoID,ocean_timeID]);
        vID = netcdf.defVar(fileID,'v','double',[xi_vID,eta_vID,s_rhoID,ocean_timeID]);
        wID = netcdf.defVar(fileID,'w','double',[xi_rhoID,eta_rhoID,s_wID,ocean_timeID]);
        ocean_timeID = netcdf.defVar(fileID,'ocean_time','double',[ocean_timeID]);
    end
end

% Exit 'define' mode
netcdf.endDef(fileID)

% Assign variables
if ODESys.spatialDimension == 2
    [X_u,Y_u] = ndgrid(ODESysGrid.xVector_u,ODESysGrid.yVector_u);
    [X_v,Y_v] = ndgrid(ODESysGrid.xVector_v,ODESysGrid.yVector_v);
    if ODESys.temporalDimension == 0
        [U,~] = ODESys.timeDerivative(X_u,Y_u);
        [~,V] = ODESys.timeDerivative(X_v,Y_v);
    elseif ODESys.temporalDimension == 1
        U = NaN([size(X_u),length(ODESysGrid.tVector)]);
        V = NaN([size(X_v),length(ODESysGrid.tVector)]);
        for i = 1:length(ODESysGrid.tVector)
            t = ODESysGrid.tVector(i);
            [U_t,~] = ODESys.timeDerivative(X_u,Y_u,t);
            [~,V_t] = ODESys.timeDerivative(X_v,Y_v,t);
            U(:,:,i) = U_t;
            V(:,:,i) = V_t;
        end
    end
    netcdf.putVar(fileID,uID,U);
    netcdf.putVar(fileID,vID,V);
elseif ODESys.spatialDimension == 3
    [X_u,Y_u,Z_u] = meshgrid(ODESysGrid.xVector_u, ...
      ODESysGrid.yVector_u,ODESysGrid.zVector_u);
    [X_v,Y_v,Z_v] = meshgrid(ODESysGrid.xVector_v, ...
      ODESysGrid.yVector_v,ODESysGrid.zVector_v);
    [X_w,Y_w,Z_w] = meshgrid(ODESysGrid.xVector_w, ...
      ODESysGrid.yVector_w,ODESysGrid.zVector_w);
    if ODESys.temporalDimension == 0
        [U,~,~] = ODESys.timeDerivative(X_u,Y_u,Z_u);
        [~,V,~] = ODESys.timeDerivative(X_v,Y_v,Z_v);
        [~,~,W] = ODESys.timeDerivative(X_w,Y_w,Z_w);
    elseif ODESys.temporalDimension == 1
        U = NaN([size(X_u),length(ODESysGrid.tVector)]);
        V = NaN([size(X_v),length(ODESysGrid.tVector)]);
        W = NaN([size(X_w),length(ODESysGrid.tVector)]);
        for i = 1:length(ODESysGrid.tVector)
            t = ODESysGrid.tVector(i);
            [U_t,~,~] = ODESys.timeDerivative(X_u,Y_u,Z_u,t);
            [~,V_t,~] = ODESys.timeDerivative(X_v,Y_v,Z_v,t);
            [~,~,W_t] = ODESys.timeDerivative(X_w,Y_w,Z_w,t);
            U(:,:,:,i) = U_t;
            V(:,:,:,i) = V_t;
            W(:,:,:,i) = W_t;
        end
    end
    netcdf.putVar(fileID,uID,U);
    netcdf.putVar(fileID,vID,V);
    netcdf.putVar(fileID,wID,W);
    if ODESys.temporalDimension == 1
         netcdf.putVar(fileID,ocean_timeID,ODESysGrid.tVector);
    end
end

% Close file
netcdf.close(fileID)