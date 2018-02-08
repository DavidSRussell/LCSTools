classdef Dataset
  properties
    name
    longName
    fileFormat
    dataDirectory
    fileNames
    spatialDimension
    tVariable
    Grid
    xBounds
    yBounds
    zBounds
    getPhysicalPositionsFunction
    DefaultRunOptions = DatasetRunOptions;
    DefaultAnalysisOptions = AnalysisOptions;
    DefaultGridSpacePlotOptions = PlotOptions;
    DefaultPhysicalSpacePlotOptions = PlotOptions;
  end
end