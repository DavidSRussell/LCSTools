function [fig, plotHandle] = plotField3D(plotType, x0, y0, z0, fieldData, ...
  t1, t2, PlotOpts, description)
% plotField3D(plotType, x0, y0, z0, fieldData, t1, t, PlotOpts,
% description): Color plot of 3D field.
%
% plotField3D constructs a formatted color plot (either a scatter plot or a
% slice plot) of the data in fieldData with appropriate formatting.
% plotType is either 'scatter' or 'slices'. fieldData represents a 3D field
% (such as the M-function or FTLE) evaluated at the points given in grid
% matrices x0, y0, z0 (which must be produced by ndgrid). fieldData
% represents some Lagrangian analysis of a system from time t1 to time t2.

x0 = permute(x0, [2, 1, 3]);
y0 = permute(y0, [2, 1, 3]);
z0 = permute(z0, [2, 1, 3]);
fieldData = permute(fieldData, [2, 1, 3]);

fig = figure;
fig.Position = [360, 278, PlotOpts.plotWindowDimensions];
switch plotType
  case 'scatter'
    markerSize = max(300 - 30*(numel(x0)^(1/3) - 16), 1);
    %markerSize = max(300 - 5*(numel(x0)^(1/3) - 16), 1);
    notNaNInds = ~isnan(fieldData);
    plotHandle = scatter3(x0(notNaNInds), y0(notNaNInds), z0(notNaNInds), ...
      markerSize, fieldData(notNaNInds), '.');
  case 'slices'
    plotHandle = slice(x0, y0, z0, fieldData, PlotOpts.xSlices, ...
      PlotOpts.ySlices, PlotOpts.zSlices);
    shading interp
end
colormap(PlotOpts.colorMap)
colorbar
if ~isempty(PlotOpts.dataAspectRatio3D)
  daspect(PlotOpts.dataAspectRatio3D)
else
  axis equal tight
end
if ~isempty(PlotOpts.viewAngle3D)
  view(PlotOpts.viewAngle3D)
end
xlim(PlotOpts.xLimits)
ylim(PlotOpts.yLimits)
zlim(PlotOpts.zLimits)
xlabel(PlotOpts.xLabel)
ylabel(PlotOpts.yLabel)
zlabel(PlotOpts.zLabel)
title(sprintf([description, ', $t$ = %.1f to $t$ = %.1f'], t1, t2))