function InitialState = setDefaultInitialState(Source, RunOpts, Params)
% setDefaultInitialState(Source, RunOptions, Params): Set default initial
% state for a run of the computeTrajectories function, based on "Source"
% (an object of type ODESystem or Dataset), "RunOpts" (an object of type
% RunOptions), and "Params" (a structure with parameter values). The
% default initial positions fall on a grid, but this can be overridden by
% editing the file setInitialState.m.

InitialState = SystemState;

spatialDimension = Source.spatialDimension;

dx = RunOpts.dxInitialConditions;
dy = RunOpts.dyInitialConditions;
xLimits = RunOpts.xLimitsInitialConditions;
yLimits = RunOpts.yLimitsInitialConditions;
x0GridVector = xLimits(1) : dx : xLimits(2);
y0GridVector = yLimits(1) : dy : yLimits(2);
if spatialDimension == 2
  [x0, y0] = ndgrid(x0GridVector, y0GridVector);
elseif spatialDimension == 3
  dz = RunOpts.dzInitialConditions;
  zLimits = RunOpts.zLimitsInitialConditions;
  z0GridVector = zLimits(1) : dz : zLimits(2);
  [x0, y0, z0] = ndgrid(x0GridVector, y0GridVector, z0GridVector);
  InitialState.z = z0;
end

InitialState.x = x0;
InitialState.y = y0;
InitialState.m = zeros(size(x0));
if isa(Source, 'ODESystem')
  fields = fieldnames(Params);
  for i = 1 : length(fields)
    field = fields{i};
    InitialState.Parameters.(field) = Params.(field);
  end
end