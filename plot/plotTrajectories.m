function plotTrajectories(runOutputFile)
% plotTrajectories(runOutputFile): Plot trajectories resulting from a run
% of the computeTrajectories function. This function is intended only for
% the case when trajectories are relatively sparse (i.e. not for a grid of
% initial conditions, as required for Lagrangian analysis).

global outputDirectory

% Unpack inputs
load(runOutputFile)
PlotOpts = setDefaultPlotOptions(Source);
PlotOpts = changePlotOptions(PlotOpts);
spatialDim = Source.spatialDimension;
t0 = RunOpts.startTime;
t0Index = find(outputTimes == t0);
if(isempty(t0Index))
  t0Index = -1;
end


% Set up matrices for plotting
nTimes = length(outputTimes);
xValues = NaN(nTimes, numel(InitialState.x));
yValues = NaN(nTimes, numel(InitialState.y));
if spatialDim == 3
  zValues = NaN(nTimes, numel(InitialState.z));
end
for i = 1 : size(stateVectors, 1)
  stateVector = stateVectors(i, :);
  State = convertVectorToStructure(stateVector, InitialState);
  xValues(i, :) = State.x(:);
  yValues(i, :) = State.y(:);
  if spatialDim == 3
    zValues(i, :) = State.z(:);
  end
end

% Plot
for dir = {'fwd', 'bwd', 'both'}
  dir = dir{1};
  if strcmpi(dir, 'both') || (t0Index ~= -1 && (strcmpi(dir, 'fwd') ...
      && t0Index < nTimes) || (strcmpi(dir, 'bwd') && t0Index > 1))
    fig = figure;
    fig.Position = [360, 278, PlotOpts.plotWindowDimensions];
    if spatialDim == 2
      switch dir
        case 'fwd'
          plot(xValues(t0Index : end, :), yValues(t0Index : end, :))
          hold on
          plot(xValues(end, :), yValues(end, :), 'k.', 'MarkerSize', 10)
          hold off
        case 'bwd'
          plot(xValues(1 : t0Index, :), yValues(1 : t0Index, :))
          hold on
          plot(xValues(t0Index, :), yValues(t0Index, :), 'k.', 'MarkerSize', 10)
          hold off
        case 'both'
          plot(xValues, yValues)
          hold on
          plot(xValues(end, :), yValues(end, :), 'k.', 'MarkerSize', 10)
          hold off
      end
    elseif spatialDim == 3
      switch dir
        case 'fwd'
          plot3(xValues(t0Index : end, :), yValues(t0Index : end, :), zValues(t0Index : end, :))
          hold on
          plot3(xValues(end, :), yValues(end, :), zValues(end, :), 'k.', 'MarkerSize', 10)
          hold off
        case 'bwd'
          plot3(xValues(1 : t0Index, :), yValues(1 : t0Index, :), zValues(1 : t0Index, :))
          hold on
          plot3(xValues(t0Index, :), yValues(t0Index, :), zValues(t0Index, :), 'k.', 'MarkerSize', 10)
          hold off
        case 'both'
          plot3(xValues, yValues, zValues)
          hold on
          plot3(xValues(end, :), yValues(end, :), zValues(end, :), 'k.', 'MarkerSize', 10)
          hold off
      end
      if ~isempty(PlotOpts.dataAspectRatio3D)
        daspect(PlotOpts.dataAspectRatio3D)
      else
        axis equal
      end
      zlim(PlotOpts.zLimits)
      zlabel(PlotOpts.zLabel)
    end
    xlim(PlotOpts.xLimits)
    ylim(PlotOpts.yLimits)
    xlabel(PlotOpts.xLabel)
    ylabel(PlotOpts.yLabel)
    switch dir
      case 'fwd'
        t1 = t0;
        t2 = outputTimes(end);
      case 'bwd'
        t1 = outputTimes(1);
        t2 = t0;
      case 'both'
        t1 = outputTimes(1);
        t2 = outputTimes(end);
    end
    title(sprintf(['$t$ = %.1f to $t$ = %.1f'], t1, t2))

    % Save plot
    if PlotOpts.savePlots
      dirName = [outputDirectory, '/figures/', Source.name, '/traj'];
      if ~exist(dirName)
        mkdir(dirName)
      end
      fprintf(['Saving figures to directory ', dirName, '\n'])
      nowString = datestr(datetime('now'), 30);
      shortFileName = [Source.name, '_', num2str(floor(t1)), 'to', num2str(ceil(t2)), '_traj_', nowString];
      outputFileName = [dirName, '/', shortFileName];
      savefig(fig, outputFileName)
    end
  end
end