function InitialState = setInitialState(InitialStateMetadata, spatialDimension)

dx = InitialStateMetadata.dx;
dy = InitialStateMetadata.dy;
xLimits = InitialStateMetadata.xLimits;
yLimits = InitialStateMetadata.yLimits;
x0GridVector = xLimits(1) : dx : xLimits(2);
y0GridVector = yLimits(1) : dy : yLimits(2);
if spatialDimension == 2
  [x0, y0] = ndgrid(x0GridVector, y0GridVector);
elseif spatialDimension == 3
  dz = InitialStateMetadata.dz;
  zLimits = InitialStateMetadata.zLimits;
  z0GridVector = zLimits(1) : dz : zLimits(2);
  [x0, y0, z0] = ndgrid(x0GridVector, y0GridVector, z0GridVector);
  InitialState.z = z0;
end

InitialState.x = x0;
InitialState.y = y0;
InitialState.m = zeros(size(x0));