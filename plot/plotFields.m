function plotFields(analysisOutputFileName)
% plotFields(analysisOutputFileName): Plot fields resulting from Lagrangian
% analysis of a flow.
%
% plotFields plots a user-defined subset of the following Lagrangian
% descriptor functions of a flow: the M-function, FTLE, or coherent set
% vectors. It takes a .mat file as input, of the type put out by the
% analyzeStates function; in particular, the file must store variables
% 'Source', 'RunOpts', 'AnalOpts', 'InitialState', 'outputTimes',
% 'outputM', 'outputFTLE', and 'outputCS'. Also reads input from
% setPlotOptions.m, where the user can set various plotting options.

global outputDirectory

% Unpack inputs
load(analysisOutputFileName, 'Source', 'RunOpts', 'AnalOpts', 'InitialState', ...
  'outputTimes', 'outputM', 'outputFTLE', 'outputCS')
PlotOpts = setDefaultPlotOptions(Source);
PlotOpts = changePlotOptions(PlotOpts);
spatialDim = Source.spatialDimension;
t0 = RunOpts.startTime;
x0 = InitialState.x;
y0 = InitialState.y;
if spatialDim == 3
  z0 = InitialState.z;
end

% Get true physical positions
if isa(Source, 'Dataset') && spatialDim == 3
  %[x0Phys, y0Phys, z0Phys] = getPhysicalPositionsChesROMS(x0, y0, z0, t0, Source);
  %Source.getPhysicalPositionsFunction
  %x0Phys2 = Source.getPhysicalPositionsFunction(x0, y0, z0, t0, Source);
  [x0Phys, y0Phys, z0Phys] = feval(Source.getPhysicalPositionsFunction, x0, y0, z0, t0, Source);
  %[x0Phys, y0Phys, z0Phys] = Source.getPhysicalPositionsFunction(x0, y0, z0, t0, Source);
end

fprintf('Generating figures\n')

if PlotOpts.savePlots
  figureDirName = [outputDirectory, '/figures/', Source.name];
  fprintf(['Saving figures to directory ', figureDirName, '\n'])
end

