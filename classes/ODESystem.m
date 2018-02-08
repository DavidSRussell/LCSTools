classdef ODESystem
    properties
        name
        longName
        spatialDimension
        DefaultParameters % structure
        stateVectorDerivative % or dStateVectordt?
        stateDerivative
        isPeriodicInX
        isPeriodicInY
        isPeriodicInZ
        xBounds
        yBounds
        zBounds
        maximumSpeed
        DefaultRunOptions = RunOptions;
        DefaultPlotOptions = PlotOptions;
        DefaultAnalysisOptions = AnalysisOptions;
    end
end