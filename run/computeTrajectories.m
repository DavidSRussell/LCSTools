function outputFileName = computeTrajectories(sourceName)
% outputFileName = computeTrajectories(sourceName): Compute trajectories
% through a given 2D or 3D velocity field, proscribed by either an ODE
% system or a dataset. Input value is a string containing the name of the
% system or dataset to use as a source for the velocity field. Output is
% the name (including time stamp) of the .mat file containing the results
% and other details of the run. Options for the run can be changed from the
% defaults for the source by editing the file changeRunOptions.m.
%
% During the integration, progress is reported every 10 seconds or every
% time step, whichever is longer.
%
% Outputs:
%
%     Source       -- ODESystem or Dataset object containing the velocity field
%     RunOpts      -- RunOptions object containing all the options for the run
%     InitialState -- SystemState object containing the intial positions,
%                     M-function, and any parameters
%     outputTimes  -- Vector of times at which the state has been recorded
%     stateVectors -- Matrix wherein each row is a state vector at a time
%                     in outputTimes (subsequent processing must convert
%                     these vectors back into SystemState objects)

global outputDirectory

%% Set up integration

Source = setUpSource(sourceName);
spatialDim = Source.spatialDimension;
RunOpts = Source.DefaultRunOptions;
if isempty(RunOpts.integrationMethod)
  RunOpts.integrationMethod = 'rk4';
end
RunOpts = changeRunOptions(RunOpts);
if isempty(RunOpts.InitialState)
  RunOpts.InitialState = setInitialState(RunOpts.InitialStateMetadata, spatialDim);
end
InitialState = RunOpts.InitialState;
InitialState.Parameters = RunOpts.Parameters;
if isa(Source, 'ODESystem')
  stateVectorDerivative = @(stateVector, t) Source.stateVectorDerivative(...
    stateVector, t, InitialState);
  fprintf(['System: ', Source.longName, '\n'])
elseif isa(Source, 'Dataset')
  addpath(Source.dataDirectory);
  startFileName = RunOpts.startFileName;
  startFileTimeVector = ncread(startFileName, Source.tVariable);
  tVectorsByFile = NaN(length(startFileTimeVector), length(Source.fileNames));
  for i = 1 : length(Source.fileNames)
    tVectorsByFile(:, i) = ncread(Source.fileNames{i}, Source.tVariable);
  end
%   if ~isempty(Source.Grid.xVector)
  if ~isempty(Source.Grid)
    Grid = Source.Grid;
  else
    Grid = getGridOfDataset(Source);
  end
  xDimForU = length(Grid.xVectorForU);
  yDimForU = length(Grid.yVectorForU);
  xDimForV = length(Grid.xVectorForV);
  yDimForV = length(Grid.yVectorForV);
  if spatialDim == 3
    zDimForU = length(Grid.zVectorForU);
    zDimForV = length(Grid.zVectorForV);
    xDimForW = length(Grid.xVectorForW);
    yDimForW = length(Grid.yVectorForW);
    zDimForW = length(Grid.zVectorForW);
  end
  if strcmp(sourceName, 'chesROMS')
    % Horizontal metric factors
    pm = ncread(startFileName, 'pm');
    pn = ncread(startFileName, 'pn');
    if spatialDim == 3
      % Vertical metric factors
      Cs_w = ncread(startFileName, 'Cs_w');
      h = ncread(startFileName, 'h');
      hc = ncread(startFileName, 'hc');
    end
  end
  fprintf(['Dataset: ', Source.longName, '\n'])    
  fprintf(['First data file: ', startFileName, '\n'])
end
dt = RunOpts.timeStep;
t0 = RunOpts.startTime;
tSpan = RunOpts.timeSpan;
tVectorFwd = t0 : dt : tSpan(2);
tVectorBwd = t0 : -dt : tSpan(1);
outputTimes = RunOpts.outputTimes;
outputTimes = outputTimes(outputTimes >= tSpan(1));
outputTimes = outputTimes(outputTimes <= tSpan(2));
initialStateVector = convertStructureToVector(InitialState);
stateVectors = NaN(length(outputTimes), length(initialStateVector));

