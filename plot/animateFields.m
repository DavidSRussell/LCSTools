function animateFields(analysisOutputFile)
% animateFields(analysisOutputFile): Animate Lagrangian fields resulting
% from an analysis of trajectories. The animation gives one frame to each
% time in "outputTimes", so "outputTimes" should be monotonic and
% equispaced.

global outputDirectory

% Unpack inputs
load(analysisOutputFile, 'Source', 'RunOpts', 'InitialState', ...
  'outputTimes', 'outputM', 'outputFTLE', 'outputCS')
PlotOpts = setDefaultPlotOptions(Source);
PlotOpts = setPlotOptions(PlotOpts);
spatialDim = Source.spatialDimension;

% Unpack data for plotting
nTimes = length(outputTimes);
t0 = RunOpts.startTime;
tf = outputTimes(end);
x0 = InitialState.x;
y0 = InitialState.y;
if spatialDim == 3
  z0 = InitialState.z;
end

% Intialize movie objects
if PlotOpts.plotM
  MMovie(length(outputTimes)) = struct('cdata', [], 'colormap', []);
end
if PlotOpts.plotFTLE
  FTLEMovie(length(outputTimes)) = struct('cdata', [], 'colormap', []);
end
if PlotOpts.plotCoherentSets
  CSMovie(length(outputTimes)) = struct('cdata', [], 'colormap', []);
end

% Plot first frame
if spatialDim == 2
  if PlotOpts.plotM
    [mFigure, mPlot] = plotField2D(x0, y0, outputM{1}, t0, ...
      outputTimes(1), PlotOpts, '$M$');
    %caxis(PlotOpts.colorAxisForM)
    MMovie(1) = getframe(mFigure);
  end
  if PlotOpts.plotFTLE
    [fTLEFigure, fTLEPlot] = plotField2D(x0(2 : end - 1, 2 : end - 1), ...
      y0(2 : end - 1, 2 : end - 1), outputFTLE{1}, t0, outputTimes(1), ...
      PlotOpts, 'FTLE');
    %caxis(PlotOpts.colorAxisForFTLE)
    FTLEMovie(1) = getframe(fTLEFigure);
  end
  if PlotOpts.plotCoherentSets
    %FigCS = plotField2D(x0, y0, outputCS{1}.xCS, t0, outputTimes(1), PlotOpts, 'Coherent Sets: x_2');
  end
elseif spatialDim == 3
  if isa(Source, 'Dataset')
    [x0, y0, z0] = feval(Source.getPhysicalPositionsFunction, x0, y0, z0, t0, Source);
    %[x0, y0, z0] = Source.getPhysicalPositionsFunction(x0, y0, z0, t0, Source);
    PlotOpts = PlotOpts;
    PlotOpts.xPlotLimits = Source.xPlotLimitsPhys;
    PlotOpts.yPlotLimits = Source.yPlotLimitsPhys;
    PlotOpts.zPlotLimits = Source.zPlotLimitsPhys;
    PlotOpts.xLabel = Source.xLabelPhys;
    PlotOpts.yLabel = Source.yLabelPhys;
    PlotOpts.zLabel = Source.zLabelPhys;
  end
  if ~isempty(Source.dataAspectRatio3DPhys)
    PlotOpts.dataAspectRatio3D =  Source.dataAspectRatio3DPhys;
  end
  if PlotOpts.plotM
    [mFigure, mPlot] = plotField3D('scatter', x0, y0, z0, outputM{1}, ...
      t0, outputTimes(1), PlotOpts, '$M$');
    %caxis(PlotOpts.colorAxisForM)
    MMovie(1) = getframe(mFigure);
    x0ForPlot = permute(x0, [2, 1, 3]);
    y0ForPlot = permute(y0, [2, 1, 3]);
    z0ForPlot = permute(z0, [2, 1, 3]);
  end
  if PlotOpts.plotFTLE
    x0Cropped = x0(2 : end - 1, 2 : end - 1, 2 : end - 1);
    y0Cropped = y0(2 : end - 1, 2 : end - 1, 2 : end - 1);
    z0Cropped = z0(2 : end - 1, 2 : end - 1, 2 : end - 1);
    [fTLEFigure, fTLEPlot] = plotField3D('scatter', x0Cropped, y0Cropped, ...
      z0Cropped, outputFTLE{1}, t0, outputTimes(1), PlotOpts, 'FTLE');
    %caxis(PlotOpts.colorAxisForFTLE)
    FTLEMovie(1) = getframe(fTLEFigure);
    x0ForPlotCropped = permute(x0Cropped, [2, 1, 3]);
    y0ForPlotCropped = permute(y0Cropped, [2, 1, 3]);
    z0ForPlotCropped = permute(z0Cropped, [2, 1, 3]);
  end
  if PlotOpts.plotCoherentSets
  end
