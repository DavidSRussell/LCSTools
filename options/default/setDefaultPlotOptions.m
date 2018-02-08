function PlotOpts = setDefaultPlotOptions(Source)
% setDefaultPlotOptions(Source): Set default plotting options for a
% Lagrangian analysis, based on "Source", which is the source of the
% velocity field and is an object of type ODESystem or Dataset.

if isa(Source, 'ODESystem')
  PlotOpts = Source.DefaultPlotOptions;
elseif isa(Source, 'Dataset')
  PlotOpts = Source.DefaultPhysicalSpacePlotOptions;
end

PlotOpts.savePlots = 1;
PlotOpts.plotM = 1;
PlotOpts.plotFTLE = 1;
PlotOpts.plotCoherentSets = 1;
PlotOpts.colorMap = jet(256);
PlotOpts.frameRate = 24;

if Source.spatialDimension == 3
  PlotOpts.plotScatter3D = 1;
  PlotOpts.plotSlices3D = 1;
  PlotOpts.xSlices = mean(PlotOpts.xLimits);
  PlotOpts.ySlices = mean(PlotOpts.yLimits);
  PlotOpts.zSlices = mean(PlotOpts.zLimits);
end

if isempty(PlotOpts.plotWindowDimensions)
  PlotOpts.plotWindowDimensions = [560, 420];
end