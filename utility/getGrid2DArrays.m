function GridArrays = getGrid2DArrays(Grid, gridFunction)
% getGrid2DArrays(Grid, gridFunction): For a Grid object (which contains
% grid vectors for u, v, and possibly w), get corresponding 2D grid arrays
% using function "gridFunction" (either meshgrid or ndgrid).

xGV4U = Grid.xVectorForU;
yGV4U = Grid.yVectorForU;
xGV4V = Grid.xVectorForV;
yGV4V = Grid.yVectorForV;
if Grid.spatialDimension == 3
  xGV4W = Grid.xVectorForW;
  yGV4W = Grid.yVectorForW;
end

[xGA4U, yGA4U] = gridFunction(xGV4U, yGV4U);
[xGA4V, yGA4V] = gridFunction(xGV4V, yGV4V);
if Grid.spatialDimension == 3
  [xGA4U, yGA4U] = gridFunction(xGV4U, yGV4U);
  [xGA4V, yGA4V] = gridFunction(xGV4V, yGV4V);
  [xGA4W, yGA4W] = gridFunction(xGV4W, yGV4W);
end

GridArrays.xGridArrayForU = xGA4U;
GridArrays.yGridArrayForU = yGA4U;
GridArrays.xGridArrayForV = xGA4V;
GridArrays.yGridArrayForV = yGA4V;
if Grid.spatialDimension == 3
  GridArrays.xGridArrayForW = xGA4W;
  GridArrays.yGridArrayForW = yGA4W;
end