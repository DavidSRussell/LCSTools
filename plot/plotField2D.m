function [fig, plotHandle] = plotField2D(x0, y0, fieldData, t1, t2, PlotOpts, description)
% plotField2D(x0, y0, fieldData, t1, t, PlotOpts, description): Color plot
% of 2D field.
%
% plotField2D constructs a formatted color plot of the data in fieldData
% with appropriate formatting. fieldData represents a 2D Lagrangian
% descriptor field (such as the M-function or FTLE) evaluated at the points
% given in grid matrices x0 and y0 (which must be as if produced by
% ndgrid) based on trajectories from time t1 to time t2.

fig = figure;
fig.Position = [360, 278, PlotOpts.plotWindowDimensions];
plotHandle = pcolor(x0', y0', fieldData');
shading interp
colormap(PlotOpts.colorMap)
colorbar
axis equal tight
xlim(PlotOpts.xLimits)
ylim(PlotOpts.yLimits)
xlabel(PlotOpts.xLabel)
ylabel(PlotOpts.yLabel)
title(sprintf([description, ', $t$ = %.1f to $t$ = %.1f'], t1, t2))