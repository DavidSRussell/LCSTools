function StateDerivative = datasetStateDerivative(State, t, VelocityData, ...
  tGridVector, Grid, InterpolationMethods)
% datasetStateDerivative(State, t, VelocityData, tGridVector, Grid,
% InterpolationMethods): Calculate state derivative by interpolating a
% velocity dataset. State is a SystemState object, and StateDerivative is a
% structure with correspondingly named fields.

% Unpack state
x = State.x;
y = State.y;
if ismember('z', fieldnames(State)) && ~isempty(State.z)
  spatialDimension = 3;
  z = State.z;
else
  spatialDimension = 2;
end

% Unpack velocity data (each given on spatio-temporal grid)
uForInterp = VelocityData.uForInterpolation;
vForInterp = VelocityData.vForInterpolation;
if spatialDimension == 3
  wForInterp = VelocityData.wForInterpolation;
end

% Unpack grid arrays
GridArrays = getGrid2DArrays(Grid, @meshgrid);
xGridArrForU = GridArrays.xGridArrayForU;
yGridArrForU = GridArrays.yGridArrayForU;
xGridArrForV = GridArrays.xGridArrayForV;
yGridArrForV = GridArrays.yGridArrayForV;
if spatialDimension == 3
  xGridArrForW = GridArrays.xGridArrayForW;
  yGridArrForW = GridArrays.yGridArrayForW;
  zGridVecForU = Grid.zVectorForU;
  zGridVecForV = Grid.zVectorForV;
  zGridVecForW = Grid.zVectorForW;
end

% Unpack interpolation methods
hInterpMethod = InterpolationMethods.horizontalInterpolationMethod;
vInterpMethod = InterpolationMethods.verticalInterpolationMethod;
tInterpMethod = InterpolationMethods.temporalInterpolationMethod;

% Set up temporal interpolation matrices
uForTempInterp = NaN([size(x), length(tGridVector)]);
vForTempInterp = NaN([size(x), length(tGridVector)]);
if spatialDimension == 3
  wForTempInterp = NaN([size(x), length(tGridVector)]);
end

