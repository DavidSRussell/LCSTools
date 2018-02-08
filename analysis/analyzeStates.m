function outputFileName = analyzeStates(runOutputFileName)
% analyzeStates(runOutputFileName): Perform Lagrangian analysis of states
% put out by function computeTrajectories.
%
% analyzeStates computes two types of Lagrangian descriptor fields based on
% knowledge of an initial and final system state (2D or 3D): the
% finite-time Lyapunov exponent (FTLE) and the coherent set vectors. Input
% "runOutputFileName" is a .mat file put out from function
% computeTrajectories, storing variables "Source", "RunOpts",
% "InitialState", "outputTimes", and "stateVectors" (each row of
% "stateVectors" corresponds to a time in "outputTimes". It also reads in
% various analysis options from file setAnalysisOptions.m (and
% setDefaultAnalysisOptions.m for any options not set there).
%
% Outputs:
%     
%     Source       -- ODESystem or Dataset object containing the velocity field
%     RunOpts      -- RunOptions object containing all the options for the run
%     AnalOpts     -- AnalysisOptions object containing mostly transition
%                     matrix parameters
%     InitialState -- SystemState object containing the initial positions,
%                     M-function, and any parameters
%     outputTimes  -- Vector of times at which the state has been analyzed
%     outputM      -- 1D cell array containg M-function at each output time
%     outputFTLE   -- 1D cell array containg FTLE at each output time
%     outputCS     -- 1D cell array containg coherent structure output 
%                     (structure containing singular vectors and arrays for
%                     plotting) at each output time

global outputDirectory

% Unpack inputs
load(runOutputFileName)
AnalOpts = setDefaultAnalysisOptions(Source, RunOpts);
AnalOpts = changeAnalysisOptions(AnalOpts);
spatialDim = Source.spatialDimension;
TMOpts = AnalOpts.TransitionMatrixOptions;
t0 = RunOpts.startTime;
x0 = InitialState.x;
y0 = InitialState.y;
if spatialDim == 3
  z0 = InitialState.z;
end

% Set up outputs
outputM = cell(1, length(outputTimes));
outputFTLE = cell(1, length(outputTimes));
outputCS = cell(1, length(outputTimes));

% Get M, FTLE, and coherent sets
for i = 1 : length(outputTimes)
  t = outputTimes(i);
  stateVector = stateVectors(i, :);
  State = convertVectorToStructure(stateVector, InitialState);
  x = State.x;
  y = State.y;
  m = State.m;
  if spatialDim == 3
    z = State.z;
  end
  outputM{i} = m;
  if AnalOpts.getFTLE
    if spatialDim == 2
      outputFTLE{i} = computeFTLE2D(x0, y0, x, y, t0, t);
    elseif spatialDim == 3
      outputFTLE{i} = computeFTLE3D(x0, y0, z0, x, y, z, t0, t);
    end
  end
  if AnalOpts.getCoherentSets
    outputCS{i} = computeCoherentSets(InitialState, State, TMOpts, spatialDim);
  end
end

% Save results
analysisDirName = [outputDirectory, '/analysis/', Source.name];
if ~exist(analysisDirName)
  mkdir(analysisDirName)
end
nowString = datestr(datetime('now'), 30);
t1 = min(outputTimes);
t2 = max(outputTimes);
shortFileName = [Source.name, '_', num2str(floor(t1)), 'to', ...
  num2str(ceil(t2)), '_analysis_', nowString];
outputFileName = [analysisDirName, '/', shortFileName];
save(outputFileName, 'outputM', 'outputFTLE', 'outputCS', 'Source', ...
  'InitialState', 'AnalOpts', 'RunOpts', 'outputTimes')