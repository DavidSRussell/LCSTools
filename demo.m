function demo(varargin)

if length(varargin) == 0
  oDESystem = 'duffing';
elseif length(varargin) == 1
  oDESystem = varargin{1};
end

runOutputFile = computeTrajectories(oDESystem);
analysisOutputFile = analyzeStates(runOutputFile);
plotFields(analysisOutputFile);