end

% Generate movie frames
for i = 2 : nTimes
  t = outputTimes(i);
  if spatialDim == 2
    if PlotOpts.plotM
      figure(mFigure)
      set(mPlot, 'CData', outputM{i}')
    end
    if PlotOpts.plotFTLE
      figure(fTLEFigure)
      set(fTLEPlot, 'CData', outputFTLE{i}')
    end
  elseif spatialDim == 3
    if PlotOpts.plotM
      figure(mFigure)
      fieldData = outputM{i};
      fieldDataForPlot = permute(fieldData, [2, 1, 3]);
      notNaNInds = ~isnan(fieldDataForPlot);
      set(mPlot, 'CData', fieldDataForPlot(notNaNInds), ...
        'XData', x0ForPlot(notNaNInds), 'YData', y0ForPlot(notNaNInds), ...
        'ZData', z0ForPlot(notNaNInds))
      %caxis(PlotOpts.colorAxisForM)
    end
    if PlotOpts.plotFTLE
      figure(fTLEFigure)
      fieldData = outputFTLE{i};
      fieldDataForPlot = permute(fieldData, [2, 1, 3]);
      notNaNInds = ~isnan(fieldDataForPlot);
      set(fTLEPlot, 'CData', fieldDataForPlot(notNaNInds), ...
        'XData', x0ForPlotCropped(notNaNInds), ...
        'YData', y0ForPlotCropped(notNaNInds), ...
        'ZData', z0ForPlotCropped(notNaNInds))
    %caxis(PlotOpts.colorAxisForFTLE)
    end
  end
  if PlotOpts.plotM
    figure(mFigure)
    title(sprintf('$M$, $t$ = %.1f to $t$ = %.1f', t0, t))
    MMovie(i) = getframe(mFigure);
  end
  if PlotOpts.plotFTLE
    figure(fTLEFigure)
    title(sprintf('FTLE, $t$ = %.1f to $t$ = %.1f', t0, t))
    FTLEMovie(i) = getframe(fTLEFigure);
  end
end

% Save movies
movieDirName = [outputDirectory, '/animations/', Source.name];
fprintf(['Saving animation to directory ', movieDirName, '\n'])
if PlotOpts.plotM
  saveMovie(MMovie, 'm')
end
if PlotOpts.plotFTLE
  saveMovie(FTLEMovie, 'ftle')
end

function saveMovie(FrameStruct, typeString)
typeDirName = [movieDirName, '/', typeString];
if ~exist(typeDirName)
  mkdir(typeDirName)
end
nowString = datestr(datetime('now'), 30);
shortFileName = [Source.name, '_', num2str(t0), 'to', num2str(tf), '_', typeString, '_', nowString];
outputFileName = [typeDirName, '/', shortFileName];
movieWriter = VideoWriter(outputFileName);
movieWriter.FrameRate = PlotOpts.frameRate;
open(movieWriter)
writeVideo(movieWriter, FrameStruct);
close(movieWriter)
end

end