for i = 1 : length(outputTimes)
  t = outputTimes(i);
  fprintf('t = %.1f\n', t)
  if PlotOpts.plotM
    if spatialDim == 2
      fig = plotField2D(x0, y0, outputM{i}, t0, t, PlotOpts, '$M$');
      saveFigFormatted(fig, 'm', [], PlotOpts.savePlots, t0, t)
      % caxis([0, 5*abs(t)]
      if t > t0 && sum(outputTimes - (2*t0 - t) < 1e-6) > 0
        j = find(abs(outputTimes - (2*t0 - t)) < 1e-6, 1);
        tBwd = outputTimes(j);
        fig = plotField2D(x0, y0, outputM{i} + outputM{j}, tBwd, t, PlotOpts, '$M$');
        saveFigFormatted(fig, 'm', [], PlotOpts.savePlots, tBwd, t)
      end
    elseif spatialDim == 3
      if PlotOpts.plotScatter3D
        if isa(Source, 'Dataset')
          fig = plotField3D('scatter', x0Phys, y0Phys, z0Phys, outputM{i}, t0, t, PlotOpts, '$M$');
        elseif isa(Source, 'ODESystem')
          fig = plotField3D('scatter', x0, y0, z0, outputM{i}, t0, t, PlotOpts, '$M$');
        end
        saveFigFormatted(fig, 'm', 'scatter_', PlotOpts.savePlots, t0, t)
        if t > t0 && sum(outputTimes - (2*t0 - t) < 1e-6) > 0
          j = find(abs(outputTimes - (2*t0 - t)) < 1e-6, 1);
          tBwd = outputTimes(j);
          fig = plotField3D('scatter', x0, y0, z0, outputM{i} + outputM{j}, tBwd, t, PlotOpts, '$M$');
          saveFigFormatted(fig, 'm', 'scatter_', PlotOpts.savePlots, tBwd, t)
        end
      end
      if PlotOpts.plotSlices3D
        fig = plotField3D('slices', x0, y0, z0, outputM{i}, t0, t, PlotOpts, '$M$');
        saveFigFormatted(fig, 'm', 'slices_', PlotOpts.savePlots, t0, t)
        if t > t0 && sum(outputTimes - (2*t0 - t) < 1e-6) > 0
          j = find(abs(outputTimes - (2*t0 - t)) < 1e-6, 1);
          tBwd = outputTimes(j);
          fig = plotField3D('slices', x0, y0, z0, outputM{i} + outputM{j}, tBwd, t, PlotOpts, '$M$');
          saveFigFormatted(fig, 'm', 'slices_', PlotOpts.savePlots, tBwd, t)
        end
      end
      % caxis([0, 5*abs(t)])
    end
  end
  if PlotOpts.plotFTLE && t ~= t0
    if spatialDim == 2
      x0Cropped = x0(2 : end - 1, 2 : end - 1);
      y0Cropped = y0(2 : end - 1, 2 : end - 1);
      fig = plotField2D(x0Cropped, y0Cropped, outputFTLE{i}, t0, t, PlotOpts, 'FTLE');
    elseif spatialDim == 3
      x0Cropped = x0(2 : end - 1, 2 : end - 1, 2 : end - 1);
      y0Cropped = y0(2 : end - 1, 2 : end - 1, 2 : end - 1);
      z0Cropped = z0(2 : end - 1, 2 : end - 1, 2 : end - 1);
      if PlotOpts.plotScatter3D
        if isa(Source, 'Dataset')
          x0PhysCropped = x0Phys(2 : end - 1, 2 : end - 1, 2 : end - 1);
          y0PhysCropped = y0Phys(2 : end - 1, 2 : end - 1, 2 : end - 1);
          z0PhysCropped = z0Phys(2 : end - 1, 2 : end - 1, 2 : end - 1);
          fig = plotField3D('scatter', x0PhysCropped, y0PhysCropped, ...
            z0PhysCropped, outputFTLE{i}, t0, t, PlotOpts, 'FTLE');
        elseif isa(Source, 'ODESystem')
          fig = plotField3D('scatter', x0Cropped, y0Cropped, ...
            z0Cropped, outputFTLE{i}, t0, t, PlotOpts, 'FTLE');
        end
        saveFigFormatted(fig, 'ftle', 'scatter_', PlotOpts.savePlots, t0, t)
      end
      if PlotOpts.plotSlices3D
        fig = plotField3D('slices', x0Cropped, y0Cropped, z0Cropped, ...
          outputFTLE{i}, t0, t, PlotOpts, 'FTLE');
        saveFigFormatted(fig, 'ftle', 'slices_', PlotOpts.savePlots, t0, t)
      end
    end
    % caxis([0, 4/abs(t)])
    saveFigFormatted(fig, 'ftle', [], PlotOpts.savePlots, t0, t)
  end
  if PlotOpts.plotCoherentSets
    TMOpts = AnalOpts.TransitionMatrixOptions;
    singVecNums = sort(TMOpts.singularVectorNumbers);
    CSOutput = outputCS{i};
    xCS = CSOutput.xCS;
    yCS = CSOutput.yCS;
    xCSxArr = CSOutput.xCSxArray;
    xCS = xCS(1 : numel(xCSxArr), :);
    xCSyArr = CSOutput.xCSyArray;
    yCSxArr = CSOutput.yCSxArray;
    yCSyArr = CSOutput.yCSyArray;
    if spatialDim == 3
      xCSzArr = CSOutput.xCSzArray;
      yCSzArr = CSOutput.yCSzArray;
      if isa(Source, 'Dataset')
%         [xCSxArrPhys, xCSyArrPhys, xCSzArrPhys] = Source.getPhysicalPositionsFunction(xCSxArr, xCSyArr, xCSzArr, t, Source);
%         [yCSxArrPhys, yCSyArrPhys, yCSzArrPhys] = Source.getPhysicalPositionsFunction(yCSxArr, yCSyArr, yCSzArr, t, Source);
        [xCSxArrPhys, xCSyArrPhys, xCSzArrPhys] = getPhysicalPositionsChesROMS(xCSxArr, xCSyArr, xCSzArr, t, Source);
        [yCSxArrPhys, yCSyArrPhys, yCSzArrPhys] = getPhysicalPositionsChesROMS(yCSxArr, yCSyArr, yCSzArr, t, Source);
      end
    end
    for i = singVecNums
      xCS_i = reshape(xCS(:, i), size(xCSxArr));
      yCS_i = reshape(yCS(1 : numel(yCSxArr), i), size(yCSxArr));
      if spatialDim == 2
        figX = plotField2D(xCSxArr, xCSyArr, xCS_i, t0, t, PlotOpts, ...
          sprintf('Coherent Sets: $x_%i$', i));
        figY = plotField2D(yCSxArr, yCSyArr, yCS_i, t0, t, PlotOpts, ...
          sprintf('Coherent Sets: $y_%i$', i));
        saveFigFormatted(figX, 'cs', sprintf('x%i_', i), PlotOpts.savePlots, t0, t)
        saveFigFormatted(figY, 'cs', sprintf('y%i_', i), PlotOpts.savePlots, t0, t)
      elseif spatialDim == 3
        if PlotOpts.plotScatter3D
          if isa(Source, 'Dataset')
            figX = plotField3D('scatter', xCSxArrPhys, xCSyArrPhys, xCSzArrPhys, xCS_i, t0, t, PlotOpts, sprintf('Coherent Sets: $x_%i$', i));
            figY = plotField3D('scatter', yCSxArrPhys, yCSyArrPhys, yCSzArrPhys, yCS_i, t0, t, PlotOpts, sprintf('Coherent Sets: $y_%i$', i));
          elseif isa(Source, 'ODESystem')
            figX = plotField3D('scatter', xCSxArr, xCSyArr, xCSzArr, xCS_i, t0, t, PlotOpts, sprintf('Coherent Sets: $x_%i$', i));
            figY = plotField3D('scatter', yCSxArr, yCSyArr, yCSzArr, yCS_i, t0, t, PlotOpts, sprintf('Coherent Sets: $y_%i$', i));
          end
          saveFigFormatted(figX, 'cs', sprintf('scatter_x%i_', i), PlotOpts.savePlots, t0, t)
          saveFigFormatted(figY, 'cs', sprintf('scatter_y%i_', i), PlotOpts.savePlots, t0, t)
        end
        if PlotOpts.plotSlices3D
          figX = plotField3D('slices', xCSxArr, xCSyArr, xCSzArr, xCS_i, ...
            t0, t, PlotOpts, sprintf('Coherent Sets: $x_%i$', i));
          figY = plotField3D('slices', yCSxArr, yCSyArr, yCSzArr, yCS_i, ...
            t0, t, PlotOpts, sprintf('Coherent Sets: $y_%i$', i));
          saveFigFormatted(figX, 'cs', sprintf('slices_x%i_', i), PlotOpts.savePlots, t0, t)
          saveFigFormatted(figY, 'cs', sprintf('slices_y%i_', i), PlotOpts.savePlots, t0, t)
        end
      end
    end
  end
end

function saveFigFormatted(fig, plotType, fileSuffix, savePlots, t1, t2)
if savePlots
  plotTypeDirName = [figureDirName, '/', plotType];
  if ~exist(plotTypeDirName)
    mkdir(plotTypeDirName);
  end
  nowString = datestr(datetime('now'), 30);
  shortFileName = [Source.name, '_', num2str(t1), 'to', num2str(t2), '_', plotType, '_', fileSuffix, nowString];
  outputFileName = [plotTypeDirName, '/', shortFileName];
  savefig(fig, outputFileName)
end
end

end