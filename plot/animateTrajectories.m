function animateTrajectories(runOutputFile)
% animateTrajectories(runOutputFile): Animate trajectories resulting from a
% run of the computeTrajectories function.

global outputDirectory

% Unpack inputs
load(runOutputFile)
PlotOpts = setDefaultPlotOptions(Source);
PlotOpts = changePlotOptions(PlotOpts);
spatialDim = Source.spatialDimension;

nTimes = length(outputTimes);

xValues = NaN(nTimes, numel(InitialState.x));
yValues = NaN(nTimes, numel(InitialState.y));
if spatialDim == 3
  zValues = NaN(nTimes, numel(InitialState.z));
end

markerSize = 10;

fig = figure;
fig.Position = [360, 278, PlotOpts.plotWindowDimensions];
trajMovie(length(outputTimes)) = struct('cdata', [], 'colormap', []); % intialize trajectory movie object

for i = 1 : length(outputTimes)
  t = outputTimes(i);
  stateVector = stateVectors(i, :);
  State = convertVectorToStructure(stateVector, InitialState);
  x = State.x;
  y = State.y;
  if spatialDim == 3
    z = State.z;
    if isa(Source, 'Dataset')
      [xPhys, yPhys, zPhys] = feval(Source.getPhysicalPositionsFunction, ...
        x, y, z, t, Source);
      scatter3(xPhys(:), yPhys(:), zPhys(:), markerSize, '.k')
      xlim(Source.xPlotLimitsPhys)
      ylim(Source.yPlotLimitsPhys)
      zlim(Source.zPlotLimitsPhys)
      xlabel(Source.xLabelPhys)
      ylabel(Source.yLabelPhys)
      zlabel(Source.zLabelPhys)
      if ~isempty(Source.dataAspectRatio3DPhys)
        daspect(Source.dataAspectRatio3DPhys)
      else
        axis equal
      end
    else
      scatter3(x(:), y(:), z(:), markerSize, 'k.')
      xlim(PlotOpts.xLimits)
      ylim(PlotOpts.yLimits)
      zlim(PlotOpts.zLimits)
      xlabel(PlotOpts.xLabel)
      ylabel(PlotOpts.yLabel)
      zlabel(PlotOpts.zLabel)
      if ~isempty(PlotOpts.dataAspectRatio3D)
        daspect(PlotOpts.dataAspectRatio3D)
      else
        axis equal
      end
    end
    if ~isempty(Source.viewAngle3D)
      view(Source.viewAngle3D)
    end
  elseif spatialDim == 2
    plot(x(:), y(:), 'k.', 'MarkerSize', markerSize)
    axis equal
    xlim(PlotOpts.xLimits)
    ylim(PlotOpts.yLimits)
    xlabel(PlotOpts.xLabel)
    ylabel(PlotOpts.yLabel)
  end
  title(sprintf(['$t$ = %.1f'], t))
  trajMovie(i) = getframe(gcf); % get first frame of movie
end

% Save animation
dirName = [outputDirectory, '/animations/', Source.name, '/traj'];
fprintf(['Saving animation to directory ', dirName, '\n'])
if ~exist(dirName)
  mkdir(dirName)
end
t0 = outputTimes(1);
tf = outputTimes(end);
nowString = datestr(datetime('now'), 30);
shortFileName = [Source.name, '_', num2str(t0), 'to', num2str(tf), '_traj_', nowString];
outputFileName = [dirName, '/', shortFileName];
movieWriter = VideoWriter(outputFileName);
movieWriter.FrameRate = PlotOpts.frameRate;
open(movieWriter)
writeVideo(movieWriter, trajMovie);
close(movieWriter)