% Interpolate spatially
for tInd = 1 : length(tGridVector)
  if spatialDimension == 2
    uForTempInterp(:, :, tInd) = interp2(xGridArrForU, ...
      yGridArrForU, uForInterp(:, :, tInd)', x, y, hInterpMethod);
    vForTempInterp(:, :, tInd) = interp2(xGridArrForV, ...
      yGridArrForV, vForInterp(:, :, tInd)', x, y, hInterpMethod);
  elseif spatialDimension == 3
    uForVertInterp = NaN([size(x), length(zGridVecForU)]);
    vForVertInterp = NaN([size(x), length(zGridVecForV)]);
    wForVertInterp = NaN([size(x), length(zGridVecForW)]);
    for zInd = 1 : length(zGridVecForU)
      eval(['uForVertInterp(', repmat(':, ', [1, length(size(x))]), ...
        'zInd) = interp2(xGridArrForU, yGridArrForU, ', ...
        'uForInterp(:, :, zInd, tInd)'', x, y, hInterpMethod);']);
    end
    for zInd = 1 : length(zGridVecForV)
      eval(['vForVertInterp(', repmat(':, ', [1, length(size(x))]), ...
        'zInd) = interp2(xGridArrForV, yGridArrForV, ', ...
        'vForInterp(:, :, zInd, tInd)'', x, y, hInterpMethod);']);
    end
    for zInd = 1 : length(zGridVecForW)
      eval(['wForVertInterp(', repmat(':, ', [1, length(size(x))]), ...
        'zInd) = interp2(xGridArrForW, yGridArrForW, ', ...
        'wForInterp(:, :, zInd, tInd)'', x, y, hInterpMethod);']);
    end
    eval(['uForTempInterp(', repmat(':, ', [1, length(size(x))]), ...
      'tInd) = interp1D(zGridVecForU, uForVertInterp, z, vInterpMethod);']);
    eval(['vForTempInterp(', repmat(':, ', [1, length(size(x))]), ...
      'tInd) = interp1D(zGridVecForV, vForVertInterp, z, vInterpMethod);']);
    eval(['wForTempInterp(', repmat(':, ', [1, length(size(x))]), ...
      'tInd) = interp1D(zGridVecForW, wForVertInterp, z, vInterpMethod);']);
%     uForTempInterp(:, :, :, tInd) = interp1D(zGridVecForU, ...
%       uForVertInterp, z, vInterpMethod);
%     vForTempInterp(:, :, :, tInd) = interp1D(zGridVecForV, ...
%       vForVertInterp, z, vInterpMethod);
%     wForTempInterp(:, :, :, tInd) = interp1D(zGridVecForW, ...
%       wForVertInterp, z, vInterpMethod);
  end
end
    
%% Now with physical velocities

% Unpack velocity data (each given on spatio-temporal grid)
uPhysForInterp = VelocityData.uPhysicalForInterpolation;
vPhysForInterp = VelocityData.vPhysicalForInterpolation;
if spatialDimension == 3
  wPhysForInterp = VelocityData.wPhysicalForInterpolation;
end

% Set up temporal interpolation matrices
uPhysForTempInterp = NaN([size(x), length(tGridVector)]);
vPhysForTempInterp = NaN([size(x), length(tGridVector)]);
if spatialDimension == 3
  wPhysForTempInterp = NaN([size(x), length(tGridVector)]);
end

% Interpolate spatially
for tInd = 1 : length(tGridVector)
  if spatialDimension == 2
    uPhysForTempInterp(:, :, tInd) = interp2(xGridArrForU, ...
      yGridArrForU, uPhysForInterp(:, :, tInd)', x, y, hInterpMethod);
    vPhysForTempInterp(:, :, tInd) = interp2(xGridArrForV, ...
      yGridArrForV, vPhysForInterp(:, :, tInd)', x, y, hInterpMethod);
  elseif spatialDimension == 3
    uPhysForVertInterp = NaN([size(x), length(zGridVecForU)]);
    vPhysForVertInterp = NaN([size(x), length(zGridVecForV)]);
    wPhysForVertInterp = NaN([size(x), length(zGridVecForW)]);
    for zInd = 1 : length(zGridVecForU)
      eval(['uPhysForVertInterp(', repmat(':, ', [1, length(size(x))]), ...
        'zInd) = interp2(xGridArrForU, yGridArrForU, ', ...
        'uPhysForInterp(:, :, zInd, tInd)'', x, y, hInterpMethod);']);
    end
    for zInd = 1 : length(zGridVecForV)
      eval(['vPhysForVertInterp(', repmat(':, ', [1, length(size(x))]), ...
        'zInd) = interp2(xGridArrForV, yGridArrForV, ', ...
        'vPhysForInterp(:, :, zInd, tInd)'', x, y, hInterpMethod);']);
    end
    for zInd = 1 : length(zGridVecForW)
      eval(['wPhysForVertInterp(', repmat(':, ', [1, length(size(x))]), ...
        'zInd) = interp2(xGridArrForW, yGridArrForW, ', ...
        'wPhysForInterp(:, :, zInd, tInd)'', x, y, hInterpMethod);']);
    end
    eval(['uPhysForTempInterp(', repmat(':, ', [1, length(size(x))]), ...
      'tInd) = interp1D(zGridVecForU, uPhysForVertInterp, z, vInterpMethod);']);
    eval(['vPhysForTempInterp(', repmat(':, ', [1, length(size(x))]), ...
      'tInd) = interp1D(zGridVecForV, vPhysForVertInterp, z, vInterpMethod);']);
    eval(['wPhysForTempInterp(', repmat(':, ', [1, length(size(x))]), ...
      'tInd) = interp1D(zGridVecForW, wPhysForVertInterp, z, vInterpMethod);']);
%     uForTempInterp(:, :, :, tInd) = interp1D(zGridVecForU, ...
%       uForVertInterp, z, vInterpMethod);
%     vForTempInterp(:, :, :, tInd) = interp1D(zGridVecForV, ...
%       vForVertInterp, z, vInterpMethod);
%     wForTempInterp(:, :, :, tInd) = interp1D(zGridVecForW, ...
%       wForVertInterp, z, vInterpMethod);
  end
end
      
% Interpolate temporally
tArr = t*ones(size(x));
dxdt = interp1D(tGridVector, uForTempInterp, tArr, tInterpMethod);
dydt = interp1D(tGridVector, vForTempInterp, tArr, tInterpMethod);
dxdtPhys = interp1D(tGridVector, uPhysForTempInterp, tArr, tInterpMethod);
dydtPhys = interp1D(tGridVector, vPhysForTempInterp, tArr, tInterpMethod);
if spatialDimension == 2
  dmdt = sqrt(dxdtPhys.^2 + dydtPhys.^2);
elseif spatialDimension == 3
  dzdt = interp1D(tGridVector, wForTempInterp, tArr, tInterpMethod);
  dzdtPhys = interp1D(tGridVector, wPhysForTempInterp, tArr, tInterpMethod);
  dmdt = sqrt(dxdtPhys.^2 + dydtPhys.^2 + dzdtPhys.^2);
end

% Pack up state derivative
StateDerivative = SystemStateDerivative;
StateDerivative.dxdt = dxdt;
StateDerivative.dydt = dydt;
StateDerivative.dmdt = dmdt;
if spatialDimension == 3
  StateDerivative.dzdt = dzdt;
end