function DSGrid = getGridOfDataset(DS)
% getGridOfDataset(DS): Get Grid object DSGrid from Dataset object DS.

DSGrid = Grid;

DSGrid.spatialDimension = getSpatialDimensionOfDataset(DS);

fileName = DS.fileNames{1};

ncID = netcdf.open(fileName, 'NOWRITE');

xi_uID = netcdf.inqDimID(ncID, 'xi_u');
[~, xi_uLen] = netcdf.inqDim(ncID, xi_uID);
xi_vID = netcdf.inqDimID(ncID, 'xi_v');
[~, xi_vLen] = netcdf.inqDim(ncID, xi_vID);
eta_uID = netcdf.inqDimID(ncID, 'eta_u');
[~, eta_uLen] = netcdf.inqDim(ncID, eta_uID);
eta_vID = netcdf.inqDimID(ncID, 'eta_v');
[~, eta_vLen] = netcdf.inqDim(ncID, eta_vID);
if DSGrid.spatialDimension == 3
  xi_rhoID = netcdf.inqDimID(ncID, 'xi_rho');
  [~, xi_rhoLen] = netcdf.inqDim(ncID, xi_rhoID);
  eta_rhoID = netcdf.inqDimID(ncID, 'eta_rho');
  [~, eta_rhoLen] = netcdf.inqDim(ncID, eta_rhoID);
end

netcdf.close(ncID);

xiLenMax = max([xi_uLen, xi_vLen, xi_rhoLen]);
etaLenMax = max([eta_uLen, eta_vLen, eta_rhoLen]);

% Sort of cheating here...
if xi_uLen == xiLenMax
  DSGrid.xVectorForU  = 0 : xi_uLen - 1;
elseif xi_uLen == xiLenMax - 1
  DSGrid.xVectorForU  = 0.5 : 1 : xi_uLen;
end
if xi_vLen == xiLenMax
  DSGrid.xVectorForV  = 0 : xi_vLen - 1;
elseif xi_vLen == xiLenMax - 1
  DSGrid.xVectorForV  = 0.5 : 1 : xi_vLen;
end
if eta_uLen == etaLenMax
  DSGrid.yVectorForU  = 0 : eta_uLen - 1;
elseif eta_uLen == etaLenMax - 1
  DSGrid.yVectorForU  = 0.5 : 1 : eta_uLen;
end
if eta_vLen == etaLenMax
  DSGrid.yVectorForV  = 0 : eta_vLen - 1;
elseif eta_vLen == etaLenMax - 1
  DSGrid.yVectorForV  = 0.5 : 1 : eta_vLen;
end
if DSGrid.spatialDimension == 3
  if xi_rhoLen == xiLenMax
    DSGrid.xVectorForW  = 0 : xi_rhoLen - 1;
  elseif xi_rhoLen == xiLenMax - 1
    DSGrid.xVectorForW  = 0.5 : 1 : xi_rhoLen;
  end
  if eta_rhoLen == etaLenMax
    DSGrid.yVectorForW  = 0 : eta_rhoLen - 1;
  elseif eta_rhoLen == etaLenMax - 1
    DSGrid.yVectorForW  = 0.5 : 1 : eta_rhoLen;
  end
  DSGrid.zVectorForU  = ncread(fileName, 's_rho');
  DSGrid.zVectorForV  = ncread(fileName, 's_rho');
  DSGrid.zVectorForW  = ncread(fileName, 's_w');
end