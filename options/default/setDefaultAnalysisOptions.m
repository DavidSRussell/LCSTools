function AnalOpts = setDefaultAnalysisOptions(Source, RunOpts)
% setDefaultAnalysisOptions(Source, RunOpts): Set default analysis options
% for analyzeStates function, based on "Source" (which is an object of type
% ODESystem or Dataset), and "RunOpts" (which is an object of type
% RunOptions). Output "AnalOpts" is an object of type AnalysisOptions.

if ~isempty(Source.DefaultAnalysisOptions)
  AnalOpts = Source.DefaultAnalysisOptions;
else
  AnalOpts = AnalysisOptions;
end

if isempty(AnalOpts.getFTLE)
  AnalOpts.getFTLE = 1;
end
if isempty(AnalOpts.getCoherentSets)
  AnalOpts.getCoherentSets = 1;
end

TMOpts = getDefaultTransitionMatrixOptions(Source, RunOpts);
if isempty(AnalOpts.TransitionMatrixOptions)
  AnalOpts.TransitionMatrixOptions = TMOpts;
else
  fields = sort(fieldnames(AnalOpts.TransitionMatrixOptions));
  for i = 1 : length(fields)
    if isempty(AnalOpts.TransitionMatrixOptions.(fields{i}))
      AnalOpts.TransitionMatrixOptions.(fields{i}) = TMOpts.(fields{i});
    end
  end
end

function TMOpts = getDefaultTransitionMatrixOptions(Source, RunOpts)
spatialDim = Source.spatialDimension;
TMOpts = TransitionMatrixOptions;
TMOpts.singularVectorNumbers = 2 : 4;
if spatialDim == 2
  TMOpts.particleDimensionsPerGridBox = [20, 20];
elseif spatialDim == 3
  TMOpts.particleDimensionsPerGridBox = [10, 10, 10];
end
TMOpts.xLimInit = RunOpts.InitialStateMetadata.xLimits + ...
  RunOpts.InitialStateMetadata.dx/2*[-1, 1];
TMOpts.yLimInit = RunOpts.InitialStateMetadata.yLimits + ...
  RunOpts.InitialStateMetadata.dy/2*[-1, 1];
if ~isempty(Source.xBounds)
  TMOpts.xLimFinal = Source.xBounds;
else
  TMOpts.xLimFinal = TMOpts.xLimInit + diff(TMOpts.xLimInit)/4*[-1, 1];
end
if ~isempty(Source.yBounds)
  TMOpts.yLimFinal = Source.yBounds;
else
  TMOpts.yLimFinal = TMOpts.yLimInit + diff(TMOpts.yLimInit)/4*[-1, 1];
end
if spatialDim == 3
  TMOpts.zLimInit = RunOpts.InitialStateMetadata.zLimits + ...
    RunOpts.InitialStateMetadata.dz/2*[-1, 1];
  if ~isempty(Source.zBounds)
    TMOpts.zLimFinal = Source.zBounds;
  else
    TMOpts.zLimFinal = TMOpts.zLimInit + diff(TMOpts.zLimInit)/4*[-1, 1];
  end
end