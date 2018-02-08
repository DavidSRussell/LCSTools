function [xPhys, yPhys, zPhys] = getPhysicalPositionsChesROMS(xi, eta, sigma, t, DS)
% getPhysicalPositionsChesROMS(xi, eta, sigma, t, DS): Get physical
% positions (longitude, latitude, depth in meters) for a ChesROMS dataset
% given grid-space coordinates xi, eta, and sigma.

% Get grid vectors
if ~isempty(DS.Grid)
  DSGrid = DS.Grid;
else
  DSGrid = getGridOfDataset(DS);
end
xgv4w = DSGrid.xVectorForW;
ygv4w = DSGrid.yVectorForW;
zgv4w = DSGrid.zVectorForW;
xDimForW = length(xgv4w);
yDimForW = length(ygv4w);
zDimForW = length(zgv4w);

% Get static data
fileName = DS.fileNames{1};
lon_rho = ncread(fileName, 'lon_rho');
lat_rho = ncread(fileName, 'lat_rho');
hForInterp = ncread(fileName, 'h');
Cs_wForInterp = ncread(fileName, 'Cs_w');
hc = ncread(fileName, 'hc');

% Get dynamic data (zeta only)
dataFileNames = DS.fileNames;
startFileTimeVector = ncread(fileName, 'ocean_time');
tVectorsByFile = NaN(length(startFileTimeVector), length(dataFileNames));
for i = 1 : length(dataFileNames)
  tVectorsByFile(:, i) = ncread(dataFileNames{i}, 'ocean_time');
end
[tVecForInterp, tVBFInds] = getCoveringSubGridVector(tVectorsByFile(:), t);
zetaForInterp = NaN(xDimForW, yDimForW, length(tVBFInds));
for ind = tVBFInds
  [tVecInd, fileInd]  = ind2sub(size(tVectorsByFile), ind);
  zetaForInterp(:, :, ind - tVBFInds(1) + 1) = ncread(dataFileNames{fileInd}, 'zeta', ...
    [1, 1, tVecInd], [xDimForW, yDimForW, 1]);
end

%% Get true x (longitude) and y (latitude)

xPhys = interpn(xgv4w, ygv4w, lon_rho, xi, eta);
yPhys = interpn(xgv4w, ygv4w, lat_rho, xi, eta);

%% Get true z (following ChesROMS documentation)

if size(zetaForInterp, 3) > 1
  zetaForTempInterp = NaN([2, size(xi)]);
  zetaForTempInterp(1, :, :, :) = interpn(xgv4w, ygv4w, ...
    zetaForInterp(:, :, 1), xi, eta);
  zetaForTempInterp(2, :, :, :) = interpn(xgv4w, ygv4w, ...
    zetaForInterp(:, :, 2), xi, eta);
  zeta = squeeze(interp1(tVecForInterp', zetaForTempInterp, t, 'linear'));
else
  zeta = interpn(xgv4w, ygv4w, zetaForInterp, xi, eta);
end

h = interpn(xgv4w, ygv4w, hForInterp, xi, eta);

Cs = interp1(zgv4w, Cs_wForInterp, sigma, 'linear');

S = hc*sigma + (h - hc).*Cs;

zPhys = S + zeta.*(1 + S./h);