%% Integrate

for direction = {'Forward', 'Backward'}
  direction = direction{1};
  switch direction
    case 'Forward'
      tVector = tVectorFwd;
      tStep = dt;
    case 'Backward'
      tVector = tVectorBwd;
      tStep = -dt;
  end
  if length(tVector) > 1 % Don't do anything if no time vector!
    t = tVector(1);
    stateVector = initialStateVector;
    outputTimeIndex = find(abs(t - outputTimes) < dt*1e-7);
    if ~isempty(outputTimeIndex)
      stateVectors(outputTimeIndex, :) = stateVector;
    end
    if isa(Source, 'Dataset')
      tVecForInterp = Inf; % to be defined later
    end
    fprintf([direction, ' integration: t = %.1f to t = %.1f\n'], ...
      tVector(1), tVector(end))
    fprintf('t = %.1f\n', t)
    startWaitingClock = tic;
    startIntegration = tic;
    for i = 1 : length(tVector) - 1
      if isa(Source, 'Dataset')
        % "TVBF" = "time vector by file"
        [newTVecForInterp, newTVBFInSource] = ...
          getCoveringSubGridVector(tVectorsByFile(:), sort([t, t + tStep]));
        if ~isequal(newTVecForInterp, tVecForInterp)
          tVecForInterp = newTVecForInterp;
          tVBFInSource = newTVBFInSource;
          if spatialDim == 2
            uForInterp = NaN(xDimForU, yDimForU, length(tVBFInSource));
            vForInterp = NaN(xDimForV, yDimForV, length(tVBFInSource));
          elseif spatialDim == 3
            uPhysForInterp = NaN(xDimForU, yDimForU, zDimForU, length(tVBFInSource));
            vPhysForInterp = NaN(xDimForV, yDimForV, zDimForV, length(tVBFInSource));
            wPhysForInterp = NaN(xDimForW, yDimForW, zDimForW, length(tVBFInSource));
            omegaForInterp = NaN(xDimForW, yDimForW, zDimForW, length(tVBFInSource));
            zetaForInterp = NaN(xDimForW, yDimForW, length(tVBFInSource));
            uForInterp = NaN(xDimForU, yDimForU, zDimForU, length(tVBFInSource));
            vForInterp = NaN(xDimForV, yDimForV, zDimForV, length(tVBFInSource));
          end
          for ind = tVBFInSource
            [tVecInd, fileInd]  = ind2sub(size(tVectorsByFile), ind);
            if spatialDim == 2
              uForInterp(:, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'u', ...
                [1, 1, tVecInd], [xDimForU, yDimForU, 1]);
              vForInterp(:, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'v', ...
                [1, 1, tVecInd], [xDimForV, yDimForV, 1]);
            elseif spatialDim == 3
              uPhysForInterp(:, :, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'u', ...
                [1, 1, 1, tVecInd], [xDimForU, yDimForU, zDimForU, 1]);
              vPhysForInterp(:, :, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'v', ...
                [1, 1, 1, tVecInd], [xDimForV, yDimForV, zDimForV, 1]);
              wPhysForInterp(:, :, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'w', ...
                [1, 1, 1, tVecInd], [xDimForW, yDimForW, zDimForW, 1]);
              omegaForInterp(:, :, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'omega', ...
                [1, 1, 1, tVecInd], [xDimForW, yDimForW, zDimForW, 1]);
              zetaForInterp(:, :, ind - tVBFInSource(1) + 1) = ncread(Source.fileNames{fileInd}, 'zeta', ...
                [1, 1, tVecInd], [xDimForW, yDimForW, 1]);
            end
          end
          zetaForInterp = repmat(zetaForInterp, 1, 1, 1, zDimForW);
          zetaForInterp = permute(zetaForInterp, [1, 2, 4, 3]);
          for zInd = 1 : size(uForInterp, 3)
            for tInd = 1 : size(uForInterp, 4)
              uForInterp(:, :, zInd, tInd) = uPhysForInterp(:, :, zInd, tInd) ...
                .*(pm(1 : end - 1, :) + pm(2 : end, :))/2;
            end
          end
          for zInd = 1 : size(vForInterp, 3)
            for tInd = 1 : size(vForInterp, 4)
              vForInterp(:, :, zInd, tInd) = vPhysForInterp(:, :, zInd, tInd) ...
                .*(pn(:, 1 : end - 1) + pn(:, 2 : end))/2;
            end
          end
          CsForInterp = repmat(Cs_w, 1, length(tVecForInterp), xDimForW, yDimForW);
          CsForInterp = permute(CsForInterp, [3, 4, 1, 2]);
          hForInterp = repmat(h, 1, 1, zDimForW, length(tVecForInterp));
          sigmaForInterp = repmat(Grid.zVectorForW(:), 1, xDimForW, yDimForW, length(tVecForInterp));
          sigmaForInterp = permute(sigmaForInterp, [2, 3, 1, 4]);
          SForInterp = hc*sigmaForInterp + (hForInterp - hc).*CsForInterp;
          zForInterp = SForInterp + zetaForInterp.*(1 + SForInterp./hForInterp);
          HzForInterp = zeros([xDimForW, yDimForW, zDimForW, length(tVecForInterp)]);
          HzForInterp(:, :, 2 : end - 1, :) = diff(zForInterp, 2, 3)./diff(sigmaForInterp, 2, 3);
          wForInterp = omegaForInterp./HzForInterp;

          VelocityData.uForInterpolation = uForInterp;
          VelocityData.vForInterpolation = vForInterp;
          if spatialDim == 3
            VelocityData.wForInterpolation = wForInterp;
          end
          
          VelocityData.uPhysicalForInterpolation = uPhysForInterp;
          VelocityData.vPhysicalForInterpolation = vPhysForInterp;
          if spatialDim == 3
            VelocityData.wPhysicalForInterpolation = wPhysForInterp;
          end
          
          InterpolationMethods.horizontalInterpolationMethod = RunOpts.horizontalInterpolationMethod;
          InterpolationMethods.temporalInterpolationMethod = RunOpts.temporalInterpolationMethod;
          if spatialDim == 3
            InterpolationMethods.verticalInterpolationMethod = RunOpts.verticalInterpolationMethod;
          end
          stateVectorDerivative = @(stateVector, t) datasetStateVectorDerivative( ...
            stateVector, t, InitialState, VelocityData, tVecForInterp, ...
            Grid, InterpolationMethods);
        end
      end
      if strcmpi(RunOpts.integrationMethod, 'rk4')
        newStateVector = rK4Step(stateVector, t, tStep, stateVectorDerivative);
      else
        error('RunOpts.integrationMethod must be ''rk4''.')
      end
      NewState = convertVectorToStructure(newStateVector, InitialState);
      if isa(Source, 'ODESystem')
        NewState = wrapBounds(NewState, Source);
      end
      if strcmp(direction, 'Backward')
        State = convertVectorToStructure(stateVector, InitialState);
        NewState.m = State.m + abs(NewState.m - State.m);
      end
      newStateVector = convertStructureToVector(NewState);
      stateVector = newStateVector;
      t = tVector(i + 1);
      if toc(startWaitingClock) > 10
        fprintf('t = %.1f\n', t)
        startWaitingClock = tic;
      end
      outputTimeIndex = find(abs(t - outputTimes) < dt*1e-7);
      if ~isempty(outputTimeIndex)
        stateVectors(outputTimeIndex, :) = stateVector;
      end
    end
    integrationTime = toc(startIntegration);
    fprintf([direction, ' integration complete (wall time: %.4f s)\n'], integrationTime)
  end
end

%% Save output
runDirName = [outputDirectory, '/run/', Source.name];
if ~exist(runDirName)
  mkdir(runDirName)
end
nowString = datestr(datetime('now'), 30);
shortFileName = [Source.name, '_', num2str(floor(tSpan(1))), 'to', ...
  num2str(ceil(tSpan(2))), '_run_', nowString];
outputFileName = [runDirName, '/', shortFileName];
save(outputFileName, 'Source', 'RunOpts', 'InitialState', 'stateVectors', ...
  'outputTimes')